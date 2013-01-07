Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28220 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3AGJv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 04:51:26 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG900BRE1W28W10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Jan 2013 09:51:24 +0000 (GMT)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MG9000NN21NU910@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Jan 2013 09:51:24 +0000 (GMT)
Message-id: <50EA9A9A.1030409@samsung.com>
Date: Mon, 07 Jan 2013 10:51:22 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: Status of the patches under review at LMML (35 patches)
References: <20130106113455.329ad868@redhat.com>
In-reply-to: <20130106113455.329ad868@redhat.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2013 02:34 PM, Mauro Carvalho Chehab wrote:
> This is the summary of the patches that are currently under review at
> Linux Media Mailing List <linux-media@vger.kernel.org>.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
> 
> P.S.: This email is c/c to the developers where some action is expected.
>       If you were copied, please review the patches, acking/nacking or
>       submitting an update.
> 
> 
> 		== New patches == 
...
> 		== Sylwester Nawrocki <s.nawrocki@samsung.com> == 
> 
> Dec,28 2012: [1/3,media] s5p-mfc: use mfc_err instead of printk                     http://patchwork.linuxtv.org/patch/16012  Sachin Kamat <sachin.kamat@linaro.org>

This patch doesn't apply any more, it's superseded by this patch from 
Kamil, that includes same change - http://patchwork.linuxtv.org/patch/16073

> Jan, 6 2013: s5p-tv: mixer: fix handling of VIDIOC_S_FMT                            http://patchwork.linuxtv.org/patch/16143  Tomasz Stanislawski <t.stanislaws@samsung.com>

And it's been decided to postpone merging of this one for some time,
so I've marked it as Under review. 

--

Thanks,
Sylwester
