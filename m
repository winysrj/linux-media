Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48287
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933233AbcJSVGt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 17:06:49 -0400
Date: Wed, 19 Oct 2016 19:06:43 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jean-Baptiste Abbadie <jb@abbadie.fr>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] Staging: media: radio-bcm2048: Fix symbolic
 permissions
Message-ID: <20161019190643.173decf4@vento.lan>
In-Reply-To: <20161019204714.11645-2-jb@abbadie.fr>
References: <20161019204714.11645-1-jb@abbadie.fr>
        <20161019204714.11645-2-jb@abbadie.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 19 Oct 2016 22:47:12 +0200
Jean-Baptiste Abbadie <jb@abbadie.fr> escreveu:

You should run get_maintainers.pl and check whomever submitted the driver, 
in order to get review. In particular, this driver looks to be
submitted by Hans, although I guess he didn't authored:

commit 899127b67df098e6d878f27be05dc91401cc6685
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Mon Nov 4 08:34:42 2013 -0300

    [media] This adds support for the BCM2048 radio module found in Nokia N900
    
    Add suport for Nokia N900 radio. This driver is far from being ready
    to be added at the main tree, as it creates its own sysfs interface,
    and violates lots of Coding Style rules, doing even evil things like
    returning from a function inside a macro.
    
    So, it is being added at staging with the condition that it will be
    soon be fixed.



> This replaces the S_* style permissions by numbers for the __ATTR macros

I really prefer to see permissions like 0644, instead of those weird
S_* macros, as I can understand right away what is permitted.

> 
> Signed-off-by: Jean-Baptiste Abbadie <jb@abbadie.fr>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 58 +++++++++++++--------------
>  1 file changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index fe637ce8f4e7..188d045d44ad 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -2057,67 +2057,67 @@ property_signed_read(fm_rssi, int, "%d")
>  DEFINE_SYSFS_PROPERTY(region, unsigned, int, "%u", 0)
>  
>  static struct device_attribute attrs[] = {
> -	__ATTR(power_state, S_IRUGO | S_IWUSR, bcm2048_power_state_read,
> +	__ATTR(power_state, 0644, bcm2048_power_state_read,
>  	       bcm2048_power_state_write),
> -	__ATTR(mute, S_IRUGO | S_IWUSR, bcm2048_mute_read,
> +	__ATTR(mute, 0644, bcm2048_mute_read,
>  	       bcm2048_mute_write),
> -	__ATTR(audio_route, S_IRUGO | S_IWUSR, bcm2048_audio_route_read,
> +	__ATTR(audio_route, 0644, bcm2048_audio_route_read,
>  	       bcm2048_audio_route_write),
> -	__ATTR(dac_output, S_IRUGO | S_IWUSR, bcm2048_dac_output_read,
> +	__ATTR(dac_output, 0644, bcm2048_dac_output_read,
>  	       bcm2048_dac_output_write),
> -	__ATTR(fm_hi_lo_injection, S_IRUGO | S_IWUSR,
> +	__ATTR(fm_hi_lo_injection, 0644,
>  	       bcm2048_fm_hi_lo_injection_read,
>  	       bcm2048_fm_hi_lo_injection_write),
> -	__ATTR(fm_frequency, S_IRUGO | S_IWUSR, bcm2048_fm_frequency_read,
> +	__ATTR(fm_frequency, 0644, bcm2048_fm_frequency_read,
>  	       bcm2048_fm_frequency_write),
> -	__ATTR(fm_af_frequency, S_IRUGO | S_IWUSR,
> +	__ATTR(fm_af_frequency, 0644,
>  	       bcm2048_fm_af_frequency_read,
>  	       bcm2048_fm_af_frequency_write),
> -	__ATTR(fm_deemphasis, S_IRUGO | S_IWUSR, bcm2048_fm_deemphasis_read,
> +	__ATTR(fm_deemphasis, 0644, bcm2048_fm_deemphasis_read,
>  	       bcm2048_fm_deemphasis_write),
> -	__ATTR(fm_rds_mask, S_IRUGO | S_IWUSR, bcm2048_fm_rds_mask_read,
> +	__ATTR(fm_rds_mask, 0644, bcm2048_fm_rds_mask_read,
>  	       bcm2048_fm_rds_mask_write),
> -	__ATTR(fm_best_tune_mode, S_IRUGO | S_IWUSR,
> +	__ATTR(fm_best_tune_mode, 0644,
>  	       bcm2048_fm_best_tune_mode_read,
>  	       bcm2048_fm_best_tune_mode_write),
> -	__ATTR(fm_search_rssi_threshold, S_IRUGO | S_IWUSR,
> +	__ATTR(fm_search_rssi_threshold, 0644,
>  	       bcm2048_fm_search_rssi_threshold_read,
>  	       bcm2048_fm_search_rssi_threshold_write),
> -	__ATTR(fm_search_mode_direction, S_IRUGO | S_IWUSR,
> +	__ATTR(fm_search_mode_direction, 0644,
>  	       bcm2048_fm_search_mode_direction_read,
>  	       bcm2048_fm_search_mode_direction_write),
> -	__ATTR(fm_search_tune_mode, S_IRUGO | S_IWUSR,
> +	__ATTR(fm_search_tune_mode, 0644,
>  	       bcm2048_fm_search_tune_mode_read,
>  	       bcm2048_fm_search_tune_mode_write),
> -	__ATTR(rds, S_IRUGO | S_IWUSR, bcm2048_rds_read,
> +	__ATTR(rds, 0644, bcm2048_rds_read,
>  	       bcm2048_rds_write),
> -	__ATTR(rds_b_block_mask, S_IRUGO | S_IWUSR,
> +	__ATTR(rds_b_block_mask, 0644,
>  	       bcm2048_rds_b_block_mask_read,
>  	       bcm2048_rds_b_block_mask_write),
> -	__ATTR(rds_b_block_match, S_IRUGO | S_IWUSR,
> +	__ATTR(rds_b_block_match, 0644,
>  	       bcm2048_rds_b_block_match_read,
>  	       bcm2048_rds_b_block_match_write),
> -	__ATTR(rds_pi_mask, S_IRUGO | S_IWUSR, bcm2048_rds_pi_mask_read,
> +	__ATTR(rds_pi_mask, 0644, bcm2048_rds_pi_mask_read,
>  	       bcm2048_rds_pi_mask_write),
> -	__ATTR(rds_pi_match, S_IRUGO | S_IWUSR, bcm2048_rds_pi_match_read,
> +	__ATTR(rds_pi_match, 0644, bcm2048_rds_pi_match_read,
>  	       bcm2048_rds_pi_match_write),
> -	__ATTR(rds_wline, S_IRUGO | S_IWUSR, bcm2048_rds_wline_read,
> +	__ATTR(rds_wline, 0644, bcm2048_rds_wline_read,
>  	       bcm2048_rds_wline_write),
> -	__ATTR(rds_pi, S_IRUGO, bcm2048_rds_pi_read, NULL),
> -	__ATTR(rds_rt, S_IRUGO, bcm2048_rds_rt_read, NULL),
> -	__ATTR(rds_ps, S_IRUGO, bcm2048_rds_ps_read, NULL),
> -	__ATTR(fm_rds_flags, S_IRUGO, bcm2048_fm_rds_flags_read, NULL),
> -	__ATTR(region_bottom_frequency, S_IRUGO,
> +	__ATTR(rds_pi, 0444, bcm2048_rds_pi_read, NULL),
> +	__ATTR(rds_rt, 0444, bcm2048_rds_rt_read, NULL),
> +	__ATTR(rds_ps, 0444, bcm2048_rds_ps_read, NULL),
> +	__ATTR(fm_rds_flags, 0444, bcm2048_fm_rds_flags_read, NULL),
> +	__ATTR(region_bottom_frequency, 0444,
>  	       bcm2048_region_bottom_frequency_read, NULL),
> -	__ATTR(region_top_frequency, S_IRUGO,
> +	__ATTR(region_top_frequency, 0444,
>  	       bcm2048_region_top_frequency_read, NULL),
> -	__ATTR(fm_carrier_error, S_IRUGO,
> +	__ATTR(fm_carrier_error, 0444,
>  	       bcm2048_fm_carrier_error_read, NULL),
> -	__ATTR(fm_rssi, S_IRUGO,
> +	__ATTR(fm_rssi, 0444,
>  	       bcm2048_fm_rssi_read, NULL),
> -	__ATTR(region, S_IRUGO | S_IWUSR, bcm2048_region_read,
> +	__ATTR(region, 0644, bcm2048_region_read,
>  	       bcm2048_region_write),
> -	__ATTR(rds_data, S_IRUGO, bcm2048_rds_data_read, NULL),
> +	__ATTR(rds_data, 0444, bcm2048_rds_data_read, NULL),
>  };
>  
>  static int bcm2048_sysfs_unregister_properties(struct bcm2048_device *bdev,



Thanks,
Mauro
