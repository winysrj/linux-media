Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:57345 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221Ab2EVLFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 07:05:04 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	"Taneja, Archit" <archit@ti.com>
Subject: RE: Warning in omap_vout.c
Date: Tue, 22 May 2012 11:04:59 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EA2F4FA@DBDE01.ent.ti.com>
References: <201205221124.45834.hverkuil@xs4all.nl>
In-Reply-To: <201205221124.45834.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 22, 2012 at 14:54:45, Hans Verkuil wrote:
> (Repost, this time without using HTML. My mailer switches to HTML once in a while
> for no reason. Very annoying.)
> 
> The daily build has this warning:
> 
> v4l-dvb-git/drivers/media/video/omap/omap_vout.c: In function 'omapvid_init':
> v4l-dvb-git/drivers/media/video/omap/omap_vout.c:381:17: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]
> v4l-dvb-git/drivers/media/video/omap/omap_vout.c:331:23: note: 'mode' was declared here
> 
> Can someone check this?
> 
> The problem is that video_mode_to_dss_mode() has a 'case 0:' that never sets
> the mode. I suspect that the case 0 can be removed so that it goes to the
> default case.
> 
> Can someone verify this?
> 


Thanks Hans for bringing my attention to this. I had submitted patch 
sometime back, then after couldn't able to follow up on it.

http://markmail.org/thread/uuv4szdy47bjgzvh

I will check on this.

Thanks,
Vaibhav

