Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18320 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2CLLFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 07:05:09 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0R00GWNQSJYP@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Mar 2012 11:05:07 +0000 (GMT)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M0R00MMKQSIT9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Mar 2012 11:05:06 +0000 (GMT)
Date: Mon, 12 Mar 2012 12:05:05 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH] [media] s5p-tv: Fix section mismatch warning in
 mixer_video.c
In-reply-to: <1331532814-24403-1-git-send-email-sachin.kamat@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	mchehab@infradead.org, patches@linaro.org
Message-id: <4F5DD861.6040108@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1331532814-24403-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin Kamat,
Thank you for finding and fixing this bug.
I will add your patch to the next pull-request for s5p-tv updates.

Regards,
Tomasz Stanislawski
