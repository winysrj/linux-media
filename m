Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:34852 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753703AbdDKHPm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 03:15:42 -0400
Received: by mail-wr0-f174.google.com with SMTP id o21so134219534wrb.2
        for <linux-media@vger.kernel.org>; Tue, 11 Apr 2017 00:15:42 -0700 (PDT)
Subject: Re: [PATCH 4/5] media: rc: meson-ir: use readl_relaxed in the
 interrupt handler
To: Heiner Kallweit <hkallweit1@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>, Kevin Hilman <khilman@baylibre.com>
References: <f65a1465-14ba-8db2-7726-454dcfbee69d@gmail.com>
 <3add55c4-1e29-f070-6fef-7f92b2595874@gmail.com>
Cc: linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <21c29ede-771c-bf91-6079-5e2f44b84457@baylibre.com>
Date: Tue, 11 Apr 2017 09:15:38 +0200
MIME-Version: 1.0
In-Reply-To: <3add55c4-1e29-f070-6fef-7f92b2595874@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/2017 08:05 AM, Heiner Kallweit wrote:
> We don't need the memory barriers here and an interrupt handler should
> be as fast as possible. Therefore switch to readl_relaxed.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/media/rc/meson-ir.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/rc/meson-ir.c b/drivers/media/rc/meson-ir.c
> index d56ef27e..246da2db 100644
> --- a/drivers/media/rc/meson-ir.c
> +++ b/drivers/media/rc/meson-ir.c
> @@ -83,16 +83,17 @@ static void meson_ir_set_mask(struct meson_ir *ir, unsigned int reg,
>  static irqreturn_t meson_ir_irq(int irqno, void *dev_id)
>  {
>  	struct meson_ir *ir = dev_id;
> -	u32 duration;
> +	u32 duration, status;
>  	DEFINE_IR_RAW_EVENT(rawir);
>  
>  	spin_lock(&ir->lock);
>  
> -	duration = readl(ir->reg + IR_DEC_REG1);
> +	duration = readl_relaxed(ir->reg + IR_DEC_REG1);
>  	duration = FIELD_GET(REG1_TIME_IV_MASK, duration);
>  	rawir.duration = US_TO_NS(duration * MESON_TRATE);
>  
> -	rawir.pulse = !!(readl(ir->reg + IR_DEC_STATUS) & STATUS_IR_DEC_IN);
> +	status = readl_relaxed(ir->reg + IR_DEC_STATUS);
> +	rawir.pulse = !!(status & STATUS_IR_DEC_IN);
>  
>  	ir_raw_event_store_with_filter(ir->rc, &rawir);
>  	ir_raw_event_handle(ir->rc);
> 

Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
