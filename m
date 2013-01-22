Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37436 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3AVJoW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 04:44:22 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH000134TPVM7D0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jan 2013 09:44:19 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MH0009E1TOMGP20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jan 2013 09:44:19 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, arun.kk@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, kyungmin.park@samsung.com,
	pawel@osciak.com, 'Marek Szyprowski' <m.szyprowski@samsung.com>
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
 <1358156164-11382-4-git-send-email-k.debski@samsung.com>
 <20130119174329.GL13641@valkosipuli.retiisi.org.uk>
In-reply-to: <20130119174329.GL13641@valkosipuli.retiisi.org.uk>
Subject: RE: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers
 which use videobuf2
Date: Tue, 22 Jan 2013 10:43:28 +0100
Message-id: <032601cdf884$f27f8f70$d77eae50$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

One more comment. Also adding videobuf2 maintainers to CC, as they were not
added in the patch "v4l: Tell user space we're using monotonic timestamps".

> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Saturday, January 19, 2013 6:43 PM
> 
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
> 
> I'd think that there should no longer be any drivers using the UNKNOWN
> timestamp type: UNKNOWN is either from monotonic or realtime clock, and
> we just replaced all of them with the monotonic ones. No driver uses
> realtime timestamps anymore.
> 
> How about making MONOTONIC timestamps default instead, or at least
> assigning all drivers something else than UNKNOWN?

In addition to my previous comment - making MONOTONIC default in videobuf2
would be inconsistent. For non videobuf2 drivers the default is UNKNOWN, so
making
MONOTONIC default for videobuf2 drivers is, in my opinion, wrong.

Best wishes,
Kamil Debski


