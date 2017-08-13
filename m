Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35908 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdHMMne (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 08:43:34 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, mkrufky@linuxtv.org, eric@anholt.net,
        stefan.wahren@i2se.com, gregkh@linuxfoundation.org,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, balbi@kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 0/6] drivers: make snd_pcm_hardware const
Date: Sun, 13 Aug 2017 18:13:07 +0530
Message-Id: <1502628193-3343-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make snd_pcm_hardware structures const.

Bhumika Goyal (6):
  [media] usb: make snd_pcm_hardware const
  [media] pci: make snd_pcm_hardware const
  drm: bridge: dw-hdmi: make snd_pcm_hardware const
  usb: gadget: make snd_pcm_hardware const
  staging: bcm2835-audio:  make snd_pcm_hardware const
  [media] tuners: make snd_pcm_hardware const

 drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c       | 2 +-
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c                | 4 ++--
 drivers/media/pci/cx18/cx18-alsa-pcm.c                    | 2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c                  | 2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c                  | 2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c                    | 2 +-
 drivers/media/pci/saa7134/saa7134-alsa.c                  | 2 +-
 drivers/media/tuners/tda18271-maps.c                      | 4 ++--
 drivers/media/usb/cx231xx/cx231xx-audio.c                 | 2 +-
 drivers/media/usb/em28xx/em28xx-audio.c                   | 2 +-
 drivers/media/usb/go7007/snd-go7007.c                     | 2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c                    | 2 +-
 drivers/media/usb/usbtv/usbtv-audio.c                     | 2 +-
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c | 4 ++--
 drivers/usb/gadget/function/u_audio.c                     | 2 +-
 15 files changed, 18 insertions(+), 18 deletions(-)

-- 
1.9.1
