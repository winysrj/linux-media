Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58707 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1HWKRE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Aug 2011 06:17:04 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQD001MVLWEMW@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Aug 2011 11:17:02 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQD00I93LWDK5@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Aug 2011 11:17:01 +0100 (BST)
Date: Tue, 23 Aug 2011 12:14:17 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH/RFC] media: vb2: change queue initialization order
In-reply-to: <201108231211.25278.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Jonathan Corbet' <corbet@lwn.net>,
	=?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>,
	'Marin Mitov' <mitov@issp.bas.bg>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <010001cc617d$6a6aeb60$3f40c220$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
 <201108231211.25278.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, August 23, 2011 12:11 PM Hans Verkuil wrote:

> Are you planning a RFCv2 for this?
> 
> I've been implementing vb2 in an internal driver and this initialization
> order of vb2 is a bit of a pain to be honest.

(snipped)

Yes, I will post it till the end of the week. I'm sorry for the delay, I was
a bit busy with updating CMA and dma-mapping patches...

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



