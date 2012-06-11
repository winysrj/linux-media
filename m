Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45113 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2FKHut (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 03:50:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.6] V4L2 API cleanups
Date: Mon, 11 Jun 2012 09:50:54 +0200
Message-ID: <6836133.PoLuVdfeXV@avalon>
In-Reply-To: <4FD50223.4030501@iki.fi>
References: <4FD50223.4030501@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 10 June 2012 23:22:59 Sakari Ailus wrote:
> Hi Mauro,
> 
> Here are two V4L2 API cleanup patches; the first removes __user from
> videodev2.h from a few places, making it possible to use the header file
> as such in user space, while the second one changes the
> v4l2_buffer.input field back to reserved.
> 
> 
> The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:
> 
>   [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
> 09:27:24 -0300)
> 
> are available in the git repository at:
>   ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.6
> 
> Sakari Ailus (2):
>       v4l: Remove __user from interface structure definitions

NAK, sorry.

__user has a purpose, we need to add it where it's missing, not remove it 
where it's rightfully present.

>       v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
> 
>  Documentation/DocBook/media/v4l/compat.xml      |   12 ++++++++++++
>  Documentation/DocBook/media/v4l/io.xml          |   19 +++++--------------
>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml |    9 +++------
>  drivers/media/video/cpia2/cpia2_v4l.c           |    2 +-
>  drivers/media/video/v4l2-compat-ioctl32.c       |   11 +++++------
>  drivers/media/video/videobuf-core.c             |   16 ----------------
>  drivers/media/video/videobuf2-core.c            |    5 ++---
>  include/linux/videodev2.h                       |    9 ++++-----
>  8 files changed, 32 insertions(+), 51 deletions(-)
> 
> 
> Kind regards,

-- 
Regards,

Laurent Pinchart

