Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1495 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbZELGvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 02:51:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: ext-eero.nurkkala@nokia.com
Subject: Re: [PATCH 0/2] V4L: Add BCM2048 radio driver
Date: Tue, 12 May 2009 08:51:48 +0200
Cc: linux-media@vger.kernel.org
References: <1242024079959-git-send-email-ext-eero.nurkkala@nokia.com>
In-Reply-To: <1242024079959-git-send-email-ext-eero.nurkkala@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905120851.48875.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 11 May 2009 08:41:17 ext-eero.nurkkala@nokia.com wrote:
> From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
>
> This patchset adds the BCM2048 radio driver code.
> BCM2048 is radio is integrated in the BCM2048 chipset
> that contains the Bluetooth also.
>
> There's quite some sysfs entries introduced here;
> But only a very few of them is meant to be used besides
> debugging/experimental purposes:
>
> "rds" (rds switch, off/on)
> "fm_search_rssi_threshold" (threshold for V4L2_CAP_HW_FREQ_SEEK)
> "region" (current region information)
> "region_bottom_frequency"
> "region_top_frequency"
>
> Unlike V4L2 suggests, the code has also a reference
> implementation for a partial RDS decoder; I understand that
> this should be done in userspace. However, the decoded
> RDS data may be read off from the sysfs nodes also:
>
> "rds_pi" (RDS PI code)
> "rds_rt" (RDS Radio Text)
> "rds_ps" (RDS PS)
>
> It would be nice to know, how RDS enabling/disabling takes
> place in V4L2.

I've made an RFC which describes the finishing touches for the RDS API:

http://www.mail-archive.com/linux-media%40vger.kernel.org/msg02498.html

I should have some time next week to finally implement this in the v4l-dvb 
tree.

I recommend that you move the RDS decoder code into an rds library in the 
v4l2-apps directory of the v4l-dvb tree. As you say, the rds decoder 
implementation does not belong in the driver, but it would be very nice to 
have it as a library.

> Below is the list of all sysfs entries; However, like mentioned,
> only the above (8) sysfs nodes should be used along with the
> V4L2. The sysfs nodes below, with the exception of the 8 ones
> above, should only be used for debugging/experiments only.
> And they do a good job for such purposes ;)
>
> audio_route (DAC, I2S)
> dac_output (OFF, LEFT, RIGHT, LEFT/RIGHT)
> fm_af_frequency (Alternate Frequency)
> fm_best_tune_mode (Best tune mode; tuning method)
> fm_carrier_error (FM carrier error)
> fm_deemphasis (De-emphasis)
> fm_frequency (frequency)
> fm_hi_lo_injection (Injection control)
> fm_rds_flags (RDS IRQ flags)
> fm_rds_mask (RDS IRQ Mask)
> fm_rssi (Current channel RSSI level)
> fm_search_mode_direction (UP, DOWN)
> fm_search_rssi_threshold (HW seek threshold search level)
> fm_search_tune_mode (stop all, preset, hw seek, AF jump)
> mute (off, on)
> power_state (off, on)
> rds (off, on)
> rds_b_block_mask (RDS b block IRQ mask)
> rds_b_block_match (RDS b block IRQ match)
> rds_data (Raw RDS data for debugging)
> rds_pi (RDS PI code)
> rds_pi_mask (RDS PI mask)
> rds_pi_match (RDS PI match)
> rds_ps (RDS PS)
> rds_rt (RDS radiotext)
> rds_wline (RDS FIFO watermark level)
> region
> region_bottom_frequency
> region_top_frequency

Such region tables do not belong in a driver IMHO. These too should go to a 
userspace library (libv4l2util? It already contains frequency tables for 
TV).

A more general comment: this driver should be split into two parts: the 
radio tuner core should really be implemented using the tuner API similar 
to the tea5767 radio tuner driver. That way this radio tuner driver can be 
reused when it is placed on e.g. a TV tuner card. However, the tuner API is 
missing functionality for e.g. RDS. Alternatively, the core driver can be 
rewritten as an v4l2_subdev driver, again allowing reuse in other drivers.

I would like to see some input from others on this. I think that it would 
help the integration of v4l and dvb enormously if dvb starts using the 
standard i2c kernel API: that API offers all the functionality that dvb 
needs now that it no longer uses autoprobing. Perhaps a topic for the 
Plumbers conference later this year?

Regards,

	Hans

>
> All comments are very welcome! Like mentioned, I'm aware of
> the somewhat ugly set of syfs nodes. For debugging/experiments,
> I would guess they're not that bad; but for real usage, they
> should be integrated into the V4L2?
>
> Eero Nurkkala (2):
>       V4L: Add BCM2048 radio driver
>       V4L: Add BCM2048 radio driver Makefile and Kconfig dependencies
>
>  drivers/media/radio/Kconfig         |   10 +
>  drivers/media/radio/Makefile        |    1 +
>  drivers/media/radio/radio-bcm2048.c | 2613
> +++++++++++++++++++++++++++++++++++ include/media/radio-bcm2048.h       |
>   30 +
>  4 files changed, 2654 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/radio-bcm2048.c
>  create mode 100644 include/media/radio-bcm2048.h
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
