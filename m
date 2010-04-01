Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24842 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab0DAJtj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 05:49:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L0600125ZAOFF60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 10:49:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0600L1NZANMZ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 10:49:36 +0100 (BST)
Date: Thu, 01 Apr 2010 11:47:36 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH 1/2] v4l2-mem2mem: Code cleanup
In-reply-to: <1270110025-1854-1-git-send-email-hvaibhav@ti.com>
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <002401cad180$5c4befe0$14e3cfa0$%osciak@samsung.com>
Content-language: pl
References: <hvaibhav@ti.com> <1270110025-1854-1-git-send-email-hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

thanks for the patch, one comment below:

>Vaibhav Hiremath (hvaibhav@ti.com) wrote:
>
>Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>---
> drivers/media/video/v4l2-mem2mem.c |   40 ++++++++++++++---------------------
> 1 files changed, 16 insertions(+), 24 deletions(-)

[...]

>@@ -319,10 +317,9 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
> 		return;
> 	}
>
>-	if (!(m2m_ctx->job_flags & TRANS_QUEUED)) {
>-		list_add_tail(&m2m_ctx->queue, &m2m_dev->jobqueue);
>-		m2m_ctx->job_flags |= TRANS_QUEUED;
>-	}
>+	list_add_tail(&m2m_ctx->queue, &m2m_dev->jobqueue);
>+	m2m_ctx->job_flags |= TRANS_QUEUED;
>+
> 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>
> 	v4l2_m2m_try_run(m2m_dev);

Nice catch! This wasn't the case before, but as v3 is now holding the job_spinlock
for the whole time, the check can be safely removed.

[...]


Acked-by: Pawel Osciak <p.osciak@samsung.com>


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





