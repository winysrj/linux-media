Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50646 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755275Ab3AXTMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 14:12:08 -0500
Date: Thu, 24 Jan 2013 21:12:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	hverkuil@xs4all.nl, verkuil@xs4all.nl,
	Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com,
	'Kyungmin Park' <kyungmin.park@samsung.com>
Subject: Re: [PATCH 3/3 v2] v4l: Set proper timestamp type in selected
 drivers which use videobuf2
Message-ID: <20130124191202.GE18639@valkosipuli.retiisi.org.uk>
References: <1359030907-9883-1-git-send-email-k.debski@samsung.com>
 <1359030907-9883-4-git-send-email-k.debski@samsung.com>
 <1751468.SnZ1UQG0Bu@avalon>
 <04b801cdfa47$e0414b90$a0c3e2b0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04b801cdfa47$e0414b90$a0c3e2b0$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Thu, Jan 24, 2013 at 04:31:26PM +0100, Kamil Debski wrote:
> Hi,
> 
> > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > Sent: Thursday, January 24, 2013 1:51 PM
> > 
> > Hi Kamil,
> > 
> > Thanks for the patch.
> > 
> > On Thursday 24 January 2013 13:35:07 Kamil Debski wrote:
> > > Set proper timestamp type in drivers that I am sure that use either
> > > MONOTONIC or COPY timestamps. Other drivers will correctly report
> > > UNKNOWN timestamp type instead of assuming that all drivers use
> > > monotonic timestamps.
> > 
> > I've replied to 2/3 before seeing this patch, sorry (although the reply
> > is still valid from a bisection point of view).
> 
> Ok, it might be a good idea to squash these two patches.
> 
> > 
> > Do you have a list of those other drivers using vb2 that will report an
> > unknown timestamp type ?
> 
> Here are the drivers:
> 
> drivers/media/platform/coda.c
> drivers/media/platform/exynos-gsc/gsc-m2m.c
> drivers/media/platform/m2m-deinterlace.c
> drivers/media/platform/marvell-ccic/mcam-core.c
> drivers/media/platform/mem2mem_testdev.c
> drivers/media/platform/mx2_emmaprp.c
> drivers/media/platform/s5p-fimc/fimc-m2m.c
> drivers/media/platform/s5p-g2d/g2d.c
> drivers/media/platform/s5p-jpeg/jpeg-core.c
> drivers/media/platform/s5p-tv/mixer_video.c
> 
> These drivers do not fill the timestamp field at all.

I wonder what should we do to those. Based on a quick look, only mcam-core.c
and s5p-tv/mixer_video.c seem not to be mem-to-mem devices. So the rest
should be COPY, I presume. At least the one I checked seem to have 1:1 ratio
between output and capture buffers.

I know you didn't break them; they were already broken... But I don't think
it'd be that big task to fix them either. Now that your patchset introduces
the COPY timestamp it'd be nice to see it being properly used, rather than
letting applications see lots of UNKNOWN timestamps again. Do you think you
could have time for that?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
