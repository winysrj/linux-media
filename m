Return-path: <linux-media-owner@vger.kernel.org>
Received: from libri.sur5r.net ([217.8.61.68]:53030 "EHLO libri.sur5r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab2FKV6f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 17:58:35 -0400
Date: Mon, 11 Jun 2012 23:53:24 +0200
From: Jakob Haufe <sur5r@sur5r.net>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add quirk for camera of Lenovo Thinkpad X220 Tablet
Message-ID: <20120611235324.3e578bf7@samsa>
In-Reply-To: <4FAB6419.8060507@googlemail.com>
References: <20120503023327.085062b7@samsa.ccchd.dn42>
	<4FAB6419.8060507@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_libri-32149-1339451612-0001-2"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_libri-32149-1339451612-0001-2
Content-Type: multipart/mixed; boundary="MP_/3ozN76_zwB9F80=DsWFyo+3"

--MP_/3ozN76_zwB9F80=DsWFyo+3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

For the sake of completeness, I'll answer here as well.

On Thu, 10 May 2012
08:45:45 +0200 Gregor Jasny <gjasny@googlemail.com> wrote:

> Without this patch, is the image flipped in both: laptop and normal mode?

Yes, it's flipped in both modes. My girlfriend actually used that as a
workaround: Flip it to tablet mode and hold it upside down while
videochatting.

> And could you please post the output of dmidecode? In the past we had=20
> different default behavior (flipped vs. non-flipped) for Thinkpad=20
> tablets with the same board / system identifiers.

Attached.

Cheers,
Jakob
--=20
ceterum censeo microsoftem esse delendam.

--MP_/3ozN76_zwB9F80=DsWFyo+3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=dmidecode.txt

# dmidecode 2.11
SMBIOS 2.6 present.
68 structures occupying 2543 bytes.
Table at 0xDAE9C000.

Handle 0x0000, DMI type 134, 16 bytes
OEM-specific Type
	Header and Data:
		86 10 00 00 00 53 54 4D 20 01 01 00 00 02 01 02
	Strings:
		TPM INFO
		System Reserved

Handle 0x0001, DMI type 4, 42 bytes
Processor Information
	Socket Designation: CPU
	Type: Central Processor
	Family: Core i7
	Manufacturer: Intel(R) Corporation
	ID: A7 06 02 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 42, Stepping 7
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
	Version: Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz
	Voltage: 1.2 V
	External Clock: 100 MHz
	Max Speed: 2700 MHz
	Current Speed: 2700 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0002
	L2 Cache Handle: 0x0003
	L3 Cache Handle: 0x0004
	Serial Number: Not Supported by CPU
	Asset Tag: None
	Part Number: None
	Core Count: 2
	Core Enabled: 2
	Thread Count: 4
	Characteristics:
		64-bit capable

Handle 0x0002, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 64 kB
	Maximum Size: 64 kB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x0003, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 8-way Set-associative

Handle 0x0004, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3-Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 4096 kB
	Maximum Size: 4096 kB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0005, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 16 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0006, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x0005
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: SODIMM
	Set: None
	Locator: ChannelA-DIMM0
	Bank Locator: BANK 0
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: Samsung
	Serial Number: 662F5904
	Asset Tag: 9876543210
	Part Number: M471B5773DH0-CH9 =20
	Rank: Unknown

Handle 0x0007, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x0005
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: SODIMM
	Set: None
	Locator: ChannelB-DIMM0
	Bank Locator: BANK 2
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: Samsung
	Serial Number: 662F583D
	Asset Tag: 9876543210
	Part Number: M471B5773DH0-CH9 =20
	Rank: Unknown

Handle 0x0008, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0006
	Memory Array Mapped Address Handle: 0x000A
	Partition Row Position: 1
	Interleave Position: 1
	Interleaved Data Depth: 2

Handle 0x0009, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0006
	Memory Array Mapped Address Handle: 0x000A
	Partition Row Position: 1
	Interleave Position: 2
	Interleaved Data Depth: 2

Handle 0x000A, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Array Handle: 0x0005
	Partition Width: 2

Handle 0x000B, DMI type 129, 8 bytes
OEM-specific Type
	Header and Data:
		81 08 0B 00 01 01 02 01
	Strings:
		Intel_ASF
		Intel_ASF_001

Handle 0x000C, DMI type 130, 20 bytes
OEM-specific Type
	Header and Data:
		82 14 0C 00 24 41 4D 54 01 01 01 01 01 A5 FF 03
		00 00 01 00

Handle 0x000D, DMI type 131, 64 bytes
OEM-specific Type
	Header and Data:
		83 40 0D 00 14 00 00 00 07 00 00 00 00 00 3D 00
		F8 00 4F 1C FF FF FF FF 09 E0 00 00 01 00 07 00
		40 04 0D 00 00 00 00 00 C8 00 02 15 00 00 00 00
		00 00 00 00 F6 00 00 00 76 50 72 6F 00 00 00 00

Handle 0x000E, DMI type 134, 13 bytes
OEM-specific Type
	Header and Data:
		86 0D 0E 00 11 06 11 20 00 00 00 00 00

Handle 0x000F, DMI type 0, 24 bytes
BIOS Information
	Vendor: LENOVO
	Version: 8DET59WW (1.29 )
	Release Date: 04/02/2012
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 8192 kB
	Characteristics:
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		3.5"/720 kB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 1.29
	Firmware Revision: 1.20

Handle 0x0010, DMI type 1, 27 bytes
System Information
	Manufacturer: LENOVO
	Product Name: 42982YG
	Version: ThinkPad X220 Tablet
	Serial Number: R9E5L6Z
	UUID: 24A86501-50A6-11CB-A004-D1B6C551B66F
	Wake-up Type: Power Switch
	SKU Number: Not Specified
	Family: ThinkPad X220 Tablet

Handle 0x0011, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: LENOVO
	Product Name: 42982YG
	Version: Not Available
	Serial Number: 1ZJUC15G18Z
	Asset Tag: Not Available
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: Not Available
	Chassis Handle: 0x0000
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0012, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: LENOVO
	Type: Notebook
	Lock: Not Present
	Version: Not Available
	Serial Number: R9E5L6Z
	Asset Tag: No Asset Information
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: Unspecified
	Contained Elements: 0

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: External Monitor
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: DisplayPort
	External Connector Type: Other
	Port Type: Video Port

Handle 0x0015, DMI type 126, 9 bytes
Inactive

Handle 0x0016, DMI type 126, 9 bytes
Inactive

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Headphone/Microphone Combo Jack
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0018, DMI type 126, 9 bytes
Inactive

Handle 0x0019, DMI type 126, 9 bytes
Inactive

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: Ethernet
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x001B, DMI type 126, 9 bytes
Inactive

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB 3
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Not Available
	Internal Connector Type: None
	External Reference Designator: USB/eSATA Combo
	External Connector Type: Other
	Port Type: Other

Handle 0x0020, DMI type 126, 9 bytes
Inactive

Handle 0x0021, DMI type 126, 9 bytes
Inactive

Handle 0x0022, DMI type 126, 9 bytes
Inactive

Handle 0x0023, DMI type 126, 9 bytes
Inactive

Handle 0x0024, DMI type 126, 9 bytes
Inactive

Handle 0x0025, DMI type 126, 9 bytes
Inactive

Handle 0x0026, DMI type 126, 9 bytes
Inactive

Handle 0x0027, DMI type 126, 9 bytes
Inactive

Handle 0x0028, DMI type 9, 17 bytes
System Slot Information
	Designation: ExpressCard Slot
	Type: x1 PCI Express
	Current Usage: Available
	Length: Other
	ID: 1
	Characteristics:
		Hot-plug devices are supported
	Bus Address: 0000:00:00.0

Handle 0x0029, DMI type 9, 17 bytes
System Slot Information
	Designation: Media Card Slot
	Type: Other
	Current Usage: Available
	Length: Other
	Characteristics:
		Hot-plug devices are supported
	Bus Address: 0000:00:00.0

Handle 0x002A, DMI type 126, 17 bytes
Inactive

Handle 0x002B, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Disabled
	Description: IBM Embedded Security hardware

Handle 0x002C, DMI type 12, 5 bytes
System Configuration Options

Handle 0x002D, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Abbreviated
	Installable Languages: 1
		en-US
	Currently Installed Language: en-US

Handle 0x002E, DMI type 22, 26 bytes
Portable Battery
	Location: Rear
	Manufacturer: LGC
	Name: 42T4881
	Design Capacity: 57720 mWh
	Design Voltage: 11100 mV
	SBDS Version: 03.01
	Maximum Error: Unknown
	SBDS Serial Number: 1E9E
	SBDS Manufacture Date: 2011-04-11
	SBDS Chemistry: LION
	OEM-specific Information: 0x00000000

Handle 0x002F, DMI type 126, 26 bytes
Inactive

Handle 0x0030, DMI type 18, 23 bytes
32-bit Memory Error Information
	Type: OK
	Granularity: Unknown
	Operation: Unknown
	Vendor Syndrome: Unknown
	Memory Array Address: Unknown
	Device Address: Unknown
	Resolution: Unknown

Handle 0x0031, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Track Point
	Interface: PS/2
	Buttons: 3

Handle 0x0032, DMI type 21, 7 bytes
Built-in Pointing Device
	Type: Touch Pad
	Interface: PS/2
	Buttons: 2

Handle 0x0033, DMI type 131, 22 bytes
OEM-specific Type
	Header and Data:
		83 16 33 00 01 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		TVT-Enablement

Handle 0x0034, DMI type 136, 6 bytes
OEM-specific Type
	Header and Data:
		88 06 34 00 5A 5A

Handle 0x0035, DMI type 135, 74 bytes
OEM-specific Type
	Header and Data:
		87 4A 35 00 54 50 07 02 42 41 59 20 49 2F 4F 20
		02 00 06 FF 00 00 00 00 00 00 00 FF 00 00 00 00
		00 00 00 FF 00 00 00 00 00 00 00 FF 00 00 00 00
		00 00 00 FF 00 00 00 00 00 00 00 FF 00 00 00 00
		00 00 00 06 00 02 01 FF FF 03

Handle 0x0036, DMI type 135, 30 bytes
OEM-specific Type
	Header and Data:
		87 1E 36 00 54 50 07 04 01 05 01 01 02 00 02 01
		02 00 03 01 02 00 05 01 02 00 06 01 02 00

Handle 0x0037, DMI type 140, 19 bytes
OEM-specific Type
	Header and Data:
		8C 13 37 00 4C 45 4E 4F 56 4F 0B 05 01 07 00 00
		00 00 00

Handle 0x0038, DMI type 140, 23 bytes
OEM-specific Type
	Header and Data:
		8C 17 38 00 4C 45 4E 4F 56 4F 0B 06 01 7E 14 00
		00 00 00 00 00 00 00

Handle 0x0039, DMI type 133, 5 bytes
OEM-specific Type
	Header and Data:
		85 05 39 00 01
	Strings:
		KHOIHGIUCCHHII

Handle 0x003A, DMI type 15, 29 bytes
System Event Log
	Area Length: 18 bytes
	Header Start Offset: 0x0000
	Header Length: 16 bytes
	Data Start Offset: 0x0010
	Access Method: General-purpose non-volatile data functions
	Access Address: 0x00F0
	Status: Valid, Not Full
	Change Token: 0x00000000
	Header Format: Type 1
	Supported Log Type Descriptors: 3
	Descriptor 1: POST error
	Data Format 1: POST results bitmap
	Descriptor 2: Single-bit ECC memory error
	Data Format 2: Multiple-event
	Descriptor 3: Multi-bit ECC memory error
	Data Format 3: Multiple-event

Handle 0x003B, DMI type 140, 67 bytes
OEM-specific Type
	Header and Data:
		8C 43 3B 00 4C 45 4E 4F 56 4F 0B 00 01 DA D3 49
		74 79 54 D1 91 51 F6 71 41 C0 FA 4E 54 01 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00

Handle 0x003C, DMI type 140, 47 bytes
OEM-specific Type
	Header and Data:
		8C 2F 3C 00 4C 45 4E 4F 56 4F 0B 01 01 09 00 1C
		ED 43 11 A6 19 5A D1 A8 B0 CA C7 66 A2 E9 A0 00
		00 00 00 10 00 10 00 10 01 D0 00 20 01 00 01

Handle 0x003D, DMI type 140, 63 bytes
OEM-specific Type
	Header and Data:
		8C 3F 3D 00 4C 45 4E 4F 56 4F 0B 02 01 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Handle 0x003E, DMI type 140, 17 bytes
OEM-specific Type
	Header and Data:
		8C 11 3E 00 4C 45 4E 4F 56 4F 0B 03 01 00 00 00
		00

Handle 0x003F, DMI type 140, 19 bytes
OEM-specific Type
	Header and Data:
		8C 13 3F 00 4C 45 4E 4F 56 4F 0B 04 01 B2 00 4D
		53 20 00

Handle 0x0040, DMI type 24, 5 bytes
Hardware Security
	Power-On Password Status: Disabled
	Keyboard Password Status: Not Implemented
	Administrator Password Status: Disabled
	Front Panel Reset Status: Not Implemented

Handle 0x0041, DMI type 132, 7 bytes
OEM-specific Type
	Header and Data:
		84 07 41 00 01 D8 36

Handle 0x0042, DMI type 135, 18 bytes
OEM-specific Type
	Header and Data:
		87 12 42 00 54 50 07 01 01 CB 01 00 00 00 00 00
		00 00

Handle 0xFEFF, DMI type 127, 4 bytes
End Of Table


--MP_/3ozN76_zwB9F80=DsWFyo+3--

--=_libri-32149-1339451612-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/WaNQACgkQ1YAhDic+adZ5cgCgp6DjhsxwRKzZEua4eDNnrPmf
ChkAn1o87tgdMLAryO2PMDvFCeVdpGGR
=Eacg
-----END PGP SIGNATURE-----

--=_libri-32149-1339451612-0001-2--
