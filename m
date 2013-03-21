Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:37308 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3CURue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 13:50:34 -0400
Received: by mail-ea0-f169.google.com with SMTP id z7so1044970eaf.28
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 10:50:33 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/8] bttv: refactor audio_mux() and fix muting/unmuting
Date: Thu, 21 Mar 2013 18:51:12 +0100
Message-Id: <1363888280-28724-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series refactors function audio_mux() and fixes several issues 
related to muting/unmuting on probing and first open.

Mute on last close will be fixed with further patches which are currently under review.
 
Tested with a Hauppauge WinTV Theatre (model 37284, Rev B421).

Frank Schäfer (8):
  bttv: audio_mux(): use a local variable "gpio_mute" instead of
    modifying the function parameter "mute"
  bttv: audio_mux(): do not change the value of the v4l2 mute control
  bttv: do not save the audio input in audio_mux()
  bttv: rename field 'audio' in struct 'bttv' to 'audio_input'
  bttv: separate GPIO part from function audio_mux()
  bttv: untangle audio input and mute setting
  bttv: do not unmute the device before the first open
  bttv: apply mute settings on open

 drivers/media/pci/bt8xx/bttv-cards.c  |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c |   94 ++++++++++++++++++---------------
 drivers/media/pci/bt8xx/bttvp.h       |    2 +-
 3 Dateien geändert, 52 Zeilen hinzugefügt(+), 46 Zeilen entfernt(-)

-- 
1.7.10.4

