Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4879 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaIUNFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 09:05:52 -0400
Message-ID: <541ECD1D.5020605@xs4all.nl>
Date: Sun, 21 Sep 2014 15:05:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RFC: vb2: replace alloc_ctx by struct device * in vb2_queue
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek, Pawel,

Currently for dma_config (and the dma_sg code that I posted before) drivers have
to allocate a alloc_ctx context, but in practice that just contains a device pointer.

Is there any reason why we can't just change in struct vb2_queue:

	void                            *alloc_ctx[VIDEO_MAX_PLANES];

to:

	struct device                   *alloc_ctx[VIDEO_MAX_PLANES];

or possibly even just:

	struct device                   *alloc_ctx;

That simplifies the code quite a bit and I don't see and need for anything
else. The last option would make it impossible to have different allocation
contexts for different planes, but that might be something that Samsumg needs.

Regards,

	Hans
