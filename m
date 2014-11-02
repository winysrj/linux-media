Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53213 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751752AbaKBW5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Nov 2014 17:57:14 -0500
Date: Mon, 3 Nov 2014 00:57:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
Message-ID: <20141102225704.GM3136@valkosipuli.retiisi.org.uk>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Grazvydas,

On Sun, Nov 02, 2014 at 04:03:55AM +0200, Grazvydas Ignotas wrote:
> There is periodic stutter (seen in vlc, for example) since 3.9 where
> the stream stops for around half a second every 3-5 seconds or so.
> Bisecting points to 1b18e7a0be859911b22138ce27258687efc528b8 "v4l:
> Tell user space we're using monotonic timestamps". I've verified the
> problem is there on stock Ubuntu 14.04 kernel, 3.16.7 from kernel.org
> and when using media_build.git . The commit does not revert on newer
> kernels as that code changed, but checking out a commit before the one
> mentioned gives properly working kernel.
> 
> I'm using Logitech C920 which can do h264 compression and playing the
> video using vlc:
> cvlc v4l2:///dev/video0:chroma=h264:width=1280:height=720

I've got Logitech C270 here but I can't reproduce the problem. The frame
rate with the above command is really low, around 5. With a smaller
resolution it works quite smoothly. The reason might be that the pixel
format is still YUYV. The other option appears to be MJPG.

My vlc is of version 2.0.3 (Debian). Which one do you have, and does it use
libv4l2?

Have you tried with a different application to see if the problem persists?
If the cause of the stutter you described is this patch, it might be how
the information the flag provides is used in the user space.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
