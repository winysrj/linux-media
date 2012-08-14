Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38064 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab2HNPKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:10:34 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R00LZJ3ICNX00@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 16:11:00 +0100 (BST)
Content-transfer-encoding: 8BIT
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M8R00CAN3HJXQ20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 16:10:32 +0100 (BST)
Message-id: <502A6A67.9020506@samsung.com>
Date: Tue, 14 Aug 2012 17:10:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sangwook Lee <sangwook.lee@linaro.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: Patches submitted via linux-media ML that are at
 patchwork.linuxtv.org
References: <502A4CD1.1020108@redhat.com>
In-reply-to: <502A4CD1.1020108@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 08/14/2012 03:04 PM, Mauro Carvalho Chehab wrote:
> 		== Silvester Nawrocki <sylvester.nawrocki@gmail.com> == 
> 
> Aug, 2 2012: [PATH,v3,1/2] v4l: Add factory register values form S5K4ECGX sensor    http://patchwork.linuxtv.org/patch/13580  Sangwook Lee <sangwook.lee@linaro.org>
> Aug, 2 2012: [PATH,v3,2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor          http://patchwork.linuxtv.org/patch/13581  Sangwook Lee <sangwook.lee@linaro.org>

These two are superseded by v4, which is currently under review. We're going
to send a pull request when these works are completed. Sangwook, could you
mark any subsequent iterations in future as "PATCH" ?

> Aug,10 2012: [1/2,media] s5p-tv: Use devm_regulator_get() in sdo_drv.c file         http://patchwork.linuxtv.org/patch/13719  Sachin Kamat <sachin.kamat@linaro.org>
> Aug,10 2012: [2/2,media] s5p-tv: Use devm_* functions in sii9234_drv.c file         http://patchwork.linuxtv.org/patch/13720  Sachin Kamat <sachin.kamat@linaro.org>

I've picked these two and will send a pull request shortly.

> Aug,10 2012: [RESEND] v4l/s5p-mfc: added support for end of stream handling in MFC  http://patchwork.linuxtv.org/patch/13721  Andrzej Hajda <a.hajda@samsung.com>

There is some problem with that one on top of latest kernel tree:

drivers/media/video/s5p-mfc/s5p_mfc_enc.c: In function ‘vidioc_subscribe_event’:
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:1536: error: too few arguments to
function ‘v4l2_event_subscribe’
make[4]: *** [drivers/media/video/s5p-mfc/s5p_mfc_enc.o] Error 1
make[3]: *** [drivers/media/video/s5p-mfc] Error 2
make[2]: *** [drivers/media/video] Error 2
make[2]: *** Waiting for unfinished jobs....

I'll ask Andrzej to see what's going on. This patch needs to be adapted now
to some recent changes at v4l2-core.

> Aug,10 2012: [v4,1/2] v4l: Add factory register values form S5K4ECGX sensor         http://patchwork.linuxtv.org/patch/13727  Sangwook Lee <sangwook.lee@linaro.org>

Under review, can be marked as RFC (see comments on v3).

> Aug,10 2012: [v4,2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor               http://patchwork.linuxtv.org/patch/13728  Sangwook Lee <sangwook.lee@linaro.org>

Ditto.

> Jun,11 2012: [1/3,media] s5p-tv: Replace printk with pr_* functions                 http://patchwork.linuxtv.org/patch/11666  Sachin Kamat <sachin.kamat@linaro.org>

I've added it to my pull request to follow.

> Jun,11 2012: [2/3,media] s5p-mfc: Replace printk with pr_* functions                http://patchwork.linuxtv.org/patch/11667  Sachin Kamat <sachin.kamat@linaro.org>

There were changes requested by Kamil Debski on this patch, which still
seem not addressed.

> Jun,11 2012: [3/3,media] s5p-fimc: Replace printk with pr_* functions               http://patchwork.linuxtv.org/patch/11668  Sachin Kamat <sachin.kamat@linaro.org>

This patch is superseded by this one [1] already merged.

> Jun,12 2012: [1/1, media] s5p-fimc: Replace custom err() macro with v4l2_err() macr http://patchwork.linuxtv.org/patch/11675  Sachin Kamat <sachin.kamat@linaro.org>

This one is already applied [1].

[1]
http://git.linuxtv.org/media_tree.git/commitdiff/a516d08fa6afb703ba508ccc55656d037c5b9e2e

--

Regards,
Sylwester
