Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13305 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3AWOuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 09:50:22 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH300KCV2HS4B70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Jan 2013 14:50:20 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MH30064C2JIAQ90@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Jan 2013 14:50:20 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, arun.kk@samsung.com,
	mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, kyungmin.park@samsung.com
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
 <20130122184442.GB18639@valkosipuli.retiisi.org.uk>
 <040701cdf946$3a18c060$ae4a4120$%debski@samsung.com>
 <201301231003.47396.hverkuil@xs4all.nl>
 <20130123135514.GD18639@valkosipuli.retiisi.org.uk>
In-reply-to: <20130123135514.GD18639@valkosipuli.retiisi.org.uk>
Subject: RE: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers
 which use videobuf2
Date: Wed, 23 Jan 2013 15:50:04 +0100
Message-id: <041f01cdf978$efa126c0$cee37440$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: 'Sakari Ailus' [mailto:sakari.ailus@iki.fi]
> Sent: Wednesday, January 23, 2013 2:55 PM
> 
> On Wed, Jan 23, 2013 at 10:03:47AM +0100, Hans Verkuil wrote:
> ...
> > Right. And in my view there should be no default timestamp. Drivers
> > should always select MONOTONIC or COPY, and never UNKNOWN. The vb2
> > code should check for that and issue a WARN_ON if no proper timestamp
> type was provided.
> >
> > v4l2-compliance already checks for that as well.
> 
> I agree with that.

I also agree. I will post patches that issue a WARN_ON.

> Speaking of non-vb2 drivers --- I guess there's no reason for a driver
> not to use vb2 these days. There are actually already multple reasons
> to use it instead.
> 
> So, vb2 drivers should choose the timestamps, and non-vb2 drivers...
> well, we shouldn't have more, but in case we do, they _must_ set the
> timestamp type, as there's no "default" since the relevant IOCTLs are
> handled by the driver itself rather than the V4L2 framework.
> 


Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


