Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46626 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbbEYMPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 08:15:51 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 48BB82A0095
	for <linux-media@vger.kernel.org>; Mon, 25 May 2015 14:15:45 +0200 (CEST)
Message-ID: <55631271.4070000@xs4all.nl>
Date: Mon, 25 May 2015 14:15:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 2a80f296422a01178d0a993479369e94f5830127:

  [media] dvb-core: fix 32-bit overflow during bandwidth calculation (2015-05-20 14:01:46 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2l

for you to fetch changes up to 151dc7fb65b0634a853645fe559dabef0ed59612:

  wl128x: Allow compile test of GPIO consumers if !GPIOLIB (2015-05-25 14:14:31 +0200)

----------------------------------------------------------------
Florian Echtler (4):
      reduce poll interval to allow full 60 FPS framerate
      add frame size/frame rate query functions
      add extra debug output, remove noisy warning
      return BUF_STATE_ERROR if streaming stopped during acquisition

Geert Uytterhoeven (1):
      wl128x: Allow compile test of GPIO consumers if !GPIOLIB

 drivers/input/touchscreen/sur40.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/media/radio/wl128x/Kconfig |  4 ++--
 2 files changed, 46 insertions(+), 4 deletions(-)
