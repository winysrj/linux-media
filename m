Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34988 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdAPFHa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 00:07:30 -0500
Date: Mon, 16 Jan 2017 18:06:25 +1300
From: Derek Robson <robsonde@gmail.com>
To: Scott Matheina <scott@matheina.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org, jb@abbadie.fr,
        aquannie@gmail.com, bankarsandhya512@gmail.com, bhumirks@gmail.com,
        claudiu.beznea@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: media: bcm2048: style fix - bare use of unsigned
Message-ID: <20170116050625.GA26815@bigbird>
References: <20170116043030.29366-1-robsonde@gmail.com>
 <6FFD25BD-70E3-4BE5-896E-793F4A47F30E@matheina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6FFD25BD-70E3-4BE5-896E-793F4A47F30E@matheina.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 15, 2017 at 10:40:02PM -0600, Scott Matheina wrote:
> 
> 
> > On Jan 15, 2017, at 10:30 PM, Derek Robson <robsonde@gmail.com> wrote:
> > 
> > Changed bare use of 'unsigned' to the prefered us of 'unsigned int'
> > found using checkpatch
> 
> Just wondering if you compiled? This patch looks exactly like a patch I tried, but it didn't compile. 
> 

It complied for me, I am on an X86 system.

> > Signed-off-by: Derek Robson <robsonde@gmail.com>
> > ---
> > drivers/staging/media/bcm2048/radio-bcm2048.c | 44 +++++++++++++--------------
> > 1 file changed, 22 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> > index 37bd439ee08b..b1923a3e4483 100644
> > --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> > +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> > @@ -2020,27 +2020,27 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,        \
> >    return count;                            \
> > }
> > 
> > -DEFINE_SYSFS_PROPERTY(power_state, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(mute, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(audio_route, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(dac_output, unsigned, int, "%u", 0)
> > -
> > -DEFINE_SYSFS_PROPERTY(fm_hi_lo_injection, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(fm_frequency, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(fm_af_frequency, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(fm_deemphasis, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(fm_rds_mask, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(fm_best_tune_mode, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(fm_search_rssi_threshold, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(fm_search_mode_direction, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(fm_search_tune_mode, unsigned, int, "%u", value > 3)
> > -
> > -DEFINE_SYSFS_PROPERTY(rds, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(rds_b_block_mask, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(rds_b_block_match, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(rds_pi_mask, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(rds_pi_match, unsigned, int, "%u", 0)
> > -DEFINE_SYSFS_PROPERTY(rds_wline, unsigned, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(power_state, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(mute, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(audio_route, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(dac_output, unsigned int, int, "%u", 0)
> > +
> > +DEFINE_SYSFS_PROPERTY(fm_hi_lo_injection, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(fm_frequency, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(fm_af_frequency, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(fm_deemphasis, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(fm_rds_mask, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(fm_best_tune_mode, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(fm_search_rssi_threshold, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(fm_search_mode_direction, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(fm_search_tune_mode, unsigned int, int, "%u", value > 3)
> > +
> > +DEFINE_SYSFS_PROPERTY(rds, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(rds_b_block_mask, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(rds_b_block_match, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(rds_pi_mask, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(rds_pi_match, unsigned int, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(rds_wline, unsigned int, int, "%u", 0)
> > property_read(rds_pi, unsigned int, "%x")
> > property_str_read(rds_rt, (BCM2048_MAX_RDS_RT + 1))
> > property_str_read(rds_ps, (BCM2048_MAX_RDS_PS + 1))
> > @@ -2052,7 +2052,7 @@ property_read(region_bottom_frequency, unsigned int, "%u")
> > property_read(region_top_frequency, unsigned int, "%u")
> > property_signed_read(fm_carrier_error, int, "%d")
> > property_signed_read(fm_rssi, int, "%d")
> > -DEFINE_SYSFS_PROPERTY(region, unsigned, int, "%u", 0)
> > +DEFINE_SYSFS_PROPERTY(region, unsigned int, int, "%u", 0)
> > 
> > static struct device_attribute attrs[] = {
> >    __ATTR(power_state, 0644, bcm2048_power_state_read,
> > -- 
> > 2.11.0
> 
