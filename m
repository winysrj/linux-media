Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:46621 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934159AbbHKLr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 07:47:57 -0400
Message-ID: <55C9E060.6050901@xs4all.nl>
Date: Tue, 11 Aug 2015 13:45:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>, lars@metafoo.de
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] i2c/adv7511: Fix license, set to GPL v2
References: <1438081066-31748-1-git-send-email-mike.looijmans@topic.nl>
In-Reply-To: <1438081066-31748-1-git-send-email-mike.looijmans@topic.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

Please split up this patch: these are two different drivers with different
authors and different subsystems.

The media/i2c/adv7511.c patch I can handle, but the patch for the drm driver
should go to the dri-devel mailinglist. I can't take that change.

Easiest is just to post two patches, one for each driver.

Regards,

	Hans

On 07/28/15 12:57, Mike Looijmans wrote:
> Header claims GPL v2, so make the MODULE_LICENSE reflect that properly.
> 
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
> ---
>  drivers/gpu/drm/i2c/adv7511_core.c | 2 +-
>  drivers/media/i2c/adv7511.c        | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/adv7511_core.c b/drivers/gpu/drm/i2c/adv7511_core.c
> index 2564b5d..12e8134 100644
> --- a/drivers/gpu/drm/i2c/adv7511_core.c
> +++ b/drivers/gpu/drm/i2c/adv7511_core.c
> @@ -956,4 +956,4 @@ module_exit(adv7511_exit);
>  
>  MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
>  MODULE_DESCRIPTION("ADV7511 HDMI transmitter driver");
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
> index 02d76c6..1a4275d 100644
> --- a/drivers/media/i2c/adv7511.c
> +++ b/drivers/media/i2c/adv7511.c
> @@ -41,7 +41,7 @@ MODULE_PARM_DESC(debug, "debug level (0-2)");
>  
>  MODULE_DESCRIPTION("Analog Devices ADV7511 HDMI Transmitter Device Driver");
>  MODULE_AUTHOR("Hans Verkuil");
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  
>  #define MASK_ADV7511_EDID_RDY_INT   0x04
>  #define MASK_ADV7511_MSEN_INT       0x40
> 
