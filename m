Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57079 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbbBDL0X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 06:26:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pablo Anton <pablo.anton@vodalys-labs.com>, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	mchehab@osg.samsung.com, lars@metafoo.de,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: Re: [PATCH] media: i2c: ADV7604: Rename adv7604 prefixes.
Date: Wed, 04 Feb 2015 13:27:07 +0200
Message-ID: <9008824.dHMd7MRA5e@avalon>
In-Reply-To: <54D1EC89.60108@xs4all.nl>
References: <1422983598-9189-1-git-send-email-pablo.anton@vodalys-labs.com> <54D1EC89.60108@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Wednesday 04 February 2015 10:55:21 Hans Verkuil wrote:
> On 02/03/15 18:13, Pablo Anton wrote:
> > It is confusing which parts of the driver are adv7604 specific, adv7611
> > specific or common for both. This patch renames any adv7604 prefixes
> > (both for functions and defines) to adv76xx whenever they are common.
> > 
> > Signed-off-by: Pablo Anton <pablo.anton@vodalys-labs.com>
> > Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> 
> I'm happy with this, except for three small changes:
> 
> - I had to rebase
> - ADV76xx_fsc should be ADV76XX_FSC
> - The driver name should stay the same to keep in sync with the module name.
> Besides, we might have a future driver for the adv7622/3, so adv76xx as the
> driver name is potentially confusing.
> 
> I've applied these changes and the updated patch is below. If possible I
> would like to get this in 3.20 so future patches for 3.21 can all be based
> on these renamed functions/defines.
> 
> Acks from Lars and Laurent would be welcome, though.
> 
> Regards,
> 
> 	Hans
> 
> From bff6f026de4fe276f99be6ca38206720659938dc Mon Sep 17 00:00:00 2001
> From: Pablo Anton <pablo.anton@vodalys-labs.com>
> Date: Tue, 3 Feb 2015 18:13:18 +0100
> Subject: [PATCH] media: i2c: ADV7604: Rename adv7604 prefixes.
> 
> It is confusing which parts of the driver are adv7604 specific, adv7611
> specific or common for both. This patch renames any adv7604 prefixes (both
> for functions and defines) to adv76xx whenever they are common.
> 
> Signed-off-by: Pablo Anton <pablo.anton@vodalys-labs.com>
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> [hans.verkuil@cisco.com: rebased and renamed ADV76xx_fsc to ADV76XX_FSC]
> [hans.verkuil@cisco.com: kept the existing adv7604 driver name]
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/adv7604.c | 898 ++++++++++++++++++++---------------------
>  include/media/adv7604.h     |  83 ++--
>  2 files changed, 491 insertions(+), 490 deletions(-)

[snip]

> diff --git a/include/media/adv7604.h b/include/media/adv7604.h
> index aa1c447..9ecf353 100644
> --- a/include/media/adv7604.h
> +++ b/include/media/adv7604.h
> @@ -47,16 +47,16 @@ enum adv7604_bus_order {

[snip]

> -enum adv7604_page {
> -	ADV7604_PAGE_IO,
> +enum adv76xx_page {
> +	ADV76XX_PAGE_IO,
>  	ADV7604_PAGE_AVLINK,
> -	ADV7604_PAGE_CEC,
> -	ADV7604_PAGE_INFOFRAME,
> +	ADV76XX_PAGE_CEC,
> +	ADV76XX_PAGE_INFOFRAME,
>  	ADV7604_PAGE_ESDP,
>  	ADV7604_PAGE_DPP,
> -	ADV7604_PAGE_AFE,
> -	ADV7604_PAGE_REP,
> -	ADV7604_PAGE_EDID,
> -	ADV7604_PAGE_HDMI,
> -	ADV7604_PAGE_TEST,
> -	ADV7604_PAGE_CP,
> +	ADV76XX_PAGE_AFE,
> +	ADV76XX_PAGE_REP,
> +	ADV76XX_PAGE_EDID,
> +	ADV76XX_PAGE_HDMI,
> +	ADV76XX_PAGE_TEST,
> +	ADV76XX_PAGE_CP,
>  	ADV7604_PAGE_VDP,
> -	ADV7604_PAGE_MAX,
> +	ADV76XX_PAGE_MAX,
>  };

(Taking the above chunk as one particular example, the comment applies to the 
rest of the driver.)

I'm fine with the change in general, but I wonder how we will handle it going 
forward. Here the ADV7604-specific pages keep their ADV7604_ prefix, while the 
pages common to all supported chips now use an ADV76XX_ prefix. If a new chip 
comes out tomorrow with support, let's say, for AVLINK, how will you name 
ADV7604_PAGE_AVLINK ? Renaming it to ADV76XX_PAGE_AVLINK would imply that it's 
supported on all chips, which wouldn't be true, and keeping the existing name 
would imply that it's only supported on the ADV7604, which wouldn't be true 
either.

-- 
Regards,

Laurent Pinchart

