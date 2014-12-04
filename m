Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:51954 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251AbaLDRiY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Dec 2014 12:38:24 -0500
Date: Thu, 04 Dec 2014 15:38:14 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>, stable@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 1/2] img-ir/hw: Avoid clearing filter for no-op
 protocol change
Message-id: <20141204153814.00a1a5ec.m.chehab@samsung.com>
In-reply-to: <1417438510-18977-2-git-send-email-james.hogan@imgtec.com>
References: <1417438510-18977-1-git-send-email-james.hogan@imgtec.com>
 <1417438510-18977-2-git-send-email-james.hogan@imgtec.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Dec 2014 12:55:09 +0000
James Hogan <james.hogan@imgtec.com> escreveu:

> When the img-ir driver is asked to change protocol, if the chosen
> decoder is already loaded then don't call img_ir_set_decoder(), so as
> not to clear the current filter.
> 
> This is important because store_protocol() does not refresh the scancode
> filter with the new protocol if the set of enabled protocols hasn't
> actually changed, but it will still call the change_protocol() callback,
> resulting in the filter being disabled in the hardware.
> 
> The problem can be reproduced by setting a filter, and then setting the
> protocol to the same protocol that is already set:
> $ echo nec > protocols
> $ echo 0xffff > filter_mask
> $ echo nec > protocols
> 
> After this, messages which don't match the filter still get received.

This should be fixed at the RC core, as this is not driver-specific.

Regards,
Mauro

> 
> Reported-by: Sifan Naeem <sifan.naeem@imgtec.com>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: <stable@vger.kernel.org> # v3.15+
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/rc/img-ir/img-ir-hw.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
> index 9db065344b41..1566337c1059 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -643,6 +643,12 @@ static int img_ir_change_protocol(struct rc_dev *dev, u64 *ir_type)
>  			continue;
>  		if (*ir_type & dec->type) {
>  			*ir_type &= dec->type;
> +			/*
> +			 * We don't want to clear the filter if nothing is
> +			 * changing as it won't get set again.
> +			 */
> +			if (dec == hw->decoder)
> +				return 0;
>  			img_ir_set_decoder(priv, dec, *ir_type);
>  			goto success;
>  		}
