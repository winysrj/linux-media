Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34030 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754936AbcK2Rik (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 12:38:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] adv7604: Initialize drive strength to default when using DT
Date: Tue, 29 Nov 2016 19:38:53 +0200
Message-ID: <5425761.IZ7KbTi7n1@avalon>
In-Reply-To: <1480418628-21879-1-git-send-email-lars@metafoo.de>
References: <1480418628-21879-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

Thank you for the patch.

On Tuesday 29 Nov 2016 12:23:48 Lars-Peter Clausen wrote:
> The adv7604 driver platform data contains fields for configuring the drive
> strength of the output pins. When probing the driver through DT these
> fields are not explicitly initialized, which means they are left at 0. This
> is a reserved setting for the drive strength configuration though and can
> cause signal integrity issues.
> 
> Whether these signal integrity issues are visible depends on the PCB
> specifics (e.g. the higher the load capacitance for the output the more
> visible the issue). But it has been observed on existing solutions at high
> pixel clock rates.
> 
> Initialize the drive strength settings to the power-on-reset value of the
> device when probing through devicetree to avoid this issue.
> 
> Fixes: 0e158be0162b ("adv7604: Add DT support")
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/adv7604.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 5630eb2..a4dc64a 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -3132,6 +3132,9 @@ static int adv76xx_parse_dt(struct adv76xx_state
> *state) state->pdata.blank_data = 1;
>  	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
>  	state->pdata.bus_order = ADV7604_BUS_ORDER_RGB;
> +	state->pdata.dr_str_data = ADV76XX_DR_STR_MEDIUM_HIGH;
> +	state->pdata.dr_str_clk = ADV76XX_DR_STR_MEDIUM_HIGH;
> +	state->pdata.dr_str_sync = ADV76XX_DR_STR_MEDIUM_HIGH;
> 
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

