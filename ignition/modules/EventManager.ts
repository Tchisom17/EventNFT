import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const eventNft = "0x479F9D37EF8664c2666a16A1547f6Fd60B535E50";

const EventManagerModule = buildModule("EventManagerModule", (m) => {
  const eventManager = m.contract("EventManager", [eventNft]);

  return { eventManager };
});

export default EventManagerModule;

// 0x479F9D37EF8664c2666a16A1547f6Fd60B535E50