Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63687 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3BKPdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 10:33:11 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so4722558wgb.1
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 07:33:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5118F4F4.1070602@redhat.com>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
	<21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
	<5118ED5C.2080801@redhat.com>
	<201302111421.17226.hverkuil@xs4all.nl>
	<5118F4F4.1070602@redhat.com>
Date: Mon, 11 Feb 2013 16:32:58 +0100
Message-ID: <CA+6av4kxho5-UJB=BCTqd+qH-ATGzBUvds7TDpenjb7W73rKVQ@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 01/12] stk-webcam: the initial hflip and vflip setup
 was the wrong way around
From: Arvydas Sidorenko <asido4@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 11, 2013 at 2:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> That doesn't make sense either. Arvydas, it worked fine for you before, right?
> That is, if you use e.g. v3.8-rc7 then your picture is the right side up.
>

It is upside down using any v3.7.x or v3.8-rc7. I didn't pay attention
in the older versions, but I am aware of this issue since pre-v3.

On Mon, Feb 11, 2013 at 2:41 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>
> Arvydas, can you please run "sudo dmidecode > dmi.log", and send me or
> Hans V. the generated dmi.log file? Then we can add your laptop to the
> upside-down model list.
>

$ sudo dmidecode
# dmidecode 2.11
SMBIOS 2.4 present.
37 structures occupying 1499 bytes.
Table at 0x000E5020.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 305
	Release Date: 02/15/2007
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 512 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PC Card (PCMCIA) is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		Smart battery is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
	BIOS Revision: 1.124
	Firmware Revision: 168.153

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: ASUSTeK Computer Inc.
	Product Name: F3JC
	Version: 1.0
	Serial Number: SSN12345678901234567
	UUID: F13181DB-43CD-9AAD-CE00-0018F338B599
	Wake-up Type: Power Switch
	SKU Number:
	Family:

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASUSTeK Computer Inc.
	Product Name: F3JC
	Version: 1.0
	Serial Number: BSN12345678901234567
	Asset Tag: ATN12345678901234567
	Features:
		Board is a hosting board
		Board requires at least one daughter board
		Board is replaceable
	Location In Chassis: MIDDLE
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: ASUSTeK Computer Inc.
	Type: Notebook
	Lock: Not Present
	Version:
	Serial Number:
	Asset Tag:
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: Socket 478
	Type: Central Processor
	Family: Other
	Manufacturer: Intel
	ID: F6 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 6
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (FXSAVE and FXSTOR instructions supported)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Multi-threading)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Intel(R) Core(TM)2 CPU T5500 @ 1.66GHz
	Voltage: 1.1 V
	External Clock: 167 MHz
	Max Speed: 1667 MHz
	Current Speed: 1666 MHz
	Status: Populated, Enabled
	Upgrade: Socket 423
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided
	Serial Number: PSN12345678901234567
	Asset Tag: PATN1234567890123456
	Part Number: PPN12345678901234567

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 kB
	Maximum Size: 64 kB
	Supported SRAM Types:
		Other
	Installed SRAM Type: Other
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 8-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 2048 kB
	Maximum Size: 2048 kB
	Supported SRAM Types:
		Other
	Installed SRAM Type: Other
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x0007, DMI type 5, 20 bytes
Memory Controller Information
	Error Detecting Method: None
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 1024 MB
	Maximum Total Memory Size: 2048 MB
	Supported Speeds:
		Other
		70 ns
		60 ns
		50 ns
	Supported Memory Types:
		Standard
		DIMM
		SDRAM
	Memory Module Voltage: 3.3 V
	Associated Memory Slots: 2
		0x0008
		0x0009
	Enabled Error Correcting Capabilities:
		None

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM0
	Bank Connections: 0 1
	Current Speed: Unknown
	Type: Standard DIMM SDRAM
	Installed Size: 1024 MB (Double-bank Connection)
	Enabled Size: 1024 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM1
	Bank Connections: 2 3
	Current Speed: Unknown
	Type: Standard DIMM SDRAM
	Installed Size: 2048 MB (Double-bank Connection)
	Enabled Size: 2048 MB (Double-bank Connection)
	Error Status: OK

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CON18
	Internal Connector Type: None
	External Reference Designator: USB1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CON18
	Internal Connector Type: None
	External Reference Designator: USB2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CON19
	Internal Connector Type: None
	External Reference Designator: USB3
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CON19
	Internal Connector Type: None
	External Reference Designator: USB4
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: BCON1
	Internal Connector Type: None
	External Reference Designator: 1394
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CON28
	Internal Connector Type: None
	External Reference Designator: MODEM
	External Connector Type: RJ-11
	Port Type: Modem Port

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CON28
	Internal Connector Type: None
	External Reference Designator: LAN
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1
	Internal Connector Type: None
	External Reference Designator: Headphone Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2
	Internal Connector Type: None
	External Reference Designator: Mic In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CON4
	Internal Connector Type: None
	External Reference Designator: Video
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CON13
	Internal Connector Type: None
	External Reference Designator: SD/MMC/MS
	External Connector Type: Other
	Port Type: Other

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CON12
	Internal Connector Type: None
	External Reference Designator: CARD BUS
	External Connector Type: 68 Pin Dual Inline
	Port Type: Cardbus

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CN12
	Internal Connector Type: None
	External Reference Designator: Multi Port
	External Connector Type: Other
	Port Type: Other

Handle 0x0017, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIE1
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 1
	Characteristics:
		3.3 V is provided
		PME signal is supported

Handle 0x0018, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description: AGP VGA controller

Handle 0x0019, DMI type 10, 6 bytes
On Board Device Information
	Type: Ethernet
	Status: Enabled
	Description: Ethernet controller

Handle 0x001A, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Enabled
	Description: Audio controller

Handle 0x001B, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description: Modem controller

Handle 0x001C, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Abbreviated
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x001D, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 4 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x001E, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000B80003FF
	Range Size: 2944 MB
	Physical Array Handle: 0x001D
	Partition Width: 4

Handle 0x001F, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x001D
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 1024 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK0
	Type: SDRAM
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Manufacturer0
	Serial Number: SerNum0
	Asset Tag: AssetTagNum0
	Part Number: PartNum0

Handle 0x0020, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0003FFFFFFF
	Range Size: 1 GB
	Physical Device Handle: 0x001F
	Memory Array Mapped Address Handle: 0x001E
	Partition Row Position: 1
	Interleaved Data Depth: 1

Handle 0x0021, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x001D
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK1
	Type: SDRAM
	Type Detail: Synchronous
	Speed: Unknown
	Manufacturer: Manufacturer1
	Serial Number: SerNum1
	Asset Tag: AssetTagNum1
	Part Number: PartNum1

Handle 0x0022, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00040000000
	Ending Address: 0x000BFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0021
	Memory Array Mapped Address Handle: 0x001E
	Partition Row Position: 1
	Interleaved Data Depth: 1

Handle 0x0023, DMI type 200, 7 bytes
OEM-specific Type
	Header and Data:
		C8 07 23 00 01 02 03
	Strings:
		1043
		F3J
		305

Handle 0x0024, DMI type 127, 4 bytes
End Of Table


Arvydas
