Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2021 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3JDKhv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 06:37:51 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id r94AbmRi009561
	for <linux-media@vger.kernel.org>; Fri, 4 Oct 2013 12:37:50 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id DA9BD2A0769
	for <linux-media@vger.kernel.org>; Fri,  4 Oct 2013 12:37:43 +0200 (CEST)
Message-ID: <524E9A77.7090205@xs4all.nl>
Date: Fri, 04 Oct 2013 12:37:43 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.13] Various fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just a bunch of various fixes. Most notably the solo fixes for big-endian systems:
these fixes were removed when I did the large sync to the Bluecherry code base for the
solo driver. Many thanks to Krzysztof for doing this work again.

Regards,

	Hans

The following changes since commit d10e8280c4c2513d3e7350c27d8e6f0fa03a5f71:

  [media] cx24117: use hybrid_tuner_request/release_state to share state between multiple instances (2013-10-03 07:40:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.13

for you to fetch changes up to fffc9c8a324c7b43db9e359ae4710176fa66f432:

  radio-sf16fmr2: Remove redundant dev_set_drvdata (2013-10-04 12:32:42 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      snd_tea575x: precedence bug in fmr2_tea575x_get_pins()

Krzysztof Hałasa (4):
      SOLO6x10: don't do DMA from stack in solo_dma_vin_region().
      SOLO6x10: Remove unused #define SOLO_DEFAULT_GOP
      SOLO6x10: Fix video encoding on big-endian systems.
      SOLO6x10: Fix video headers on certain hardware.

Michael Opdenacker (1):
      davinci: remove deprecated IRQF_DISABLED

Sachin Kamat (1):
      radio-sf16fmr2: Remove redundant dev_set_drvdata

Sylwester Nawrocki (1):
      v4l2-ctrls: Correct v4l2_ctrl_get_int_menu() function prototype

 drivers/media/platform/davinci/vpbe_display.c      |   2 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   4 +-
 drivers/media/radio/radio-sf16fmr2.c               |   5 +--
 drivers/media/v4l2-core/v4l2-ctrls.c               |   6 +--
 drivers/staging/media/solo6x10/solo6x10-disp.c     |  24 ++++++++----
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 153 ++++++++++++++++++++++++++++++++++++++++++++-----------------------------
 drivers/staging/media/solo6x10/solo6x10.h          |   1 -
 include/media/v4l2-common.h                        |   2 +-
 8 files changed, 117 insertions(+), 80 deletions(-)
