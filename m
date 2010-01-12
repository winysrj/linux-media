Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway02.websitewelcome.com ([69.56.176.20]:45092 "HELO
	gateway02.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752256Ab0AMBdQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2010 20:33:16 -0500
Subject: Re: go7007 driver -- which program you use for capture
From: Pete Eberlein <pete@sensoray.com>
To: TJ <one.timothy.jones@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4B47828B.9050000@gmail.com>
References: <4B47828B.9050000@gmail.com>
Content-Type: text/plain
Date: Tue, 12 Jan 2010 15:46:27 -0800
Message-Id: <1263339987.4697.36.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-01-08 at 14:07 -0500, TJ wrote:
> Pete and anybody else out there with go7007 devices, what do you use for capture?

I used a modified capture.c, based on
http://v4l2spec.bytesex.org/v4l2spec/capture.c 

In the init_device(void) function, use:

        fmt.type                = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	switch (G_size) {
	case 0:
		fmt.fmt.pix.height = 640;
		fmt.fmt.pix.width = 480;
		break;
	case 1:
		fmt.fmt.pix.height = 320;
		fmt.fmt.pix.width = 240;
		break;
	}
	switch (type) {
	case TYPE_MJPEG:
		printf("MJPEG\n");
	  fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_MJPEG;
	  break;
	case TYPE_MPEG1:
	case TYPE_MPEG2:
	case TYPE_MPEG4:
	  fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_MPEG;
	  break;
	}

        fmt.fmt.pix.field       = V4L2_FIELD_ANY;

        if (-1 == xioctl (fd, VIDIOC_S_FMT, &fmt))
                errno_exit ("VIDIOC_S_FMT");

        /* Note VIDIOC_S_FMT may change width and height. */

	/* Buggy driver paranoia. */
	min = fmt.fmt.pix.width * 2;
	if (fmt.fmt.pix.bytesperline < min)
		fmt.fmt.pix.bytesperline = min;
	min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
	if (fmt.fmt.pix.sizeimage < min)
		fmt.fmt.pix.sizeimage = min;

	/* optional MPEG parameters */
	if( type != TYPE_MJPEG) {
		struct v4l2_control ctrl;
		
		ctrl.id = V4L2_CID_MPEG_VIDEO_ENCODING;
		switch (type) {
		case TYPE_MPEG1:
			ctrl.value = V4L2_MPEG_VIDEO_ENCODING_MPEG_1;
			break;
		case TYPE_MPEG2:
			ctrl.value = V4L2_MPEG_VIDEO_ENCODING_MPEG_2;
			break;
		case TYPE_MPEG4:
			ctrl.value = V4L2_MPEG_VIDEO_ENCODING_MPEG_4_SP;
			break;
		}

		if (0 != xioctl (fd, VIDIOC_S_CTRL, &ctrl)) {
			printf("could not set video encoding\n");
		}

		ctrl.id = V4L2_CID_MPEG_VIDEO_BITRATE;
		ctrl.value = G_br;
		if (0 != xioctl (fd, VIDIOC_S_CTRL, &ctrl)) {
			printf("could not change bitrate\n");
		}
	}

> Without GO7007 ioctls, I was only able to get vlc to capture in MJPEG format.

Does VLC try to change video parameters after starting the stream?  The
driver currently doesn't allow that.  I think I've seen xawtv try to do
that too.

Pete



