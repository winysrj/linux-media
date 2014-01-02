Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1634 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaABMsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 07:48:25 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id s02CmLmJ012719
	for <linux-media@vger.kernel.org>; Thu, 2 Jan 2014 13:48:23 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 4214C2A0142
	for <linux-media@vger.kernel.org>; Thu,  2 Jan 2014 13:47:45 +0100 (CET)
Message-ID: <52C55FF1.3010900@xs4all.nl>
Date: Thu, 02 Jan 2014 13:47:45 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] adv fixes and feature enhancements
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Please pull this patch series for 3.14.

It's rebased but otherwise unchanged from the last review patch series:

http://www.spinics.net/lists/linux-media/msg70819.html

Happy New Year!

Regards,

	Hans


The following changes since commit 7d459937dc09bb8e448d9985ec4623779427d8a5:

  [media] Add driver for Samsung S5K5BAF camera sensor (2013-12-21 07:01:36 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git adv

for you to fetch changes up to 4644c02f7befe821bdd0d20b33d6a0de7b59cfae:

  adv7842: add drive strength enum and sync names with adv7604. (2014-01-02 13:44:30 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
      adv7604: adv7604_s_register clean up.
      adv7604: initialize timings to CEA 640x480p59.94.
      adv7842: support YCrCb analog input, receive CEA formats as RGB on VGA input
      adv7842: set LLC DLL phase from platform_data
      adv7842: initialize timings to CEA 640x480p59.94.
      adv7842: add drive strength enum and sync names with adv7604.

Martin Bugge (27):
      ad9389b: whitespace changes to improve readability
      ad9389b: remove rx-sense irq dependency
      ad9389b: retry setup if the state is inconsistent
      adv7511: disable register reset by HPD
      adv7511: add VIC and audio CTS/N values to log_status
      adv7511: verify EDID header
      adv7604: support 1366x768 DMT Reduced Blanking
      adv7604: set restart_stdi_once flag when signal is lost.
      adv7604: sync polarities from platform data
      adv7842: Re-worked query_dv_timings()
      adv7842: corrected setting of cp-register 0x91 and 0x8f.
      adv7842: properly enable/disable the irqs.
      adv7842: save platform data in state struct
      adv7842: added DE vertical position in SDP-io-sync
      adv7842: set defaults spa-location.
      adv7842: 625/525 line standard jitter fix.
      adv7842: set default input in platform-data
      adv7842: increase wait time.
      adv7842: clear edid, if no edid just disable Edid-DDC access
      adv7842: restart STDI once if format is not found.
      adv7842: support g_edid ioctl
      adv7842: i2c dummy clients registration.
      adv7842: enable HDMI/DVI mode irq
      adv7842: composite sd-ram test, clear timings before setting.
      adv7842: obtain free-run mode from the platform_data.
      adv7842: Composite sync adjustment
      adv7842: return 0 if no change in s_dv_timings

Mats Randgaard (16):
      ad9389b: verify EDID header
      adv7604: add support for all the digital input ports
      adv7604: Receive CEA formats as RGB on VGA (RGB) input
      adv7604: select YPbPr if RGB_RANGE_FULL/LIMITED is set for VGA_COMP inputs
      adv7604: set CEC address (SPA) in EDID
      adv7604: improve EDID handling
      adv7604: remove connector type. Never used for anything useful.
      adv7604: return immediately if the new input is equal to what is configured
      adv7604: remove debouncing of ADV7604_FMT_CHANGE events
      adv7604: improve HDMI audio handling
      adv7604: adjust gain and offset for DVI-D signals
      adv7604: Enable HDMI_MODE interrupt
      adv7604: return immediately if the new timings are equal to what is configured
      adv7842: remove connector type. Never used for anything useful
      adv7842: Use defines to select EDID port
      adv7842: mute audio before switching inputs to avoid noise/pops

Mikhail Khelik (1):
      adv7604: add hdmi driver strength adjustment

 arch/blackfin/mach-bf609/boards/ezkit.c |   4 +-
 drivers/media/i2c/ad9389b.c             | 277 +++++++++++++++++++-----------------
 drivers/media/i2c/adv7511.c             |  64 +++++++--
 drivers/media/i2c/adv7604.c             | 645 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 drivers/media/i2c/adv7842.c             | 646 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------
 include/media/adv7604.h                 |  38 +++--
 include/media/adv7842.h                 |  59 ++++++--
 7 files changed, 1135 insertions(+), 598 deletions(-)
