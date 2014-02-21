Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1346 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbaBUI1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 03:27:46 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1L8Rhmp051023
	for <linux-media@vger.kernel.org>; Fri, 21 Feb 2014 09:27:45 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8EF0F2A01A7
	for <linux-media@vger.kernel.org>; Fri, 21 Feb 2014 09:27:40 +0100 (CET)
Message-ID: <53070DFC.9010406@xs4all.nl>
Date: Fri, 21 Feb 2014 09:27:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] 3.15 updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Some sleep_on race fixes, s2255 driver cleanups and vb2 conversion and
some ths8200 fixes.

This pull request superseded https://patchwork.linuxtv.org/patch/22207/.
The only change is the addition of the "s2255drv: upgrade to videobuf2"
patch which completes the vb2 conversion of that driver.

Regards,

	Hans

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.15b

for you to fetch changes up to 311445baf9e1e35cdaf5e32951c0c5487804212b:

  s2255drv: upgrade to videobuf2 (2014-02-21 08:50:26 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      omap_vout: avoid sleep_on race

Dean Anderson (7):
      s2255drv: removal of s2255_dmaqueue structure
      s2255drv: refactoring s2255_channel to s2255_vc
      s2255drv: buffer setup fix
      s2255drv: remove redundant parameter
      s2255drv: dynamic memory allocation efficiency fix
      s2255drv: fix for return code not checked
      s2255drv: cleanup of s2255_fh

Hans Verkuil (1):
      radio-cadet: avoid interruptible_sleep_on race

Martin Bugge (3):
      ths8200: Zero blanking level for RGB.
      ths8200: Corrected sync polarities setting.
      ths8200: Format adjustment.

sensoray-dev (1):
      s2255drv: upgrade to videobuf2

 drivers/media/i2c/ths8200.c                  |   26 +-
 drivers/media/platform/omap/omap_vout_vrfb.c |    3 +-
 drivers/media/radio/radio-cadet.c            |   46 ++--
 drivers/media/usb/s2255/s2255drv.c           | 1077 +++++++++++++++++++++++++++++++-----------------------------------------------
 4 files changed, 470 insertions(+), 682 deletions(-)
