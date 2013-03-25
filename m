Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23283 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3CYLD3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 07:03:29 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MK700DH6QN4S050@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Mar 2013 11:03:27 +0000 (GMT)
Received: from [127.0.0.1] ([106.116.147.30])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MK7006G3QPQ1EB0@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Mar 2013 11:03:27 +0000 (GMT)
Message-id: <51502EFD.6060606@samsung.com>
Date: Mon, 25 Mar 2013 12:03:25 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Status of the patches under review at LMML (32 patches)
References: <20130324151111.1b2ca8d4@redhat.com>
In-reply-to: <20130324151111.1b2ca8d4@redhat.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 3/24/2013 7:11 PM, Mauro Carvalho Chehab wrote:
> This is the summary of the patches that are currently under review at
> Linux Media Mailing List <linux-media@vger.kernel.org>.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
>
> P.S.: This email is c/c to the developers where some action is expected.
>        If you were copied, please review the patches, acking/nacking or
>        submitting an update.
>
> It took me a lot of time to handle patches this time. The good news is that
> there's just one patch without an owner.
>
...

> 		== Marek Szyprowski <m.szyprowski@samsung.com> ==
>
> Nov,12 2012: [media] videobuf2-core: print current state of buffer in vb2_buffer_do http://patchwork.linuxtv.org/patch/15420  Tushar Behera <tushar.behera@linaro.org>

This one is ok. I acked it by gmane interface as I don't have original 
mail, I have no

> Mar, 5 2013: [media] dma-mapping: enable no mmu support in dma_common_mmap          http://patchwork.linuxtv.org/patch/17112  Scott Jiang <scott.jiang.linux@gmail.com>

IMHO this one is RFC. I would like to get some more explanation why it 
is needed and how it will be used.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


