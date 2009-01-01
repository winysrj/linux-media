Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LIUuE-0007xI-TQ
	for linux-dvb@linuxtv.org; Thu, 01 Jan 2009 22:16:40 +0100
From: Andy Walls <awalls@radix.net>
To: Mark Jenks <mjenks1968@gmail.com>
In-Reply-To: <e5df86c90901011034o5d58113fx62897ba05ff2c7a3@mail.gmail.com>
References: <e5df86c90812270840w2fd6be64l40f9838aef23db4f@mail.gmail.com>
	<1230500176.3120.60.camel@palomino.walls.org>
	<e5df86c90812281451o111e3ebem77c7d9bb8469e149@mail.gmail.com>
	<49580FAB.2000003@rogers.com>
	<e5df86c90812281701x561691ej219ee83604bbb083@mail.gmail.com>
	<49583D09.5080507@rogers.com>
	<e5df86c90901011034o5d58113fx62897ba05ff2c7a3@mail.gmail.com>
Date: Thu, 01 Jan 2009 16:18:43 -0500
Message-Id: <1230844723.11900.8.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with kernel oops when installing HVR-1800.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, 2009-01-01 at 12:34 -0600, Mark Jenks wrote:



> Well, I patched it, make clean, make, make install, and a reboot.
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000168
> IP: [<f0e2571c>] :cx23885:mpeg_open+0x41/0xc0
> *pde = 00000000
> Oops: 0000 [#1] SMP

Same failure mode, different place in the driver:

linux/drivers/media/video/cx23885/cx23885-417.c:mpeg_open():

        static int mpeg_open(struct file *file)
        {
        	[...]
                lock_kernel();
                list_for_each(list, &cx23885_devlist) {
                        h = list_entry(list, struct cx23885_dev,
        devlist);
                        if (h->v4l_device->minor == minor) {
                                dev = h;
        	[...]

"h->v4l_device" is likely NULL here for one device due to one card
having analog support in the driver and the other not having analog
support in the driver.

The fix for this is analogous to the previous fix.

Those are the only two places in the driver the cx23885_devlist is
iterated over, so hopefully every other instance of system will know
what type of device it it dealing with and v4l_device and video_dev will
only be used when well defined.

Fix, Test, Repeat...

Regards,
Andy




> Modules linked in: cpufreq_conservative cpufreq_userspace
> cpufreq_powersave powernow_k8 xfs loop dm_mod cx25840 mt2131 s5h1409
> cx23885 v4l2_compat_ioctl32 nvidia(P) snd_mpu401 cx2341x
> videobuf_dma_sg videobuf_dvb dvb_core videobuf_core snd_usb_audio
> snd_usb_lib snd_cs4232 snd_opl3_lib v4l2_common videodev agpgart
> snd_hwdep lirc_mceusb2 snd_cs4231_lib snd_mpu401_uart snd_rawmidi
> snd_hda_intel snd_pcm parport_pc ohci1394 snd_timer k8temp osst
> v4l1_compat snd_seq_device hwmon snd button i2c_nforce2 lirc_dev
> parport ieee1394 st forcedeth sr_mod cdrom rtc_cmos rtc_core btcx_risc
> tveeprom i2c_core snd_page_alloc soundcore rtc_lib sg usbhid hid
> ff_memless ohci_hcd ehci_hcd usbcore sd_mod edd ext3 mbcache jbd fan
> aic7xxx scsi_transport_spi sata_nv pata_amd libata scsi_mod dock
> thermal processor thermal_sys
> 
> Pid: 2876, comm: X Tainted: P          (2.6.27.10-default #3)
> EIP: 0060:[<f0e2571c>] EFLAGS: 00013287 CPU: 1
> EIP is at mpeg_open+0x41/0xc0 [cx23885]
> EAX: 00000000 EBX: ef1fd000 ECX: f0e308a8 EDX: ef3be000
> ESI: 00000001 EDI: ef189980 EBP: efba1790 ESP: efe93e84
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process X (pid: 2876, ti=efe92000 task=ef1e5070 task.ti=efe92000)
> Stack: efbf5a00 efbf5a04 ef189980 f0d775b8 00000000 ef3876c0 00000000
> efba1790
>        c016bee5 ef189980 00000000 ef189980 efba1790 00000000 c016bdd9
> c01683cd
>        ef81ebc0 ef504c6c efe93f14 ef189980 efe93f14 00000003 c01684d8
> ef189980
> Call Trace:
>  [<f0d775b8>] v4l2_open+0x62/0x76 [videodev]
>  [<c016bee5>] chrdev_open+0x10c/0x122
>  [<c016bdd9>] chrdev_open+0x0/0x122
>  [<c01683cd>] __dentry_open+0x10d/0x1fc
>  [<c01684d8>] nameidata_to_filp+0x1c/0x2c
>  [<c0172986>] do_filp_open+0x33d/0x63e
>  [<f1aad8ce>] _nv004117rm+0x9/0x12 [nvidia]
>  [<c01582f8>] handle_mm_fault+0x2b3/0x5dd
>  [<f0dcf391>] __videobuf_mmap_free+0x3e/0x7d [videobuf_core]
>  [<c017ab2d>] alloc_fd+0x57/0xd3
>  [<c01681e8>] do_sys_open+0x3f/0xb8
>  [<c01682a5>] sys_open+0x1e/0x23
>  [<c01037ad>] sysenter_do_call+0x12/0x21
>  =======================
> Code: 17 68 38 7a e2 f0 68 c8 0a 00 00 68 ee a2 e2 f0 e8 51 aa 2f cf
> 83 c4 0c e8 88 66 49 cf 8b 1d a0 fd e2 f0 eb 10 8b 83 c4 0e 00 00 <39>
> b0 68 01 00 00 74 1c 89 d3 8b 13 0f 18 02 90 81 fb a0 fd e2
> EIP: [<f0e2571c>] mpeg_open+0x41/0xc0 [cx23885] SS:ESP 0068:efe93e84
> ---[ end trace 1bdce38cbcdc8781 ]---
>  
> 
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
