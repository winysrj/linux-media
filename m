Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:63786 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab0BLOiN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 09:38:13 -0500
Received: by bwz4 with SMTP id 4so2826821bwz.2
        for <linux-media@vger.kernel.org>; Fri, 12 Feb 2010 06:38:09 -0800 (PST)
Message-ID: <4B7567CB.20609@gmail.com>
Date: Fri, 12 Feb 2010 15:38:03 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antoine Jacquet <royale@zerezo.com>
Subject: Re: zr364xx: Aiptek DV8800 (neo): 08ca:2062: Fails on subsequent
 zr364xx_open()
References: <4B73C792.3060907@gmail.com> <4B741C47.1090905@zerezo.com>
In-Reply-To: <4B741C47.1090905@zerezo.com>
Content-Type: multipart/mixed;
 boundary="------------060000070907090006070909"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060000070907090006070909
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Antoine,

Antoine Jacquet wrote:
> Hi Thomas,
> 
>> Looks like the device does not like to be fed with the (full) init 
>> METHOD2 on every open()...
>> Since the VIDIOC_QUERYCAP worked it should not be the wrong METHOD.
> 
> Someone reported similar behavior recently, and was apparently able to 
> fix the issue by adding more delay between open/close sequences.

No search tags to find it on the list, can You remember device model?

> 
> Could you try the attached patch to see if it solves the issue?

Didn't work, same -110 errors, sorry, no v4l-dvb git here, vdr production machine on 2.6.32.7.

> 
> If not, we can also try to add some mdelay() after each usb_control_msg().

1. Patch with optimized delay below, slow but works, 1st try was delaying subsequent msg 
at open sequence i=6, worked until the last 2 open() before capture start.
>From the windows snoopy log I sent yesterday I can see only 1-2 URBs with relevant delay of ~1s but 
cannot see the sequence point.

What is error -22, can not find it in errno.h?

2. Picture with (640->320) lines alignment error with ekiga+cheese 
*attached*, wether cam is configured internally for 640x480 or 320x240, not affecting.
setting the driver to mode=2 fails with libv4l jpeg decoding errors. I try to correct this.

3. Driver oops on modprobe -r or device firmware crash, 
I need to unplug first or null pointer fault occours (mutex locks), see below

> 
> Regards,
> 
> Antoine
> 

y
tom

--- drivers/media/video/zr364xx.c.orig	2009-12-18 23:27:07.000000000 +0100
+++ drivers/media/video/zr364xx.c	2010-02-12 12:57:54.000000000 +0100
@@ -205,40 +205,41 @@
 struct zr364xx_buffer {
 	/* common v4l buffer stuff -- must be first */
 	struct videobuf_buffer vb;
 	const struct zr364xx_fmt *fmt;
 };
 
 /* function used to send initialisation commands to the camera */
 static int send_control_msg(struct usb_device *udev, u8 request, u16 value,
 			    u16 index, unsigned char *cp, u16 size)
 {
 	int status;
 
 	unsigned char *transfer_buffer = kmalloc(size, GFP_KERNEL);
 	if (!transfer_buffer) {
 		dev_err(&udev->dev, "kmalloc(%d) failed\n", size);
 		return -ENOMEM;
 	}
 
 	memcpy(transfer_buffer, cp, size);
 
+	mdelay(300);
 	status = usb_control_msg(udev,
 				 usb_sndctrlpipe(udev, 0),
 				 request,
 				 USB_DIR_OUT | USB_TYPE_VENDOR |
 				 USB_RECIP_DEVICE, value, index,
 				 transfer_buffer, size, CTRL_TIMEOUT);
 
 	kfree(transfer_buffer);
 
 	if (status < 0)
 		dev_err(&udev->dev,
 			"Failed sending control message, error %d.\n", status);
 
 	return status;
 }
 
 
 /* Control messages sent to the camera to initialize it
  * and launch the capture */
 typedef struct {
@@ -1248,40 +1249,41 @@
 
 
 /* open the camera */
 static int zr364xx_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct zr364xx_camera *cam = video_drvdata(file);
 	struct usb_device *udev = cam->udev;
 	int i, err;
 
 	DBG("%s\n", __func__);
 
 	mutex_lock(&cam->open_lock);
 
 	if (cam->users) {
 		err = -EBUSY;
 		goto out;
 	}
 
 	for (i = 0; init[cam->method][i].size != -1; i++) {
+//		if (i == 6) mdelay(1000);
 		err =
 		    send_control_msg(udev, 1, init[cam->method][i].value,
 				     0, init[cam->method][i].bytes,
 				     init[cam->method][i].size);
 		if (err < 0) {
 			dev_err(&cam->udev->dev,
 				"error during open sequence: %d\n", i);
 			goto out;
 		}
 	}
 
 	cam->skip = 2;
 	cam->users++;
 	file->private_data = vdev;
 	cam->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	cam->fmt = formats;
 
 	videobuf_queue_vmalloc_init(&cam->vb_vidq, &zr364xx_video_qops,
 				    NULL, &cam->slock,
 				    cam->type,


usb 1-2: new high speed USB device using ehci_hcd and address 7
usb 1-2: New USB device found, idVendor=08ca, idProduct=2062
usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: DV 8800
usb 1-2: Manufacturer: AIPTEK
usb 1-2: configuration #1 chosen from 1 choice
zr364xx probing...
zr364xx 1-2:1.0: Zoran 364xx compatible webcam plugged
zr364xx 1-2:1.0: model 08ca:2062 detected
usb 1-2: 320x240 mode selected
zr364xx dev: ffff880039379000, udev ffff8800388d1800 interface ffff880039380a00
zr364xx num endpoints 3
zr364xx board init: ffff880039379000
zr364xx valloc ffff880039379028, idx 0, pdata ffffc900019ef000
zr364xx zr364xx_start_readpipe: start pipe IN x81
zr364xx submitting URB ffff8800393a1900
zr364xx : board initialized
usb 1-2: Zoran 364xx controlling video device 3
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
Zoran 364xx: VIDIOC_QUERYCAP driver=Zoran 364xx, card=DV 8800, bus=1-2, version=0x00000703, capabilities=0x05000001
zr364xx zr364xx_release
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
zr364xx zr364xx_release
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
Zoran 364xx: VIDIOC_QUERYCAP driver=Zoran 364xx, card=DV 8800, bus=1-2, version=0x00000703, capabilities=0x05000001
zr364xx zr364xx_release
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
zr364xx zr364xx_release
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
Zoran 364xx: VIDIOC_QUERYCAP driver=Zoran 364xx, card=DV 8800, bus=1-2, version=0x00000703, capabilities=0x05000001
Zoran 364xx: VIDIOC_ENUMINPUT index=0, name=Zoran 364xx Camera, type=2, audioset=0, tuner=0, std=00000000, status=0
Zoran 364xx: VIDIOC_ENUMINPUT error -22
Zoran 364xx: VIDIOC_ENUM_FMT index=0, type=1, flags=1, pixelformat=JPEG, description='JPG'
Zoran 364xx: VIDIOC_TRY_FMT type=vid-cap
zr364xx zr364xx_vidioc_try_fmt_vid_cap: V4L2_PIX_FMT_JPEG (1) ok!
Zoran 364xx: width=320, height=240, format=JPEG, field=none, bytesperline=640 sizeimage=153600, colorspace=0
zr364xx zr364xx_release
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
zr364xx zr364xx_release
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
Zoran 364xx: VIDIOC_QUERYCAP driver=Zoran 364xx, card=DV 8800, bus=1-2, version=0x00000703, capabilities=0x05000001
zr364xx zr364xx_release
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
zr364xx zr364xx_release
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
Zoran 364xx: VIDIOC_QUERYCAP driver=Zoran 364xx, card=DV 8800, bus=1-2, version=0x00000703, capabilities=0x05000001
zr364xx zr364xx_release
zr364xx zr364xx_open
zr364xx zr364xx_open: 0
Zoran 364xx: VIDIOC_QUERYCAP driver=Zoran 364xx, card=DV 8800, bus=1-2, version=0x00000703, capabilities=0x05000001
Zoran 364xx: VIDIOC_G_FMT type=vid-cap
Zoran 364xx: width=320, height=240, format=JPEG, field=none, bytesperline=640 sizeimage=153600, colorspace=0
Zoran 364xx: VIDIOC_ENUM_FMT index=0, type=1, flags=1, pixelformat=JPEG, description='JPG'
Zoran 364xx: VIDIOC_ENUM_FRAMESIZES error -22
Zoran 364xx: VIDIOC_ENUM_FMT error -22
Zoran 364xx: VIDIOC_QUERYCAP driver=Zoran 364xx, card=DV 8800, bus=1-2, version=0x00000703, capabilities=0x05000001
Zoran 364xx: VIDIOC_G_INPUT value=0
Zoran 364xx: VIDIOC_ENUMINPUT index=0, name=Zoran 364xx Camera, type=2, audioset=0, tuner=0, std=00000000, status=0
Zoran 364xx: VIDIOC_QUERYCTRL id=0x80000000
Zoran 364xx: VIDIOC_QUERYCTRL error -22
Zoran 364xx: VIDIOC_QUERYCAP driver=Zoran 364xx, card=DV 8800, bus=1-2, version=0x00000703, capabilities=0x05000001
Zoran 364xx: VIDIOC_G_PARM type=1
Zoran 364xx: VIDIOC_G_PARM error -22
Zoran 364xx: VIDIOC_S_STD std=000000ff
Zoran 364xx: VIDIOC_S_STD error -22
Zoran 364xx: VIDIOC_ENUMINPUT index=0, name=Zoran 364xx Camera, type=2, audioset=0, tuner=0, std=00000000, status=0
Zoran 364xx: VIDIOC_ENUMINPUT error -22
Zoran 364xx: VIDIOC_S_INPUT value=0
Zoran 364xx: VIDIOC_QUERYBUF error -22
Zoran 364xx: VIDIOC_G_PARM type=1
Zoran 364xx: VIDIOC_G_PARM error -22
Zoran 364xx: VIDIOC_TRY_FMT type=vid-cap
zr364xx zr364xx_vidioc_try_fmt_vid_cap: V4L2_PIX_FMT_JPEG (1) ok!
Zoran 364xx: width=320, height=240, format=JPEG, field=none, bytesperline=640 sizeimage=153600, colorspace=0
Zoran 364xx: VIDIOC_TRY_FMT type=vid-cap
zr364xx zr364xx_vidioc_try_fmt_vid_cap: V4L2_PIX_FMT_JPEG (1) ok!
Zoran 364xx: width=320, height=240, format=JPEG, field=none, bytesperline=640 sizeimage=153600, colorspace=0
Zoran 364xx: VIDIOC_TRY_FMT type=vid-cap
zr364xx zr364xx_vidioc_try_fmt_vid_cap: V4L2_PIX_FMT_JPEG (1) ok!
Zoran 364xx: width=320, height=240, format=JPEG, field=none, bytesperline=640 sizeimage=153600, colorspace=0
Zoran 364xx: VIDIOC_QUERYBUF error -22
Zoran 364xx: VIDIOC_G_PARM type=1
Zoran 364xx: VIDIOC_G_PARM error -22
Zoran 364xx: VIDIOC_REQBUFS count=4, type=vid-cap, memory=mmap
Zoran 364xx: VIDIOC_QUERYBUF 00:00:00.00000000 index=0, type=vid-cap, bytesused=0, flags=0x00000000, field=0, sequence=0, memory=mmap, offset/userptr=0x00000000, length=233472
...
Zoran 364xx: VIDIOC_QUERYBUF 351661:46:32.00475137 index=3, type=vid-cap, bytesused=230400, flags=0x00000001, field=1, sequence=9, memory=mmap, offset/userptr=0x000ab000, length=233472
Zoran 364xx: timecode=00:00:00 type=0, flags=0x00000000, frames=0, userbits=0x00000000
Zoran 364xx: VIDIOC_QUERYBUF error -22
zr364xx zr364xx_release
usb 1-2: USB disconnect, address 7
zr364xx read_pipe_completion, err shutdown
zr364xx 1-2:1.0: Zoran 364xx webcam unplugged
zr364xx stop read pipe
zr364xx vfree ffffc900019ef000


Feb 12 07:35:17 tom1 kernel: usb 1-2: USB disconnect, address 9
Feb 12 07:35:17 tom1 kernel: zr364xx read_pipe_completion, err shutdown
Feb 12 07:35:17 tom1 kernel: BUG: unable to handle kernel NULL pointer dereference at (null)
Feb 12 07:35:17 tom1 kernel: IP: [<ffffffff8160f168>] __mutex_lock_slowpath+0x48/0x140
Feb 12 07:35:17 tom1 kernel: PGD 3cf8f067 PUD 2fd36067 PMD 0 
Feb 12 07:35:17 tom1 kernel: Oops: 0002 [#1] PREEMPT 
Feb 12 07:35:17 tom1 kernel: last sysfs file: /sys/devices/platform/w83627hf.656/fan2_input
Feb 12 07:35:17 tom1 kernel: CPU 0 
Feb 12 07:35:17 tom1 kernel: Modules linked in: zr364xx videobuf_vmalloc isofs ehci_hcd dvb_usb_dibusb_mc dvb_usb_dibusb_common dib3000mc dibx000_common dvb_usb mt2060 radeon ttm drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect ppdev lp parport sco bridge stp llc bnep l2cap bluetooth rfkill battery cpufreq_userspace cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_ondemand freq_table nfsd nfs lockd sunrpc ipv6 af_packet joydev hid_sunplus fuse w83627hf hwmon_vid usbhid snd_usb_audio hid snd_usb_lib uvcvideo snd_hwdep ves1820 snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm dvb_ttpci snd_page_alloc snd_mpu401_uart tda10021 snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event budget_av budget_core saa7146_vv uhci_hcd snd_seq videodev v4l1_compat v4l2_compat_ioctl32 videobuf_dma_sg snd_timer snd_seq_device videobuf_core dvb_core psmouse ohci1394 k8temp saa7146 snd ttpci_eeprom usbcore rtc_cmos evdev proc
essor thermal hwmon button serio_r
Feb 12 07:35:17 tom1 kernel: w pcspkr ieee1394 i2c_viapro sata_promise r8169 mii soundcore i2c_core unix [last unloaded: videobuf_vmalloc]
Feb 12 07:35:17 tom1 kernel: Pid: 1474, comm: khubd Not tainted 2.6.32.7 #4 MS-6702E
Feb 12 07:35:17 tom1 kernel: RIP: 0010:[<ffffffff8160f168>]  [<ffffffff8160f168>] __mutex_lock_slowpath+0x48/0x140
Feb 12 07:35:17 tom1 kernel: RSP: 0018:ffff88003da73b50  EFLAGS: 00010213
Feb 12 07:35:17 tom1 kernel: RAX: ffff88003da73b50 RBX: ffff880001e0a500 RCX: ffff88003ba3fc00
Feb 12 07:35:17 tom1 kernel: RDX: 0000000000000000 RSI: 0000000000000083 RDI: 0000000000000001
Feb 12 07:35:17 tom1 kernel: RBP: ffff88003da73ba0 R08: 0000000000000000 R09: 00000000000043c1
Feb 12 07:35:17 tom1 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff88002c514000
Feb 12 07:35:17 tom1 kernel: R13: ffff88003df95320 R14: ffff880019289800 R15: ffff880001e0a508
Feb 12 07:35:17 tom1 kernel: FS:  00007f0a41208910(0000) GS:ffffffff817e6000(0000) knlGS:0000000000000000
Feb 12 07:35:17 tom1 kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 12 07:35:17 tom1 kernel: CR2: 0000000000000000 CR3: 000000003ebde000 CR4: 00000000000006f0
Feb 12 07:35:17 tom1 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 12 07:35:17 tom1 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 12 07:35:17 tom1 kernel: Process khubd (pid: 1474, threadinfo ffff88003da72000, task ffff88003df95320)
Feb 12 07:35:17 tom1 kernel: Stack:
Feb 12 07:35:17 tom1 kernel:  ffff880001e0a508 0000000000000000 ffff88003da73b88 ffff88003da73fd8
Feb 12 07:35:17 tom1 kernel: <0> ffff88003da73fd8 ffff880001e0a500 ffff88002c514000 ffff880001e0a400
Feb 12 07:35:17 tom1 kernel: <0> ffff880019289800 ffff880019289890 ffff88003da73bb0 ffffffff8160f08d
Feb 12 07:35:17 tom1 kernel: Call Trace:
Feb 12 07:35:17 tom1 kernel:  [<ffffffff8160f08d>] mutex_lock+0xd/0x10
Feb 12 07:35:17 tom1 kernel:  [<ffffffffa01645b9>] videobuf_mmap_free+0x19/0x40 [videobuf_core]
Feb 12 07:35:17 tom1 kernel:  [<ffffffffa01bb12b>] zr364xx_disconnect+0x2b/0x1a0 [zr364xx]
Feb 12 07:35:17 tom1 kernel:  [<ffffffffa00bc78c>] usb_unbind_interface+0xac/0x100 [usbcore]
Feb 12 07:35:17 tom1 kernel:  [<ffffffff814690f0>] __device_release_driver+0x70/0xd0
Feb 12 07:35:17 tom1 kernel:  [<ffffffff81469268>] device_release_driver+0x28/0x40
Feb 12 07:35:17 tom1 kernel:  [<ffffffff8146856c>] bus_remove_device+0x9c/0xd0
Feb 12 07:35:17 tom1 kernel:  [<ffffffff814666ab>] device_del+0x12b/0x1d0
Feb 12 07:35:17 tom1 kernel:  [<ffffffffa00b9885>] usb_disable_device+0x95/0x110 [usbcore]
Feb 12 07:35:17 tom1 kernel:  [<ffffffffa00b3d23>] usb_disconnect+0xb3/0x140 [usbcore]
Feb 12 07:35:17 tom1 kernel:  [<ffffffffa00b4ce9>] hub_thread+0x339/0x1340 [usbcore]
Feb 12 07:35:17 tom1 kernel:  [<ffffffff81038488>] ? pick_next_task_fair+0xc8/0x110
Feb 12 07:35:17 tom1 kernel:  [<ffffffff8105c3a0>] ? autoremove_wake_function+0x0/0x40
Feb 12 07:35:17 tom1 kernel:  [<ffffffffa00b49b0>] ? hub_thread+0x0/0x1340 [usbcore]
Feb 12 07:35:17 tom1 kernel:  [<ffffffffa00b49b0>] ? hub_thread+0x0/0x1340 [usbcore]
Feb 12 07:35:17 tom1 kernel:  [<ffffffff8105bfae>] kthread+0x8e/0xa0
Feb 12 07:35:17 tom1 kernel:  [<ffffffff8100c14a>] child_rip+0xa/0x20
Feb 12 07:35:17 tom1 kernel:  [<ffffffff8105bf20>] ? kthread+0x0/0xa0
Feb 12 07:35:17 tom1 kernel:  [<ffffffff8100c140>] ? child_rip+0x0/0x20
Feb 12 07:35:17 tom1 kernel: Code: 48 83 ec 28 e8 7a 97 a2 ff bf 01 00 00 00 e8 70 97 a2 ff 48 8b 53 10 48 8d 45 b0 4c 8d 7b 08 48 89 43 10 4c 89 7d b0 48 89 55 b8 <48> 89 02 48 c7 c2 ff ff ff ff 4c 89 6d c0 48 89 d0 87 03 ff c8 
Feb 12 07:35:17 tom1 kernel: RIP  [<ffffffff8160f168>] __mutex_lock_slowpath+0x48/0x140
Feb 12 07:35:17 tom1 kernel:  RSP <ffff88003da73b50>
Feb 12 07:35:17 tom1 kernel: CR2: 0000000000000000
Feb 12 07:35:17 tom1 kernel: ---[ end trace 6a5f37e07ec8365f ]---



--------------060000070907090006070909
Content-Type: image/jpeg;
 name="2010-02-12-095743.jpg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="2010-02-12-095743.jpg"

/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRof
Hh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwh
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAAR
CADwAUADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAA
AgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWG
h4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl
5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREA
AgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYk
NOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk
5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwC6BzwDTwpYjCE+tdn2GaQHnjOK5rN7jbOQ
ztHPWpFXCgkZrq9oPJpx49qOVBc5TjrTuo611IIIz1+lSAUOAKZyg68j8qADzk1rXBJkYVW4
65qeVIvcpcbeaMkcdquN64+Wo2weRgU722RSRDg9e1MGQeTmrSnII9aOR3oUvICqQS3Q8VGU
OAw6Cri9cjpTyD9KLu+gaGUT1B70xl54Fa5BZMEUKCF2k8VLk+o7oyU4bnmpZF4GTWiOPelO
evap52PQx2z26etMYA9eDW4CWOAM4pdpHHelfXYWhhcBeTSZ4xjNbrBh2Y0oUkZ7Vd0NMwxn
HbBoHHUZPtW6FIOQOKMHPShSYXMlDxjsamUc4WtHIUFn+VR3NZV94o06y+WOTz5v7sZo1bJ3
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
DQ6q7CeC/vH/2Q==
--------------060000070907090006070909--
