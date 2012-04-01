Return-path: <linux-media-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:40040 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab2DAUug (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 16:50:36 -0400
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Stephan Raue <stephan@openelec.tv>,
	Martin Beyss <Martin.Beyss@rwth-aachen.de>
Subject: [PATCH 0/2] [media] ati_remote: Medion X10 Digitainer remote support
Date: Sun,  1 Apr 2012 23:41:44 +0300
Message-Id: <1333312906-9325-1-git-send-email-anssi.hannula@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This patchset adds support for another Medion X10 remote to the
ati_remote driver. See the individual patches for detailed explanations.


Anssi Hannula (2):
      [media] ati_remote: allow specifying a default keymap selector function
      [media] ati_remote: add support for Medion X10 Digitainer remote

 drivers/media/rc/ati_remote.c                      |  124 ++++++++++++++------
 drivers/media/rc/keymaps/Makefile                  |    1 +
 .../media/rc/keymaps/rc-medion-x10-digitainer.c    |  115 ++++++++++++++++++
 include/media/rc-map.h                             |    1 +
 4 files changed, 204 insertions(+), 37 deletions(-)

-- 
Anssi Hannula

