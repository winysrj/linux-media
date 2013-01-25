Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51953 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab3AYKWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 05:22:12 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH60054DFCODN30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jan 2013 10:22:09 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MH600459FGOYM10@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jan 2013 10:22:09 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	hverkuil@xs4all.nl, verkuil@xs4all.nl,
	Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com,
	'Kyungmin Park' <kyungmin.park@samsung.com>
References: <1359030907-9883-1-git-send-email-k.debski@samsung.com>
 <1359030907-9883-4-git-send-email-k.debski@samsung.com>
 <1751468.SnZ1UQG0Bu@avalon>
 <04b801cdfa47$e0414b90$a0c3e2b0$%debski@samsung.com>
 <20130124191202.GE18639@valkosipuli.retiisi.org.uk>
In-reply-to: <20130124191202.GE18639@valkosipuli.retiisi.org.uk>
Subject: RE: [PATCH 3/3 v2] v4l: Set proper timestamp type in selected drivers
 which use videobuf2
Date: Fri, 25 Jan 2013 11:21:58 +0100
Message-id: <04fd01cdfae5$d0afa840$720ef8c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Thursday, January 24, 2013 8:12 PM
> 

[snip]

> > >
> > > Do you have a list of those other drivers using vb2 that will
> report
> > > an unknown timestamp type ?
> >
> > Here are the drivers:
> >
> > drivers/media/platform/coda.c
> > drivers/media/platform/exynos-gsc/gsc-m2m.c
> > drivers/media/platform/m2m-deinterlace.c
> > drivers/media/platform/marvell-ccic/mcam-core.c
> > drivers/media/platform/mem2mem_testdev.c
> > drivers/media/platform/mx2_emmaprp.c
> > drivers/media/platform/s5p-fimc/fimc-m2m.c
> > drivers/media/platform/s5p-g2d/g2d.c
> > drivers/media/platform/s5p-jpeg/jpeg-core.c
> > drivers/media/platform/s5p-tv/mixer_video.c
> >
> > These drivers do not fill the timestamp field at all.
> 
> I wonder what should we do to those. Based on a quick look, only mcam-
> core.c and s5p-tv/mixer_video.c seem not to be mem-to-mem devices. So
> the rest should be COPY, I presume. At least the one I checked seem to
> have 1:1 ratio between output and capture buffers.
> 
> I know you didn't break them; they were already broken... But I don't
> think it'd be that big task to fix them either. Now that your patchset
> introduces the COPY timestamp it'd be nice to see it being properly
> used, rather than letting applications see lots of UNKNOWN timestamps
> again. Do you think you could have time for that?

I agree that they should fixed by adding proper timestamp handling (copy).
Currently I have other tasks to do, I might find some time next week to
write the patch. I think that the fix for these drivers can be separate to
this patch set.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center



