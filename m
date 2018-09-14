Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeINXiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 19:38:19 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/4] em28xx: solve several issues pointed by v4l2-compliance
Date: Fri, 14 Sep 2018 15:22:30 -0300
Message-Id: <cover.1536949178.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several non-compliance issues on em28xx.  Fix those that
I can hit with a simple grabber board like Terratec AV 350.

I also tested it with a WinTV USB2. There, I got several other compliants
all related to msp3400 driver and step size. Fixing those is more complex,
as it would require some non-trivial changes. So, for now, let's do just
the ones that aren't related to msp3400.

Mauro Carvalho Chehab (4):
  media: em28xx: fix handler for vidioc_s_input()
  media: em28xx: use a default format if TRY_FMT fails
  media: em28xx: fix input name for Terratec AV 350
  media: em28xx: make v4l2-compliance happier by starting sequence on
    zero

 drivers/media/usb/em28xx/em28xx-cards.c | 33 ++++++++-
 drivers/media/usb/em28xx/em28xx-video.c | 91 ++++++++++++++++++++++---
 drivers/media/usb/em28xx/em28xx.h       |  8 ++-
 3 files changed, 118 insertions(+), 14 deletions(-)

-- 
2.17.1
