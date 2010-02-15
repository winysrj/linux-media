Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10178 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0BOQ3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 11:29:11 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KXW00GWL5SKCH70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Feb 2010 16:29:08 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KXW00ESF5SKDZ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Feb 2010 16:29:08 +0000 (GMT)
Date: Mon, 15 Feb 2010 17:27:46 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: Fourcc for multiplanar formats
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kamil Debski' <k.debski@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC09C5635702@bssrvexch01.BS.local>
Content-language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

we would like to ask for suggestions for new fourcc formats for multiplanar buffers.

There are planar formats in V4L2 API, but for all of them, each plane X "immediately
follows Y plane in memory". We are in the process of testing formats and V4L2 extensions
that relax those requirements and allow each plane to reside in a separate area of
memory.

I am not sure how we should name those formats though. In our example, we are focusing
on the following formats at the moment:
- YCbCr 422 2-planar (multiplanar version of V4L2_PIX_FMT_NV16)
- YCbCr 422 3-planar (multiplanar version of V4L2_PIX_FMT_YUV422P)
- YCbCr 420 2-planar (multiplanar version of V4L2_PIX_FMT_NV12)
- YCbCr 420 3-planar (multiplanar version of V4L2_PIX_FMT_YUV420)


Could anyone give any suggestions how we should name such formats and what to pass to
the v4l2_fourcc() macro?


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


