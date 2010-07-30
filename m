Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:7969 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755697Ab0G3Cto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 22:49:44 -0400
Subject: Re: [PATCH 06/13] IR: nec decoder: fix repeat.
From: Andy Walls <awalls@md.metrocast.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <1280456235-2024-7-git-send-email-maximlevitsky@gmail.com>
References: <1280456235-2024-1-git-send-email-maximlevitsky@gmail.com>
	 <1280456235-2024-7-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 22:50:07 -0400
Message-ID: <1280458207.15737.75.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-30 at 05:17 +0300, Maxim Levitsky wrote:
> Repeat space is 4 units, not 8.
> Current code would never trigger a repeat.


Yup.  Page 11, line (4)

http://www.datasheetcatalog.org/datasheet/nec/UPD6122G-002.pdf

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> However that isn't true for NECX, so repeat there
> must be handled differently.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/media/IR/ir-nec-decoder.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
> index 52e0f37..1c0cf03 100644
> --- a/drivers/media/IR/ir-nec-decoder.c
> +++ b/drivers/media/IR/ir-nec-decoder.c
> @@ -20,7 +20,7 @@
>  #define NEC_HEADER_PULSE	(16 * NEC_UNIT)
>  #define NECX_HEADER_PULSE	(8  * NEC_UNIT) /* Less common NEC variant */
>  #define NEC_HEADER_SPACE	(8  * NEC_UNIT)
> -#define NEC_REPEAT_SPACE	(8  * NEC_UNIT)
> +#define NEC_REPEAT_SPACE	(4  * NEC_UNIT)
>  #define NEC_BIT_PULSE		(1  * NEC_UNIT)
>  #define NEC_BIT_0_SPACE		(1  * NEC_UNIT)
>  #define NEC_BIT_1_SPACE		(3  * NEC_UNIT)


