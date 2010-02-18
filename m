Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37751 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab0BRJzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2010 04:55:21 -0500
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KY100BHT7K48C@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Feb 2010 09:55:16 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KY1007SW7K48I@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Feb 2010 09:55:16 +0000 (GMT)
Date: Thu, 18 Feb 2010 10:53:48 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: Fourcc for multiplanar formats
In-reply-to: <A69FA2915331DC488A831521EAE36FE40169C5C59A@dlee06.ent.ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kamil Debski' <k.debski@samsung.com>
Message-id: <000001cab080$44a35de0$cdea19a0$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC09C5635702@bssrvexch01.BS.local>
 <201002171921.36567.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE40169C5C583@dlee06.ent.ti.com>
 <201002171942.01004.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE40169C5C59A@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

>Any progress on the RFC for allowing user applications to specify separate user ptr
>for each plane of a multi-planar format?

I have finished ver. 1 of V4L2 API, videobuf adaptations and tested everything on
a slightly modified vivi. Patches are ready, I'm in the middle of writing the RFC.

I should be posting everything really soon (still waiting for a green light but
it's usually a matter of hours, couple of days at most).


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


