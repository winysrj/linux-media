Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2100 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaCQNZu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 09:25:50 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id s2HDPl2b009766
	for <linux-media@vger.kernel.org>; Mon, 17 Mar 2014 14:25:49 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B86A12A188B
	for <linux-media@vger.kernel.org>; Mon, 17 Mar 2014 14:25:37 +0100 (CET)
Message-ID: <5326F7D1.2000508@xs4all.nl>
Date: Mon, 17 Mar 2014 14:25:37 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] Two fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ed97a6fe5308e5982d118a25f0697b791af5ec50:

  [media] af9033: Don't export functions for the hardware filter (2014-03-14 20:26:59 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.15f

for you to fetch changes up to a05c0cc3764a013444fd7e0aad194f3474470d6d:

  Sensoray 2255 uses videobuf2 (2014-03-17 14:24:44 +0100)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      adv7180: free an interrupt on failure paths in init_device()

Arnd Bergmann (1):
      Sensoray 2255 uses videobuf2

 drivers/media/i2c/adv7180.c     | 18 +++++++++++-------
 drivers/media/usb/s2255/Kconfig |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)
