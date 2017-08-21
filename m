Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:33944 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751959AbdHUK5x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 06:57:53 -0400
Subject: Re: [PATCH] Staging: bcm2048: fix bare use of 'unsigned' in
 radio-bcm2048.c
To: Branislav Radocaj <branislav@radocaj.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org
Cc: jb@abbadie.fr, hans.verkuil@cisco.com, nikola.jelic83@gmail.com,
        ran.algawi@gmail.com, aquannie@gmail.com, shilpapri@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20170804145824.11768-1-branislav@radocaj.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f140e262-4f3e-a46f-0dd8-df02915cf9e6@xs4all.nl>
Date: Mon, 21 Aug 2017 12:57:47 +0200
MIME-Version: 1.0
In-Reply-To: <20170804145824.11768-1-branislav@radocaj.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/2017 04:58 PM, Branislav Radocaj wrote:
> This is a patch to the radio-bcm2048.c file that fixes up
> a warning found by the checkpatch.pl tool.
> 
> Signed-off-by: Branislav Radocaj <branislav@radocaj.org>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 50 +++++++++++++--------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 38f72d069e27..90b8f05201ba 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -2000,9 +2000,9 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
>  	return sprintf(buf, mask "\n", value);				\
>  }
>  
> -#define DEFINE_SYSFS_PROPERTY(prop, signal, size, mask, check)		\
> -property_write(prop, signal size, mask, check)				\
> -property_read(prop, size, mask)
> +#define DEFINE_SYSFS_PROPERTY(prop, signal_size, size, mask, check)	\
> +property_write(prop, signal_size, mask, check)				\
> +property_read(prop, size, mask)						\

Jeez, the code in this header is awful.

Let's improve this a bit more:

The 'size' argument in property_read is unused AFAICT, so remove it from that
macro and wherever it is used.

The 'signal, size' arguments of property_write is just a type, so replace
'signal, size' by prop_type. Update DEFINE_SYSFS_PROPERTY accordingly and
then all the DEFINE_SYSFS_PROPERTY lines become:

DEFINE_SYSFS_PROPERTY(power_state, unsigned int, "%u", 0)

which finally makes sense when you read it.

Regards,

	Hans

>  
>  #define property_str_read(prop, size)					\
>  static ssize_t bcm2048_##prop##_read(struct device *dev,		\
> @@ -2028,27 +2028,27 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
>  	return count;							\
>  }
>  
> -DEFINE_SYSFS_PROPERTY(power_state, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(mute, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(audio_route, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(dac_output, unsigned, int, "%u", 0)
> -
> -DEFINE_SYSFS_PROPERTY(fm_hi_lo_injection, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(fm_frequency, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(fm_af_frequency, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(fm_deemphasis, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(fm_rds_mask, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(fm_best_tune_mode, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(fm_search_rssi_threshold, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(fm_search_mode_direction, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(fm_search_tune_mode, unsigned, int, "%u", value > 3)
> -
> -DEFINE_SYSFS_PROPERTY(rds, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(rds_b_block_mask, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(rds_b_block_match, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(rds_pi_mask, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(rds_pi_match, unsigned, int, "%u", 0)
> -DEFINE_SYSFS_PROPERTY(rds_wline, unsigned, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(power_state, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(mute, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(audio_route, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(dac_output, unsigned int, int, "%u", 0)
> +
> +DEFINE_SYSFS_PROPERTY(fm_hi_lo_injection, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(fm_frequency, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(fm_af_frequency, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(fm_deemphasis, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(fm_rds_mask, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(fm_best_tune_mode, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(fm_search_rssi_threshold, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(fm_search_mode_direction, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(fm_search_tune_mode, unsigned int, int, "%u", value > 3)
> +
> +DEFINE_SYSFS_PROPERTY(rds, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(rds_b_block_mask, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(rds_b_block_match, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(rds_pi_mask, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(rds_pi_match, unsigned int, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(rds_wline, unsigned int, int, "%u", 0)
>  property_read(rds_pi, unsigned int, "%x")
>  property_str_read(rds_rt, (BCM2048_MAX_RDS_RT + 1))
>  property_str_read(rds_ps, (BCM2048_MAX_RDS_PS + 1))
> @@ -2060,7 +2060,7 @@ property_read(region_bottom_frequency, unsigned int, "%u")
>  property_read(region_top_frequency, unsigned int, "%u")
>  property_signed_read(fm_carrier_error, int, "%d")
>  property_signed_read(fm_rssi, int, "%d")
> -DEFINE_SYSFS_PROPERTY(region, unsigned, int, "%u", 0)
> +DEFINE_SYSFS_PROPERTY(region, unsigned int, int, "%u", 0)
>  
>  static struct device_attribute attrs[] = {
>  	__ATTR(power_state, 0644, bcm2048_power_state_read,
> 
