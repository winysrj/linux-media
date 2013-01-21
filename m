Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34415 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3AUOIE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 09:08:04 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGZ00MAUB8H9H50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jan 2013 14:08:01 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MGZ00154B98NCA0@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jan 2013 14:08:01 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, kyungmin.park@samsung.com
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
 <1358156164-11382-4-git-send-email-k.debski@samsung.com>
 <20130119174329.GL13641@valkosipuli.retiisi.org.uk>
In-reply-to: <20130119174329.GL13641@valkosipuli.retiisi.org.uk>
Subject: RE: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers
 which use videobuf2
Date: Mon, 21 Jan 2013 15:07:55 +0100
Message-id: <029c01cdf7e0$b64ce4c0$22e6ae40$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Saturday, January 19, 2013 6:43 PM
> Hi Kamil,
> 
> Thanks for the patch.
> 
> On Mon, Jan 14, 2013 at 10:36:04AM +0100, Kamil Debski wrote:
> > Set proper timestamp type in drivers that I am sure that use either
> > MONOTONIC or COPY timestamps. Other drivers will correctly report
> > UNKNOWN timestamp type instead of assuming that all drivers use
> > monotonic timestamps.
> 
> What other kind of timestamps there can be? All drivers (at least those
> not
> mem-to-mem) that do obtain timestamps using system clock use monotonic
> ones.

Not set. It is not a COPY or MONOTONIC either. Any new or custom kind of
timestamp, maybe?

> I'd think that there should no longer be any drivers using the UNKNOWN
> timestamp type: UNKNOWN is either from monotonic or realtime clock, and
> we just replaced all of them with the monotonic ones. No driver uses
> realtime timestamps anymore.

Maybe there should be no drivers using UNKNOWN. But definitely
there should be no driver reporting MONOTONIC when the timestamp is not
monotonic.
 
> How about making MONOTONIC timestamps default instead, or at least
> assigning all drivers something else than UNKNOWN?

So why did you add the UNKNOWN flag?

The way I see it - UNKNOWN is the default and the one who coded the driver
will set it to either MONOTONIC or COPY if it is one of these two. It won't
be changed otherwise. There are drivers, which do not fill the timestamp
field
at all:
- drivers/media/platform/coda.c
- drivers/media/platform/exynos-gsc/gsc-m2m.c
- drivers/media/platform/m2m-deinterlace.c
- drivers/media/platform/mx2_emmaprp.c
- drivers/media/platform/s5p-fimc/fimc-m2m.c
- drivers/media/platform/s5p-g2d.c
- drivers/media/platform/s5p-jpeg/jpeg-core.c
 
The way you did it in your patches left no room for any kind of choice. I
did
comment at least twice about mem-2-mem devices in your RFCs, if I remember
correctly. I think Sylwester was also writing about this. 
Still everything got marked as MONOTONIC. 

If we were to assume that there were no other timestamp types then monotonic
(which is not true, but this was your assumption), then what was the reason
to add this timestamp framework?

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


