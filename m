Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42261 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbZKJU0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 15:26:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Philipp Wiesner" <p.wiesner@gmx.net>
Subject: Re: soc_camera, v4l2 api, gstreamer: setting errno ?
Date: Tue, 10 Nov 2009 21:27:00 +0100
Cc: linux-media@vger.kernel.org
References: <20091110161318.44980@gmx.net>
In-Reply-To: <20091110161318.44980@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911102127.00348.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tuesday 10 November 2009 17:13:18 Philipp Wiesner wrote:
> I'm having some trouble using gstreamer with soc_camera and am a
> modified tw9910 driver. I had difficulties compiling the latest sources
> for my target so I'm using old kernel and gstreamer versions. But my
> question may still be valid, because the problem doesn't seem to be fixed
> and this may be interesting for driver programming in the future.
> 
> The part I'm suspecting is
> 
>   if (v4l2_ioctl (fd, VIDIOC_S_FMT, &format) < 0) {
>     if (errno != EINVAL)
>       goto set_fmt_failed;
> 
> [v4l2src_calls.c,1223]
> According to V4L2 api documentation drivers should set errno, but all
>  drivers I've seen in the soc_camera framework (including soc_camera.c)
>  only 'return -errno'. Should device drivers (like tw9910) set errno or
>  should soc_camera use return values and set errno? Is it correct that none
>  of them happens at the moment?

errno is a userspace variable. Kernel drivers return a negative error code 
which is stored into errno by the ioctl() function in glibc.

-- 
Regards,

Laurent Pinchart
