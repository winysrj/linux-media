Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59585 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbaFQMxG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jun 2014 08:53:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] adv7604: Update recommended writes for the adv7611
Date: Tue, 17 Jun 2014 14:53:44 +0200
Message-ID: <1641028.ccza9szUgP@avalon>
In-Reply-To: <1403005944-27745-1-git-send-email-lars@metafoo.de>
References: <1403005944-27745-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

Thank you for the patch.

On Tuesday 17 June 2014 13:52:24 Lars-Peter Clausen wrote:
> Update the recommended writes to those mentioned in the Rev 1.5 version of
> the ADV7611 Register Settings Recommendations document released by Analog
> Devices. The document does not mention why the recommended settings have
> been updated, but presumably those are more fine tuned settings that can
> enhance performance in some cases.

At least the HDMI register 0x6f change is documented as "optimized DVI 
detection". You could include that in the commit message.

> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

(although all I can do is check that the patch matches the document)

> ---
>  drivers/media/i2c/adv7604.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 1778d32..d4fa213 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2588,8 +2588,11 @@ static const struct adv7604_reg_seq
> adv7604_recommended_settings_hdmi[] = { };
> 
>  static const struct adv7604_reg_seq adv7611_recommended_settings_hdmi[] = {
> +	/* ADV7611 Register Settings Recommendations Rev 1.5, May 2014 */ {
> ADV7604_REG(ADV7604_PAGE_CP, 0x6c), 0x00 },
> -	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x6f), 0x0c },
> +	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x9b), 0x03 },
> +	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x6f), 0x08 },
> +	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x85), 0x1f },
>  	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x87), 0x70 },
>  	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x57), 0xda },
>  	{ ADV7604_REG(ADV7604_PAGE_HDMI, 0x58), 0x01 },

-- 
Regards,

Laurent Pinchart

