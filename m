Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39784 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3CJVxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 17:53:16 -0400
Received: by mail-ea0-f174.google.com with SMTP id q10so875486eaj.19
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 14:53:15 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH v2 0/6] bttv: fix muting/unmuting on probing, first open and last close
Date: Sun, 10 Mar 2013 22:53:48 +0100
Message-Id: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fixes some remaining issues with regards to device 
muting/unmuting on probing, first open and last close with the bttv driver.

The first 2 patches are preparatory patches, patches 3 to 6 the actual fixes.

Changes since v1:
- splitted patch 1 to 4 separate patches (patches 1-4)
- dropped patch 2 (mute on last close of the radio device node)
- added patches 5+6

Frank Schäfer (6):
  bttv: audio_mux() use a local variable "gpio_mute" instead of
    modifying the function parameter "mute"
  bttv: audio_mux(): do not change the value of the v4l2 mute control
  bttv: fix mute on last close of the video device node
  bttv: do not unmute the device before the first open
  bttv: avoid mute on last close when the radio device node is still
    open
  bttv: radio: apply mute settings on open

 drivers/media/pci/bt8xx/bttv-driver.c |   34 +++++++++++++++++++--------------
 1 Datei geändert, 20 Zeilen hinzugefügt(+), 14 Zeilen entfernt(-)

-- 
1.7.10.4

