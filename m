Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60215 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1HBJsN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 05:48:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPA003SDOKBTO30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:48:11 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.139])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPA009AROK6EP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:48:11 +0100 (BST)
Date: Tue, 02 Aug 2011 11:48:07 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Buffer sharing proof-of-concept
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4E37C7D7.40301@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Everyone,

This patchset introduces the proof-of-concept infrastructure for buffer 
sharing between multiple devices using file descriptors. The 
infrastructure has been integrated with V4L2 framework, more 
specifically videobuf2 and two S5P drivers FIMC (capture interface) and 
TV drivers, but it can be easily used by other kernel subsystems, like DRI.

In this patch the buffer object has been simplified to absolute minimum 
- it contains only the buffer physical address (only physically 
contiguous buffers are supported), but this can be easily extended to 
complete scatter list in the future.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


