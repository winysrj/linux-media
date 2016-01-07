Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35473 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbcAGRbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2016 12:31:15 -0500
Received: by mail-ig0-f180.google.com with SMTP id t15so33569367igr.0
        for <linux-media@vger.kernel.org>; Thu, 07 Jan 2016 09:31:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ2oMh+kHdnMkK-Fua+KSja3YDPHPC6GKbFE2vtVjAYo8T9_Qg@mail.gmail.com>
References: <CAJ2oMh+kHdnMkK-Fua+KSja3YDPHPC6GKbFE2vtVjAYo8T9_Qg@mail.gmail.com>
Date: Thu, 7 Jan 2016 19:31:14 +0200
Message-ID: <CAJ2oMh+zA5gBt1Q67agXq_0QPJFJK9WO2XhYf7C638mXJt=wjQ@mail.gmail.com>
Subject: Fwd: Vivi - Capturing HD video
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am trying to test v4l application with vivi. I tried several
resolution, pixelformat, different inputs,
but on trying to display the captured file, it always has a sync ( the
bars are moving in the horizontal axis).
I tried to change resolution, pixelformat, in both capture application
or player , but nothing helps.
This is what I did:
I use the v4l2 API example AS-IS, with minor modification in the
--force, so that I choose hd input (number 3), and 1920x1080
resolution, V4L2_PIX_FMT_YUV420 , progressive.

      if (force_format) {
                input = 3;
                if (-1==xioctl(fd,VIDIOC_S_INPUT,&input))
                {
                 errno_exit("VIDIOC_S_INPUT");
                }
                fmt.fmt.pix.width       = 1920;
                fmt.fmt.pix.height      = 1080;
                fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420; // <<-
tried also V4L2_PIX_FMT_YUV422P
                fmt.fmt.pix.field       = V4L2_FIELD_NONE; // <-
trying to capture progressive

                if (-1 == xioctl(fd, VIDIOC_S_FMT, &fmt))
                        errno_exit("VIDIOC_S_FMT");

        } else {

I run the application with:
./video_test -f -o -c 10  >
cap_vivi_1920_1080_yuv420p_progressive_hd_input.yuv (for
fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420 trial )
And
./video_test -f -o -c 10  >
cap_vivi_1920_1080_yuv422p_progressive_hd_input.yuv (for
fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P trial )

I've tried to play them with:
ffplay -f rawvideo -pixel_format yuv420p -video_size 1920x1080 -i
cap_vivi_1920_1080_yuv420p_progressive_hd_input.yuv (for
fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420 trial )
And
ffplay -f rawvideo -pixel_format yuv422p -video_size 1920x1080 -i
cap_vivi_1920_1080_yuv422p_progressive_hd_input.yuv (for
fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV422P trial )


The video files are here:
https://drive.google.com/folderview?id=0B22GsWueReZTUS1tSHBraTAyZ00&usp=sharing

I probably am doing something wrong.
Is there any idea what's wrong in my configurations or how I can debug
it better ?

Thank you very much,
Ran
