Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52744 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZEKGmu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 02:42:50 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id n4B6gdHX005187
	for <linux-media@vger.kernel.org>; Mon, 11 May 2009 09:42:46 +0300
From: ext-eero.nurkkala@nokia.com
To: linux-media@vger.kernel.org
Cc: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Subject: [PATCH 0/2] V4L: Add BCM2048 radio driver
Date: Mon, 11 May 2009 09:41:17 +0300
Message-Id: <1242024079959-git-send-email-ext-eero.nurkkala@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>

This patchset adds the BCM2048 radio driver code.
BCM2048 is radio is integrated in the BCM2048 chipset
that contains the Bluetooth also.

There's quite some sysfs entries introduced here;
But only a very few of them is meant to be used besides
debugging/experimental purposes:

"rds" (rds switch, off/on)
"fm_search_rssi_threshold" (threshold for V4L2_CAP_HW_FREQ_SEEK)
"region" (current region information)
"region_bottom_frequency"
"region_top_frequency"

Unlike V4L2 suggests, the code has also a reference
implementation for a partial RDS decoder; I understand that
this should be done in userspace. However, the decoded
RDS data may be read off from the sysfs nodes also:

"rds_pi" (RDS PI code)
"rds_rt" (RDS Radio Text)
"rds_ps" (RDS PS)

It would be nice to know, how RDS enabling/disabling takes
place in V4L2.

Below is the list of all sysfs entries; However, like mentioned,
only the above (8) sysfs nodes should be used along with the
V4L2. The sysfs nodes below, with the exception of the 8 ones
above, should only be used for debugging/experiments only.
And they do a good job for such purposes ;)

audio_route (DAC, I2S)
dac_output (OFF, LEFT, RIGHT, LEFT/RIGHT)
fm_af_frequency (Alternate Frequency)
fm_best_tune_mode (Best tune mode; tuning method)
fm_carrier_error (FM carrier error)
fm_deemphasis (De-emphasis)
fm_frequency (frequency)
fm_hi_lo_injection (Injection control)
fm_rds_flags (RDS IRQ flags)
fm_rds_mask (RDS IRQ Mask)
fm_rssi (Current channel RSSI level)
fm_search_mode_direction (UP, DOWN)
fm_search_rssi_threshold (HW seek threshold search level)
fm_search_tune_mode (stop all, preset, hw seek, AF jump)
mute (off, on)
power_state (off, on)
rds (off, on)
rds_b_block_mask (RDS b block IRQ mask)
rds_b_block_match (RDS b block IRQ match)
rds_data (Raw RDS data for debugging)
rds_pi (RDS PI code)
rds_pi_mask (RDS PI mask)
rds_pi_match (RDS PI match)
rds_ps (RDS PS)
rds_rt (RDS radiotext)
rds_wline (RDS FIFO watermark level)
region
region_bottom_frequency
region_top_frequency

All comments are very welcome! Like mentioned, I'm aware of
the somewhat ugly set of syfs nodes. For debugging/experiments,
I would guess they're not that bad; but for real usage, they
should be integrated into the V4L2?

Eero Nurkkala (2):
      V4L: Add BCM2048 radio driver
      V4L: Add BCM2048 radio driver Makefile and Kconfig dependencies

 drivers/media/radio/Kconfig         |   10 +
 drivers/media/radio/Makefile        |    1 +
 drivers/media/radio/radio-bcm2048.c | 2613 +++++++++++++++++++++++++++++++++++
 include/media/radio-bcm2048.h       |   30 +
 4 files changed, 2654 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-bcm2048.c
 create mode 100644 include/media/radio-bcm2048.h


