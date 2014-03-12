Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.89.28.114]:33043 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaCLLMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 07:12:50 -0400
Message-ID: <53204130.8040007@imgtec.com>
Date: Wed, 12 Mar 2014 11:12:48 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 10/10] rc: img-ir: add Sanyo decoder module
References: <1393630140-31765-1-git-send-email-james.hogan@imgtec.com> <1393630140-31765-11-git-send-email-james.hogan@imgtec.com> <20140312075759.71eceec7@samsung.com>
In-Reply-To: <20140312075759.71eceec7@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/14 10:57, Mauro Carvalho Chehab wrote:
> Hi James,
> 
> Em Fri, 28 Feb 2014 23:29:00 +0000
> James Hogan <james.hogan@imgtec.com> escreveu:
> 
>> Add an img-ir module for decoding the Sanyo infrared protocol.
> 
> After applying this series, some new warnings are popping up,
> when compiled with W=1:
> 
> drivers/media/rc/img-ir/img-ir-hw.c: In function 'img_ir_free_timing':
> drivers/media/rc/img-ir/img-ir-hw.c:228:23: warning: variable 'maxlen' set but not used [-Wunused-but-set-variable]
>   unsigned int minlen, maxlen, ft_min;
>                        ^
> drivers/media/rc/img-ir/img-ir-hw.c:228:15: warning: variable 'minlen' set but not used [-Wunused-but-set-variable]
>   unsigned int minlen, maxlen, ft_min;
>                ^
> drivers/media/rc/img-ir/img-ir-jvc.c:76:3: warning: initialized field overwritten [-Woverride-init]
>    },
>    ^
> drivers/media/rc/img-ir/img-ir-jvc.c:76:3: warning: (near initialization for 'img_ir_jvc.timings.s00') [-Woverride-init]
> drivers/media/rc/img-ir/img-ir-jvc.c:81:3: warning: initialized field overwritten [-Woverride-init]
>    },
>    ^
> drivers/media/rc/img-ir/img-ir-jvc.c:81:3: warning: (near initialization for 'img_ir_jvc.timings.s01') [-Woverride-init]
> 
> Please fix.

Ooh yes, I hadn't tried W=1. Both appear to indicate genuine bugs. I'll
fix and do a retest later today.

Thanks
James
