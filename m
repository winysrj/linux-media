Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:25431 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbZCBQhe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 11:37:34 -0500
Received: from e177043048.adsl.alicedsl.de ([85.177.43.48] helo=[192.168.0.124])
	by mail.uni-paderborn.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63 hoth)
	id 1LeB90-0007qY-RD
	for linux-media@vger.kernel.org; Mon, 02 Mar 2009 17:37:31 +0100
Message-ID: <49AC0BB5.8020702@campus.upb.de>
Date: Mon, 02 Mar 2009 17:39:17 +0100
From: David Woitkowski <jarrn@campus.upb.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Using tm6010 for Haupauge WinTV-HVR 900H
References: <49AADB15.8060900@campus.upb.de> <49ABF1FF.5070908@gmail.com>
In-Reply-To: <49ABF1FF.5070908@gmail.com>
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Helge Nert schrieb:
> I'm also interested in the status of the tm6010 driver (and getting it 
> to work).
> 
> Mauro: Is there any way that we can help in developing the driver?

I researched a bit more and discovered that the driver activates a
video-device at /dev/video1 (video0 is a webcam).

Now I tried a bit xawtv with this device:

$ xawtv -c /dev/video1
This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.27-11-generic)
xinerama 0: 1280x800+0+0
Segmentation fault
v4l-conf had some trouble, trying to continue anyway
v4l2: open /dev/video1: Permission denied
v4l2: open /dev/video1: Permission denied
v4l: open /dev/video1: Permission denied
no video grabber device available

$ xawtv -c /dev/video1 -v 2
This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.27-11-generic)
visual: id=0x21 class=4 (TrueColor), depth=24
visual: id=0x22 class=5 (DirectColor), depth=24
visual: id=0x54 class=4 (TrueColor), depth=32
x11: color depth: 24 bits, 3 bytes - pixmap: 4 bytes
x11: color masks: red=0x00ff0000 green=0x0000ff00 blue=0x000000ff
x11: server byte order: little endian
x11: client byte order: little endian
check if the X-Server is local ... * ok (unix socket)
main: dga extention...
DGA version 2.0
main: xinerama extention...
xinerama 0: 1280x800+0+0
main: xvideo extention [video]...
main: xvideo extention [image]...
blit: xv: 0x32595559 (YUY2) packed [ok: 16 bit YUV 4:2:2 (packed, YUYV)]
blit: xv: 0x32315659 (YV12) planar
blit: xv: 0x30323449 (I420) planar [ok: 12 bit YUV 4:2:0 (planar)]
blit: xv: 0x59565955 (UYVY) packed [ok: 16 bit YUV 4:2:2 (packed, UYVY)]
blit: xv: 0x434d5658 (XVMC) planar
main: init main window...
main: install signal handlers...
main thread [pid=10908]
main: open grabber device...
x11: 1280x800, 32 bit/pixel, 12800 byte/scanline, DGA
v4l-conf: using X11 display :0.0
dga: version 2.0
mode: 1280x800, depth=24, bpp=32, bpl=12800, base=0xd0300000
Segmentation fault
got sigchild
waitpid: No child processes
v4l-conf had some trouble, trying to continue anyway
vid-open: trying: v4l2-old...
v4l2: open /dev/video1: Permission denied
vid-open: failed: v4l2-old
vid-open: trying: v4l2...
v4l2: open /dev/video1: Permission denied
vid-open: failed: v4l2
vid-open: trying: v4l...
v4l: open /dev/video1: Permission denied
vid-open: failed: v4l
no video grabber device available

$ xawtv -hwscan
This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.27-11-generic)
looking for available devices
port 66-81
     type : Xvideo, image scaler
     name : Intel(R) Textured Video

/dev/video0: OK                         [ -device /dev/video0 ]
     type : v4l2
     name : Lenovo EasyCamera
     flags:  capture

/dev/video1: Permission denied


And every time I try accessing /dev/video1 there is
$ dmesg
[12604.332127] BUG: unable to handle kernel NULL pointer dereference at
000000e8
[12604.332134] IP: [<f95ac39d>] :tm6000:tm6000_poll+0x1d/0xa0
[12604.332143] *pde = 00000000
[12604.332147] Oops: 0000 [#7] SMP
[12604.332151] Modules linked in: tuner_xc2028 tuner v4l2_common tm6000
i2c_core videobuf_vmalloc videobuf_core af_packet i915 drm binfmt_misc
rfcomm sco bridge stp bnep l2cap ipv6 vboxnetflt vboxdrv ppdev
acpi_cpufreq cpufreq_powersave cpufreq_userspace cpufreq_stats
cpufreq_ondemand cpufreq_conservative freq_table sbs pci_slot wmi sbshc
container iptable_filter ip_tables x_tables parport_pc lp parport loop
joydev serio_raw arc4 uvcvideo psmouse evdev ecb crypto_blkcipher
videodev usblp v4l1_compat iwlagn btusb iwlcore rfkill led_class
bluetooth snd_hda_intel mac80211 snd_pcm_oss snd_mixer_oss cfg80211
snd_pcm sdhci_pci sdhci mmc_core snd_seq_dummy snd_seq_oss battery
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq ac video output
snd_timer snd_seq_device snd button soundcore shpchp snd_page_alloc
pci_hotplug intel_agp agpgart ext3 jbd mbcache usbhid hid sr_mod cdrom
sd_mod crc_t10dif sg ahci libata tg3 libphy scsi_mod dock ehci_hcd
uhci_hcd usbcore thermal processor fan fbcon tileblit font bitblit
softcursor fuse
[12604.332255]
[12604.332258] Pid: 10913, comm: v4l-conf Tainted: G      D
(2.6.27-11-generic #1)
[12604.332260] EIP: 0060:[<f95ac39d>] EFLAGS: 00210246 CPU: 1
[12604.332265] EIP is at tm6000_poll+0x1d/0xa0 [tm6000]
[12604.332268] EAX: edd26900 EBX: 00000000 ECX: f8e63930 EDX: f95b1000
[12604.332270] ESI: edd26900 EDI: f95b1000 EBP: eb4b5e44 ESP: eb4b5e38
[12604.332272]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[12604.332275] Process v4l-conf (pid: 10913, ti=eb4b4000 task=eb5b8c90
task.ti=eb4b4000)
[12604.332277] Stack: f59ab200 edd26900 f59ab204 eb4b5e58 f8e639b3
00000000 eccf5780 00000000
[12604.332286]        eb4b5e80 c01b5035 edd26900 edf5dc60 eb4b5e70
c05ac8a0 eb4b5e80 edd26900
[12604.332294]        00000000 edf5dc60 eb4b5e9c c01b049c f6b29a00
e8cd7b28 edd26900 eb4b5f04
[12604.332301] Call Trace:
[12604.332305]  [<f8e639b3>] ? v4l2_open+0x83/0xa0 [videodev]
[12604.332312]  [<c01b5035>] ? chrdev_open+0xd5/0x1b0
[12604.332320]  [<c01b049c>] ? __dentry_open+0xbc/0x260
[12604.332324]  [<c01b0717>] ? nameidata_to_filp+0x47/0x60
[12604.332329]  [<c01b4f60>] ? chrdev_open+0x0/0x1b0
[12604.332333]  [<c01bddbd>] ? do_filp_open+0x1bd/0x790
[12604.332337]  [<c02a904f>] ? pty_write+0x3f/0x60
[12604.332343]  [<c01e244e>] ? inotify_inode_queue_event+0xe/0xe0
[12604.332348]  [<c02a8bda>] ? tty_ldisc_deref+0x5a/0x80
[12604.332352]  [<c01c98f9>] ? expand_files+0x9/0x60
[12604.332356]  [<c01c9a30>] ? alloc_fd+0xe0/0x100
[12604.332360]  [<c01b0295>] ? do_sys_open+0x65/0x100
[12604.332364]  [<c01b039e>] ? sys_open+0x2e/0x40
[12604.332367]  [<c0103f7b>] ? sysenter_do_call+0x12/0x2f
[12604.332372]  [<c0370000>] ? enable_nonboot_cpus+0x60/0xc0
[12604.332377]  =======================
[12604.332379] Code: ff 5d c3 8d 74 26 00 8d bc 27 00 00 00 00 55 89 e5
83 ec 0c 89 1c 24 89 74 24 04 89 7c 24 08 e8 0a 8f b5 c6 8b 58 70 89 c6
89 d7 <83> bb e8 00 00 00 01 74 1a b8 08 00 00 00 8b 1c 24 8b 74 24 04
[12604.332422] EIP: [<f95ac39d>] tm6000_poll+0x1d/0xa0 [tm6000] SS:ESP
0068:eb4b5e38
[12604.332430] ---[ end trace 2c9a251a17248d49 ]---


And just to cover the "Permission dienied"s. Doing these steps as
superuser gives the same results. The permissions are set as follows:
$ ls -l /dev/video*
crw-rw----+ 1 root video 81, 0 2009-03-02 13:45 /dev/video0
crw-rw----  1 root video 81, 1 2009-03-02 17:01 /dev/video1



> I hope it doesn't require a Windows environment (which I haven't). In
> any case I'm willing to test the driver in different environments
> (64bit, 32bit, Intel (Atom), AMD and VIA processors).

Speaking about Windows: I tried the device inside VirtualBox-PUEL 2.1.4.
The device is recognised correctly, can scan for channels and play
sound. The guys at forums.virtualbox.org told me the USB-support is
probably too slow to handle the video.
Full thread at http://forums.virtualbox.org/viewtopic.php?p=62194#62194

Buy,
David

