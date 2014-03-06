Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:64638 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaCFMKR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 07:10:17 -0500
Received: by mail-ig0-f173.google.com with SMTP id t19so8120344igi.0
        for <linux-media@vger.kernel.org>; Thu, 06 Mar 2014 04:10:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5317ACAC.8000008@williammanley.net>
References: <5317ACAC.8000008@williammanley.net>
From: Paulo Assis <pj.assis@gmail.com>
Date: Thu, 6 Mar 2014 12:09:56 +0000
Message-ID: <CAPueXH7UaScMA2S1r77oR+5p=MCxQEx3P0c2bhxS+8weqdVUBQ@mail.gmail.com>
Subject: Re: uvcvideo: logitech C920 resets controls during VIDIOC_STREAMON
To: William Manley <will@williammanley.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2014-03-05 23:01 GMT+00:00 William Manley <will@williammanley.net>:
> Hi All
>
> I've been attempting to use the Logitech C920 with the uvcvideo driver.
>  I set the controls with v4l2-ctl but some of them change during
> VIDIOC_STREAMON.  My understanding is that the values of controls should
> be preserved.
>
> Minimal test case:
>
>     #include <linux/videodev2.h>
>     #include <stdio.h>
>     #include <stdlib.h>
>     #include <fcntl.h>
>     #include <errno.h>
>     #include <string.h>
>     #include <unistd.h>
>     #include <sys/ioctl.h>
>
>     #define DEVICE "/dev/video2"
>
>     int main()
>     {
>             int fd, type;
>
>             fd = open(DEVICE, O_RDWR | O_CLOEXEC);
>             if (fd < 0) {
>                     perror("Failed to open " DEVICE "\n");
>                     return 1;
>             }
>
>             struct v4l2_requestbuffers reqbuf = {
>                     .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
>                     .memory = V4L2_MEMORY_MMAP,
>                     .count = 1,
>             };
>
>             if (-1 == ioctl (fd, VIDIOC_REQBUFS, &reqbuf)) {
>                     perror("VIDIOC_REQBUFS");
>                     return 1;
>             }
>
>             system("v4l2-ctl -d" DEVICE " -l | grep exposure_absolute");
>
>             type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>             if (ioctl (fd, VIDIOC_STREAMON, &type) != 0) {
>                     perror("VIDIOC_STREAMON");
>                     return 1;
>             }
>
>             printf("VIDIOC_STREAMON\n");
>
>             usleep(100000);
>             system("v4l2-ctl -d" DEVICE " -l | grep exposure_absolute");
>
>             return 0;
>     }
>
> None of the other controls seem to be affected.  Note: to get the C920
> to report exposure_absolute correctly I also had to make this change to
> the uvcvideo kernel driver:
>
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c
> index a2f4501..e7c805b 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -227,7 +227,8 @@ static struct uvc_control_info uvc_ctrls[] = {
>                 .size           = 4,
>                 .flags          = UVC_CTRL_FLAG_SET_CUR
>                                 | UVC_CTRL_FLAG_GET_RANGE
> -                               | UVC_CTRL_FLAG_RESTORE,
> +                               | UVC_CTRL_FLAG_RESTORE
> +                               | UVC_CTRL_FLAG_AUTO_UPDATE,
>         },
>         {
>                 .entity         = UVC_GUID_UVC_CAMERA,
>
>
> The variables seem to be changed when the URBs are Submitted.  To
> investigate I made the following change to the uvc driver:
>
>
> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c
> index 3394c34..f2f66f6 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1649,17 +1649,23 @@ static int uvc_init_video(struct uvc_streaming
> *stream, gfp_t gfp_flags)
>         if (ret < 0)
>                 return ret;
>
> +       /* No effect: */
> +       uvc_ctrl_resume_device(stream->dev);
> +
>         /* Submit the URBs. */
>         for (i = 0; i < UVC_URBS; ++i) {
>                 ret = usb_submit_urb(stream->urb[i], gfp_flags);
>                 if (ret < 0) {
>                         uvc_printk(KERN_ERR, "Failed to submit URB %u "
>                                         "(%d).\n", i, ret);
>                         uvc_uninit_video(stream, 1);
>                         return ret;
>                 }
>         }
>
> +       /* "Fixes" the issue: */
> +       uvc_ctrl_resume_device(stream->dev);
> +
>         return 0;
>  }
>
>
> At this point the backtrace looks something like:
>
>     uvc_init_video
>     uvc_video_enable
>     uvc_v4l2_do_ioctl (in the case VIDIOC_STREAMON:)
>
> The call to uvc_ctrl_resume_device() has the effect that the v4l2 ctrls
> which are cached in the kernel get resubmitted to the camera as if it
> were coming out of suspend/resume.
>
> I've looked at the wireshark capture of USB traffic and I can't find
> anywhere where the host causes exposure_auto to change.  The camera does
> have a mode where it would change by itself but that is disabled
> (exposure_auto=1).

This alone doesn't guarantee that exposure absolute is untouched.
To do so you need to set V4L2_CID_EXPOSURE_AUTO_PRIORITY to 0 and
V4L2_CID_EXPOSURE_AUTO to V4L2_EXPOSURE_MANUAL

> I've uploaded the wireshark trace to:
>
> http://williammanley.net/usb-wireshark-streamon.pcapng
>
> I'm guessing that this is a hardware bug.  One fix would be modify the
> driver to save all values at the beginning of STREAMON and then restore
> them at the end.  What do you think?
>
> Thanks
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,
Paulo
