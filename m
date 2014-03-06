Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:20191 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbaCFCMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 21:12:55 -0500
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N1Z00FABSTI9LA0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Mar 2014 11:12:54 +0900 (KST)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <5317D9B4.1080405@samsung.com>
Date: Thu, 06 Mar 2014 11:13:08 +0900
From: Seung-Woo Kim <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH] [media] s5-mfc: remove meaningless memory bank assignment
References: <187b01cf385bb9b4510$%debski@samsung.com>
 <1394017710-671-1-git-send-email-sw0312.kim@samsung.com>
 <CAK9yfHx_yx9qvitSGfNZWJfRK1ZtrOu3VdhJh-aEZ4LNv_8Z-A@mail.gmail.com>
In-reply-to: <CAK9yfHx_yx9qvitSGfNZWJfRK1ZtrOu3VdhJh-aEZ4LNv_8Z-A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sachin,

On 2014년 03월 05일 20:42, Sachin Kamat wrote:
> On 5 March 2014 16:38, Seung-Woo Kim <sw0312.kim@samsung.com> wrote:

(...)

>> -       dev->bank1 = dev->bank1;
> 
> Are you sure this isn't some kind of typo? If not then your commit
> description is too verbose
> to actually say that the code is redundant and could be removed. The
> code here is something like
> 
>  a = a;
> 
> which does not make sense nor add any value and hence redundant and
> could be removed.

Right, this meaningless code can be simply removed as like the first
version. Anyway this redundant made from change of address type in
earlier patch. So I tried to describe that.

Regards,
- Seung-Woo Kim

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

