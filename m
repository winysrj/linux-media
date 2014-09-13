Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:38968 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaIMIrt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 04:47:49 -0400
Received: by mail-lb0-f180.google.com with SMTP id b12so2096691lbj.25
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 01:47:47 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/4] em28xx: clean up the audio variable mess
Date: Sat, 13 Sep 2014 10:49:00 +0200
Message-Id: <1410598140-29994-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The audio variables in em28xx are a big mess:
- many have misleading names
- some are completely unnecessary
- some duplicate in parts or even completely the meaning of others
- some device features are described by combinations of multiple variables,
  which makes the code difficult to understand and allows inconsistencies

So clean up the em28xx audio variables:
- Patch 1 removes 3 unneeded audio variables.
- Patch 2 replaces the variables "has_alsa_audio" and "has_audio_class" with a 
  single enum variable describing the type of usb audio (no usb audio / audio class / vendor).
- Patches 3+4 replace the variables "has_audio" and "ac97" of struct em28xx_audio_mode
  with a single enum variable describing the type of internal audio connection (none / ac97 / i2s).
  Variable "audio_mode" is finally removed together with the obsolete structs 
  "em28xx_audio_mode" and "em28xx_ac97_mode".

This simplifies the audio code a lot, making it much more self-explaining and easier to understand.
It will hopefully reduce the risk of audio regression in the future.


Frank Schäfer (4):
  em28xx: remove some unnecessary fields from struct em28xx_audio_mode
  em28xx: simplify usb audio class handling
  em28xx: get rid of field has_audio in struct em28xx_audio_mode
  em28xx: get rid of structs em28xx_ac97_mode and em28xx_audio_mode

 drivers/media/usb/em28xx/em28xx-audio.c | 10 ++---
 drivers/media/usb/em28xx/em28xx-cards.c | 30 +++++++-------
 drivers/media/usb/em28xx/em28xx-core.c  | 72 +++++++++++----------------------
 drivers/media/usb/em28xx/em28xx-video.c |  8 ++--
 drivers/media/usb/em28xx/em28xx.h       | 28 +++++--------
 5 files changed, 59 insertions(+), 89 deletions(-)

-- 
1.8.4.5

