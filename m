Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58623 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752619AbdGKLUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 07:20:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>, dri-devel@lists.freedesktop.org
Subject: [PATCH 0/4] drm/vc4: add HDMI CEC support
Date: Tue, 11 Jul 2017 13:20:17 +0200
Message-Id: <20170711112021.38525-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for HDMI CEC to the vc4 drm driver.
This series is based on the mainline kernel as of yesterday since
both the vc4 and cec patches for the 4.13 merge window are now merged
in that kernel.

Note: the first cec patch is independent of the vc4 patches and will be
merged via the media subsystem for 4.14. Without that patch everything
will still work, but it will attempt to retry messages twice as many
times as it should.

This has been tested with the Raspberry Pi 2B and 3B. I don't have older
rpi's, so I can't test those.

Many thanks to Eric Anholt for his help with this driver!

There is one open issue: when booting the rpi without an HDMI cable 
connected, then CEC won't work. But neither apparently does HDMI since
reconnecting it will not bring back any display.

If you boot with the HDMI cable connected, then all is well and 
disconnecting and reconnecting the cable will do the right thing.

I don't understand what is going on here, but it does not appear to
be CEC related and the same problem occurs without this patch series.

You also need to update your config.txt with this line to prevent the
firmware from eating the CEC interrupts:

mask_gpu_interrupt1=0x100

Eric, I've experimented with setting hdmi_ignore_cec=1 but that simply
doesn't work. Instead that disables CEC completely. With this
mask_gpu_interrupt1 setting everything works perfectly. This also
prevents the firmware from sending the initial Active Source CEC
message so the CPU has full control over the CEC bus, as it should.

My main concern is that this is rather magical, but it is not
something I have any control over.

Regards,

	Hans

Eric Anholt (1):
  drm/vc4: Add register defines for CEC.

Hans Verkuil (3):
  cec: be smarter about detecting the number of attempts made
  drm/vc4: prepare for CEC support
  drm/vc4: add HDMI CEC support

 drivers/gpu/drm/vc4/Kconfig    |   8 ++
 drivers/gpu/drm/vc4/vc4_hdmi.c | 278 +++++++++++++++++++++++++++++++++++------
 drivers/gpu/drm/vc4/vc4_regs.h | 113 +++++++++++++++++
 drivers/media/cec/cec-adap.c   |   9 +-
 4 files changed, 371 insertions(+), 37 deletions(-)

-- 
2.11.0
