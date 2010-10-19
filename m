Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41034 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab0JSDFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 23:05:11 -0400
Received: by qwa26 with SMTP id 26so1242230qwa.19
        for <linux-media@vger.kernel.org>; Mon, 18 Oct 2010 20:05:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Oct 2010 23:05:10 -0400
Message-ID: <AANLkTimQAu-76tv6MWQhfT5L1fDJrnK0uTYobQXBi8vQ@mail.gmail.com>
Subject: Pinnacle PCTV HD 800i troubles
From: Tugrul Galatali <tugrul@galatali.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

After a variable amount of time recording, the card stops functioning
and starts filling my disk with error messages. It usually starts with
something like this:

[ 4098.203170] lgdt3305_read_reg: error (addr 0e reg 0003 error (ret == -5)
[ 4098.203173] lgdt3305_read_status: error -5 on line 819
[ 4098.205312] tda18271_write_regs: [2-0060|M] ERROR: idx = 0x5, len =
1, i2c_transfer returned: -5
[ 4098.205315] tda18271_init: [2-0060|M] error -5 on line 830
[ 4098.205316] tda18271_tune: [2-0060|M] error -5 on line 908
[ 4098.205318] tda18271_set_params: [2-0060|M] error -5 on line 989
[ 4098.205320] lgdt3305_set_parameters: error -5 on line 655
[ 4098.706164] lgdt3305_read_reg: error (addr 0e reg 0003 error (ret == -5)
[ 4098.706167] lgdt3305_read_status: error -5 on line 819
[ 4099.054176] s5h1409_readreg: readreg error (ret == -6)
[ 4099.054824] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[ 4099.055467] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[ 4099.056110] s5h1409_writereg: error (reg == 0xf4, val == 0x0001, ret == -6)
[ 4099.056754] s5h1409_writereg: error (reg == 0x85, val == 0x0110, ret == -6)
[ 4099.057404] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[ 4099.058069] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[ 4099.058711] s5h1409_writereg: error (reg == 0xf3, val == 0x0001, ret == -6)
[ 4099.059355] xc5000: I2C read failed
[ 4099.060004] xc5000: I2C read failed
[ 4099.060006] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[ 4099.062250] xc5000: firmware read 12401 bytes.
[ 4099.062251] xc5000: firmware uploading...
[ 4099.062253] cx88[0]: Calling XC5000 callback
[ 4099.063014] xc5000: I2C write failed (len=3)
[ 4099.063015] xc5000: firmware upload complete...
[ 4099.063660] s5h1409_writereg: error (reg == 0xf3, val == 0x0000, ret == -6)
[ 4099.064302] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[ 4099.064946] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[ 4099.065608] s5h1409_readreg: readreg error (ret == -6)
[ 4099.066256] s5h1409_writereg: error (reg == 0x96, val == 0x0008, ret == -6)
[ 4099.066899] s5h1409_writereg: error (reg == 0x93, val == 0x3332, ret == -6)
[ 4099.067541] s5h1409_writereg: error (reg == 0x9e, val == 0x2c37, ret == -6)
[ 4099.068184] s5h1409_readreg: readreg error (ret == -6)
[ 4099.068826] s5h1409_writereg: error (reg == 0x96, val == 0x0008, ret == -6)
[ 4099.069475] s5h1409_readreg: readreg error (ret == -6)
[ 4099.070148] s5h1409_writereg: error (reg == 0xab, val == 0x1001, ret == -6)
[ 4099.207167] lgdt3305_read_reg: error (addr 0e reg 0003 error (ret == -5)
[ 4099.207169] lgdt3305_read_status: error -5 on line 819
[ 4099.706207] lgdt3305_read_reg: error (addr 0e reg 0003 error (ret == -5)
[ 4099.706210] lgdt3305_read_status: error -5 on line 819
[ 4100.069748] s5h1409_readreg: readreg error (ret == -6)
[ 4100.070393] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[ 4100.071037] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[ 4100.071680] s5h1409_writereg: error (reg == 0xf4, val == 0x0001, ret == -6)
[ 4100.072329] s5h1409_writereg: error (reg == 0x85, val == 0x0110, ret == -6)
[ 4100.072977] s5h1409_writereg: error (reg == 0xf5, val == 0x0000, ret == -6)
[ 4100.073648] s5h1409_writereg: error (reg == 0xf5, val == 0x0001, ret == -6)
[ 4100.074328] s5h1409_writereg: error (reg == 0xf3, val == 0x0001, ret == -6)
[ 4100.074971] xc5000: I2C read failed
[ 4100.075612] xc5000: I2C read failed
[ 4100.075613] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[ 4100.077869] xc5000: firmware read 12401 bytes.
[ 4100.077870] xc5000: firmware uploading...
[ 4100.077872] cx88[0]: Calling XC5000 callback
[ 4100.078627] xc5000: I2C write failed (len=3)
[ 4100.078629] xc5000: firmware upload complete...

and etc.

The box is built around a Intel DG45ID board running a recently
updated debian/squeeze, kernel version 2.6.35.5, myth 0.23.1 and has
one other ATSC tuner, a Hauppauge HVR 1250. Following are the dmesg
and lspci -vvv on the box. What else can I pull up to help?

Tugrul Galatali

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35.5 (root@fourway) (gcc version
4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Tue Sep 21 23:52:20 EDT 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35.5
root=UUID=de9d2459-8da6-47db-b5d4-827bfd3232d3 ro quiet
enable_mtrr_cleanup mtrr_gran_size=32M mtrr_chunk_size=32M
mtrr_spare_reg_nr=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cbba8000 (usable)
[    0.000000]  BIOS-e820: 00000000cbba8000 - 00000000cbc2a000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cbc2a000 - 00000000cbd41000 (reserved)
[    0.000000]  BIOS-e820: 00000000cbd41000 - 00000000cbd55000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cbd55000 - 00000000cbe56000 (reserved)
[    0.000000]  BIOS-e820: 00000000cbe56000 - 00000000cbe5e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cbe5e000 - 00000000cbe68000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cbe68000 - 00000000cbe8a000 (reserved)
[    0.000000]  BIOS-e820: 00000000cbe8a000 - 00000000cbe90000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cbe90000 - 00000000cc000000 (usable)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000022c000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x22c000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FC0000000 write-back
[    0.000000]   2 base 0CC000000 mask FFC000000 uncachable
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   5 base 22C000000 mask FFC000000 uncachable
[    0.000000]   6 base 230000000 mask FF0000000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 8GB, type WB
[    0.000000] reg 1, base: 8GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3264MB, range: 64MB, type UC
[    0.000000] reg 3, base: 3328MB, range: 256MB, type UC
[    0.000000] reg 4, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 5, base: 8896MB, range: 64MB, type UC
[    0.000000] reg 6, base: 8960MB, range: 256MB, type UC
[    0.000000] total RAM covered: 8064M
[    0.000000]  gran_size: 32M 	chunk_size: 32M 	num_reg: 7  	lose
cover RAM: 64M
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 128MB, type WB
[    0.000000] reg 3, base: 3200MB, range: 64MB, type WB
[    0.000000] reg 4, base: 4GB, range: 4GB, type WB
[    0.000000] reg 5, base: 8GB, range: 512MB, type WB
[    0.000000] reg 6, base: 8704MB, range: 128MB, type WB
[    0.000000] e820 update range: 00000000cc000000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] e820 update range: 0000000228000000 - 000000022c000000
(usable) ==> (reserved)
[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory,
losing 64MB of RAM.
[    0.000000] update e820 for mtrr
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009d800 (usable)
[    0.000000]  modified: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cbba8000 (usable)
[    0.000000]  modified: 00000000cbba8000 - 00000000cbc2a000 (ACPI NVS)
[    0.000000]  modified: 00000000cbc2a000 - 00000000cbd41000 (reserved)
[    0.000000]  modified: 00000000cbd41000 - 00000000cbd55000 (ACPI NVS)
[    0.000000]  modified: 00000000cbd55000 - 00000000cbe56000 (reserved)
[    0.000000]  modified: 00000000cbe56000 - 00000000cbe5e000 (ACPI data)
[    0.000000]  modified: 00000000cbe5e000 - 00000000cbe68000 (ACPI NVS)
[    0.000000]  modified: 00000000cbe68000 - 00000000cbe8a000 (reserved)
[    0.000000]  modified: 00000000cbe8a000 - 00000000cbe90000 (ACPI NVS)
[    0.000000]  modified: 00000000cbe90000 - 00000000cc000000 (usable)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000228000000 (usable)
[    0.000000]  modified: 0000000228000000 - 000000022c000000 (reserved)
[    0.000000] last_pfn = 0x228000 max_arch_pfn = 0x400000000
[    0.000000] last_pfn = 0xcc000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cc000000
[    0.000000]  0000000000 - 00cc000000 page 2M
[    0.000000] kernel direct mapping tables up to cc000000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000228000000
[    0.000000]  0100000000 - 0228000000 page 2M
[    0.000000] kernel direct mapping tables up to 228000000 @ 19000-23000
[    0.000000] RAMDISK: 32298000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f03c0 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT 00000000cbe5ce18 0004C (v01 INTEL  DG45ID
00000083 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000cbe5bd98 000F4 (v04  INTEL    A M I
06222004 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two
FACS tables! (20100428/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT -
0xCBE5FF40/0x00000000CBE65E40, using 32 (20100428/tbfadt-486)
[    0.000000] ACPI: DSDT 00000000cbe56018 0492F (v01 INTEL  DG45ID
00000083 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cbe5ff40 00040
[    0.000000] ACPI: APIC 00000000cbe5bf18 0006C (v02 INTEL  DG45ID
00000083 MSFT 00010013)
[    0.000000] ACPI: MCFG 00000000cbe66d98 0003C (v01 INTEL  DG45ID
00000083 MSFT 00000097)
[    0.000000] ACPI: ASF! 00000000cbe65c18 000A0 (v32 INTEL  DG45ID
00000083 TFSM 000F4240)
[    0.000000] ACPI: HPET 00000000cbe66d18 00038 (v01 INTEL  DG45ID
00000083 AMI. 00000003)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000228000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000228000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00079fffff] PMD ->
[ffff880100200000-ffff8801071fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00228000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000cbba8
[    0.000000]     0: 0x000cbe90 -> 0x000cc000
[    0.000000]     0: 0x00100000 -> 0x00228000
[    0.000000] On node 0 totalpages: 2047141
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3925 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 816464 pages, LIFO batch:31
[    0.000000]   Normal zone: 16576 pages used for memmap
[    0.000000]   Normal zone: 1195840 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [1e000 - 1e7ff]
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cbba8000 - 00000000cbc2a000
[    0.000000] PM: Registered nosave memory: 00000000cbc2a000 - 00000000cbd41000
[    0.000000] PM: Registered nosave memory: 00000000cbd41000 - 00000000cbd55000
[    0.000000] PM: Registered nosave memory: 00000000cbd55000 - 00000000cbe56000
[    0.000000] PM: Registered nosave memory: 00000000cbe56000 - 00000000cbe5e000
[    0.000000] PM: Registered nosave memory: 00000000cbe5e000 - 00000000cbe68000
[    0.000000] PM: Registered nosave memory: 00000000cbe68000 - 00000000cbe8a000
[    0.000000] PM: Registered nosave memory: 00000000cbe8a000 - 00000000cbe90000
[    0.000000] PM: Registered nosave memory: 00000000cc000000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at cc000000 (gap:
cc000000:32d1c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512
nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001a00000 s90176
r8192 d24512 u524288
[    0.000000] pcpu-alloc: s90176 r8192 d24512 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 2016229
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35.5
root=UUID=de9d2459-8da6-47db-b5d4-827bfd3232d3 ro quiet
enable_mtrr_cleanup mtrr_gran_size=32M mtrr_chunk_size=32M
mtrr_spare_reg_nr=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] early_res array is doubled to 128 at [1e800 - 1f7ff]
[    0.000000] Subtract (59 early reservations)
[    0.000000]   #1 [0001000000 - 000189df64]   TEXT DATA BSS
[    0.000000]   #2 [0032298000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000009d800 - 0000100000]   BIOS reserved
[    0.000000]   #4 [000189e000 - 000189e1ec]             BRK
[    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #7 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #8 [0000019000 - 000001e000]         PGTABLE
[    0.000000]   #9 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #10 [000189e200 - 000189f200]         BOOTMEM
[    0.000000]   #11 [0100005000 - 01000055e8]         BOOTMEM
[    0.000000]   #12 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #13 [0100007000 - 0100008000]         BOOTMEM
[    0.000000]   #14 [0100200000 - 0107200000]        MEMMAP 0
[    0.000000]   #15 [000189f200 - 00018b7200]         BOOTMEM
[    0.000000]   #16 [00018b7200 - 00018cf200]         BOOTMEM
[    0.000000]   #17 [00018cf200 - 00018e7200]         BOOTMEM
[    0.000000]   #18 [00018e8000 - 00018e9000]         BOOTMEM
[    0.000000]   #19 [000189df80 - 000189dfc1]         BOOTMEM
[    0.000000]   #20 [00018e7200 - 00018e7243]         BOOTMEM
[    0.000000]   #21 [00018e7280 - 00018e7670]         BOOTMEM
[    0.000000]   #22 [00018e7680 - 00018e76e8]         BOOTMEM
[    0.000000]   #23 [00018e7700 - 00018e7768]         BOOTMEM
[    0.000000]   #24 [00018e7780 - 00018e77e8]         BOOTMEM
[    0.000000]   #25 [00018e7800 - 00018e7868]         BOOTMEM
[    0.000000]   #26 [00018e7880 - 00018e78e8]         BOOTMEM
[    0.000000]   #27 [00018e7900 - 00018e7968]         BOOTMEM
[    0.000000]   #28 [00018e7980 - 00018e79e8]         BOOTMEM
[    0.000000]   #29 [00018e7a00 - 00018e7a68]         BOOTMEM
[    0.000000]   #30 [00018e7a80 - 00018e7ae8]         BOOTMEM
[    0.000000]   #31 [00018e7b00 - 00018e7b68]         BOOTMEM
[    0.000000]   #32 [00018e7b80 - 00018e7be8]         BOOTMEM
[    0.000000]   #33 [00018e7c00 - 00018e7c68]         BOOTMEM
[    0.000000]   #34 [00018e7c80 - 00018e7ce8]         BOOTMEM
[    0.000000]   #35 [00018e7d00 - 00018e7d68]         BOOTMEM
[    0.000000]   #36 [00018e7d80 - 00018e7de8]         BOOTMEM
[    0.000000]   #37 [00018e7e00 - 00018e7e68]         BOOTMEM
[    0.000000]   #38 [00018e7e80 - 00018e7ea0]         BOOTMEM
[    0.000000]   #39 [00018e7ec0 - 00018e7ee0]         BOOTMEM
[    0.000000]   #40 [00018e7f00 - 00018e7f20]         BOOTMEM
[    0.000000]   #41 [00018e7f40 - 00018e7fe9]         BOOTMEM
[    0.000000]   #42 [00018e9000 - 00018e90a9]         BOOTMEM
[    0.000000]   #43 [0001a00000 - 0001a1e000]         BOOTMEM
[    0.000000]   #44 [0001a80000 - 0001a9e000]         BOOTMEM
[    0.000000]   #45 [0001b00000 - 0001b1e000]         BOOTMEM
[    0.000000]   #46 [0001b80000 - 0001b9e000]         BOOTMEM
[    0.000000]   #47 [00018eb0c0 - 00018eb0c8]         BOOTMEM
[    0.000000]   #48 [00018eb100 - 00018eb108]         BOOTMEM
[    0.000000]   #49 [00018eb140 - 00018eb150]         BOOTMEM
[    0.000000]   #50 [00018eb180 - 00018eb1a0]         BOOTMEM
[    0.000000]   #51 [00018eb1c0 - 00018eb2f0]         BOOTMEM
[    0.000000]   #52 [00018eb300 - 00018eb350]         BOOTMEM
[    0.000000]   #53 [00018eb380 - 00018eb3d0]         BOOTMEM
[    0.000000]   #54 [00018eb400 - 00018f3400]         BOOTMEM
[    0.000000]   #55 [0001b9e000 - 0005b9e000]         BOOTMEM
[    0.000000]   #56 [00018f3400 - 0001913400]         BOOTMEM
[    0.000000]   #57 [0001913400 - 0001953400]         BOOTMEM
[    0.000000]   #58 [000001f800 - 0000027800]         BOOTMEM
[    0.000000] Memory: 7902604k/9043968k available (3116k kernel code,
855404k absent, 285960k reserved, 3716k data, 592k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:33024 nr_irqs:712
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2833.546 MHz processor.
[    0.004007] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5667.09 BogoMIPS (lpj=11334184)
[    0.004010] pid_max: default: 32768 minimum: 301
[    0.004026] Security Framework initialized
[    0.004030] SELinux:  Disabled at boot.
[    0.004557] Dentry cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.010513] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.012079] Mount-cache hash table entries: 256
[    0.012198] Initializing cgroup subsys ns
[    0.012202] Initializing cgroup subsys cpuacct
[    0.012205] Initializing cgroup subsys devices
[    0.012206] Initializing cgroup subsys freezer
[    0.012208] Initializing cgroup subsys net_cls
[    0.012229] CPU: Physical Processor ID: 0
[    0.012230] CPU: Processor Core ID: 0
[    0.012232] mce: CPU supports 6 MCE banks
[    0.012238] CPU0: Thermal monitoring enabled (TM2)
[    0.012241] using mwait in idle threads.
[    0.012243] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.012248] ... version:                2
[    0.012249] ... bit width:              40
[    0.012250] ... generic registers:      2
[    0.012252] ... value mask:             000000ffffffffff
[    0.012253] ... max period:             000000007fffffff
[    0.012254] ... fixed-purpose events:   3
[    0.012255] ... event mask:             0000000700000003
[    0.013027] ACPI: Core revision 20100428
[    0.017718] Setting APIC routing to flat
[    0.018037] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057735] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz stepping 07
[    0.060000] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.332007] Brought up 4 CPUs
[    0.332009] Total of 4 processors activated (22664.98 BogoMIPS).
[    0.334348] devtmpfs: initialized
[    0.337470] regulator: core version 0.5
[    0.337470] NET: Registered protocol family 16
[    0.337470] ACPI: bus type pci registered
[    0.337470] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem
0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.337470] PCI: not using MMCONFIG
[    0.337470] PCI: Using configuration type 1 for base access
[    0.337470] bio: create slab <bio-0> at 0
[    0.337470] ACPI: EC: Look up EC in DSDT
[    0.340299] ACPI: Executed 1 blocks of module-level executable AML code
[    0.342812] ACPI: BIOS _OSI(Linux) query ignored
[    0.344632] ACPI: SSDT 00000000cbe5fc18 002CC (v01    AMI      IST
00000001 MSFT 03000001)
[    0.344865] ACPI: Dynamic OEM Table Load:
[    0.344867] ACPI: SSDT (null) 002CC (v01    AMI      IST 00000001
MSFT 03000001)
[    0.344998] ACPI: Interpreter enabled
[    0.345000] ACPI: (supports S0 S3 S4 S5)
[    0.345014] ACPI: Using IOAPIC for interrupt routing
[    0.345105] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem
0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.345161] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved
in ACPI motherboard resources
[    0.361202] ACPI: No dock devices found.
[    0.361205] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.361385] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.361509] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.361511] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.361513] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.361515] pci_root PNP0A08:00: host bridge window [mem
0xd0000000-0xffffffff]
[    0.361551] pci 0000:00:02.0: reg 10: [mem 0xe3400000-0xe37fffff 64bit]
[    0.361556] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.361559] pci 0000:00:02.0: reg 20: [io  0xf1c0-0xf1c7]
[    0.361581] pci 0000:00:02.1: reg 10: [mem 0xe3a00000-0xe3afffff 64bit]
[    0.361631] pci 0000:00:03.0: reg 10: [mem 0xe3c26100-0xe3c2610f 64bit]
[    0.361685] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.361689] pci 0000:00:03.0: PME# disabled
[    0.361735] pci 0000:00:19.0: reg 10: [mem 0xe3c00000-0xe3c1ffff]
[    0.361740] pci 0000:00:19.0: reg 14: [mem 0xe3c24000-0xe3c24fff]
[    0.361744] pci 0000:00:19.0: reg 18: [io  0xf100-0xf11f]
[    0.361774] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.361777] pci 0000:00:19.0: PME# disabled
[    0.361813] pci 0000:00:1a.0: reg 20: [io  0xf0e0-0xf0ff]
[    0.361866] pci 0000:00:1a.1: reg 20: [io  0xf0c0-0xf0df]
[    0.361917] pci 0000:00:1a.2: reg 20: [io  0xf0a0-0xf0bf]
[    0.361967] pci 0000:00:1a.7: reg 10: [mem 0xe3c25c00-0xe3c25fff]
[    0.362011] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.362014] pci 0000:00:1a.7: PME# disabled
[    0.362041] pci 0000:00:1b.0: reg 10: [mem 0xe3c20000-0xe3c23fff 64bit]
[    0.362073] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.362076] pci 0000:00:1b.0: PME# disabled
[    0.362128] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.362131] pci 0000:00:1c.0: PME# disabled
[    0.362184] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.362187] pci 0000:00:1c.3: PME# disabled
[    0.362238] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.362241] pci 0000:00:1c.4: PME# disabled
[    0.362282] pci 0000:00:1d.0: reg 20: [io  0xf080-0xf09f]
[    0.362332] pci 0000:00:1d.1: reg 20: [io  0xf060-0xf07f]
[    0.362383] pci 0000:00:1d.2: reg 20: [io  0xf040-0xf05f]
[    0.362435] pci 0000:00:1d.7: reg 10: [mem 0xe3c25800-0xe3c25bff]
[    0.362478] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.362482] pci 0000:00:1d.7: PME# disabled
[    0.362576] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by
ICH6 ACPI/GPIO/TCO
[    0.362579] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    0.362582] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
0a00 (mask 00ff)
[    0.362628] pci 0000:00:1f.2: reg 10: [io  0xf1b0-0xf1b7]
[    0.362633] pci 0000:00:1f.2: reg 14: [io  0xf1a0-0xf1a3]
[    0.362637] pci 0000:00:1f.2: reg 18: [io  0xf190-0xf197]
[    0.362641] pci 0000:00:1f.2: reg 1c: [io  0xf180-0xf183]
[    0.362646] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    0.362650] pci 0000:00:1f.2: reg 24: [mem 0xe3c25000-0xe3c257ff]
[    0.362673] pci 0000:00:1f.2: PME# supported from D3hot
[    0.362676] pci 0000:00:1f.2: PME# disabled
[    0.362698] pci 0000:00:1f.3: reg 10: [mem 0xe3c26000-0xe3c260ff 64bit]
[    0.362708] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    0.362738] pci 0000:00:1f.5: reg 10: [io  0xf170-0xf177]
[    0.362743] pci 0000:00:1f.5: reg 14: [io  0xf160-0xf163]
[    0.362747] pci 0000:00:1f.5: reg 18: [io  0xf150-0xf157]
[    0.362751] pci 0000:00:1f.5: reg 1c: [io  0xf140-0xf143]
[    0.362756] pci 0000:00:1f.5: reg 20: [io  0xf130-0xf13f]
[    0.362760] pci 0000:00:1f.5: reg 24: [io  0xf120-0xf12f]
[    0.362813] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.362816] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.362820] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.362824] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.362887] pci 0000:02:00.0: reg 10: [mem 0xe3800000-0xe39fffff 64bit]
[    0.362958] pci 0000:02:00.0: supports D1 D2
[    0.362960] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.362965] pci 0000:02:00.0: PME# disabled
[    0.368016] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.368020] pci 0000:00:1c.3:   bridge window [io  0xf000-0x0000] (disabled)
[    0.368024] pci 0000:00:1c.3:   bridge window [mem 0xe3800000-0xe39fffff]
[    0.368030] pci 0000:00:1c.3:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.368107] pci 0000:03:00.0: reg 10: [mem 0xe3b40000-0xe3b5ffff]
[    0.368118] pci 0000:03:00.0: reg 14: [mem 0xe3b20000-0xe3b3ffff]
[    0.368129] pci 0000:03:00.0: reg 18: [io  0xe000-0xe01f]
[    0.368179] pci 0000:03:00.0: reg 30: [mem 0xe3b00000-0xe3b1ffff pref]
[    0.368225] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.368230] pci 0000:03:00.0: PME# disabled
[    0.368258] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe
device.  You can enable it with 'pcie_aspm=force'
[    0.368268] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.368271] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.368274] pci 0000:00:1c.4:   bridge window [mem 0xe3b00000-0xe3bfffff]
[    0.368279] pci 0000:00:1c.4:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.368316] pci 0000:04:00.0: reg 10: [mem 0xe2000000-0xe2ffffff]
[    0.368379] pci 0000:04:00.1: reg 10: [mem 0xe1000000-0xe1ffffff]
[    0.368437] pci 0000:04:00.2: reg 10: [mem 0xe0000000-0xe0ffffff]
[    0.368501] pci 0000:04:01.0: reg 10: [mem 0xe3000000-0xe3000fff]
[    0.368506] pci 0000:04:01.0: reg 14: [mem 0xe3001000-0xe30010ff]
[    0.368540] pci 0000:04:01.0: supports D1 D2
[    0.368541] pci 0000:04:01.0: PME# supported from D0 D1 D2 D3hot
[    0.368545] pci 0000:04:01.0: PME# disabled
[    0.368581] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    0.368584] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.368588] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe30fffff]
[    0.368592] pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.368594] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.368596] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.368598] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.368600] pci 0000:00:1e.0:   bridge window [mem
0xd0000000-0xffffffff] (subtractive decode)
[    0.368616] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.368722] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.368790] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.368833] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.368870] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.374624] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.374696] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.374768] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.374839] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.374909] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.374980] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.375051] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.375121] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.375184] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.375195] vgaarb: loaded
[    0.375205] PCI: Using ACPI for IRQ routing
[    0.375205] PCI: pci_cache_line_size set to 64 bytes
[    0.375205] reserve RAM buffer: 000000000009d800 - 000000000009ffff
[    0.375205] reserve RAM buffer: 00000000cbba8000 - 00000000cbffffff
[    0.375205] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.375205] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.375205] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.384019] Switching to clocksource tsc
[    0.384871] pnp: PnP ACPI init
[    0.384876] ACPI: bus type pnp registered
[    0.386548] pnp: PnP ACPI: found 11 devices
[    0.386550] ACPI: ACPI bus type pnp unregistered
[    0.386556] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
[    0.386558] system 00:01: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.386561] system 00:01: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.386564] system 00:02: [io  0x0a20-0x0a3f] has been reserved
[    0.386566] system 00:02: [io  0x0a00-0x0a1f] has been reserved
[    0.386568] system 00:02: [io  0x0b78-0x0b7f] has been reserved
[    0.386570] system 00:02: [io  0x0f78-0x0f7f] has been reserved
[    0.386574] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.386578] system 00:09: [io  0x0400-0x047f] has been reserved
[    0.386580] system 00:09: [io  0x1180-0x119f] has been reserved
[    0.386582] system 00:09: [io  0x0500-0x057f] could not be reserved
[    0.386584] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.386587] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.386589] system 00:09: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.386591] system 00:09: [mem 0xfed20000-0xfed9ffff] has been reserved
[    0.386593] system 00:09: [mem 0xff000000-0xffffffff] has been reserved
[    0.392151] pci 0000:00:1c.0: BAR 14: assigned [mem 0xe3100000-0xe32fffff]
[    0.392154] pci 0000:00:1c.0: BAR 15: assigned [mem
0xe3d00000-0xe3efffff 64bit pref]
[    0.392157] pci 0000:00:1c.3: BAR 15: assigned [mem
0xe3f00000-0xe40fffff 64bit pref]
[    0.392159] pci 0000:00:1c.4: BAR 15: assigned [mem
0xe4100000-0xe42fffff 64bit pref]
[    0.392161] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.392163] pci 0000:00:1c.3: BAR 13: assigned [io  0x3000-0x3fff]
[    0.392165] pci 0000:00:1c.0: PCI bridge to [bus 01-01]
[    0.392168] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.392172] pci 0000:00:1c.0:   bridge window [mem 0xe3100000-0xe32fffff]
[    0.392175] pci 0000:00:1c.0:   bridge window [mem
0xe3d00000-0xe3efffff 64bit pref]
[    0.392180] pci 0000:00:1c.3: PCI bridge to [bus 02-02]
[    0.392182] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.392186] pci 0000:00:1c.3:   bridge window [mem 0xe3800000-0xe39fffff]
[    0.392189] pci 0000:00:1c.3:   bridge window [mem
0xe3f00000-0xe40fffff 64bit pref]
[    0.392194] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.392196] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.392200] pci 0000:00:1c.4:   bridge window [mem 0xe3b00000-0xe3bfffff]
[    0.392203] pci 0000:00:1c.4:   bridge window [mem
0xe4100000-0xe42fffff 64bit pref]
[    0.392208] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    0.392209] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.392213] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe30fffff]
[    0.392216] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.392227]   alloc irq_desc for 17 on node -1
[    0.392228]   alloc kstat_irqs on node -1
[    0.392232] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.392236] pci 0000:00:1c.0: setting latency timer to 64
[    0.392242]   alloc irq_desc for 19 on node -1
[    0.392243]   alloc kstat_irqs on node -1
[    0.392245] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.392249] pci 0000:00:1c.3: setting latency timer to 64
[    0.392255] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.392258] pci 0000:00:1c.4: setting latency timer to 64
[    0.392263] pci 0000:00:1e.0: setting latency timer to 64
[    0.392265] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.392267] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.392269] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.392270] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xffffffff]
[    0.392272] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.392273] pci_bus 0000:01: resource 1 [mem 0xe3100000-0xe32fffff]
[    0.392275] pci_bus 0000:01: resource 2 [mem 0xe3d00000-0xe3efffff
64bit pref]
[    0.392277] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.392278] pci_bus 0000:02: resource 1 [mem 0xe3800000-0xe39fffff]
[    0.392280] pci_bus 0000:02: resource 2 [mem 0xe3f00000-0xe40fffff
64bit pref]
[    0.392281] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.392283] pci_bus 0000:03: resource 1 [mem 0xe3b00000-0xe3bfffff]
[    0.392285] pci_bus 0000:03: resource 2 [mem 0xe4100000-0xe42fffff
64bit pref]
[    0.392286] pci_bus 0000:04: resource 1 [mem 0xe0000000-0xe30fffff]
[    0.392288] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.392289] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.392291] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.392292] pci_bus 0000:04: resource 7 [mem 0xd0000000-0xffffffff]
[    0.392311] NET: Registered protocol family 2
[    0.392469] IP route cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    0.393347] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.396011] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.396396] TCP: Hash tables configured (established 524288 bind 65536)
[    0.396398] TCP reno registered
[    0.396413] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.396473] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.396610] NET: Registered protocol family 1
[    0.396626] pci 0000:00:02.0: Boot video device
[    1.996006] pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    3.596006] pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
[    3.596144] PCI: CLS 64 bytes, default 64
[    3.596198] Unpacking initramfs...
[    5.263027] Freeing initrd memory: 95584k freed
[    5.291369] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.291373] Placing 64MB software IO TLB between ffff880001b9e000 -
ffff880005b9e000
[    5.291375] software IO TLB at phys 0x1b9e000 - 0x5b9e000
[    5.291779] audit: initializing netlink socket (disabled)
[    5.291790] type=2000 audit(1287370981.288:1): initialized
[    5.303899] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.305053] VFS: Disk quotas dquot_6.5.2
[    5.305093] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.305155] msgmni has been set to 15621
[    5.305487] alg: No test for stdrng (krng)
[    5.305554] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    5.305556] io scheduler noop registered
[    5.305558] io scheduler deadline registered
[    5.305582] io scheduler cfq registered (default)
[    5.305651] pcieport 0000:00:1c.0: setting latency timer to 64
[    5.305678]   alloc irq_desc for 40 on node -1
[    5.305680]   alloc kstat_irqs on node -1
[    5.305690] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    5.305747] pcieport 0000:00:1c.3: setting latency timer to 64
[    5.305769]   alloc irq_desc for 41 on node -1
[    5.305770]   alloc kstat_irqs on node -1
[    5.305776] pcieport 0000:00:1c.3: irq 41 for MSI/MSI-X
[    5.305834] pcieport 0000:00:1c.4: setting latency timer to 64
[    5.305857]   alloc irq_desc for 42 on node -1
[    5.305858]   alloc kstat_irqs on node -1
[    5.305864] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    5.306156] Linux agpgart interface v0.103
[    5.306233] agpgart-intel 0000:00:00.0: Intel G45/G43 Chipset
[    5.307775] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    5.321515] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    5.321555] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.321646] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.321872] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.322027] PNP: No PS/2 controller found. Probing ports directly.
[    5.326498] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.326508] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.326590] mice: PS/2 mouse device common for all mice
[    5.326622] rtc_cmos 00:05: RTC can wake from S4
[    5.326650] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    5.326672] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    5.326681] cpuidle: using governor ladder
[    5.326682] cpuidle: using governor menu
[    5.326688] No iBFT detected.
[    5.326861] TCP cubic registered
[    5.326939] NET: Registered protocol family 10
[    5.327188] lo: Disabled Privacy Extensions
[    5.327321] Mobile IPv6
[    5.327323] NET: Registered protocol family 17
[    5.327383] PM: Resume from disk failed.
[    5.327391] registered taskstats version 1
[    5.327706] rtc_cmos 00:05: setting system clock to 2010-10-18
03:03:01 UTC (1287370981)
[    5.327741] Initalizing network drop monitor service
[    5.327774] Freeing unused kernel memory: 592k freed
[    5.327863] Write protecting the kernel read-only data: 6144k
[    5.327987] Freeing unused kernel memory: 960k freed
[    5.328203] Freeing unused kernel memory: 452k freed
[    5.339068] udev: starting version 160
[    5.351912] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
[    5.351916] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    5.351960]   alloc irq_desc for 20 on node -1
[    5.351963]   alloc kstat_irqs on node -1
[    5.351974] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.351987] e1000e 0000:00:19.0: setting latency timer to 64
[    5.352114]   alloc irq_desc for 43 on node -1
[    5.352116]   alloc kstat_irqs on node -1
[    5.352126] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    5.382248] usbcore: registered new interface driver usbfs
[    5.382267] usbcore: registered new interface driver hub
[    5.393493] usbcore: registered new device driver usb
[    5.397617] SCSI subsystem initialized
[    5.407701]   alloc irq_desc for 22 on node -1
[    5.407704]   alloc kstat_irqs on node -1
[    5.407711] firewire_ohci 0000:04:01.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    5.414711] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.426508] libata version 3.00 loaded.
[    5.548008] firewire_ohci: Added fw-ohci device 0000:04:01.0, OHCI
v1.0, 8 IR + 8 IT contexts, quirks 0x0
[    5.620274] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width
x1) 00:1c:c0:6e:f3:df
[    5.620276] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.620298] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[    5.620322] e1000e 0000:03:00.0: Disabling ASPM  L1
[    5.620330]   alloc irq_desc for 18 on node -1
[    5.620332]   alloc kstat_irqs on node -1
[    5.620337] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.620341]   alloc irq_desc for 16 on node -1
[    5.620343]   alloc kstat_irqs on node -1
[    5.620350] e1000e 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.620367] e1000e 0000:03:00.0: setting latency timer to 64
[    5.620493] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    5.620496] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.620512] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[    5.620546]   alloc irq_desc for 44 on node -1
[    5.620550] ehci_hcd 0000:00:1a.7: debug port 1
[    5.620551]   alloc kstat_irqs on node -1
[    5.620568] e1000e 0000:03:00.0: irq 44 for MSI/MSI-X
[    5.624425] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    5.624435] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe3c25c00
[    5.640007] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.640026] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.640029] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    5.640031] usb usb1: Product: EHCI Host Controller
[    5.640033] usb usb1: Manufacturer: Linux 2.6.35.5 ehci_hcd
[    5.640035] usb usb1: SerialNumber: 0000:00:1a.7
[    5.640134] hub 1-0:1.0: USB hub found
[    5.640138] hub 1-0:1.0: 6 ports detected
[    5.640217]   alloc irq_desc for 23 on node -1
[    5.640219]   alloc kstat_irqs on node -1
[    5.640222] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.640233] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.640236] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.640242] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[    5.640261] ehci_hcd 0000:00:1d.7: debug port 1
[    5.644135] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    5.644145] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe3c25800
[    5.660006] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.660020] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.660022] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    5.660025] usb usb2: Product: EHCI Host Controller
[    5.660026] usb usb2: Manufacturer: Linux 2.6.35.5 ehci_hcd
[    5.660028] usb usb2: SerialNumber: 0000:00:1d.7
[    5.660107] hub 2-0:1.0: USB hub found
[    5.660111] hub 2-0:1.0: 6 ports detected
[    5.660183] ata_piix 0000:00:1f.5: version 2.13
[    5.660195] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.660198] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    5.660229] ata_piix 0000:00:1f.5: setting latency timer to 64
[    5.660292] scsi0 : ata_piix
[    5.660365] scsi1 : ata_piix
[    5.660398] ata1: SATA max UDMA/133 cmd 0xf170 ctl 0xf160 bmdma 0xf130 irq 19
[    5.660401] ata2: SATA max UDMA/133 cmd 0xf150 ctl 0xf140 bmdma 0xf138 irq 19
[    5.660424] ahci 0000:00:1f.2: version 3.0
[    5.660434] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.660469]   alloc irq_desc for 45 on node -1
[    5.660470]   alloc kstat_irqs on node -1
[    5.660477] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    5.660542] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3
Gbps 0x3f impl SATA mode
[    5.660545] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio
slum part ccc ems sxs
[    5.660548] ahci 0000:00:1f.2: setting latency timer to 64
[    5.661547] uhci_hcd: USB Universal Host Controller Interface driver
[    5.701542] scsi2 : ahci
[    5.701608] scsi3 : ahci
[    5.701678] scsi4 : ahci
[    5.701742] scsi5 : ahci
[    5.701811] scsi6 : ahci
[    5.701873] scsi7 : ahci
[    5.701904] ata3: SATA max UDMA/133 abar m2048@0xe3c25000 port
0xe3c25100 irq 45
[    5.701906] ata4: SATA max UDMA/133 abar m2048@0xe3c25000 port
0xe3c25180 irq 45
[    5.701908] ata5: SATA max UDMA/133 abar m2048@0xe3c25000 port
0xe3c25200 irq 45
[    5.701911] ata6: SATA max UDMA/133 abar m2048@0xe3c25000 port
0xe3c25280 irq 45
[    5.701913] ata7: SATA max UDMA/133 abar m2048@0xe3c25000 port
0xe3c25300 irq 45
[    5.701915] ata8: SATA max UDMA/133 abar m2048@0xe3c25000 port
0xe3c25380 irq 45
[    5.701951] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.701958] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.701961] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.701967] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    5.701999] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0e0
[    5.702032] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.702034] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    5.702036] usb usb3: Product: UHCI Host Controller
[    5.702037] usb usb3: Manufacturer: Linux 2.6.35.5 uhci_hcd
[    5.702038] usb usb3: SerialNumber: 0000:00:1a.0
[    5.702105] hub 3-0:1.0: USB hub found
[    5.702108] hub 3-0:1.0: 2 ports detected
[    5.702155]   alloc irq_desc for 21 on node -1
[    5.702157]   alloc kstat_irqs on node -1
[    5.702160] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.702165] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.702167] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.702172] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
[    5.702200] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000f0c0
[    5.702224] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.702226] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    5.702228] usb usb4: Product: UHCI Host Controller
[    5.702229] usb usb4: Manufacturer: Linux 2.6.35.5 uhci_hcd
[    5.702230] usb usb4: SerialNumber: 0000:00:1a.1
[    5.702290] hub 4-0:1.0: USB hub found
[    5.702293] hub 4-0:1.0: 2 ports detected
[    5.702340] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.702345] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.702347] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.702352] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
bus number 5
[    5.702372] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000f0a0
[    5.702395] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.702397] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    5.702398] usb usb5: Product: UHCI Host Controller
[    5.702399] usb usb5: Manufacturer: Linux 2.6.35.5 uhci_hcd
[    5.702401] usb usb5: SerialNumber: 0000:00:1a.2
[    5.702460] hub 5-0:1.0: USB hub found
[    5.702463] hub 5-0:1.0: 2 ports detected
[    5.702509] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.702513] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.702516] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.702520] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 6
[    5.702541] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[    5.702564] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.702565] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    5.702567] usb usb6: Product: UHCI Host Controller
[    5.702568] usb usb6: Manufacturer: Linux 2.6.35.5 uhci_hcd
[    5.702570] usb usb6: SerialNumber: 0000:00:1d.0
[    5.702629] hub 6-0:1.0: USB hub found
[    5.702632] hub 6-0:1.0: 2 ports detected
[    5.702679] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.702684] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.702686] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.702691] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 7
[    5.702711] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[    5.702736] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.702737] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    5.702739] usb usb7: Product: UHCI Host Controller
[    5.702740] usb usb7: Manufacturer: Linux 2.6.35.5 uhci_hcd
[    5.702742] usb usb7: SerialNumber: 0000:00:1d.1
[    5.702801] hub 7-0:1.0: USB hub found
[    5.702804] hub 7-0:1.0: 2 ports detected
[    5.702853] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.702858] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.702860] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.702865] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 8
[    5.702885] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[    5.702908] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    5.702910] usb usb8: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    5.702912] usb usb8: Product: UHCI Host Controller
[    5.702913] usb usb8: Manufacturer: Linux 2.6.35.5 uhci_hcd
[    5.702914] usb usb8: SerialNumber: 0000:00:1d.2
[    5.702977] hub 8-0:1.0: USB hub found
[    5.702980] hub 8-0:1.0: 2 ports detected
[    5.804407] e1000e 0000:03:00.0: eth1: (PCI Express:2.5GB/s:Width
x1) 00:1b:21:1e:2f:3a
[    5.804410] e1000e 0000:03:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    5.804495] e1000e 0000:03:00.0: eth1: MAC: 1, PHY: 4, PBA No: d50854-003
[    5.990791] ata2: SATA link down (SStatus 0 SControl 300)
[    6.020024] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.020030] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.020063] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.020068] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.020095] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.020098] ata8: SATA link down (SStatus 0 SControl 300)
[    6.021286] ata3.00: ATA-6: ST3250310NS, SN04, max UDMA/133
[    6.021289] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    6.022832] ata5.00: ATA-6: ST3160023AS, 3.18, max UDMA/133
[    6.022835] ata5.00: 312581808 sectors, multi 16: LBA48
[    6.022917] ata6.00: ATA-6: ST3160023AS, 3.05, max UDMA/133
[    6.022920] ata3.00: configured for UDMA/133
[    6.022923] ata6.00: 312581808 sectors, multi 16: LBA48
[    6.023024] ata4.00: ATA-6: ST3160023AS, 3.05, max UDMA/133
[    6.023026] ata4.00: 312581808 sectors, multi 16: LBA48
[    6.025910] ata5.00: configured for UDMA/133
[    6.026022] ata6.00: configured for UDMA/133
[    6.026148] ata4.00: configured for UDMA/133
[    6.036064] firewire_core: created device fw0: GUID 009027000223d592, S400
[    6.048678] ata7.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
[    6.048681] ata7.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    6.064510] usb 1-5: new high speed USB device using ehci_hcd and address 3
[    6.090648] ata7.00: configured for UDMA/133
[    6.144041] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.144180] scsi 2:0:0:0: Direct-Access     ATA      ST3250310NS
  SN04 PQ: 0 ANSI: 5
[    6.144331] scsi 3:0:0:0: Direct-Access     ATA      ST3160023AS
  3.05 PQ: 0 ANSI: 5
[    6.144455] scsi 4:0:0:0: Direct-Access     ATA      ST3160023AS
  3.18 PQ: 0 ANSI: 5
[    6.144604] scsi 5:0:0:0: Direct-Access     ATA      ST3160023AS
  3.05 PQ: 0 ANSI: 5
[    6.144735] scsi 6:0:0:0: Direct-Access     ATA      ST31500341AS
  CC1H PQ: 0 ANSI: 5
[    6.154559] sd 2:0:0:0: [sda] 488397168 512-byte logical blocks:
(250 GB/232 GiB)
[    6.154604] sd 2:0:0:0: [sda] Write Protect is off
[    6.154606] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.154619] sd 3:0:0:0: [sdb] 312581808 512-byte logical blocks:
(160 GB/149 GiB)
[    6.154646] sd 4:0:0:0: [sdc] 312581808 512-byte logical blocks:
(160 GB/149 GiB)
[    6.154663] sd 3:0:0:0: [sdb] Write Protect is off
[    6.154665] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    6.154683] sd 5:0:0:0: [sdd] 312581808 512-byte logical blocks:
(160 GB/149 GiB)
[    6.154685] sd 3:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.154742] sd 6:0:0:0: [sde] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[    6.154749] sd 4:0:0:0: [sdc] Write Protect is off
[    6.154751] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    6.154761] sd 5:0:0:0: [sdd] Write Protect is off
[    6.154763] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    6.154783] sd 6:0:0:0: [sde] Write Protect is off
[    6.154784] sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    6.154788] sd 4:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.154802]  sdb:
[    6.154807] sd 6:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.154852] sd 5:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.154881] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.154934]  sde:
[    6.155078]  sda:
[    6.155118]  sdd:
[    6.155146]  sdc: sdc1
[    6.159502] sd 4:0:0:0: [sdc] Attached SCSI disk
[    6.160354]  sde1
[    6.160526] sd 6:0:0:0: [sde] Attached SCSI disk
[    6.163331]  sdd1
[    6.163501] sd 5:0:0:0: [sdd] Attached SCSI disk
[    6.163620]  sdb1
[    6.163794] sd 3:0:0:0: [sdb] Attached SCSI disk
[    6.170007]  sda1 sda2 sda3 < sda5
[    6.201883] usb 1-5: New USB device found, idVendor=05e3, idProduct=0605
[    6.201886] usb 1-5: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    6.201888] usb 1-5: Product: USB2.0 Hub
[    6.202290] hub 1-5:1.0: USB hub found
[    6.202635] hub 1-5:1.0: 4 ports detected
[    6.210839]  sda6 > sda4
[    6.229389] sd 2:0:0:0: [sda] Attached SCSI disk
[    6.496012] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    6.667047] usb 4-2: New USB device found, idVendor=413c, idProduct=1003
[    6.667050] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.667052] usb 4-2: Product: Dell USB Keyboard Hub
[    6.667054] usb 4-2: Manufacturer: Dell
[    6.675073] hub 4-2:1.0: USB hub found
[    6.676047] hub 4-2:1.0: 3 ports detected
[    6.774606] async_tx: api initialized (async)
[    6.775070] xor: automatically using best checksumming function: generic_sse
[    6.793504]    generic_sse: 10582.000 MB/sec
[    6.793506] xor: using function: generic_sse (10582.000 MB/sec)
[    6.861526] raid6: int64x1   2361 MB/s
[    6.924506] usb 5-2: new low speed USB device using uhci_hcd and address 2
[    6.929517] raid6: int64x2   3160 MB/s
[    6.997527] raid6: int64x4   2497 MB/s
[    7.065506] raid6: int64x8   2108 MB/s
[    7.107142] usb 5-2: New USB device found, idVendor=0518, idProduct=0001
[    7.107144] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.107146] usb 5-2: Product: PS2 to USB Converter
[    7.107147] usb 5-2: Manufacturer: CHESEN
[    7.128648] usbcore: registered new interface driver hiddev
[    7.133506] raid6: sse2x1    4894 MB/s
[    7.142313] input: CHESEN PS2 to USB Converter as
/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input0
[    7.142354] generic-usb 0003:0518:0001.0001: input,hidraw0: USB HID
v1.10 Keyboard [CHESEN PS2 to USB Converter] on
usb-0000:00:1a.2-2/input0
[    7.164399] input: CHESEN PS2 to USB Converter as
/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/input/input1
[    7.164446] generic-usb 0003:0518:0001.0002: input,hidraw1: USB HID
v1.10 Mouse [CHESEN PS2 to USB Converter] on usb-0000:00:1a.2-2/input1
[    7.164457] usbcore: registered new interface driver usbhid
[    7.164458] usbhid: USB HID core driver
[    7.192835] usb 1-5.1: new low speed USB device using ehci_hcd and address 5
[    7.201515] raid6: sse2x2    5428 MB/s
[    7.269508] raid6: sse2x4    8384 MB/s
[    7.269513] raid6: using algorithm sse2x4 (8384 MB/s)
[    7.277049] md: raid6 personality registered for level 6
[    7.277052] md: raid5 personality registered for level 5
[    7.277053] md: raid4 personality registered for level 4
[    7.308300] usb 1-5.1: New USB device found, idVendor=045e, idProduct=0039
[    7.308304] usb 1-5.1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    7.308306] usb 1-5.1: Product: Microsoft IntelliMouse® Optical
[    7.308308] usb 1-5.1: Manufacturer: Microsoft
[    7.315124] input: Microsoft Microsoft IntelliMouse® Optical as
/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.1/1-5.1:1.0/input/input2
[    7.315177] generic-usb 0003:045E:0039.0003: input,hidraw2: USB HID
v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on
usb-0000:00:1a.7-5.1/input0
[    7.318196] md: md0 stopped.
[    7.319969] md: bind<sdc1>
[    7.320177] md: bind<sdd1>
[    7.320387] md: bind<sdb1>
[    7.321431] md/raid:md0: device sdb1 operational as raid disk 0
[    7.321433] md/raid:md0: device sdd1 operational as raid disk 2
[    7.321435] md/raid:md0: device sdc1 operational as raid disk 1
[    7.321710] md/raid:md0: allocated 3230kB
[    7.321755] md/raid:md0: raid level 5 active with 3 out of 3
devices, algorithm 2
[    7.321756] RAID conf printout:
[    7.321758]  --- level:5 rd:3 wd:3
[    7.321759]  disk 0, o:1, dev:sdb1
[    7.321761]  disk 1, o:1, dev:sdc1
[    7.321762]  disk 2, o:1, dev:sdd1
[    7.321780] md0: detected capacity change from 0 to 320078348288
[    7.322394] md0: detected capacity change from 0 to 320078348288
[    7.322398]  md0: unknown partition table
[    7.394916] usb 4-2.1: new full speed USB device using uhci_hcd and address 3
[    7.426376] PM: Starting manual resume from disk
[    7.426378] PM: Resume from partition 8:4
[    7.426379] PM: Checking hibernation image.
[    7.427561] PM: Error -22 checking image file
[    7.427562] PM: Resume from disk failed.
[    7.440095] EXT3-fs (sda1): recovery required on readonly filesystem
[    7.440099] EXT3-fs (sda1): write access will be enabled during recovery
[    7.468972] EXT3-fs: barriers not enabled
[    7.534884] usb 4-2.1: New USB device found, idVendor=413c, idProduct=2010
[    7.534888] usb 4-2.1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    7.534890] usb 4-2.1: Product: Dell USB Keyboard Hub
[    7.534892] usb 4-2.1: Manufacturer: Dell
[    7.545112] input: Dell Dell USB Keyboard Hub as
/devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2.1/4-2.1:1.0/input/input3
[    7.545163] generic-usb 0003:413C:2010.0004: input,hidraw3: USB HID
v1.10 Keyboard [Dell Dell USB Keyboard Hub] on
usb-0000:00:1a.1-2.1/input0
[    7.551954] input: Dell Dell USB Keyboard Hub as
/devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2.1/4-2.1:1.1/input/input4
[    7.551998] generic-usb 0003:413C:2010.0005: input,hidraw4: USB HID
v1.10 Device [Dell Dell USB Keyboard Hub] on
usb-0000:00:1a.1-2.1/input1
[    7.625869] usb 4-2.3: new low speed USB device using uhci_hcd and address 4
[    7.769837] usb 4-2.3: New USB device found, idVendor=045e, idProduct=0039
[    7.769840] usb 4-2.3: New USB device strings: Mfr=1, Product=3,
SerialNumber=0
[    7.769843] usb 4-2.3: Product: Microsoft 5-Button Mouse with IntelliEye(TM)
[    7.769845] usb 4-2.3: Manufacturer: Microsoft
[    7.788035] input: Microsoft Microsoft 5-Button Mouse with
IntelliEye(TM) as
/devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2.3/4-2.3:1.0/input/input5
[    7.788079] generic-usb 0003:045E:0039.0006: input,hidraw5: USB HID
v1.10 Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)]
on usb-0000:00:1a.1-2.3/input0
[    9.092901] kjournald starting.  Commit interval 5 seconds
[    9.092919] EXT3-fs (sda1): recovery complete
[    9.095252] EXT3-fs (sda1): mounted filesystem with ordered data mode
[   10.524338] udev: starting version 160
[   11.000360] ACPI: acpi_idle registered with cpuidle
[   11.000736] Marking TSC unstable due to TSC halts in idle
[   11.003182] Switching to clocksource hpet
[   11.153093] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input6
[   11.153135] ACPI: Power Button [PWRB]
[   11.153171] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input7
[   11.153189] ACPI: Power Button [PWRF]
[   11.250965] input: PC Speaker as /devices/platform/pcspkr/input/input8
[   11.526936] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[   12.081812] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[   12.082046]   alloc irq_desc for 46 on node -1
[   12.082047]   alloc kstat_irqs on node -1
[   12.082057] HDA Intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   12.082078] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.114217] IR NEC protocol handler initialized
[   12.127305] Linux video capture interface: v2.00
[   12.208136] IR RC5(x) protocol handler initialized
[   12.349043] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input9
[   12.370492] IR RC6 protocol handler initialized
[   12.388191] IR JVC protocol handler initialized
[   12.403178] IR Sony protocol handler initialized
[   12.409797] input: HDA Intel Mic at Ext Front Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   12.409849] input: HDA Intel Mic at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   12.409889] input: HDA Intel Line Out at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   12.409929] input: HDA Intel Line Out at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   12.409972] input: HDA Intel Line Out at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   12.410014] input: HDA Intel Line Out at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input15
[   12.410055] input: HDA Intel HP Out at Ext Front Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input16
[   13.569726] cx2388x alsa driver version 0.0.8 loaded
[   13.569763] cx88_audio 0000:04:00.1: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[   13.571229] cx88[0]: subsystem: 11bd:0051, board: Pinnacle PCTV HD
800i [card=58,autodetected], frontend(s): 1
[   13.571231] cx88[0]: TV tuner type 76, Radio tuner type -1
[   13.588138] cx23885 driver version 0.0.2 loaded
[   13.588159] cx23885 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   13.588369] CORE cx23885[0]: subsystem: 0070:2211, board: Hauppauge
WinTV-HVR1270 [card=18,autodetected]
[   13.715895] cx88/0: cx2388x v4l2 driver version 0.0.8 loaded
[   13.723377] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.8 loaded
[   13.734975] tveeprom 2-0050: Hauppauge model 22111, rev C2F5, serial# 6311974
[   13.734978] tveeprom 2-0050: MAC address is 00:0d:fe:60:50:26
[   13.734980] tveeprom 2-0050: tuner model is NXP 18271C2 (idx 155, type 54)
[   13.734982] tveeprom 2-0050: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[   13.734984] tveeprom 2-0050: audio processor is CX23888 (idx 40)
[   13.734985] tveeprom 2-0050: decoder processor is CX23888 (idx 34)
[   13.734987] tveeprom 2-0050: has no radio, has IR receiver, has no
IR transmitter
[   13.734989] cx23885[0]: hauppauge eeprom: model=22111
[   13.734991] cx23885_dvb_register() allocating 1 frontend(s)
[   13.734995] cx23885[0]: cx23885 based dvb card
[   13.738324] tuner 1-0064: chip found @ 0xc8 (cx88[0])
[   13.793079] xc5000 1-0064: creating new instance
[   13.794090] xc5000: Successfully identified at address 0x64
[   13.794091] xc5000: Firmware has not been loaded previously
[   13.794094] cx88[0]: Calling XC5000 callback
[   13.828332] tda18271 3-0060: creating new instance
[   13.830377] TDA18271HD/C2 detected @ 3-0060
[   13.836033] Registered IR keymap rc-pinnacle-pctv-hd
[   13.836087] input: cx88 IR (Pinnacle PCTV HD 800i) as
/devices/pci0000:00/0000:00:1e.0/0000:04:00.1/rc/rc0/input17
[   13.836130] rc0: cx88 IR (Pinnacle PCTV HD 800i) as
/devices/pci0000:00/0000:00:1e.0/0000:04:00.1/rc/rc0
[   13.836151] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   13.836376] cx8800 0000:04:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   13.836382] cx88[0]/0: found at 0000:04:00.0, rev: 5, irq: 21,
latency: 128, mmio: 0xe2000000
[   13.836413] cx88[0]/0: registered device video0 [v4l2]
[   13.836431] cx88[0]/0: registered device vbi0
[   13.838529] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[   13.903565] xc5000: firmware read 12401 bytes.
[   13.903566] xc5000: firmware uploading...
[   13.903569] cx88[0]: Calling XC5000 callback
[   14.064376] DVB: registering new adapter (cx23885[0])
[   14.064379] DVB: registering adapter 0 frontend 0 (LG Electronics
LGDT3305 VSB/QAM Frontend)...
[   14.064612] cx23885_dev_checkrevision() Hardware revision = 0xd0
[   14.064619] cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 19,
latency: 0, mmio: 0xe3800000
[   14.064626] cx23885 0000:02:00.0: setting latency timer to 64
[   15.992028] xc5000: firmware upload complete...
[   16.581615] cx88[0]/2: cx2388x 8802 Driver Manager
[   16.581632] cx88-mpeg driver manager 0000:04:00.2: PCI INT A -> GSI
21 (level, low) -> IRQ 21
[   16.581641] cx88[0]/2: found at 0000:04:00.2, rev: 5, irq: 21,
latency: 128, mmio: 0xe0000000
[   16.617724] cx88[0]: Calling XC5000 callback
[   16.643940] cx88/2: cx2388x dvb driver version 0.0.8 loaded
[   16.643943] cx88/2: registering cx8802 driver, type: dvb access: shared
[   16.643946] cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV
HD 800i [card=58]
[   16.643947] cx88[0]/2: cx2388x based DVB/ATSC card
[   16.643949] cx8802_alloc_frontends() allocating 1 frontend(s)
[   16.703268] xc5000 1-0064: attaching existing instance
[   16.704271] xc5000: Successfully identified at address 0x64
[   16.704272] xc5000: Firmware has been loaded previously
[   16.705641] DVB: registering new adapter (cx88[0])
[   16.705644] DVB: registering adapter 1 frontend 0 (Samsung S5H1409
QAM/8VSB Frontend)...
[   17.191220] Adding 7855780k swap on /dev/sda4.  Priority:-1
extents:1 across:7855780k
[   17.366389] EXT3-fs (sda1): using internal journal
[   17.465378] loop: module loaded
[   17.615965] [drm] Initialized drm 1.1.0 20060810
[   17.729097] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.729100] i915 0000:00:02.0: setting latency timer to 64
[   17.754611] mtrr: no more MTRRs available
[   17.754613] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   17.754718]   alloc irq_desc for 47 on node -1
[   17.754719]   alloc kstat_irqs on node -1
[   17.754727] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[   17.754734] [drm] set up 31M of stolen space
[   18.555166] Console: switching to colour frame buffer device 160x64
[   18.558181] fb0: inteldrmfb frame buffer device
[   18.558182] drm: registered panic notifier
[   18.558184] Slow work thread pool: Starting up
[   18.558308] Slow work thread pool: Ready
[   18.558426] ACPI Exception: AE_NOT_FOUND, Evaluating _DOD
(20100428/video-1937)
[   18.558469] input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input18
[   18.558496] ACPI: Video Device [GFX0] (multi-head: no  rom: yes  post: no)
[   18.558509] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   38.118594] EXT3-fs: barriers not enabled
[   38.128841] kjournald starting.  Commit interval 5 seconds
[   38.129302] EXT3-fs (sda5): using internal journal
[   38.129306] EXT3-fs (sda5): mounted filesystem with ordered data mode
[   38.160207] EXT3-fs: barriers not enabled
[   38.167902] kjournald starting.  Commit interval 5 seconds
[   38.168351] EXT3-fs (sda6): using internal journal
[   38.168355] EXT3-fs (sda6): mounted filesystem with ordered data mode
[   38.192609] EXT3-fs: barriers not enabled
[   38.194445] kjournald starting.  Commit interval 5 seconds
[   38.194862] EXT3-fs (sda2): using internal journal
[   38.194866] EXT3-fs (sda2): mounted filesystem with ordered data mode
[   38.226052] EXT3-fs: barriers not enabled
[   38.232140] kjournald starting.  Commit interval 5 seconds
[   38.232514] EXT3-fs (md0): using internal journal
[   38.232517] EXT3-fs (md0): mounted filesystem with ordered data mode
[   38.255953] EXT3-fs: barriers not enabled
[   38.256251] kjournald starting.  Commit interval 5 seconds
[   38.257046] EXT3-fs (sde1): using internal journal
[   38.257050] EXT3-fs (sde1): mounted filesystem with ordered data mode
[   39.044671] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   39.100058] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   39.100922] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   39.246748] ip_tables: (C) 2000-2006 Netfilter Core Team
[   39.329106] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   39.329295] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Please use
[   39.329296] nf_conntrack.acct=1 kernel parameter, acct=1
nf_conntrack module option or
[   39.329298] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   39.843671] fuse init (API version 7.14)

00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller (rev 03)
	Subsystem: Intel Corporation Device 5002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset
Integrated Graphics Controller (rev 03) (prog-if 00 [VGA controller])
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 47
	Region 0: Memory at e3400000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at f1c0 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 41b1
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation 4 Series Chipset
Integrated Graphics Controller (rev 03)
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at e3a00000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Communication controller: Intel Corporation 4 Series Chipset
HECI Controller (rev 03)
	Subsystem: Intel Corporation Device 5002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at e3c26100 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

00:19.0 Ethernet controller: Intel Corporation 82567LF-2 Gigabit
Network Connection
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at e3c00000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at e3c24000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at f100 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41c1
	Capabilities: [e0] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: e1000e
	Kernel modules: e1000e

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at f0e0 [size=32]
	Capabilities: [50] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at f0c0 [size=32]
	Capabilities: [50] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at f0a0 [size=32]
	Capabilities: [50] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2 (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Device 5002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at e3c25c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
Audio Controller
	Subsystem: Intel Corporation Device 5002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 46
	Region 0: Memory at e3c20000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 41a9
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=80
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Root Port 1 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: e3100000-e32fffff
	Prefetchable memory behind bridge: 00000000e3d00000-00000000e3efffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4149
	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Root Port 4 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: e3800000-e39fffff
	Prefetchable memory behind bridge: 00000000e3f00000-00000000e40fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4151
	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=04 ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Root Port 5 (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: e3b00000-e3bfffff
	Prefetchable memory behind bridge: 00000000e4100000-00000000e42fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch+ ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0f00c  Data: 4159
	Capabilities: [90] Subsystem: Gammagraphx, Inc. (or missing ID) Device 0000
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=05 ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at f080 [size=32]
	Capabilities: [50] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at f060 [size=32]
	Capabilities: [50] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at f040 [size=32]
	Capabilities: [50] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1 (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Device 5002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at e3c25800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=128
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: e0000000-e30fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Intel Corporation Device 5002

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
AHCI Controller (prog-if 01 [AHCI 1.0])
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 45
	Region 0: I/O ports at f1b0 [size=8]
	Region 1: I/O ports at f1a0 [size=4]
	Region 2: I/O ports at f190 [size=8]
	Region 3: I/O ports at f180 [size=4]
	Region 4: I/O ports at f020 [size=32]
	Region 5: Memory at e3c25000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
		Address: fee0f00c  Data: 4199
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at e3c26000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at f000 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port
SATA IDE Controller #2 (prog-if 85 [Master SecO PriO])
	Subsystem: Intel Corporation Device 5002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at f170 [size=8]
	Region 1: I/O ports at f160 [size=4]
	Region 2: I/O ports at f150 [size=8]
	Region 3: I/O ports at f140 [size=4]
	Region 4: I/O ports at f130 [size=16]
	Region 5: I/O ports at f120 [size=16]
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] Vendor Specific Information: Len=06 <?>
	Kernel driver in use: ata_piix
	Kernel modules: ata_piix, ata_generic

02:00.0 Multimedia video controller: Conexant Systems, Inc. Hauppauge
Inc. HDPVR-1250 model 1196 (rev 04)
	Subsystem: Hauppauge computer works Inc. Device 2211
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at e3800000 (64-bit, non-prefetchable) [disabled] [size=2M]
	Capabilities: [40] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<2us, L1 <4us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Vital Product Data
		Unknown small resource type 01, will not decode more.
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [200 v1] Virtual Channel
		Caps:	LPEVC=1 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32+ WRR64+ WRR128-
		Ctrl:	ArbSelect=WRR64
		Status:	InProgress-
		Port Arbitration Table [240] <?>
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=1 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Kernel driver in use: cx23885
	Kernel modules: cx23885

03:00.0 Ethernet controller: Intel Corporation 82572EI Gigabit
Ethernet Controller (Copper) (rev 06)
	Subsystem: Intel Corporation PRO/1000 PT Desktop Adapter
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 44
	Region 0: [virtual] Memory at e3b40000 (32-bit, non-prefetchable) [size=128K]
	Region 1: [virtual] Memory at e3b20000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at e000 [size=32]
	[virtual] Expansion ROM at e3b00000 [disabled] [size=128K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-1b-21-ff-ff-1e-2f-3a
	Kernel driver in use: e1000e
	Kernel modules: e1000e

04:00.0 Multimedia video controller: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
	Subsystem: Pinnacle Systems Inc. Device 0051
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 21
	Region 0: [virtual] Memory at e2000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data
		No end tag found
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: cx8800

04:00.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
PCI Video and Audio Decoder [Audio Port] (rev 05)
	Subsystem: Pinnacle Systems Inc. Device 0051
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 21
	Region 0: [virtual] Memory at e1000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: cx88-alsa

04:00.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3
PCI Video and Audio Decoder [MPEG Port] (rev 05)
	Subsystem: Pinnacle Systems Inc. Device 0051
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 21
	Region 0: [virtual] Memory at e0000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: cx88-mpeg driver manager
	Kernel modules: cx8802

04:01.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 70)
(prog-if 10 [OHCI])
	Subsystem: Agere Systems FW322/323
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 22
	Region 0: [virtual] Memory at e3000000 (32-bit, non-prefetchable) [size=4K]
	Region 1: [virtual] Memory at e3001000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci
