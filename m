Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64138 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1KUKvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 05:51:47 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LV0004ZIBI9N4@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Nov 2011 10:51:45 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV0007PMBI800@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Nov 2011 10:51:45 +0000 (GMT)
Date: Mon, 21 Nov 2011 11:51:41 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: vmalloc-based allocator user pointer handling
In-reply-to: <CACKLOr2AnJtga7+vjUYQDbhzuZimX1iSHaW+rUVR+62iH_0JuA@mail.gmail.com>
To: 'javier Martin' <javier.martin@vista-silicon.com>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <00d201cca83b$8d4c33a0$a7e49ae0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1320231122-22518-1-git-send-email-andrzej.p@samsung.com>
 <201111081501.00656.laurent.pinchart@ideasonboard.com>
 <004e01cc9e22$c1c0b390$45421ab0$%szyprowski@samsung.com>
 <201111081543.43122.laurent.pinchart@ideasonboard.com>
 <006a01cc9e29$19da33c0$4d8e9b40$%szyprowski@samsung.com>
 <CACKLOr2AnJtga7+vjUYQDbhzuZimX1iSHaW+rUVR+62iH_0JuA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, November 17, 2011 11:41 AM javier Martin wrote:

> what is the current status of this patch? Do you plan to send an
> improved version?
>
> I want to test it against my mem2mem driver I recently submitted
> (emma-PrP) and a UVC camera in order to transform YUYV to YUV420.
> 
> Provided we ignore the locking  problems you have mentioned is it in a
> 'working' state?

The updated version will be posted soon. However using it for accessing
mmaped buffers from your mem2mem driver (which relies on 
videobuf2-dma-contig allocator) requires some additional work to get
access to direct PFNMAP-type mappings in kernel space. 

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



