Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:52477 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab3CTTYH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:07 -0400
Received: by mail-ee0-f44.google.com with SMTP id l10so1378060eei.3
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 12:24:05 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: =?UTF-8?q?=5BRFC=20PATCH=2000/10=5D=20bttv=3A=20refactor=20audio=5Fmux=28=29=20and=20fix=20muting/unmuting?=
Date: Wed, 20 Mar 2013 20:24:40 +0100
Message-Id: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series refactors function audio_mux() and fixes several issues 
related to muting/unmuting on probing, first open and last close.

Two thirds of the changes have already been sent as part of the RFC patch series
"bttv: fix muting/unmuting on probing, first open and last close" v1 and v2, 
the new patches 3-6 untagle the mute and input setting code as much as possible
as suggested by hans Verkuil.

Tested with a Hauppauge WinTV Theatre (model 37284, Rev B421).

Frank Schäfer (10):
  bttv: audio_mux(): use a local variable "gpio_mute" instead of
    modifying the function parameter "mute"
  bttv: audio_mux(): do not change the value of the v4l2 mute control
  bttv: do not save the audio input in audio_mux()
  bttv: rename field 'audio' in struct 'bttv' to 'audio_input'
  bttv: separate GPIO part from function audio_mux()
  bttv: untangle audio input and mute setting
  bttv: do not unmute the device before the first open
  bttv: apply mute settings on open
  bttv: fix mute on last close of the video device node
  bttv: avoid mute on last close when the radio device node is still
    open

 drivers/media/pci/bt8xx/bttv-cards.c  |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c |  101 ++++++++++++++++++---------------
 drivers/media/pci/bt8xx/bttvp.h       |    2 +-
 3 Dateien geändert, 57 Zeilen hinzugefügt(+), 48 Zeilen entfernt(-)

-- 
1.7.10.4

