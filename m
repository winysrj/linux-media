Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54033 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaKDLvs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 06:51:48 -0500
Message-ID: <1415101898.3701.11.camel@pengutronix.de>
Subject: Re: [PATCH 4/5] [media] vivid: add support for contiguous DMA
 buffers
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Tue, 04 Nov 2014 12:51:38 +0100
In-Reply-To: <54578551.7070002@xs4all.nl>
References: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de>
	 <1413972221-13669-5-git-send-email-p.zabel@pengutronix.de>
	 <54578551.7070002@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Montag, den 03.11.2014, 14:38 +0100 schrieb Hans Verkuil:
> Hi Philipp,
> 
> I've been playing with this and I cannot make it work. One thing that is missing
> in this patch is that the device struct isn't passed to v4l2_device_register.
> Without that the vb2 allocation context will actually be a NULL pointer.
> 
> But after fixing that and a few other minor things (see this branch of mine:
> git://linuxtv.org/hverkuil/media_tree.git vivid) it still won't work because
> dma_alloc_coherent fails and that's because the device is not DMA capable.

Thanks you. Unfortunately I don't have experience with coherent dma on
x86 either, I've only tested this on ARM with CMA. I suspect a missing
call to dma_set_mask_and_coherent in the probe function be the issue?

regards
Philipp

