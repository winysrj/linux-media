Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:53508 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbaIYRgW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 13:36:22 -0400
Date: Thu, 25 Sep 2014 19:36:13 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140925173613.GA12900@linuxtv.org>
References: <20140925125353.GA5129@linuxtv.org>
 <54241C81.60301@osg.samsung.com>
 <20140925160134.GA6207@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925160134.GA6207@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 25, 2014 at 06:01:34PM +0200, Johannes Stezenbach wrote:
> Hi Shuah,
> 
> On Thu, Sep 25, 2014 at 07:45:37AM -0600, Shuah Khan wrote:
> > On 09/25/2014 06:53 AM, Johannes Stezenbach wrote:
> > > ever since your patchset which implements suspend/resume
> > > for em28xx, hibernating the system breaks the Hauppauge WinTV HVR 930C driver.
> > > In v3.15.y and v3.16.y it throws a request_firmware warning
> > > during hibernate + resume, and the /dev/dvb/ device nodes disappears after
> > > resume.  In current git v3.17-rc6-247-g005f800, it hangs
> > > after resume.  I bisected the hang in qemu to
> > > b89193e0b06f "media: em28xx - remove reset_resume interface",
> > > the hang is fixed if I revert this commit on top of v3.17-rc6-247-g005f800.
> > > 
> > > Regarding the request_firmware issue. I think a possible
> > > fix would be:
> 
> I think you should take a closer look at the code you snipped.
> Maybe this fixes the root of the issue you worked around
> with the DVB_FE_DEVICE_RESUME thing, namely calling
> fe->ops.tuner_ops.init from wrong context.
> 
> > The request_firmware has been fixed. I ran into this on
> > Hauppauge WinTV HVR 950Q device. The fix is in xc5000
> > driver to not release firmware as soon as it loads.
> > With this fix firmware is cached and available in
> > resume path.
> > 
> > These patches are pulled into linux-media git couple
> > of days ago.
> > 
> > http://patchwork.linuxtv.org/patch/26073/
> > http://patchwork.linuxtv.org/patch/25345/
> 
> The second patch does not apply to current git master (v3.17-rc6-247-g005f800).
> Maybe some other patch I need?

FWIW, there are six other xc5000 patches in the queue:

http://git.linuxtv.org/cgit.cgi/media_tree.git/log/drivers/media/tuners/xc5000.c?h=devel-3.17-rc6

I'm assuming this is the development branch for the 3.18 merge window,
so the question is how will the issue be fixed in 3.17 and 3.16-stable?
If you have patches I'm ready to test.

FWIW, I tried v3.17-rc6-247-g005f800 with only my suggested
dvb_frontend_resume() change, it breaks in another place after
resume and then still hangs.  I think the b89193e0b06f revert is needed to 
fix the hang.  If you care, the dmesg after resume:

[    1.561456] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.562745] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.564059] usb usb1: Product: EHCI Host Controller
[    1.564941] usb usb1: Manufacturer: Linux 3.17.0-rc6+ ehci_hcd
[    1.565974] usb usb1: SerialNumber: 0000:00:04.0
[    1.567946] hub 1-0:1.0: USB hub found
[    1.568736] hub 1-0:1.0: 6 ports detected
[    1.570949] uhci_hcd: USB Universal Host Controller Interface driver
[    1.572492] usbcore: registered new interface driver usb-storage
[    1.573726] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.576145] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.577447] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.579250] mousedev: PS/2 mouse device common for all mice
[    1.582207] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.583951] rtc_cmos 00:00: RTC can wake from S4
[    1.586862] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.588434] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet irqs
[    1.590157] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, revision 0
[    1.592999] usbcore: registered new interface driver em28xx
[    1.594005] em28xx: Registered (Em28xx v4l2 Extension) extension
[    1.595075] em28xx: Registered (Em28xx dvb Extension) extension
[    1.596905] usbcore: registered new interface driver usbhid
[    1.597934] usbhid: USB HID core driver
[    1.598728] TCP: cubic registered
[    1.599353] NET: Registered protocol family 17
[    1.601375] registered taskstats version 1
[    1.603511] rtc_cmos 00:00: setting system clock to 2014-09-25 17:27:49 UTC (1411666069)
[    1.611018] Freeing unused kernel memory: 2668K (ffffffff81adc000 - ffffffff81d77000)
[    1.612517] Write protecting the kernel read-only data: 10240k
[    1.618189] Freeing unused kernel memory: 1260K (ffff8800014c5000 - ffff880001600000)
[    1.622896] Freeing unused kernel memory: 1100K (ffff8800018ed000 - ffff880001a00000)
Loading, please wait...
[    1.638167] init (73) used greatest stack depth: 13880 bytes left
[    1.649393] udevd[80]: starting version 175
[    1.689799] udevadm (81) used greatest stack depth: 13704 bytes left
[    1.758878] ata_id (159) used greatest stack depth: 13512 bytes left
[    1.804296] ata_id (168) used greatest stack depth: 12408 bytes left
[    1.980161] tsc: Refined TSC clocksource calibration: 3300.000 MHz
[    2.032114] usb 1-1: new high-speed USB device number 2 using ehci-pci
modprobe: chdir(3.17.0-rc6+): No such file or directory
Begin: Loading essential drivers ... modprobe: chdir(3.17.0-rc6+): No such file or directory
modprobe: chdir(3.17.0-rc6+): No such file or directory
done.
Begin: Running /scripts/init-premount ... done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ... done.
Begin: Running /scripts/local-premount ... [    2.056942] PM: Starting manual resume from disk
[    2.070693] Freezing user space processes ... (elapsed 0.001 seconds) done.
[    2.084106] PM: Using 3 thread(s) for decompression.
[    2.084106] PM: Loading and decompressing image data (27439 pages)...
[    2.293043] PM: Image loading progress:   0%
[    2.319775] usb 1-1: New USB device found, idVendor=2040, idProduct=1605
[    2.321248] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[    2.322609] usb 1-1: Product: WinTV HVR-930C
[    2.323389] usb 1-1: SerialNumber: 4034209007
[    2.329808] em28xx: New device  WinTV HVR-930C @ 480 Mbps (2040:1605, interface 0, class 0)
[    2.331367] em28xx: Audio interface 0 found (Vendor Class)
[    2.332494] em28xx: Video interface 0 found: isoc
[    2.333352] em28xx: DVB interface 0 found: isoc
[    2.334869] em28xx: chip ID is em2884
[    2.407162] em2884 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x33f006aa
[    2.408502] em2884 #0: EEPROM info:
[    2.409420] em2884 #0:       microcode start address = 0x0004, boot configuration = 0x01
[    2.425131] PM: Image loading progress:  10%
[    2.429760] em2884 #0:       I2S audio, 5 sample rates
[    2.430677] em2884 #0:       500mA max power
[    2.431367] em2884 #0:       Table at offset 0x24, strings=0x1e82, 0x186a, 0x0000
[    2.432944] em2884 #0: Identified as Hauppauge WinTV HVR 930C (card=81)
[    2.434115] tveeprom 2-0050: Hauppauge model 16009, rev B1F0, serial# 7677167
[    2.435388] tveeprom 2-0050: MAC address is 00:0d:fe:75:24:ef
[    2.436455] tveeprom 2-0050: tuner model is Xceive XC5000 (idx 150, type 76)
[    2.437687] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    2.439699] tveeprom 2-0050: audio processor is unknown (idx 45)
[    2.441049] tveeprom 2-0050: decoder processor is unknown (idx 44)
[    2.442353] tveeprom 2-0050: has no radio, has IR receiver, has no IR transmitter
[    2.443941] em2884 #0: analog set to isoc mode.
[    2.445001] em2884 #0: dvb set to isoc mode.
[    2.446140] em2884 #0: Registering V4L2 extension
[    2.449227] em2884 #0: Config register raw data: 0xc3
[    2.464965] PM: Image loading progress:  20%
[    2.472872] em2884 #0: V4L2 video device registered as video0
[    2.474056] em2884 #0: V4L2 extension successfully initialized
[    2.475302] em2884 #0: Binding DVB extension
[    2.477440] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    2.493172] PM: Image loading progress:  30%
[    2.515588] PM: Image loading progress:  40%
[    2.535418] PM: Image loading progress:  50%
[    2.554481] PM: Image loading progress:  60%
[    2.571057] PM: Image loading progress:  70%
[    2.591357] PM: Image loading progress:  80%
[    2.607388] PM: Image loading progress:  90%
[    2.626382] PM: Image loading progress: 100%
[    2.627503] PM: Image loading done.
[    2.628206] PM: Read 109756 kbytes in 0.54 seconds (203.25 MB/s)
[    2.637928] em2884 #0: Suspending extensions
[    2.981447] Switched to clocksource tsc
[    3.792310] ------------[ cut here ]------------
[    3.794316] WARNING: CPU: 1 PID: 39 at drivers/base/firmware_class.c:1124 _request_firmware+0x205/0x568()
[    3.797957] Modules linked in:
[    3.799342] CPU: 1 PID: 39 Comm: kworker/1:1 Not tainted 3.17.0-rc6+ #79
[    3.801929] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    3.805865] Workqueue: events request_module_async
[    3.807587]  0000000000000000 ffff88003dff7b40 ffffffff814b51e8 0000000000000000
[    3.810357]  ffff88003dff7b78 ffffffff81032d75 ffffffff81320b03 00000000fffffff5
[    3.813124]  ffff88003a385400 ffff88003c95df40 ffff880038608900 ffff88003dff7b88
[    3.815817] Call Trace:
[    3.816690]  [<ffffffff814b51e8>] dump_stack+0x4e/0x7a
[    3.818427]  [<ffffffff81032d75>] warn_slowpath_common+0x7a/0x93
[    3.820457]  [<ffffffff81320b03>] ? _request_firmware+0x205/0x568
[    3.822491]  [<ffffffff81032e32>] warn_slowpath_null+0x15/0x17
[    3.824401]  [<ffffffff81320b03>] _request_firmware+0x205/0x568
[    3.826290]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[    3.828064]  [<ffffffff81063c2c>] ? lockdep_init_map+0xc4/0x13f
[    3.829900]  [<ffffffff81320e96>] request_firmware+0x30/0x42
[    3.831645]  [<ffffffff813f2f6b>] drxk_attach+0x546/0x656
[    3.833342]  [<ffffffff814ba9a2>] em28xx_dvb_init.part.3+0xa1c/0x1cc6
[    3.835298]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[    3.837275]  [<ffffffff814be24d>] ? mutex_unlock+0x9/0xb
[    3.838841]  [<ffffffff814b9671>] ? em28xx_v4l2_init.part.11+0xcbd/0xd04
[    3.840763]  [<ffffffff8141b7ad>] em28xx_dvb_init+0x1d/0x1f
[    3.842373]  [<ffffffff81415706>] em28xx_init_extension+0x51/0x67
[    3.844113]  [<ffffffff81416cfe>] request_module_async+0x19/0x1b
[    3.845803]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[    3.847366]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[    3.848868]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[    3.850376]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[    3.851605]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[    3.853226]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[    3.854958]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[    3.856424]  [<ffffffff814c0d6c>] ret_from_fork+0x7c/0xb0
[    3.857726]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[    3.859133] ---[ end trace 94d8c0167e9bae27 ]---
[    3.860249] usb 1-1: firmware: dvb-usb-hauppauge-hvr930c-drxk.fw will not be loaded
[    3.862111] drxk: Could not load firmware file dvb-usb-hauppauge-hvr930c-drxk.fw.
[    3.863952] drxk: Copy dvb-usb-hauppauge-hvr930c-drxk.fw to your hotplug directory!
[    3.906976] drxk: status = 0x439130d9
[    3.908000] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
[    4.005309] drxk: DRXK driver version 0.9.4300
[    4.043341] drxk: frontend initialized.
[    4.044269] xc5000 2-0061: creating new instance
[    4.047038] xc5000: Successfully identified at address 0x61
[    4.048306] xc5000: Firmware has not been loaded previously
[    4.049426] DVB: registering new adapter (em2884 #0)
[    4.050394] usb 1-1: DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
[    4.052342] dvb dvb0.frontend0: parent 1-1 should not be sleeping
[    4.054491] dvb dvb0.demux0: parent 1-1 should not be sleeping
[    4.055822] dvb dvb0.dvr0: parent 1-1 should not be sleeping
[    4.057198] dvb dvb0.net0: parent 1-1 should not be sleeping
[    4.058391] em2884 #0: DVB extension successfully initialized
[    4.059462] em2884 #0: Suspending video extension
[    4.060953] em2884 #0: Suspending DVB extensionem2884 #0: fe0 suspend 0
[    4.069504] PM: quiesce of devices complete after 1431.879 msecs
[    4.071643] PM: late quiesce of devices complete after 0.981 msecs
[    4.074401] PM: noirq quiesce of devices complete after 1.605 msecs
[    4.075688] Disabling non-boot CPUs ...
[    4.138099] smpboot: CPU 1 is now offline
[    4.209733] smpboot: CPU 2 is now offline
[    4.265655] smpboot: CPU 3 is now offline
[   17.044639] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S0_] (20140724/hwxface-580)
[   17.044639] PM: Restoring platform NVS memory
[   17.044639] Enabling non-boot CPUs ...
[   17.044639] x86: Booting SMP configuration:
[   17.044639] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   17.077329] CPU1 is up
[   17.078483] smpboot: Booting Node 0 Processor 2 APIC 0x2
[   17.111110] CPU2 is up
[   17.112300] smpboot: Booting Node 0 Processor 3 APIC 0x3
[   17.144969] CPU3 is up
[   17.145724] ACPI: Waking up from system sleep state S4
[   17.148863] PM: noirq restore of devices complete after 2.091 msecs
[   17.150841] PM: early restore of devices complete after 0.731 msecs
[   17.176315] rtc_cmos 00:00: System wakeup disabled by ACPI
[   17.177614] usb usb1: root hub lost power or was reset
[   17.179814] sd 0:0:0:0: [sda] Starting disk
[   17.497706] ata2.00: configured for MWDMA2
[   17.499922] ata1.00: configured for MWDMA2
[   17.820141] usb 1-1: reset high-speed USB device number 2 using ehci-pci
[   18.105549] em2884 #0: Disconnecting em2884 #0
[   18.106715] em2884 #0: Closing video extension
[   18.107771] em2884 #0: V4L2 device video0 deregistered
[   18.110265] em2884 #0: Closing DVB extension
[   18.114693] xc5000 2-0061: destroying instance

(hangs, trace after 120 sec is similar to the one posted in previous mail)


Thanks,
Johannes
