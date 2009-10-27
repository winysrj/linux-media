Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14727 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZJ0LBr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 07:01:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KS6007RD6N26800@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Oct 2009 11:01:50 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KS600MVB6N2XK@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Oct 2009 11:01:50 +0000 (GMT)
Date: Tue, 27 Oct 2009 11:59:54 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: V4L2_MEMORY_USERPTR support in videobuf-core
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC07D2F45C6B@bssrvexch01.BS.local>
Content-language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
could anybody confirm that there is no full/working support for USERPTR in
current videobuf-core? That is the conclusion I came up with after a more 
thorough investigation.

I am currently working to fix that, and will hopefully be posting patches in
the coming days/weeks. Is there any other development effort underway related
to this problem?

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


