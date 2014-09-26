Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37900 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbaIZPfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 11:35:10 -0400
Date: Fri, 26 Sep 2014 12:35:04 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926123504.08b9fb1f@recife.lan>
In-Reply-To: <542584CD.6060507@osg.samsung.com>
References: <20140926080824.GA8382@linuxtv.org>
	<20140926071411.61a011bd@recife.lan>
	<20140926110727.GA880@linuxtv.org>
	<20140926084215.772adce9@recife.lan>
	<20140926090316.5ae56d93@recife.lan>
	<20140926122721.GA11597@linuxtv.org>
	<20140926101222.778ebcaf@recife.lan>
	<20140926132513.GA30084@linuxtv.org>
	<20140926142543.GA3806@linuxtv.org>
	<54257888.90802@osg.samsung.com>
	<20140926150602.GA15766@linuxtv.org>
	<542584CD.6060507@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Sep 2014 09:22:53 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 09/26/2014 09:06 AM, Johannes Stezenbach wrote:
> > On Fri, Sep 26, 2014 at 08:30:32AM -0600, Shuah Khan wrote:
> >> On 09/26/2014 08:25 AM, Johannes Stezenbach wrote:
> >>>
> >>> So, what is happening is that the em28xx driver still async initializes
> >>> while the initramfs already has started resume.  Thus the rootfs in not
> >>> mounted and the firmware is not loadable.  Maybe this is only an issue
> >>> of my qemu test because I compiled a non-modular kernel but don't have
> >>> the firmware in the initramfs for testing simplicity?
> >>>
> >>>
> >>
> >> Right. We have an issue when media drivers are compiled static
> >> (non-modular). I have been debugging that problem for a while.
> >> We have to separate the two cases - if you are compiling em28xx
> >> as static then you will run into the issue.
> > 
> > So I compiled em28xx as modules and installed them in my qemu image.
> > One issue solved, but it still breaks after resume:
> > 
> > [   20.212162] usb 1-1: reset high-speed USB device number 2 using ehci-pci
> > [   20.503868] em2884 #0: Resuming extensions
> > [   20.505275] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
> > [   20.533513] drxk: status = 0x439130d9
> > [   20.534282] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
> > [   23.008852] em2884 #0: writing to i2c device at 0x52 failed (error=-5)
> > [   23.011408] drxk: i2c write error at addr 0x29
> > [   23.013187] drxk: write_block: i2c write error at addr 0x8303b4
> > [   23.015440] drxk: Error -5 while loading firmware
> > [   23.017291] drxk: Error -5 on init_drxk
> > [   23.018835] em2884 #0: fe0 resume 0
> > 
> > Any idea on this?
> > 
> 
> Looks like this is what's happening:
> during suspend:
> 
> drxk_sleep() gets called and marks state->m_drxk_state == DRXK_UNINITIALIZED
> 
> init_drxk() does download_microcode() and this step fails
> because the conditions in which init_drxk() gets called
> from drxk_attach() are different.
> 
> i2c isn't ready.
> 
> Is it possible for you to test this without power loss
> on usb assuming this test run usb bus looses power?
> 
> If you could do the following tests and see if there is
> a difference:
> 
> echo mem > /sys/power/state

It follows the full logs on my test machine running fedora,
with suspend2ram:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc5version+ (mchehab@pedra.lan) (gcc version 4.8.1 (GCC) ) #1 SMP Fri Sep 26 12:16:16 BRT 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.17.0-rc5version+ root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root rhgb quiet LANG=pt_BR.UTF-8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000200fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020100000-0x00000000ad559fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ad55a000-0x00000000ad589fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ad58a000-0x00000000ad59afff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000ad59b000-0x00000000ad6ccfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ad6cd000-0x00000000ad9dafff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ad9db000-0x00000000ad9dbfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ad9dc000-0x00000000ada1dfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ada1e000-0x00000000adb93fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000adb94000-0x00000000adff8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000adff9000-0x00000000adffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed03000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed0c000-0x00000000fed0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff990000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x9d2cf018-0x9d2df057] usable ==> usable
[    0.000000] e820: update [mem 0x9d2c1018-0x9d2ce857] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000008efff] usable
[    0.000000] reserve setup_data: [mem 0x000000000008f000-0x000000000008ffff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x0000000000090000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000020000000-0x00000000200fffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000020100000-0x000000009d2c1017] usable
[    0.000000] reserve setup_data: [mem 0x000000009d2c1018-0x000000009d2ce857] usable
[    0.000000] reserve setup_data: [mem 0x000000009d2ce858-0x000000009d2cf017] usable
[    0.000000] reserve setup_data: [mem 0x000000009d2cf018-0x000000009d2df057] usable
[    0.000000] reserve setup_data: [mem 0x000000009d2df058-0x00000000ad559fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000ad55a000-0x00000000ad589fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ad58a000-0x00000000ad59afff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000ad59b000-0x00000000ad6ccfff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000ad6cd000-0x00000000ad9dafff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ad9db000-0x00000000ad9dbfff] usable
[    0.000000] reserve setup_data: [mem 0x00000000ad9dc000-0x00000000ada1dfff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ada1e000-0x00000000adb93fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000adb94000-0x00000000adff8fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000adff9000-0x00000000adffffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed03000-0x00000000fed03fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed0c000-0x00000000fed0ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1cfff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fef00000-0x00000000feffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff990000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000013fffffff] usable
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0xad58d000  ACPI 2.0=0xad58d000  SMBIOS=0xf04d0  MPS=0xfd4e0 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000008000-0x0000000000009000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000009000-0x000000000002f000) (0MB)
[    0.000000] efi: mem03: type=3, attr=0xf, range=[0x000000000002f000-0x000000000008f000) (0MB)
[    0.000000] efi: mem04: type=10, attr=0xf, range=[0x000000000008f000-0x0000000000090000) (0MB)
[    0.000000] efi: mem05: type=7, attr=0xf, range=[0x0000000000090000-0x000000000009f000) (0MB)
[    0.000000] efi: mem06: type=4, attr=0xf, range=[0x000000000009f000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem07: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem08: type=2, attr=0xf, range=[0x0000000001000000-0x0000000002414000) (20MB)
[    0.000000] efi: mem09: type=7, attr=0xf, range=[0x0000000002414000-0x0000000020000000) (475MB)
[    0.000000] efi: mem10: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020100000) (1MB)
[    0.000000] efi: mem11: type=7, attr=0xf, range=[0x0000000020100000-0x000000003ef47000) (494MB)
[    0.000000] efi: mem12: type=2, attr=0xf, range=[0x000000003ef47000-0x0000000040000000) (16MB)
[    0.000000] efi: mem13: type=7, attr=0xf, range=[0x0000000040000000-0x0000000066b5b000) (619MB)
[    0.000000] efi: mem14: type=2, attr=0xf, range=[0x0000000066b5b000-0x000000008e000000) (628MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x000000008e000000-0x000000008e020000) (0MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x000000008e020000-0x000000009d2c0000) (242MB)
[    0.000000] efi: mem17: type=2, attr=0xf, range=[0x000000009d2c0000-0x000000009d4aa000) (1MB)
[    0.000000] efi: mem18: type=1, attr=0xf, range=[0x000000009d4aa000-0x000000009d5e5000) (1MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x000000009d5e5000-0x00000000acc11000) (246MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x00000000acc11000-0x00000000acdec000) (1MB)
[    0.000000] efi: mem21: type=3, attr=0xf, range=[0x00000000acdec000-0x00000000ad55a000) (7MB)
[    0.000000] efi: mem22: type=0, attr=0xf, range=[0x00000000ad55a000-0x00000000ad58a000) (0MB)
[    0.000000] efi: mem23: type=9, attr=0xf, range=[0x00000000ad58a000-0x00000000ad59b000) (0MB)
[    0.000000] efi: mem24: type=10, attr=0xf, range=[0x00000000ad59b000-0x00000000ad6cd000) (1MB)
[    0.000000] efi: mem25: type=6, attr=0x800000000000000f, range=[0x00000000ad6cd000-0x00000000ad97f000) (2MB)
[    0.000000] efi: mem26: type=5, attr=0x800000000000000f, range=[0x00000000ad97f000-0x00000000ad9db000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x00000000ad9db000-0x00000000ad9dc000) (0MB)
[    0.000000] efi: mem28: type=6, attr=0x800000000000000f, range=[0x00000000ad9dc000-0x00000000ada1e000) (0MB)
[    0.000000] efi: mem29: type=4, attr=0xf, range=[0x00000000ada1e000-0x00000000adb94000) (1MB)
[    0.000000] efi: mem30: type=6, attr=0x800000000000000f, range=[0x00000000adb94000-0x00000000adff9000) (4MB)
[    0.000000] efi: mem31: type=4, attr=0xf, range=[0x00000000adff9000-0x00000000ae000000) (0MB)
[    0.000000] efi: mem32: type=7, attr=0xf, range=[0x0000000100000000-0x0000000140000000) (1024MB)
[    0.000000] efi: mem33: type=11, attr=0x8000000000000001, range=[0x00000000e0000000-0x00000000f0000000) (256MB)
[    0.000000] efi: mem34: type=11, attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] efi: mem35: type=11, attr=0x8000000000000001, range=[0x00000000fed01000-0x00000000fed02000) (0MB)
[    0.000000] efi: mem36: type=11, attr=0x8000000000000001, range=[0x00000000fed03000-0x00000000fed04000) (0MB)
[    0.000000] efi: mem37: type=11, attr=0x8000000000000001, range=[0x00000000fed08000-0x00000000fed09000) (0MB)
[    0.000000] efi: mem38: type=11, attr=0x8000000000000001, range=[0x00000000fed0c000-0x00000000fed10000) (0MB)
[    0.000000] efi: mem39: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed1d000) (0MB)
[    0.000000] efi: mem40: type=11, attr=0x8000000000000001, range=[0x00000000fee00000-0x00000000fee01000) (0MB)
[    0.000000] efi: mem41: type=11, attr=0x8000000000000001, range=[0x00000000fef00000-0x00000000ff000000) (1MB)
[    0.000000] efi: mem42: type=11, attr=0x8000000000000000, range=[0x00000000ff990000-0x0000000100000000) (6MB)
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: \xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff \xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff/DE3815TYKH, BIOS TYBYT10H.86A.0019.2014.0327.1516 03/27/201
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 0A0000000 mask FF0000000 write-back
[    0.000000]   3 base 0AE000000 mask FFE000000 uncachable
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xae000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xae000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd6a0-0x000fd6af] mapped at [ffff8800000fd6a0]
[    0.000000] Base memory trampoline at [ffff880000087000] 87000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01ff0000, 0x01ff0fff] PGTABLE
[    0.000000] BRK [0x01ff1000, 0x01ff1fff] PGTABLE
[    0.000000] BRK [0x01ff2000, 0x01ff2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13fe00000-0x13fffffff]
[    0.000000]  [mem 0x13fe00000-0x13fffffff] page 2M
[    0.000000] BRK [0x01ff3000, 0x01ff3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13c000000-0x13fdfffff]
[    0.000000]  [mem 0x13c000000-0x13fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x13bffffff]
[    0.000000]  [mem 0x100000000-0x13bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20100000-0xad559fff]
[    0.000000]  [mem 0x20100000-0x201fffff] page 4k
[    0.000000]  [mem 0x20200000-0xad3fffff] page 2M
[    0.000000]  [mem 0xad400000-0xad559fff] page 4k
[    0.000000] BRK [0x01ff4000, 0x01ff4fff] PGTABLE
[    0.000000] BRK [0x01ff5000, 0x01ff5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xad9db000-0xad9dbfff]
[    0.000000]  [mem 0xad9db000-0xad9dbfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xada1e000-0xadb93fff]
[    0.000000]  [mem 0xada1e000-0xadb93fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xadff9000-0xadffffff]
[    0.000000]  [mem 0xadff9000-0xadffffff] page 4k
[    0.000000] RAMDISK: [mem 0x3ef47000-0x3fffafff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000AD58D000 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000AD58D090 00009C (v01 INTEL  DE3815TY 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000AD598440 00010C (v05 INTEL  DE3815TY 01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 128/32 (20140724/tbfadt-618)
[    0.000000] ACPI: DSDT 0x00000000AD58D1B8 00B287 (v02 INTEL  DE3815TY 01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x00000000AD6CCF80 000040
[    0.000000] ACPI: APIC 0x00000000AD598550 00005A (v03 INTEL  DE3815TY 01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000AD5985B0 000044 (v01 INTEL  DE3815TY 01072009 AMI  00010013)
[    0.000000] ACPI: TCPA 0x00000000AD5985F8 000032 (v02 INTEL  DE3815TY 00000001 MSFT 01000013)
[    0.000000] ACPI: LPIT 0x00000000AD598630 000104 (v01 INTEL  DE3815TY 00000003 VLV2 0100000D)
[    0.000000] ACPI: MCFG 0x00000000AD598738 00003C (v01 INTEL  DE3815TY 01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000AD598778 000038 (v01 INTEL  DE3815TY 01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000AD5987B0 000353 (v01 INTEL  DE3815TY 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000AD598B08 000433 (v01 INTEL  DE3815TY 00003001 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000AD598F40 000763 (v01 INTEL  DE3815TY 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000AD5996A8 000290 (v01 INTEL  DE3815TY 00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 0x00000000AD599938 000042 (v01 INTEL  DE3815TY 00000000      00000000)
[    0.000000] ACPI: SSDT 0x00000000AD599980 000530 (v01 INTEL  DE3815TY 00000001 INTL 20120913)
[    0.000000] ACPI: CSRT 0x00000000AD599EB0 00014C (v00 INTEL  DE3815TY 00000005 INTL 20120624)
[    0.000000] ACPI: BGRT 0x00000000AD59A000 000038 (v01 INTEL  DE3815TY 01072009 AMI  00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fffffff]
[    0.000000]   NODE_DATA [mem 0x13ffe7000-0x13fffafff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013ba00000-ffff88013f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008efff]
[    0.000000]   node   0: [mem 0x00090000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20100000-0xad559fff]
[    0.000000]   node   0: [mem 0xad9db000-0xad9dbfff]
[    0.000000]   node   0: [mem 0xada1e000-0xadb93fff]
[    0.000000]   node   0: [mem 0xadff9000-0xadffffff]
[    0.000000]   node   0: [mem 0x100000000-0x13fffffff]
[    0.000000] On node 0 totalpages: 972150
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 39 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11032 pages used for memmap
[    0.000000]   DMA32 zone: 706008 pages, LIFO batch:31
[    0.000000]   Normal zone: 4096 pages used for memmap
[    0.000000]   Normal zone: 262144 pages, LIFO batch:31
[    0.000000] tboot: non-0 tboot_addr but it is not of type E820_RESERVED
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics stolen memory at 0xaf000000-0xbeffffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl edge lint[0x39])
[    0.000000] ACPI: NMI not connected to LINT 1!
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x0008f000-0x0008ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x200fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9d2c1000-0x9d2c1fff]
[    0.000000] PM: Registered nosave memory: [mem 0x9d2ce000-0x9d2cefff]
[    0.000000] PM: Registered nosave memory: [mem 0x9d2cf000-0x9d2cffff]
[    0.000000] PM: Registered nosave memory: [mem 0x9d2df000-0x9d2dffff]
[    0.000000] PM: Registered nosave memory: [mem 0xad55a000-0xad589fff]
[    0.000000] PM: Registered nosave memory: [mem 0xad58a000-0xad59afff]
[    0.000000] PM: Registered nosave memory: [mem 0xad59b000-0xad6ccfff]
[    0.000000] PM: Registered nosave memory: [mem 0xad6cd000-0xad9dafff]
[    0.000000] PM: Registered nosave memory: [mem 0xad9dc000-0xada1dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xadb94000-0xadff8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xae000000-0xaeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xaf000000-0xbeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbf000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed02000-0xfed02fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed03000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed0c000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1d000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xff98ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff990000-0xffffffff]
[    0.000000] e820: [mem 0xbf000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88013fc00000 s85504 r8192 d20992 u2097152
[    0.000000] pcpu-alloc: s85504 r8192 d20992 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 956919
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.17.0-rc5version+ root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root rhgb quiet LANG=pt_BR.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3465732K/3888600K available (6973K kernel code, 1096K rwdata, 3116K rodata, 1464K init, 1432K bss, 422868K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=1.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.000000] NR_IRQS:8448 nr_irqs:256 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 15728640 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Maximum core-clock to bus-clock ratio: 0xb
[    0.000000] Resolved frequency ID: 2, frequency: 133200 KHz
[    0.000000] TSC runs at 1465200 KHz
[    0.000000] lapic_timer_frequency = 133200
[    0.000000] tsc: Detected 1465.200 MHz processor
[    0.000052] Calibrating delay loop (skipped), value calculated using timer frequency.. 2930.40 BogoMIPS (lpj=1465200)
[    0.000059] pid_max: default: 32768 minimum: 301
[    0.000084] ACPI: Core revision 20140724
[    0.030309] ACPI: All ACPI Tables successfully acquired
[    0.032615] Security Framework initialized
[    0.032630] SELinux:  Initializing.
[    0.032643] SELinux:  Starting in permissive mode
[    0.033560] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.036258] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.037435] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.037456] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.037936] Initializing cgroup subsys memory
[    0.037954] Initializing cgroup subsys devices
[    0.037962] Initializing cgroup subsys freezer
[    0.037968] Initializing cgroup subsys net_cls
[    0.037975] Initializing cgroup subsys blkio
[    0.038014] Initializing cgroup subsys perf_event
[    0.038022] Initializing cgroup subsys hugetlb
[    0.038072] CPU: Physical Processor ID: 0
[    0.038080] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.044121] mce: CPU supports 6 MCE banks
[    0.044133] CPU0: Thermal monitoring handled by SMI
[    0.044145] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.051502] Freeing SMP alternatives memory: 24K (ffffffff81e82000 - ffffffff81e88000)
[    0.081878] ftrace: allocating 26497 entries in 104 pages
[    0.102670] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.112680] smpboot: CPU0: Intel(R) Atom(TM) CPU  E3815  @ 1.46GHz (fam: 06, model: 37, stepping: 03)
[    0.112709] TSC deadline timer enabled
[    0.112753] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, full-width counters, Intel PMU driver.
[    0.112773] ... version:                3
[    0.112776] ... bit width:              40
[    0.112779] ... generic registers:      2
[    0.112782] ... value mask:             000000ffffffffff
[    0.112785] ... max period:             000000ffffffffff
[    0.112787] ... fixed-purpose events:   3
[    0.112790] ... event mask:             0000000700000003
[    0.116058] x86: Booted up 1 node, 1 CPUs
[    0.116066] smpboot: Total of 1 processors activated (2930.40 BogoMIPS)
[    0.116424] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.116645] devtmpfs: initialized
[    0.117243] PM: Registering ACPI NVS region [mem 0x0008f000-0x0008ffff] (4096 bytes)
[    0.117250] PM: Registering ACPI NVS region [mem 0xad59b000-0xad6ccfff] (1253376 bytes)
[    0.120048] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.120057] pinctrl core: initialized pinctrl subsystem
[    0.120130] RTC time: 15:24:31, date: 09/26/14
[    0.120429] NET: Registered protocol family 16
[    0.120867] cpuidle: using governor menu
[    0.121098] ACPI: bus type PCI registered
[    0.121105] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.121240] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.121247] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.122286] PCI: Using configuration type 1 for base access
[    0.126224] ACPI: Added _OSI(Module Device)
[    0.126231] ACPI: Added _OSI(Processor Device)
[    0.126235] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.126238] ACPI: Added _OSI(Processor Aggregator Device)
[    0.146555] ACPI: Interpreter enabled
[    0.146577] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    0.146591] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.146629] ACPI: (supports S0 S3 S4 S5)
[    0.146634] ACPI: Using IOAPIC for interrupt routing
[    0.146718] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.159274] ACPI: Power Resource [USBC] (on)
[    0.161607] ACPI: Power Resource [PLPE] (on)
[    0.162020] ACPI: Power Resource [PLPE] (on)
[    0.169067] ACPI: Power Resource [CLK0] (on)
[    0.169202] ACPI: Power Resource [CLK1] (on)
[    0.238996] ACPI: Power Resource [FN00] (off)
[    0.240484] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.240499] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.240872] \_SB_.PCI0:_OSC invalid UUID
[    0.240876] _OSC request data:1 1f 0 
[    0.240888] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.242238] PCI host bridge to bus 0000:00
[    0.242248] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.242255] pci_bus 0000:00: root bus resource [io  0x0000-0x006f]
[    0.242260] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7]
[    0.242265] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.242271] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.242276] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.242281] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff]
[    0.242286] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xffffffff]
[    0.242303] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.242625] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.242648] pci 0000:00:02.0: reg 0x10: [mem 0xd0000000-0xd03fffff]
[    0.242665] pci 0000:00:02.0: reg 0x18: [mem 0xc0000000-0xcfffffff pref]
[    0.242682] pci 0000:00:02.0: reg 0x20: [io  0xe080-0xe087]
[    0.242993] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
[    0.243021] pci 0000:00:13.0: reg 0x10: [io  0xe070-0xe077]
[    0.243036] pci 0000:00:13.0: reg 0x14: [io  0xe060-0xe063]
[    0.243049] pci 0000:00:13.0: reg 0x18: [io  0xe050-0xe057]
[    0.243063] pci 0000:00:13.0: reg 0x1c: [io  0xe040-0xe043]
[    0.243077] pci 0000:00:13.0: reg 0x20: [io  0xe020-0xe03f]
[    0.243091] pci 0000:00:13.0: reg 0x24: [mem 0xd072e000-0xd072e7ff]
[    0.243151] pci 0000:00:13.0: PME# supported from D3hot
[    0.243420] pci 0000:00:14.0: [8086:0f35] type 00 class 0x0c0330
[    0.243459] pci 0000:00:14.0: reg 0x10: [mem 0xd0700000-0xd070ffff 64bit]
[    0.243535] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.243748] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.243871] pci 0000:00:17.0: [8086:0f50] type 00 class 0x080501
[    0.243897] pci 0000:00:17.0: reg 0x10: [mem 0xd072d000-0xd072dfff]
[    0.243912] pci 0000:00:17.0: reg 0x14: [mem 0xd072c000-0xd072cfff]
[    0.243994] pci 0000:00:17.0: PME# supported from D0 D3hot
[    0.244340] pci 0000:00:18.0: [8086:0f40] type 00 class 0x080102
[    0.244364] pci 0000:00:18.0: reg 0x10: [mem 0xd0718000-0xd071bfff]
[    0.244376] pci 0000:00:18.0: reg 0x14: [mem 0xd072b000-0xd072bfff]
[    0.244698] pci 0000:00:18.1: [8086:0f41] type 00 class 0x0c8000
[    0.244721] pci 0000:00:18.1: reg 0x10: [mem 0xd072a000-0xd072afff]
[    0.244733] pci 0000:00:18.1: reg 0x14: [mem 0xd0729000-0xd0729fff]
[    0.245041] pci 0000:00:18.2: [8086:0f42] type 00 class 0x0c8000
[    0.245063] pci 0000:00:18.2: reg 0x10: [mem 0xd0728000-0xd0728fff]
[    0.245076] pci 0000:00:18.2: reg 0x14: [mem 0xd0727000-0xd0727fff]
[    0.245403] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.245437] pci 0000:00:1a.0: reg 0x10: [mem 0xd0500000-0xd05fffff]
[    0.245466] pci 0000:00:1a.0: reg 0x14: [mem 0xd0400000-0xd04fffff]
[    0.245587] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.245911] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
[    0.245944] pci 0000:00:1b.0: reg 0x10: [mem 0xd0714000-0xd0717fff 64bit]
[    0.246032] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.246296] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
[    0.246380] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.246657] pci 0000:00:1c.1: [8086:0f4a] type 01 class 0x060400
[    0.246739] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.247019] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
[    0.247102] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.247373] pci 0000:00:1e.0: [8086:0f06] type 00 class 0x080102
[    0.247396] pci 0000:00:1e.0: reg 0x10: [mem 0xd0710000-0xd0713fff]
[    0.247409] pci 0000:00:1e.0: reg 0x14: [mem 0xd0725000-0xd0725fff]
[    0.247732] pci 0000:00:1e.1: [8086:0f08] type 00 class 0x0c8000
[    0.247755] pci 0000:00:1e.1: reg 0x10: [mem 0xd0724000-0xd0724fff]
[    0.247767] pci 0000:00:1e.1: reg 0x14: [mem 0xd0723000-0xd0723fff]
[    0.248074] pci 0000:00:1e.2: [8086:0f09] type 00 class 0x0c8000
[    0.248097] pci 0000:00:1e.2: reg 0x10: [mem 0xd0722000-0xd0722fff]
[    0.248110] pci 0000:00:1e.2: reg 0x14: [mem 0xd0721000-0xd0721fff]
[    0.248423] pci 0000:00:1e.3: [8086:0f0a] type 00 class 0x078000
[    0.248446] pci 0000:00:1e.3: reg 0x10: [mem 0xd0720000-0xd0720fff]
[    0.248458] pci 0000:00:1e.3: reg 0x14: [mem 0xd071f000-0xd071ffff]
[    0.248777] pci 0000:00:1e.4: [8086:0f0c] type 00 class 0x078000
[    0.248800] pci 0000:00:1e.4: reg 0x10: [mem 0xd071e000-0xd071efff]
[    0.248813] pci 0000:00:1e.4: reg 0x14: [mem 0xd071d000-0xd071dfff]
[    0.249127] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.249465] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
[    0.249518] pci 0000:00:1f.3: reg 0x10: [mem 0xd071c000-0xd071c01f]
[    0.249597] pci 0000:00:1f.3: reg 0x20: [io  0xe000-0xe01f]
[    0.250071] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.250212] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.250382] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.250410] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.250445] pci 0000:03:00.0: reg 0x18: [mem 0xd0604000-0xd0604fff 64bit]
[    0.250470] pci 0000:03:00.0: reg 0x20: [mem 0xd0600000-0xd0603fff 64bit pref]
[    0.250587] pci 0000:03:00.0: supports D1 D2
[    0.250593] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.250676] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.252531] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.252540] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.252548] pci 0000:00:1c.2:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.253603] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.253771] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.253934] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.254098] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.254261] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 *15)
[    0.254424] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.254600] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 *14 15)
[    0.254763] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.257207] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.257561] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.257567] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.257576] vgaarb: loaded
[    0.257580] vgaarb: bridge control possible 0000:00:02.0
[    0.257778] SCSI subsystem initialized
[    0.257879] libata version 3.00 loaded.
[    0.257960] ACPI: bus type USB registered
[    0.258024] usbcore: registered new interface driver usbfs
[    0.258052] usbcore: registered new interface driver hub
[    0.258111] usbcore: registered new device driver usb
[    0.258480] PCI: Using ACPI for IRQ routing
[    0.265618] PCI: pci_cache_line_size set to 64 bytes
[    0.265714] e820: reserve RAM buffer [mem 0x0008f000-0x0008ffff]
[    0.265720] e820: reserve RAM buffer [mem 0x9d2c1018-0x9fffffff]
[    0.265724] e820: reserve RAM buffer [mem 0x9d2cf018-0x9fffffff]
[    0.265728] e820: reserve RAM buffer [mem 0xad55a000-0xafffffff]
[    0.265733] e820: reserve RAM buffer [mem 0xad9dc000-0xafffffff]
[    0.265737] e820: reserve RAM buffer [mem 0xadb94000-0xafffffff]
[    0.265741] e820: reserve RAM buffer [mem 0xae000000-0xafffffff]
[    0.266028] NetLabel: Initializing
[    0.266033] NetLabel:  domain hash size = 128
[    0.266036] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.266069] NetLabel:  unlabeled traffic allowed by default
[    0.266234] Switched to clocksource refined-jiffies
[    0.285555] pnp: PnP ACPI init
[    0.285698] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.286049] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.286057] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.286063] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.286069] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.286078] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.286524] system 00:02: [io  0x0a10-0x0a3f] has been reserved
[    0.286533] system 00:02: [io  0x0a40-0x0a4f] has been reserved
[    0.286538] system 00:02: [io  0x0a00-0x0a0f] has been reserved
[    0.286546] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.287222] system 00:03: [mem 0xe0000000-0xefffffff] has been reserved
[    0.287231] system 00:03: [mem 0xfed01000-0xfed01fff] has been reserved
[    0.287238] system 00:03: [mem 0xfed03000-0xfed03fff] has been reserved
[    0.287244] system 00:03: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.287251] system 00:03: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.287257] system 00:03: [mem 0xfed1c000-0xfed1cfff] has been reserved
[    0.287264] system 00:03: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.287270] system 00:03: [mem 0xfef00000-0xfeffffff] has been reserved
[    0.287278] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.289075] pnp 00:04: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.289108] pnp: PnP ACPI: found 5 devices
[    0.299083] Switched to clocksource acpi_pm
[    0.299114] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01] add_size 1000
[    0.299124] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000
[    0.299131] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 01] add_size 200000
[    0.299144] pci 0000:00:1c.1: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.299151] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000
[    0.299157] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
[    0.299171] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.299199] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.299206] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.299212] pci 0000:00:1c.1: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.299218] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.299224] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.299230] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.299235] pci 0000:00:1c.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.299251] pci 0000:00:1c.0: BAR 14: assigned [mem 0xd0800000-0xd09fffff]
[    0.299270] pci 0000:00:1c.0: BAR 15: assigned [mem 0xd0a00000-0xd0bfffff 64bit pref]
[    0.299280] pci 0000:00:1c.1: BAR 14: assigned [mem 0xd0c00000-0xd0dfffff]
[    0.299298] pci 0000:00:1c.1: BAR 15: assigned [mem 0xd0e00000-0xd0ffffff 64bit pref]
[    0.299316] pci 0000:00:1c.2: BAR 15: assigned [mem 0xd1000000-0xd11fffff 64bit pref]
[    0.299324] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.299332] pci 0000:00:1c.1: BAR 13: assigned [io  0x2000-0x2fff]
[    0.299341] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.299348] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.299357] pci 0000:00:1c.0:   bridge window [mem 0xd0800000-0xd09fffff]
[    0.299365] pci 0000:00:1c.0:   bridge window [mem 0xd0a00000-0xd0bfffff 64bit pref]
[    0.299374] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.299380] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.299388] pci 0000:00:1c.1:   bridge window [mem 0xd0c00000-0xd0dfffff]
[    0.299395] pci 0000:00:1c.1:   bridge window [mem 0xd0e00000-0xd0ffffff 64bit pref]
[    0.299404] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.299410] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.299418] pci 0000:00:1c.2:   bridge window [mem 0xd0600000-0xd06fffff]
[    0.299425] pci 0000:00:1c.2:   bridge window [mem 0xd1000000-0xd11fffff 64bit pref]
[    0.299435] pci_bus 0000:00: resource 4 [io  0x0000-0x006f]
[    0.299440] pci_bus 0000:00: resource 5 [io  0x0078-0x0cf7]
[    0.299445] pci_bus 0000:00: resource 6 [io  0x0d00-0xffff]
[    0.299451] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    0.299456] pci_bus 0000:00: resource 8 [mem 0x000c0000-0x000dffff]
[    0.299461] pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000fffff]
[    0.299466] pci_bus 0000:00: resource 10 [mem 0xc0000000-0xffffffff]
[    0.299472] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.299477] pci_bus 0000:01: resource 1 [mem 0xd0800000-0xd09fffff]
[    0.299482] pci_bus 0000:01: resource 2 [mem 0xd0a00000-0xd0bfffff 64bit pref]
[    0.299487] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.299492] pci_bus 0000:02: resource 1 [mem 0xd0c00000-0xd0dfffff]
[    0.299498] pci_bus 0000:02: resource 2 [mem 0xd0e00000-0xd0ffffff 64bit pref]
[    0.299503] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.299508] pci_bus 0000:03: resource 1 [mem 0xd0600000-0xd06fffff]
[    0.299513] pci_bus 0000:03: resource 2 [mem 0xd1000000-0xd11fffff 64bit pref]
[    0.299579] NET: Registered protocol family 2
[    0.300153] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.300369] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.300588] TCP: Hash tables configured (established 32768 bind 32768)
[    0.300664] TCP: reno registered
[    0.300691] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.300753] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.300933] NET: Registered protocol family 1
[    0.300978] pci 0000:00:02.0: Video device with shadowed ROM
[    0.301490] PCI: CLS 64 bytes, default 64
[    0.301634] Unpacking initramfs...
[    0.943954] Freeing initrd memory: 17104K (ffff88003ef47000 - ffff88003fffb000)
[    0.944014] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.944022] software IO TLB [mem 0x992c0000-0x9d2c0000] (64MB) mapped at [ffff8800992c0000-ffff88009d2bffff]
[    0.944873] SSE version of gcm_enc/dec engaged.
[    0.950762] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.951640] futex hash table entries: 256 (order: 2, 16384 bytes)
[    0.951664] Initialise system trusted keyring
[    0.951718] audit: initializing netlink subsys (disabled)
[    0.951759] audit: type=2000 audit(1411745071.942:1): initialized
[    0.952642] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.957122] zpool: loaded
[    0.957131] zbud: loaded
[    0.957473] VFS: Disk quotas dquot_6.5.2
[    0.957580] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.958676] msgmni has been set to 7312
[    0.958837] Key type big_key registered
[    0.958846] SELinux:  Registering netfilter hooks
[    0.960642] alg: No test for stdrng (krng)
[    0.960661] NET: Registered protocol family 38
[    0.960678] Key type asymmetric registered
[    0.960686] Asymmetric key parser 'x509' registered
[    0.960814] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.960952] io scheduler noop registered
[    0.960959] io scheduler deadline registered
[    0.961064] io scheduler cfq registered (default)
[    0.962073] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.962120] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.962255] efifb: probing for efifb
[    0.962305] efifb: framebuffer at 0xc0000000, mapped to 0xffffc90010800000, using 5120k, total 5120k
[    0.962310] efifb: mode is 1280x1024x32, linelength=5120, pages=1
[    0.962313] efifb: scrolling: redraw
[    0.962317] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.974270] Console: switching to colour frame buffer device 160x64
[    0.985140] fb0: EFI VGA frame buffer device
[    0.985188] intel_idle: MWAIT substates: 0x3000020
[    0.985192] intel_idle: v0.4 model 0x37
[    0.985196] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.985521] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.985531] ACPI: Power Button [PWRB]
[    0.985643] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
[    0.985651] ACPI: Sleep Button [SLPB]
[    0.985767] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.985774] ACPI: Power Button [PWRF]
[    0.986034] ACPI: Fan [FAN0] (off)
[    0.989606] thermal LNXTHERM:00: registered as thermal_zone0
[    0.989613] ACPI: Thermal Zone [TZ01] (27 C)
[    0.989797] GHES: HEST is not enabled!
[    0.990021] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.010431] serial8250: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.011064] serial 0000:00:1e.3: enabling device (0000 -> 0002)
[    1.011454] 0000:00:1e.3: ttyS1 at MMIO 0xd0720000 (irq = 19, base_baud = 2764800) is a 16550A
[    1.011632] serial 0000:00:1e.4: enabling device (0000 -> 0002)
[    1.012003] 0000:00:1e.4: ttyS2 at MMIO 0xd071e000 (irq = 19, base_baud = 2764800) is a 16550A
[    1.012553] hpet: number irqs doesn't agree with number of timers
[    1.012728] Non-volatile memory driver v1.3
[    1.012736] Linux agpgart interface v0.103
[    1.013129] ahci 0000:00:13.0: version 3.0
[    1.013355] ahci 0000:00:13.0: controller can't do DEVSLP, turning off
[    1.013407] ahci 0000:00:13.0: irq 87 for MSI/MSI-X
[    1.023985] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x1 impl SATA mode
[    1.023993] ahci 0000:00:13.0: flags: 64bit ncq pm led clo pio slum part deso 
[    1.024663] scsi host0: ahci
[    1.025023] scsi host1: ahci
[    1.025160] ata1: SATA max UDMA/133 abar m2048@0xd072e000 port 0xd072e100 irq 87
[    1.025165] ata2: DUMMY
[    1.025403] libphy: Fixed MDIO Bus: probed
[    1.025655] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.025670] ehci-pci: EHCI PCI platform driver
[    1.025710] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.025723] ohci-pci: OHCI PCI platform driver
[    1.025759] uhci_hcd: USB Universal Host Controller Interface driver
[    1.026127] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.026259] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.026678] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.026710] xhci_hcd 0000:00:14.0: irq 88 for MSI/MSI-X
[    1.026867] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.026874] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.026879] usb usb1: Product: xHCI Host Controller
[    1.026884] usb usb1: Manufacturer: Linux 3.17.0-rc5version+ xhci_hcd
[    1.026888] usb usb1: SerialNumber: 0000:00:14.0
[    1.027263] hub 1-0:1.0: USB hub found
[    1.027288] hub 1-0:1.0: 6 ports detected
[    1.028442] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.028578] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.028688] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    1.028695] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.028700] usb usb2: Product: xHCI Host Controller
[    1.028704] usb usb2: Manufacturer: Linux 3.17.0-rc5version+ xhci_hcd
[    1.028709] usb usb2: SerialNumber: 0000:00:14.0
[    1.029054] hub 2-0:1.0: USB hub found
[    1.029077] hub 2-0:1.0: 1 port detected
[    1.029522] usbcore: registered new interface driver usbserial
[    1.029544] usbcore: registered new interface driver usbserial_generic
[    1.029563] usbserial: USB Serial support registered for generic
[    1.029638] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.062496] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.062729] mousedev: PS/2 mouse device common for all mice
[    1.063324] rtc_cmos 00:00: RTC can wake from S4
[    1.063529] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.063568] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes nvram
[    1.063770] device-mapper: uevent: version 1.0.3
[    1.063969] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    1.064156] Intel P-state driver initializing.
[    1.066328] EFI Variables Facility v0.08 2004-May-17
[    1.067458] efivars: duplicate variable: Events-b452fd8a-c9ca-4764-977e-59d839dd861b
[    1.067589] hidraw: raw HID events driver (C) Jiri Kosina
[    1.068607] usbcore: registered new interface driver usbhid
[    1.068618] usbhid: USB HID core driver
[    1.068808] drop_monitor: Initializing network drop monitor service
[    1.069287] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.069392] TCP: cubic registered
[    1.069430] Initializing XFRM netlink socket
[    1.070523] NET: Registered protocol family 10
[    1.071882] mip6: Mobile IPv6
[    1.071909] NET: Registered protocol family 17
[    1.073620] Loading compiled-in X.509 certificates
[    1.073739] registered taskstats version 1
[    1.075504]   Magic number: 14:936:437
[    1.075715] rtc_cmos 00:00: setting system clock to 2014-09-26 15:24:32 UTC (1411745072)
[    1.076374] PM: Hibernation image not present or could not be loaded.
[    1.330856] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.333238] ata1.00: supports DRM functions and may not be fully accessible
[    1.333405] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    1.333422] ata1.00: ATA-9: Samsung SSD 840 EVO 250GB, EXT0BB6Q, max UDMA/133
[    1.333435] ata1.00: 488397168 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    1.333854] ata1.00: supports DRM functions and may not be fully accessible
[    1.334008] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[    1.334033] ata1.00: configured for UDMA/133
[    1.336238] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 840  BB6Q PQ: 0 ANSI: 5
[    1.337621] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.338169] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.338825] sd 0:0:0:0: [sda] Write Protect is off
[    1.338846] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.339041] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.345736]  sda: sda1 sda2 sda3
[    1.347776] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.353688] Freeing unused kernel memory: 1464K (ffffffff81d14000 - ffffffff81e82000)
[    1.353701] Write protecting the kernel read-only data: 12288k
[    1.369424] Freeing unused kernel memory: 1208K (ffff8800016d2000 - ffff880001800000)
[    1.379286] Freeing unused kernel memory: 980K (ffff880001b0b000 - ffff880001c00000)
[    1.381448] usb 1-2: new low-speed USB device number 2 using xhci_hcd
[    1.388098] efivars: duplicate variable: Events-b452fd8a-c9ca-4764-977e-59d839dd861b
[    1.390834] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.391319] systemd[1]: Running in initial RAM disk.
[    1.391614] systemd[1]: Set hostname to <bronze.lan>.
[    1.393876] random: systemd urandom read with 13 bits of entropy available
[    1.492305] systemd[1]: Expecting device dev-mapper-fedora\x2droot.device...
[    1.492357] systemd[1]: Starting -.slice.
[    1.493210] systemd[1]: Created slice -.slice.
[    1.493257] systemd[1]: Starting System Slice.
[    1.493474] systemd[1]: Created slice System Slice.
[    1.493577] systemd[1]: Starting Slices.
[    1.493618] systemd[1]: Reached target Slices.
[    1.493652] systemd[1]: Starting Timers.
[    1.493690] systemd[1]: Reached target Timers.
[    1.493731] systemd[1]: Starting Journal Socket.
[    1.493912] systemd[1]: Listening on Journal Socket.
[    1.494273] systemd[1]: Starting dracut cmdline hook...
[    1.495332] systemd[1]: Starting Journal Service...
[    1.496589] systemd[1]: Started Journal Service.
[    1.551321] usb 1-2: New USB device found, idVendor=2101, idProduct=020f
[    1.551330] usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.551596] usb 1-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.551610] usb 1-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[    1.610142] input: HID 2101:020f as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:2101:020F.0001/input/input5
[    1.610393] hid-generic 0003:2101:020F.0001: input,hidraw0: USB HID v1.01 Keyboard [HID 2101:020f] on usb-0000:00:14.0-2/input0
[    1.614289] input: HID 2101:020f as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/0003:2101:020F.0002/input/input6
[    1.614598] hid-generic 0003:2101:020F.0002: input,hidraw1: USB HID v1.01 Mouse [HID 2101:020f] on usb-0000:00:14.0-2/input1
[    1.768878] usb 1-3: new high-speed USB device number 3 using xhci_hcd
[    1.934282] usb 1-3: New USB device found, idVendor=2040, idProduct=1605
[    1.934291] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[    1.934297] usb 1-3: Product: WinTV HVR-930C
[    1.934301] usb 1-3: SerialNumber: 4034508088
[    1.949062] tsc: Refined TSC clocksource calibration: 1466.666 MHz
[    2.088280] usb 1-4: new high-speed USB device number 4 using xhci_hcd
[    2.253715] usb 1-4: New USB device found, idVendor=05e3, idProduct=0610
[    2.253724] usb 1-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.253730] usb 1-4: Product: USB2.0 Hub
[    2.254523] hub 1-4:1.0: USB hub found
[    2.255481] hub 1-4:1.0: 4 ports detected
[    2.362655] systemd-udevd[239]: starting version 208
[    2.791919] [drm] Initialized drm 1.1.0 20060810
[    2.856285] [drm] Memory usable by graphics device = 2048M
[    2.856293] [drm] Replacing VGA console driver
[    2.856301] checking generic (c0000000 500000) vs hw (c0000000 10000000)
[    2.856305] fb: switching to inteldrmfb from EFI VGA
[    2.856359] Console: switching to colour dummy device 80x25
[    2.872689] i915 0000:00:02.0: irq 89 for MSI/MSI-X
[    2.872710] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.872714] [drm] Driver supports precise vblank timestamp query.
[    2.878012] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.878034] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    2.905642] r8169 0000:03:00.0: irq 90 for MSI/MSI-X
[    2.906054] r8169 0000:03:00.0 eth0: RTL8168g/8111g at 0xffffc90000678000, c0:3f:d5:64:bb:a7, XID 0c000800 IRQ 90
[    2.906061] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    2.953726] Switched to clocksource tsc
[    2.967372] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    3.004319] [drm] failed to retrieve link info, disabling eDP
[    3.077832] r8169 0000:03:00.0 p2p1: renamed from eth0
[    3.078141] systemd-udevd[242]: renamed network interface eth0 to p2p1
[    3.205288] fbcon: inteldrmfb (fb0) is primary device
[    3.319078] Console: switching to colour frame buffer device 128x48
[    3.334264] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    3.334269] i915 0000:00:02.0: registered panic notifier
[    3.340719] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    3.343550] acpi device:09: registered as cooling_device2
[    3.346389] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input7
[    3.349368] [drm] Initialized i915 1.6.0 20140725 for 0000:00:02.0 on minor 0
[    3.786400] PM: Starting manual resume from disk
[    3.786411] PM: Hibernation image partition 253:1 present
[    3.786415] PM: Looking for hibernation image.
[    3.786671] PM: Image not found (code -22)
[    3.786677] PM: Hibernation image not present or could not be loaded.
[    3.817764] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    4.634508] systemd-journald[95]: Received SIGTERM
[    4.643716] systemd-cgroups-agent[427]: Failed to get D-Bus connection: Failed to connect to socket /run/systemd/private: No such file or directory
[    4.689613] random: nonblocking pool is initialized
[    4.775002] SELinux: 2048 avtab hash slots, 101177 rules.
[    4.816209] SELinux: 2048 avtab hash slots, 101177 rules.
[    4.922271] SELinux:  8 users, 86 roles, 4853 types, 288 bools, 1 sens, 1024 cats
[    4.922281] SELinux:  83 classes, 101177 rules
[    4.934726] SELinux:  Permission audit_read in class capability2 not defined in policy.
[    4.934741] SELinux: the above unknown classes and permissions will be allowed
[    4.934757] SELinux:  Completing initialization.
[    4.934760] SELinux:  Setting up existing superblocks.
[    4.934773] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    4.934792] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    4.934803] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    4.934880] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.934952] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    4.936957] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    4.938631] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    4.938641] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    4.938654] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    4.938660] SELinux: initialized (dev aio, type aio), not configured for labeling
[    4.938667] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    4.938707] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    4.938722] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    4.938739] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    4.938761] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.939292] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    4.939299] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.939320] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.939600] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.940598] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940614] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    4.940622] SELinux: initialized (dev efivarfs, type efivarfs), uses genfs_contexts
[    4.940630] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940635] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940641] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940654] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940661] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940666] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940671] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940684] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940689] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    4.940699] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    4.940706] SELinux: initialized (dev drm, type drm), not configured for labeling
[    4.940721] SELinux: initialized (dev dm-0, type ext4), uses xattr
[    4.944893] audit: type=1403 audit(1411745076.363:2): policy loaded auid=4294967295 ses=4294967295
[    4.957142] systemd[1]: Successfully loaded SELinux policy in 218.215ms.
[    5.114621] systemd[1]: Relabelled /dev and /run in 119.360ms.
[    5.473037] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[    5.610976] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    5.740237] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    6.229322] systemd-udevd[471]: starting version 208
[    6.281996] EXT4-fs (dm-0): re-mounted. Opts: (null)
[    7.515955] tpm_tis 00:04: 1.2 TPM (device-id 0x0, rev-id 78)
[    7.563675] tpm_tis 00:04: TPM is disabled/deactivated (0x7)
[    7.594178] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    7.798584] microcode: CPU0 sig=0x30673, pf=0x1, revision=0x31e
[    7.812348] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    7.887656] alg: No test for crc32 (crc32-pclmul)
[    8.357076] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    8.357249] SELinux: initialized (dev sda2, type ext4), uses xattr
[    8.376504] snd_hda_intel 0000:00:1b.0: irq 91 for MSI/MSI-X
[    8.442580] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[    8.442658] SELinux: initialized (dev sda1, type vfat), uses genfs_contexts
[    8.464142] sound hdaudioC0D0: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    8.464151] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    8.464157] sound hdaudioC0D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[    8.464162] sound hdaudioC0D0:    mono: mono_out=0x0
[    8.464166] sound hdaudioC0D0:    inputs:
[    8.464171] sound hdaudioC0D0:      Mic=0x19
[    8.549471] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    8.550018] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    8.551010] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[    8.724177] Adding 4079612k swap on /dev/mapper/fedora-swap.  Priority:-1 extents:1 across:4079612k SSFS
[    8.948034] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[    8.948055] SELinux: initialized (dev dm-2, type ext4), uses xattr
[    8.979192] media: Linux media interface: v0.10
[    9.039042] Linux video capture interface: v2.00
[    9.047175] systemd-journald[462]: Received request to flush runtime journal from PID 1
[    9.080916] em28xx: New device  WinTV HVR-930C @ 480 Mbps (2040:1605, interface 0, class 0)
[    9.080924] em28xx: Audio interface 0 found (Vendor Class)
[    9.080928] em28xx: Video interface 0 found: isoc
[    9.080931] em28xx: DVB interface 0 found: isoc
[    9.081521] em28xx: chip ID is em2884
[    9.142085] em2884 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0xe4f009aa
[    9.142092] em2884 #0: EEPROM info:
[    9.142096] em2884 #0: 	microcode start address = 0x0004, boot configuration = 0x01
[    9.148556] em2884 #0: 	I2S audio, 5 sample rates
[    9.148564] em2884 #0: 	500mA max power
[    9.148569] em2884 #0: 	Table at offset 0x24, strings=0x1e82, 0x186a, 0x0000
[    9.150498] em2884 #0: Identified as Hauppauge WinTV HVR 930C (card=81)
[    9.163840] tveeprom 8-0050: Hauppauge model 16009, rev B1F0, serial# 7976248
[    9.163849] tveeprom 8-0050: MAC address is 00:0d:fe:79:b5:38
[    9.163854] tveeprom 8-0050: tuner model is Xceive XC5000 (idx 150, type 76)
[    9.163859] tveeprom 8-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    9.163863] tveeprom 8-0050: audio processor is unknown (idx 45)
[    9.163867] tveeprom 8-0050: decoder processor is unknown (idx 44)
[    9.163871] tveeprom 8-0050: has no radio, has IR receiver, has no IR transmitter
[    9.163876] em2884 #0: analog set to isoc mode.
[    9.163879] em2884 #0: dvb set to isoc mode.
[    9.165395] usbcore: registered new interface driver em28xx
[    9.196626] em2884 #0: Registering V4L2 extension
[    9.197616] em2884 #0: Config register raw data: 0xca
[    9.201590] em2884 #0: V4L2 video device registered as video0
[    9.201598] em2884 #0: V4L2 extension successfully initialized
[    9.201603] em28xx: Registered (Em28xx v4l2 Extension) extension
[    9.241811] em2884 #0: Binding DVB extension
[    9.329886] audit: type=1305 audit(1411745080.743:3): audit_pid=607 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[   10.234418] cfg80211: Calling CRDA to update world regulatory domain
[   10.402732] cfg80211: World regulatory domain updated:
[   10.402741] cfg80211:  DFS Master region: unset
[   10.402745] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[   10.402751] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   10.402756] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[   10.402760] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[   10.402765] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
[   10.402770] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   10.402774] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[   10.402779] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[   10.402783] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[   10.558330] drxk: status = 0x439130d9
[   10.558339] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
[   10.813011] ttyS1 - failed to request DMA
[   10.828220] ttyS2 - failed to request DMA
[   11.149194] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   12.024361] r8169 0000:03:00.0 p2p1: link down
[   12.024407] r8169 0000:03:00.0 p2p1: link down
[   12.024668] IPv6: ADDRCONF(NETDEV_UP): p2p1: link is not ready
[   12.223400] drxk: DRXK driver version 0.9.4300
[   12.246173] drxk: frontend initialized.
[   12.310727] xc5000 8-0061: creating new instance
[   12.311717] xc5000: Successfully identified at address 0x61
[   12.311723] xc5000: Firmware has not been loaded previously
[   12.311731] DVB: registering new adapter (em2884 #0)
[   12.311740] usb 1-3: DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
[   12.314029] em2884 #0: DVB extension successfully initialized
[   12.314037] em28xx: Registered (Em28xx dvb Extension) extension
[   12.403756] Bluetooth: Core ver 2.19
[   12.403935] NET: Registered protocol family 31
[   12.403940] Bluetooth: HCI device and connection manager initialized
[   12.403954] Bluetooth: HCI socket layer initialized
[   12.403961] Bluetooth: L2CAP socket layer initialized
[   12.403981] Bluetooth: SCO socket layer initialized
[   12.417124] em2884 #0: Registering input extension
[   12.463237] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   12.463244] Bluetooth: BNEP filters: protocol multicast
[   12.499805] Registered IR keymap rc-hauppauge
[   12.500075] input: em28xx IR (em2884 #0) as /devices/pci0000:00/0000:00:14.0/usb1/1-3/rc/rc0/input11
[   12.500950] rc0: em28xx IR (em2884 #0) as /devices/pci0000:00/0000:00:14.0/usb1/1-3/rc/rc0
[   12.501130] em2884 #0: Input extension successfully initalized
[   12.501136] em28xx: Registered (Em28xx Input Extension) extension
[   14.262596] r8169 0000:03:00.0 p2p1: link up
[   14.262618] IPv6: ADDRCONF(NETDEV_CHANGE): p2p1: link becomes ready
[  319.694599] xc5000: Firmware dvb-fe-xc5000-1.6.114.fw loaded and running.
[  354.912021] PM: Syncing filesystems ... done.
[  354.930380] PM: Preparing system for mem sleep
[  354.931689] Freezing user space processes ... (elapsed 0.002 seconds) done.
[  354.934694] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  354.935980] PM: Entering mem sleep
[  354.936029] Suspending console(s) (use no_console_suspend to debug)
[  354.941986] em2884 #0: Suspending extensions
[  354.942220] em2884 #0: Suspending video extension
[  354.942870] em2884 #0: Suspending DVB extension
[  354.942871] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  354.943185] sd 0:0:0:0: [sda] Stopping disk
[  354.943993] em2884 #0: fe0 suspend 0
[  355.250517] em2884 #0: Suspending input extension
[  355.250517] PM: suspend of devices complete after 313.663 msecs
[  355.262563] PM: late suspend of devices complete after 12.015 msecs
[  355.263733] r8169 0000:03:00.0: System wakeup enabled by ACPI
[  355.264517] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  355.275090] PM: noirq suspend of devices complete after 12.501 msecs
[  355.275144] ACPI: Preparing to enter system sleep state S3
[  355.276371] PM: Saving platform NVS memory
[  355.276383] Disabling non-boot CPUs ...
[  355.276845] ACPI: Low-level resume complete
[  355.276922] PM: Restoring platform NVS memory
[  355.277311] CPU0: Thermal monitoring handled by SMI
[  355.277347] ACPI: Waking up from system sleep state S3
[  355.381437] acpi LNXPOWER:02: Turning OFF
[  355.381666] acpi LNXPOWER:01: Turning OFF
[  355.381829] acpi LNXPOWER:00: Turning OFF
[  355.393524] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  355.394708] PM: noirq resume of devices complete after 12.819 msecs
[  355.487333] PM: early resume of devices complete after 92.447 msecs
[  355.509379] snd_hda_intel 0000:00:1b.0: irq 91 for MSI/MSI-X
[  355.509592] r8169 0000:03:00.0: System wakeup disabled by ACPI
[  355.542561] rtc_cmos 00:00: System wakeup disabled by ACPI
[  355.543157] sd 0:0:0:0: [sda] Starting disk
[  355.545560] r8169 0000:03:00.0 p2p1: link down
[  355.560255] tpm_tis 00:04: TPM is disabled/deactivated (0x7)
[  355.636595] em2884 #0: Resuming extensions
[  355.636597] em2884 #0: Resuming video extension
[  355.754811] em2884 #0: Resuming DVB extension
[  355.754814] em2884 #0: fe0 resume 0
[  355.754908] em2884 #0: Resuming input extension
[  355.754908] PM: resume of devices complete after 267.250 msecs
[  355.755284] PM: Finishing wakeup.
[  355.755288] Restarting tasks ... done.
[  355.765627] video LNXVIDEO:00: Restoring backlight state
[  355.852585] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  355.854472] ata1.00: supports DRM functions and may not be fully accessible
[  355.854542] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[  355.854933] ata1.00: supports DRM functions and may not be fully accessible
[  355.854999] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[  355.855009] ata1.00: configured for UDMA/133
[  357.923210] r8169 0000:03:00.0 p2p1: link up

I tested DVB-C after suspend/resume. It worked properly:

$ dvbv5-zap -c ~/net_digital.conf -r "canção nova"
using demux '/dev/dvb/adapter0/demux0'
reading channels from file '/home/mchehab/net_digital.conf'
tuning to 651000000 Hz
video pid 3664
  dvb_set_pesfilter 3664
audio pid 3665
  dvb_set_pesfilter 3665
       (0x00) Signal= 100.00%
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.20dB UCB= 656 postBER= 546x10^-6 PER= 0
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.70dB UCB= 656 postBER= 546x10^-6 PER= 0
DVR interface '/dev/dvb/adapter0/dvr0' can now be opened
       (0x00) Quality= Good Signal= 100.00% C/N= 36.80dB UCB= 656 postBER= 26.0x10^-6 PER= 0
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.90dB UCB= 863 postBER= 23.5x10^-6 PER= 0

Please notice that the 0x00 status above was just after resuming from ram.

Regards,
Mauro
