Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9LX9H9002825
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:33:09 -0500
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9LWtCL013700
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:32:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Brandon Jenkins" <bcjenkins@tvwhere.com>
Date: Tue, 9 Dec 2008 22:32:52 +0100
References: <15114.62.70.2.252.1228832086.squirrel@webmail.xs4all.nl>
	<200812091918.00276.hverkuil@xs4all.nl>
	<de8cad4d0812091318h348d4417lef4e98dc9593445e@mail.gmail.com>
In-Reply-To: <de8cad4d0812091318h348d4417lef4e98dc9593445e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EQuPJXp9qDGVFfg"
Message-Id: <200812092232.52716.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2-compat-ioctl32 update?
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

--Boundary-00=_EQuPJXp9qDGVFfg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 09 December 2008 22:18:28 Brandon Jenkins wrote:
> Hi Hans,
>
> Received the following during compilation:
>
> CC [M]  /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.o
> /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c: In function
> 'put_v4l2_ext_controls32':
> /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c:615: error: 'kcontrols'
> undeclared (first use in this function)
> /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c:615: error: (Each
> undeclared identifier is reported only once
> /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c:615: error: for each
> function it appears in.)
> make[3]: *** [/root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.o] Error 1
> make[2]: *** [_module_/root/drivers/hdpvr/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-2.6.27-ARCH'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/root/drivers/hdpvr/v4l'
> make: *** [all] Error 2

Hmm, note to self: must compile this on a 64-bit CPU :-)

Try the attached patch, this time it should compile.

	Hans

>
> Brandon
>
> On Tue, Dec 9, 2008 at 1:18 PM, Hans Verkuil <hverkuil@xs4all.nl> 
wrote:
> > On Tuesday 09 December 2008 15:14:46 Hans Verkuil wrote:
> >> OK, I'll mail you a diff this evening. In the meantime, can you
> >> compile v4l2-ctl for 32-bit? That's the test tool for several of
> >> my tests.
> >
> > Hi Brandon,
> >
> > As promised I've attached the diff with my current changes.
> >
> > You should be able to test it fairly well with v4l2-ctl. In
> > particular, please test getting and setting controls (MPEG controls
> > use S_EXT_CTRLS while user controls use the older VIDIOC_S_CTRL
> > ioctl).
> >
> > Also try --get-audio-input, --list-audio-inputs, --get-cropcap,
> > --get-input, --set-input and --list-inputs.
> >
> > Basically test as many ioctls as you can :-) And of course with
> > sagetv!
> >
> > Thanks,
> >
> >        Hans
> >
> >> Regards,
> >>
> >>        Hans
> >>
> >> > Hans,
> >> >
> >> > I would love to test! I am using 3 HVR-1600s and an HD-PVR for
> >> > encoders.
> >> >
> >> > Brandon
> >> >
> >> > On Tue, Dec 9, 2008 at 9:03 AM, Hans Verkuil
> >> > <hverkuil@xs4all.nl>
> >
> > wrote:
> >> >> Hi Brandon,
> >> >>
> >> >> As you noticed I found suspicious code in the current source.
> >> >> At the moment I have no easy way of testing this, although I
> >> >> hope to be able to do that some time in the next week or the
> >> >> week after that.
> >> >>
> >> >> However, if you are able to do some testing for me, then that
> >> >> would be very welcome and definitely speed things up.
> >> >>
> >> >> I have a patch that I can mail you and a bunch of tests to
> >> >> perform.
> >> >>
> >> >> Let me know if you can help.
> >> >>
> >> >> Regards,
> >> >>
> >> >>        Hans
> >> >>
> >> >>> Hi Hans,
> >> >>>
> >> >>> I noted over the weekend that you were working on updating the
> >> >>> v4l2-compat-ioctl32 module, thank you! Do you have a sense of
> >> >>> timing for availability in your tree? I know of a few SageTV
> >> >>> users who will be glad to see it done. :)
> >> >>>
> >> >>> Thanks in advance,
> >> >>>
> >> >>> Brandon
> >> >>
> >> >> --
> >> >> Hans Verkuil - video4linux developer - sponsored by TANDBERG
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by TANDBERG



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--Boundary-00=_EQuPJXp9qDGVFfg
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="compat.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="compat.diff"

diff -r 6a9d064fe0ee linux/drivers/media/video/v4l2-compat-ioctl32.c
--- a/linux/drivers/media/video/v4l2-compat-ioctl32.c	Fri Dec 05 11:49:53 2008 -0200
+++ b/linux/drivers/media/video/v4l2-compat-ioctl32.c	Tue Dec 09 22:29:34 2008 +0100
@@ -540,6 +540,95 @@
 	return 0;
 }
 
+
+struct v4l2_ext_controls32 {
+       __u32 ctrl_class;
+       __u32 count;
+       __u32 error_idx;
+       __u32 reserved[2];
+       compat_caddr_t controls; /* actually struct v4l2_ext_control32 * */
+};
+
+static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
+{
+	struct v4l2_ext_control __user *ucontrols;
+	struct v4l2_ext_control __user *kcontrols;
+	int n;
+	compat_caddr_t p;
+
+	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_ext_controls32)) ||
+		get_user(kp->ctrl_class, &up->ctrl_class) ||
+		get_user(kp->count, &up->count) ||
+		get_user(kp->error_idx, &up->error_idx) ||
+		copy_from_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
+			return -EFAULT;
+	n = kp->count;
+	if (n == 0) {
+		kp->controls = NULL;
+		return 0;
+	}
+	if (get_user(p, &up->controls))
+		return -EFAULT;
+	ucontrols = compat_ptr(p);
+	if (!access_ok(VERIFY_READ, ucontrols, n * sizeof(struct v4l2_ext_control)))
+		return -EFAULT;
+	kcontrols = compat_alloc_user_space(n * sizeof(struct v4l2_ext_control));
+	kp->controls = kcontrols;
+	while (--n >= 0) {
+		if (copy_in_user(&kcontrols->id, &ucontrols->id, sizeof(__u32)))
+			return -EFAULT;
+		if (copy_in_user(&kcontrols->reserved2, &ucontrols->reserved2, sizeof(ucontrols->reserved2)))
+			return -EFAULT;
+		/* Note: if the void * part of the union ever becomes relevant
+		   then we need to know the type of the control in order to do
+		   the right thing here. Luckily, that is not yet an issue. */
+		if (copy_in_user(&kcontrols->value, &ucontrols->value, sizeof(ucontrols->value)))
+			return -EFAULT;
+		ucontrols++;
+		kcontrols++;
+	}
+	return 0;
+}
+
+static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext_controls32 __user *up)
+{
+	struct v4l2_ext_control __user *ucontrols;
+	struct v4l2_ext_control __user *kcontrols = kp->controls;
+	int n = kp->count;
+	compat_caddr_t p;
+
+	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_ext_controls32)) ||
+		put_user(kp->ctrl_class, &up->ctrl_class) ||
+		put_user(kp->count, &up->count) ||
+		put_user(kp->error_idx, &up->error_idx) ||
+		copy_to_user(up->reserved, kp->reserved, sizeof(up->reserved)))
+			return -EFAULT;
+	if (!kp->count)
+		return 0;
+
+	if (get_user(p, &up->controls))
+		return -EFAULT;
+	ucontrols = compat_ptr(p);
+	if (!access_ok(VERIFY_WRITE, ucontrols, n * sizeof(struct v4l2_ext_control)))
+		return -EFAULT;
+
+	while (--n >= 0) {
+		if (copy_in_user(&ucontrols->id, &kcontrols->id, sizeof(__u32)))
+			return -EFAULT;
+		if (copy_in_user(&ucontrols->reserved2, &kcontrols->reserved2,
+					sizeof(ucontrols->reserved2)))
+			return -EFAULT;
+		/* Note: if the void * part of the union ever becomes relevant
+		   then we need to know the type of the control in order to do
+		   the right thing here. Luckily, that is not yet an issue. */
+		if (copy_in_user(&ucontrols->value, &kcontrols->value, sizeof(ucontrols->value)))
+			return -EFAULT;
+		ucontrols++;
+		kcontrols++;
+	}
+	return 0;
+}
+
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 struct video_code32 {
 	char		loadwhat[16];	/* name or tag of file being passed */
@@ -588,6 +677,9 @@
 #define VIDIOC_G_INPUT32	_IOR  ('V', 38, compat_int_t)
 #define VIDIOC_S_INPUT32	_IOWR ('V', 39, compat_int_t)
 #define VIDIOC_TRY_FMT32      	_IOWR ('V', 64, struct v4l2_format32)
+#define VIDIOC_G_EXT_CTRLS32    _IOWR ('V', 71, struct v4l2_ext_controls32)
+#define VIDIOC_S_EXT_CTRLS32    _IOWR ('V', 72, struct v4l2_ext_controls32)
+#define VIDIOC_TRY_EXT_CTRLS32  _IOWR ('V', 73, struct v4l2_ext_controls32)
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 enum {
@@ -672,6 +764,7 @@
 		struct v4l2_standard v2s;
 		struct v4l2_input v2i;
 		struct v4l2_tuner v2t;
+		struct v4l2_ext_controls v2ecs;
 		unsigned long vx;
 	} karg;
 	void __user *up = compat_ptr(arg);
@@ -707,6 +800,9 @@
 	case VIDIOC_G_INPUT32: realcmd = cmd = VIDIOC_G_INPUT; break;
 	case VIDIOC_S_INPUT32: realcmd = cmd = VIDIOC_S_INPUT; break;
 	case VIDIOC_TRY_FMT32: realcmd = cmd = VIDIOC_TRY_FMT; break;
+	case VIDIOC_G_EXT_CTRLS32: realcmd = cmd = VIDIOC_G_EXT_CTRLS; break;
+	case VIDIOC_S_EXT_CTRLS32: realcmd = cmd = VIDIOC_S_EXT_CTRLS; break;
+	case VIDIOC_TRY_EXT_CTRLS32: realcmd = cmd = VIDIOC_TRY_EXT_CTRLS; break;
 	};
 
 	switch (cmd) {
@@ -800,9 +896,16 @@
 		compatible_arg = 0;
 		break;
 #endif
-	};
+
+	case VIDIOC_G_EXT_CTRLS:
+	case VIDIOC_S_EXT_CTRLS:
+	case VIDIOC_TRY_EXT_CTRLS:
+		err = get_v4l2_ext_controls32(&karg.v2ecs, up);
+		compatible_arg = 0;
+		break;
+	}
 	if (err)
-		goto out;
+		return err;
 
 	if (compatible_arg)
 		err = native_ioctl(file, realcmd, (unsigned long)up);
@@ -813,73 +916,78 @@
 		err = native_ioctl(file, realcmd, (unsigned long)&karg);
 		set_fs(old_fs);
 	}
-	if (err == 0) {
-		switch (cmd) {
+	if (err)
+		return err;
+	switch (cmd) {
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
-		case VIDIOCGTUNER:
-			err = put_video_tuner32(&karg.vt, up);
-			break;
+	case VIDIOCGTUNER:
+		err = put_video_tuner32(&karg.vt, up);
+		break;
 
-		case VIDIOCGWIN:
-			err = put_video_window32(&karg.vw, up);
-			break;
+	case VIDIOCGWIN:
+		err = put_video_window32(&karg.vw, up);
+		break;
 
-		case VIDIOCGFBUF:
-			err = put_video_buffer32(&karg.vb, up);
-			break;
+	case VIDIOCGFBUF:
+		err = put_video_buffer32(&karg.vb, up);
+		break;
 #if 0 /*FIXME*/
-		case VIDIOCGAUDIO:
-			err = put_video_audio32(&karg.va, up);
-			break;
+	case VIDIOCGAUDIO:
+		err = put_video_audio32(&karg.va, up);
+		break;
 #endif
 
 #endif
-		case VIDIOC_G_FBUF:
-			err = put_v4l2_framebuffer32(&karg.v2fb, up);
-			break;
+	case VIDIOC_G_FBUF:
+		err = put_v4l2_framebuffer32(&karg.v2fb, up);
+		break;
 
-		case VIDIOC_G_FMT:
-		case VIDIOC_S_FMT:
-		case VIDIOC_TRY_FMT:
-			err = put_v4l2_format32(&karg.v2f, up);
-			break;
+	case VIDIOC_G_FMT:
+	case VIDIOC_S_FMT:
+	case VIDIOC_TRY_FMT:
+		err = put_v4l2_format32(&karg.v2f, up);
+		break;
 
-		case VIDIOC_QUERYBUF:
-		case VIDIOC_QBUF:
-		case VIDIOC_DQBUF:
-			err = put_v4l2_buffer32(&karg.v2b, up);
-			break;
+	case VIDIOC_QUERYBUF:
+	case VIDIOC_QBUF:
+	case VIDIOC_DQBUF:
+		err = put_v4l2_buffer32(&karg.v2b, up);
+		break;
 
-		case VIDIOC_ENUMSTD:
-			err = put_v4l2_standard(&karg.v2s, up);
-			break;
+	case VIDIOC_ENUMSTD:
+		err = put_v4l2_standard(&karg.v2s, up);
+		break;
 
-		case VIDIOC_ENUMSTD32:
-			err = put_v4l2_standard32(&karg.v2s, up);
-			break;
+	case VIDIOC_ENUMSTD32:
+		err = put_v4l2_standard32(&karg.v2s, up);
+		break;
 
-		case VIDIOC_G_TUNER:
-		case VIDIOC_S_TUNER:
-			err = put_v4l2_tuner(&karg.v2t, up);
-			break;
+	case VIDIOC_G_TUNER:
+	case VIDIOC_S_TUNER:
+		err = put_v4l2_tuner(&karg.v2t, up);
+		break;
 
-		case VIDIOC_ENUMINPUT:
-			err = put_v4l2_input(&karg.v2i, up);
-			break;
+	case VIDIOC_ENUMINPUT:
+		err = put_v4l2_input(&karg.v2i, up);
+		break;
 
-		case VIDIOC_ENUMINPUT32:
-			err = put_v4l2_input32(&karg.v2i, up);
-			break;
+	case VIDIOC_ENUMINPUT32:
+		err = put_v4l2_input32(&karg.v2i, up);
+		break;
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
-		case VIDIOCGFREQ:
+	case VIDIOCGFREQ:
 #endif
-		case VIDIOC_G_INPUT:
-			err = put_user(((u32)karg.vx), (u32 __user *)up);
-			break;
-		};
+	case VIDIOC_G_INPUT:
+		err = put_user(((u32)karg.vx), (u32 __user *)up);
+		break;
+
+	case VIDIOC_G_EXT_CTRLS:
+	case VIDIOC_S_EXT_CTRLS:
+	case VIDIOC_TRY_EXT_CTRLS:
+		err = put_v4l2_ext_controls32(&karg.v2ecs, up);
+		break;
 	}
-out:
 	return err;
 }
 
@@ -944,6 +1052,13 @@
 	case VIDIOC_S_HW_FREQ_SEEK:
 	case VIDIOC_ENUM_FRAMESIZES:
 	case VIDIOC_ENUM_FRAMEINTERVALS:
+ 	case VIDIOC_ENCODER_CMD:
+ 	case VIDIOC_TRY_ENCODER_CMD:
+ 	case VIDIOC_G_AUDIO:
+ 	case VIDIOC_S_AUDIO:
+ 	case VIDIOC_S_EXT_CTRLS32:
+ 	case VIDIOC_G_EXT_CTRLS32:
+ 	case VIDIOC_TRY_EXT_CTRLS32:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 

--Boundary-00=_EQuPJXp9qDGVFfg
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_EQuPJXp9qDGVFfg--
