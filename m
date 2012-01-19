Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58612 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2ASMu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 07:50:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH] Adding YUV input support for OMAP3ISP driver
Date: Thu, 19 Jan 2012 13:50:51 +0100
Cc: linux-media@vger.kernel.org
References: <EBE38CF866F2F94F95FA9A8CB3EF2284069CAE@singex1.aptina.com> <201201171633.50619.laurent.pinchart@ideasonboard.com> <4F180F95.7050003@mlbassoc.com>
In-Reply-To: <4F180F95.7050003@mlbassoc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201191350.51761.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Thursday 19 January 2012 13:41:57 Gary Thomas wrote:
> On 2012-01-17 08:33, Laurent Pinchart wrote:
>     <snip>
> 
> > I already had a couple of YUV support patches in my OMAP3 ISP tree at
> > git.kernel.org. I've rebased them on top of the lastest V4L/DVB tree and
> > pushed them to
> > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp-
> > omap3isp-yuv. Could you please try them, and see if they're usable with
> > your sensor ?
> 
> I just tried this kernel with my board.  The media control infrastructure
> comes up and all of the devices are created, but I can't access them.
> 
>  From the bootup log:
>    Linux media interface: v0.10
>    Linux video capture interface: v2.00

Any message from the omap3isp driver and from the sensor driver ?

> When I try to access the devices:
>    root@cobra3530p73:~# media-ctl -p
>    Opening media device /dev/media0
>    media_open_debug: Can't open media device /dev/media0
>    Failed to open /dev/media0

Could you please strace that ?

> The devices look OK to me:
>    root@cobra3530p73:~# ls -l /dev/v*  /dev/med*
>    crw------- 1 root root 252, 0 Nov  8 10:44 /dev/media0
>    crw-rw---- 1 root video 81,   7 Nov  8 10:44 /dev/v4l-subdev0
>    crw-rw---- 1 root video 81,   8 Nov  8 10:44 /dev/v4l-subdev1
>    crw-rw---- 1 root video 81,   9 Nov  8 10:44 /dev/v4l-subdev2
>    crw-rw---- 1 root video 81,  10 Nov  8 10:44 /dev/v4l-subdev3
>    crw-rw---- 1 root video 81,  11 Nov  8 10:44 /dev/v4l-subdev4
>    crw-rw---- 1 root video 81,  12 Nov  8 10:44 /dev/v4l-subdev5
>    crw-rw---- 1 root video 81,  13 Nov  8 10:44 /dev/v4l-subdev6
>    crw-rw---- 1 root video 81,  14 Nov  8 10:44 /dev/v4l-subdev7
>    crw-rw---- 1 root video 81,  15 Nov  8 10:44 /dev/v4l-subdev8
>    crw-rw---- 1 root tty    7,   0 Nov  8 10:44 /dev/vcs
>    crw-rw---- 1 root tty    7,   1 Nov  8 10:44 /dev/vcs1
>    crw-rw---- 1 root tty    7, 128 Nov  8 10:44 /dev/vcsa
>    crw-rw---- 1 root tty    7, 129 Nov  8 10:44 /dev/vcsa1
>    crw-rw---- 1 root video 81,   0 Nov  8 10:44 /dev/video0
>    crw-rw---- 1 root video 81,   1 Nov  8 10:44 /dev/video1
>    crw-rw---- 1 root video 81,   2 Nov  8 10:44 /dev/video2
>    crw-rw---- 1 root video 81,   3 Nov  8 10:44 /dev/video3
>    crw-rw---- 1 root video 81,   4 Nov  8 10:44 /dev/video4
>    crw-rw---- 1 root video 81,   5 Nov  8 10:44 /dev/video5
>    crw-rw---- 1 root video 81,   6 Nov  8 10:44 /dev/video6

Have the device nodes have been created manually ?

-- 
Regards,

Laurent Pinchart
