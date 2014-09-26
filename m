Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37905 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbaIZPky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 11:40:54 -0400
Date: Fri, 26 Sep 2014 12:40:49 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926124049.1f469f8e@recife.lan>
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
> vs
> echo disk > /sys/power/state

Now, tested suspend2disk:

[  538.132309] PM: Syncing filesystems ... done.
[  538.139141] PM: Preparing system for mem sleep
[  538.139616] Freezing user space processes ... (elapsed 0.003 seconds) done.
[  538.142949] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  538.144630] PM: Entering mem sleep
[  538.144680] Suspending console(s) (use no_console_suspend to debug)
[  538.149771] em2884 #0: Suspending extensions
[  538.150253] em2884 #0: Suspending video extension
[  538.151086] em2884 #0: Suspending DVB extension
[  538.151087] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  538.151373] sd 0:0:0:0: [sda] Stopping disk
[  538.152206] em2884 #0: fe0 suspend 0
[  541.323511] em2884 #0: Suspending input extension
[  541.323512] snd_hda_intel 0000:00:1b.0: azx_get_response timeout, switching to polling mode: last cmd=0x20170503
[  542.323879] snd_hda_intel 0000:00:1b.0: No response from codec, disabling MSI: last cmd=0x20170503
[  543.324191] snd_hda_intel 0000:00:1b.0: azx_get_response timeout, switching to single_cmd mode: last cmd=0x20170503
[  543.365176] PM: suspend of devices complete after 5233.920 msecs
[  543.377172] PM: late suspend of devices complete after 12.010 msecs
[  543.378338] r8169 0000:03:00.0: System wakeup enabled by ACPI
[  543.379075] xhci_hcd 0000:00:14.0: System wakeup enabled by ACPI
[  543.389656] PM: noirq suspend of devices complete after 12.506 msecs
[  543.389710] ACPI: Preparing to enter system sleep state S3
[  543.390945] PM: Saving platform NVS memory
[  543.390957] Disabling non-boot CPUs ...
[  543.391419] ACPI: Low-level resume complete
[  543.391496] PM: Restoring platform NVS memory
[  543.391886] CPU0: Thermal monitoring handled by SMI
[  543.391922] ACPI: Waking up from system sleep state S3
[  543.393404] acpi LNXPOWER:02: Turning OFF
[  543.393484] acpi LNXPOWER:01: Turning OFF
[  543.393543] acpi LNXPOWER:00: Turning OFF
[  543.404929] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
[  543.406091] PM: noirq resume of devices complete after 12.556 msecs
[  543.500362] PM: early resume of devices complete after 94.453 msecs
[  543.501487] r8169 0000:03:00.0: System wakeup disabled by ACPI
[  543.555379] sd 0:0:0:0: [sda] Starting disk
[  543.556498] rtc_cmos 00:00: System wakeup disabled by ACPI
[  543.559105] r8169 0000:03:00.0 p2p1: link down
[  543.574005] tpm_tis 00:04: TPM is disabled/deactivated (0x7)
[  543.629112] em2884 #0: Resuming extensions
[  543.629114] em2884 #0: Resuming video extension
[  543.745863] em2884 #0: Resuming DVB extension
[  543.745866] em2884 #0: fe0 resume 0
[  543.758776] em2884 #0: Resuming input extension
[  543.758776] PM: resume of devices complete after 259.090 msecs
[  543.759153] PM: Finishing wakeup.
[  543.759157] Restarting tasks ... done.
[  543.771826] video LNXVIDEO:00: Restoring backlight state
[  543.868209] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  543.870098] ata1.00: supports DRM functions and may not be fully accessible
[  543.870196] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[  543.870535] ata1.00: supports DRM functions and may not be fully accessible
[  543.870601] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[  543.870612] ata1.00: configured for UDMA/133
[  545.828953] r8169 0000:03:00.0 p2p1: link up
[  641.432607] PM: Syncing filesystems ... done.
[  641.437218] Freezing user space processes ... (elapsed 0.003 seconds) done.
[  641.440792] PM: Marking nosave pages: [mem 0x0008f000-0x0008ffff]
[  641.440810] PM: Marking nosave pages: [mem 0x000a0000-0x000fffff]
[  641.440830] PM: Marking nosave pages: [mem 0x20000000-0x200fffff]
[  641.440862] PM: Marking nosave pages: [mem 0x9d2c1000-0x9d2c1fff]
[  641.440873] PM: Marking nosave pages: [mem 0x9d2ce000-0x9d2cffff]
[  641.440884] PM: Marking nosave pages: [mem 0x9d2df000-0x9d2dffff]
[  641.440895] PM: Marking nosave pages: [mem 0xad55a000-0xad9dafff]
[  641.440998] PM: Marking nosave pages: [mem 0xad9dc000-0xada1dfff]
[  641.441014] PM: Marking nosave pages: [mem 0xadb94000-0xadff8fff]
[  641.441117] PM: Marking nosave pages: [mem 0xae000000-0xffffffff]
[  641.448058] PM: Basic memory bitmaps created
[  641.448614] PM: Preallocating image memory... done (allocated 227028 pages)
[  642.130339] PM: Allocated 908112 kbytes in 0.68 seconds (1335.45 MB/s)
[  642.130343] Freezing remaining freezable tasks ... 
[  642.130764] em2884 #0: write to i2c device at 0x52 failed with unknown error (status=6)
[  642.130776] drxk: write_block: i2c write error at addr 0x831ffd
[  642.145144] (elapsed 0.014 seconds) done.
[  642.145434] Suspending console(s) (use no_console_suspend to debug)
[  642.145997] em2884 #0: Suspending extensions
[  642.146309] em2884 #0: Suspending video extension
[  642.147580] em2884 #0: Suspending DVB extension
[  642.147583] em2884 #0: fe0 suspend 0
[  642.476097] em2884 #0: Suspending input extension
[  642.476098] PM: freeze of devices complete after 330.258 msecs
[  642.476904] PM: late freeze of devices complete after 0.797 msecs
[  642.478059] PM: noirq freeze of devices complete after 1.144 msecs
[  642.478095] ACPI: Preparing to enter system sleep state S4
[  642.478821] PM: Saving platform NVS memory
[  642.481956] Disabling non-boot CPUs ...
[  642.482227] PM: Creating hibernation image:
[  642.682298] PM: Need to copy 226720 pages
[  642.682304] PM: Normal pages needed: 226720 + 1024, available pages: 745328
[  642.482564] PM: Restoring platform NVS memory
[  642.484130] CPU0: Thermal monitoring handled by SMI
[  642.485959] ACPI: Waking up from system sleep state S4
[  642.589058] acpi LNXPOWER:02: Turning OFF
[  642.589223] acpi LNXPOWER:01: Turning OFF
[  642.589380] acpi LNXPOWER:00: Turning OFF
[  642.601274] PM: noirq restore of devices complete after 11.835 msecs
[  642.657475] PM: early restore of devices complete after 56.065 msecs
[  642.846669] usb usb1: root hub lost power or was reset
[  642.846673] usb usb2: root hub lost power or was reset
[  642.847278] xhci_hcd 0000:00:14.0: irq 88 for MSI/MSI-X
[  642.880828] rtc_cmos 00:00: System wakeup disabled by ACPI
[  642.880957] sd 0:0:0:0: [sda] Starting disk
[  642.883749] r8169 0000:03:00.0 p2p1: link down
[  642.898233] tpm_tis 00:04: TPM is disabled/deactivated (0x7)
[  643.186754] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  643.187063] ata1.00: supports DRM functions and may not be fully accessible
[  643.187157] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[  643.187427] ata1.00: supports DRM functions and may not be fully accessible
[  643.187557] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[  643.187571] ata1.00: configured for UDMA/133
[  643.346322] usb 1-2: reset low-speed USB device number 2 using xhci_hcd
[  643.614145] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800aa967cc0
[  643.614156] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800aa967d20
[  643.614181] usb 1-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[  643.614209] usb 1-2: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[  643.764779] usb 1-3: reset high-speed USB device number 3 using xhci_hcd
[  643.930442] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880138dc7c00
[  643.930453] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880138dc7c48
[  643.930462] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880138dc7c90
[  643.930470] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880138dc7cd8
[  643.931446] em2884 #0: Resuming extensions
[  643.931451] em2884 #0: Resuming video extension
[  644.049435] em2884 #0: Resuming DVB extension
[  644.049442] em2884 #0: fe0 resume 0
[  644.081819] em2884 #0: Resuming input extension
[  644.081820] usb 1-4: reset high-speed USB device number 4 using xhci_hcd
[  644.247477] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8800aaa9c180
[  644.355325] PM: restore of devices complete after 1522.004 msecs
[  644.356217] PM: Image restored successfully.
[  644.356334] PM: Basic memory bitmaps freed
[  644.356344] Restarting tasks ... done.
[  644.374153] video LNXVIDEO:00: Restoring backlight state
[  645.247936] r8169 0000:03:00.0 p2p1: link up

Again, the application returned to lock the signal after resume:

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
       (0x00) Quality= Good Signal= 100.00% C/N= 36.70dB UCB= 863 postBER= 28.3x10^-6 PER= 0
Lock   (0x1f) Quality= Good Signal= 100.00% C/N= 36.50dB UCB= 2155 postBER= 21.6x10^-6 PER= 0


So, the frontend also restarted fine after suspend/resume.

Note: this time, I actually tested to play the stream with:

$ cat /dev/dvb/adapter0/dvr0 | ssh -X my_desktop "mplayer -cache 2000 -"

After suspend2disk/resume, it didn't work. I had to stop and restart
the dvbv5-zap in order to watch the channel, so, some init is still
seems to be needed for the demux to restart.

Regards,
Mauro



