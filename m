Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41463 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2KHP2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 10:28:15 -0500
Received: from eusync2.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MD600DUODNWKM00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Nov 2012 15:28:44 +0000 (GMT)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MD6000RTDN0LV60@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Nov 2012 15:28:13 +0000 (GMT)
Message-id: <509BCF8C.3060806@samsung.com>
Date: Thu, 08 Nov 2012 16:28:12 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 27/26] v4l: vb2: Set data_offset to 0 for single-plane
 buffers
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
 <1352376336-5404-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <509BA1FE.9010301@samsung.com> <5434150.xFoZpmKjxA@avalon>
In-reply-to: <5434150.xFoZpmKjxA@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
The fix was partially applied in "[PATCHv10 03/26] v4l: vb2: add support for shared buffer (dma_buf)".
The data_offset is set to 0 for DMABUF capture/output for single-planar API.

We should define the meaning of data_offset in case of USERPTR and MMAP buffers.
For output device it is pretty intuitive.

For DMABUF capture devices data_offset maybe used to inform a driver to
capture the image at some offset inside the DMABUF buffer.

BTW. Should {} be added after "if (V4L2_TYPE_IS_OUTPUT(b->type))"
to avoid 'interesting' behavior? :)

Regards,
Tomasz Stanislawski


