Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5AB02Tl019184
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 07:00:02 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5AAxolo001514
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 06:59:50 -0400
Received: by fg-out-1718.google.com with SMTP id e21so2026853fga.7
	for <video4linux-list@redhat.com>; Tue, 10 Jun 2008 03:59:50 -0700 (PDT)
Date: Tue, 10 Jun 2008 21:01:57 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080610210157.35fa0c11@glory.loctelecom.ru>
In-Reply-To: <1211331167.4235.26.camel@pc10.localdom.local>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<20080414172821.3966dfbf@areia>
	<20080415125059.3e065997@glory.loctelecom.ru>
	<20080415000611.610af5c6@gaivota>
	<20080415135455.76d18419@glory.loctelecom.ru>
	<20080415122524.3455e060@gaivota>
	<20080422175422.3d7e4448@glory.loctelecom.ru>
	<20080422130644.7bfe3b2d@gaivota>
	<20080423124157.1a8eda0a@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804222254350.20809@bombadil.infradead.org>
	<20080423160505.36064bf7@glory.loctelecom.ru>
	<20080423113739.7f314663@gaivota>
	<20080424093259.7880795b@glory.loctelecom.ru>
	<Pine.LNX.4.64.0804232237450.31358@bombadil.infradead.org>
	<20080512201114.3bd41ee5@glory.loctelecom.ru>
	<1210719122.26311.37.camel@pc10.localdom.local>
	<20080520152426.5540ee7f@glory.loctelecom.ru>
	<1211331167.4235.26.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/N2Zq76NT.2h6_DogzOwwbz0"
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] callbacks function of saa7134_empress
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--MP_/N2Zq76NT.2h6_DogzOwwbz0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

If I try v4l2-ctl --all -d /dev/video1 or v4l2-ctl --streamon -d /dev/video1 modules crashed:

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c028b66e>] __mutex_lock_slowpath+0x29/0x7b
*pde = 00000000 
Oops: 0002 [#1] SMP 
Modules linked in: ac battery loop saa7134_empress(F) saa6752hs(F) tuner_simple(F) tuner_types(F) tea5767(F) tda9887(F) tda8290(F) tea5761(F) tuner(F) snd_cmipci snd_pcm snd_page_alloc snd_opl3_lib saa7134(F) snd_mpu401 parport_pc parport snd_timer snd_hwdep snd_mpu401_uart floppy rtc psmouse videodev(F) v4l1_compat(F) compat_ioctl32(F) v4l2_common(F) videobuf_dma_sg(F) videobuf_core(F) snd_rawmidi snd_seq_device via_ircc pcspkr snd ir_kbd_i2c(F) irda soundcore ir_common(F) crc_ccitt tveeprom(F) i2c_viapro i2c_core button via_agp agpgart evdev ext3 jbd mbcache ide_cd_mod cdrom ide_disk 8139cp via82cxxx ide_core 8139too mii ehci_hcd uhci_hcd usbcore thermal processor fan

Pid: 2742, comm: v4l2-ctl Tainted: GF        (2.6.25 #1)
EIP: 0060:[<c028b66e>] EFLAGS: 00010286 CPU: 0
EIP is at __mutex_lock_slowpath+0x29/0x7b
EAX: ffffffff EBX: d0a09eb4 ECX: c0314b04 EDX: 00000000
ESI: d0a09ebc EDI: d0a09eb8 EBP: cf325260 ESP: ced7fde4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process v4l2-ctl (pid: 2742, ti=ced7e000 task=cf325260 task.ti=ced7e000)
Stack: d0a09ebc d0a097c4 ced7fed4 fffffff0 d0a09eb4 00000000 cf17e000 c028b52b 
       d08e5411 00000000 ced7fed4 00000000 d0975acb 40045612 cfa86ee0 ffffffcd 
       cf2b7000 ced7febc c03858d6 00000019 00000292 d089e4ec cf37b2a0 d089e4a0 
Call Trace:
 [<c028b52b>] mutex_lock+0xa/0xb
 [<d08e5411>] videobuf_streamon+0xf/0x9a [videobuf_core]
 [<d0975acb>] __video_do_ioctl+0x136a/0x2d68 [videodev]
 [<d088f789>] task_end_request+0x40/0x51 [ide_core]
 [<d088c4aa>] ide_intr+0x187/0x192 [ide_core]
 [<c016a551>] mntput_no_expire+0x11/0x64
 [<c0160b1c>] path_walk+0x90/0x98
 [<d0977738>] video_ioctl2+0x173/0x239 [videodev]
 [<c0140936>] filemap_fault+0x202/0x370
 [<c014930a>] __do_fault+0x2c3/0x2fe
 [<c014ab03>] handle_mm_fault+0x22a/0x49f
 [<c0162737>] vfs_ioctl+0x47/0x5d
 [<c0162992>] do_vfs_ioctl+0x245/0x258
 [<c01629e6>] sys_ioctl+0x41/0x5b
 [<c01036a6>] sysenter_past_esp+0x5f/0x85
 =======================
Code: c0 c3 55 57 56 53 89 c3 8d 78 04 83 ec 0c 89 f8 64 8b 2d 00 c0 36 c0 e8 ef 0b 00 00 8d 73 08 83 c8 ff 8b 56 04 89 34 24 89 66 04 <89> 22 89 54 24 04 89 6c 24 08 87 03 48 74 21 83 c8 ff 87 03 48 
EIP: [<c028b66e>] __mutex_lock_slowpath+0x29/0x7b SS:ESP 0068:ced7fde4
---[ end trace 157ece570bdba591 ]---

After this fix all of that commands works without problem:

v4l2-ctl --all -d /dev/video1

Driver Info:
	Driver name   : saa7134
	Card type     : Beholder BeholdTV M6 Extra
	Bus info      : PCI:0000:00:0d.0
	Driver version: 526
	Capabilities  : 0x05000001
		Video Capture
		Read/Write
		Streaming
Format Video Capture:
	Width/Height  : 720/576
	Pixel Format  : MPEG
	Field         : Any
	Bytes per Line: 0
	Size Image    : 58656
	Colorspace    : Unknown (00000000)
Video input : 0 (CCIR656)
Video Standard = 0x000000ff
	PAL-B/B1/G/H/I/D/D1/K


diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Mon Jun 09 11:59:05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Tue Jun 10 20:34:22 2008 +1000
@@ -227,8 +227,7 @@ static int empress_g_fmt_vid_cap(struct 
 static int empress_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	saa7134_i2c_call_clients(dev, VIDIOC_G_FMT, f);
 
@@ -241,8 +240,7 @@ static int empress_s_fmt_vid_cap(struct 
 static int empress_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	saa7134_i2c_call_clients(dev, VIDIOC_S_FMT, f);
 
@@ -256,8 +254,7 @@ static int empress_reqbufs(struct file *
 static int empress_reqbufs(struct file *file, void *priv,
 					struct v4l2_requestbuffers *p)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_reqbufs(&dev->empress_tsq, p);
 }
@@ -265,24 +262,21 @@ static int empress_querybuf(struct file 
 static int empress_querybuf(struct file *file, void *priv,
 					struct v4l2_buffer *b)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_querybuf(&dev->empress_tsq, b);
 }
 
 static int empress_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_qbuf(&dev->empress_tsq, b);
 }
 
 static int empress_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_dqbuf(&dev->empress_tsq, b,
 				file->f_flags & O_NONBLOCK);
@@ -291,8 +285,7 @@ static int empress_streamon(struct file 
 static int empress_streamon(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_streamon(&dev->empress_tsq);
 }
@@ -300,8 +293,7 @@ static int empress_streamoff(struct file
 static int empress_streamoff(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_streamoff(&dev->empress_tsq);
 }
@@ -309,8 +301,7 @@ static int empress_s_ext_ctrls(struct fi
 static int empress_s_ext_ctrls(struct file *file, void *priv,
 			       struct v4l2_ext_controls *ctrls)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	/* count == 0 is abused in saa6752hs.c, so that special
 		case is handled here explicitly. */
@@ -329,8 +320,7 @@ static int empress_g_ext_ctrls(struct fi
 static int empress_g_ext_ctrls(struct file *file, void *priv,
 			       struct v4l2_ext_controls *ctrls)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
 		return -EINVAL;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

P.S. data from /dev/video1 is not correct :(( .

With my best regards, Dmitry.

--MP_/N2Zq76NT.2h6_DogzOwwbz0
Content-Type: text/x-patch; name=beholder_empress_03.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=beholder_empress_03.diff

diff -r ca65777314d2 linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Mon Jun 09 11:59:05 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Tue Jun 10 20:34:22 2008 +1000
@@ -227,8 +227,7 @@ static int empress_g_fmt_vid_cap(struct 
 static int empress_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	saa7134_i2c_call_clients(dev, VIDIOC_G_FMT, f);
 
@@ -241,8 +240,7 @@ static int empress_s_fmt_vid_cap(struct 
 static int empress_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	saa7134_i2c_call_clients(dev, VIDIOC_S_FMT, f);
 
@@ -256,8 +254,7 @@ static int empress_reqbufs(struct file *
 static int empress_reqbufs(struct file *file, void *priv,
 					struct v4l2_requestbuffers *p)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_reqbufs(&dev->empress_tsq, p);
 }
@@ -265,24 +262,21 @@ static int empress_querybuf(struct file 
 static int empress_querybuf(struct file *file, void *priv,
 					struct v4l2_buffer *b)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_querybuf(&dev->empress_tsq, b);
 }
 
 static int empress_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_qbuf(&dev->empress_tsq, b);
 }
 
 static int empress_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_dqbuf(&dev->empress_tsq, b,
 				file->f_flags & O_NONBLOCK);
@@ -291,8 +285,7 @@ static int empress_streamon(struct file 
 static int empress_streamon(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_streamon(&dev->empress_tsq);
 }
@@ -300,8 +293,7 @@ static int empress_streamoff(struct file
 static int empress_streamoff(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	return videobuf_streamoff(&dev->empress_tsq);
 }
@@ -309,8 +301,7 @@ static int empress_s_ext_ctrls(struct fi
 static int empress_s_ext_ctrls(struct file *file, void *priv,
 			       struct v4l2_ext_controls *ctrls)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	/* count == 0 is abused in saa6752hs.c, so that special
 		case is handled here explicitly. */
@@ -329,8 +320,7 @@ static int empress_g_ext_ctrls(struct fi
 static int empress_g_ext_ctrls(struct file *file, void *priv,
 			       struct v4l2_ext_controls *ctrls)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = file->private_data;
 
 	if (ctrls->ctrl_class != V4L2_CTRL_CLASS_MPEG)
 		return -EINVAL;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/N2Zq76NT.2h6_DogzOwwbz0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--MP_/N2Zq76NT.2h6_DogzOwwbz0--
