Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48227 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2JCKQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 06:16:58 -0400
Received: from eusync1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBB004YZB8WYH50@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Oct 2012 11:17:20 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBB009HMB88CQ80@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Oct 2012 11:16:56 +0100 (BST)
Message-id: <506C1097.6030301@samsung.com>
Date: Wed, 03 Oct 2012 12:16:55 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Anatolij Gustschin <agust@denx.de>
Subject: Re: [RFC PATCH 2/3] s5p-fimc: fix compiler warning
References: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com>
 <6311a7c997a9020117d78855d80384468e585601.1349168132.git.hans.verkuil@cisco.com>
In-reply-to: <6311a7c997a9020117d78855d80384468e585601.1349168132.git.hans.verkuil@cisco.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/2012 10:57 AM, Hans Verkuil wrote:
> drivers/media/platform/s5p-fimc/fimc-m2m.c:561:2: warning: passing argument 2 of 'fimc_m2m_try_crop' discards 'const' qualifier from pointer target type [enabled by default]
> drivers/media/platform/s5p-fimc/fimc-m2m.c:502:12: note: expected 'struct v4l2_crop *' but argument is of type 'const struct v4l2_crop *'
> 
> This is fall-out from this commit:
> 
> commit 4f996594ceaf6c3f9bc42b40c40b0f7f87b79c86
> Author: Hans Verkuil <hans.verkuil@cisco.com>
> Date:   Wed Sep 5 05:10:48 2012 -0300
> 
>     [media] v4l2: make vidioc_s_crop const
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Applied, thanks.
