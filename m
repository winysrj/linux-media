Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3970 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaB0OVK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:10 -0500
Message-ID: <530F49BA.9070606@xs4all.nl>
Date: Thu, 27 Feb 2014 15:20:42 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linaro-mm-sig@lists.linaro.org
CC: linux-media <linux-media@vger.kernel.org>
Subject: Use of dma_buf_unmap_attachment in interrupt context?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A quick question: can dma_buf_unmap_attachment be called from
interrupt context? It is the dmabuf equivalent to e.g. dma_sync_sg_for_cpu
or dma_unmap_sg, and those can be called from interrupt context.

I cannot see anything specific about this in the sources or dma-buf-sharing.txt.

If it turns out that dma_buf_unmap_attachment can be called from atomic context,
then that should be documented, I think.

Regards,

	Hans
