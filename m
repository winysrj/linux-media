Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35048 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab2HNOGz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 10:06:55 -0400
Received: from eusync1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R006SQ0K7TP00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 15:07:19 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M8R008S20JHY820@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 15:06:53 +0100 (BST)
Message-id: <502A5B7C.4070700@samsung.com>
Date: Tue, 14 Aug 2012 16:06:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	k.debski@samsung.com, kyungmin.park@samsung.com,
	mchehab@infradead.org, patches@linaro.org
Subject: Re: [PATCH 1/3] [media] s5p-tv: Replace printk with pr_* functions
References: <1339409634-13657-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1339409634-13657-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/11/2012 12:13 PM, Sachin Kamat wrote:
> Replace printk with pr_* functions to silence checkpatch warnings.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
