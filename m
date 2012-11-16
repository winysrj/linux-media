Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1903 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2KPQDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 11:03:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 0/2] Two vpif fixes protecting the dma_queue by a lock
Date: Fri, 16 Nov 2012 17:03:05 +0100
Message-Id: <1353081787-7010-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

These two patches add protection to the dma_queue. We discovered that not
locking caused race conditions, which caused the display DMA to jam. After
adding the lock we never saw this again.

It makes sense as well since the interrupt routine and normal code both
manipulated the same list.

It's fixed for both capture and display.

Regards,

	Hans

