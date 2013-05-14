Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60049 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3ENKpt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 06:45:49 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/5] media: i2c: tvp7002 feature enhancement and cleanup
Date: Tue, 14 May 2013 16:15:29 +0530
Message-Id: <1368528334-13595-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series enables tvp7002 decoder driver for asynchronous probing
and adds OF support, with few cleanup patches.

Lad, Prabhakar (5):
  media: i2c: tvp7002: remove duplicate define
  media: i2c: tvp7002: rearrange description of structure members
  media: i2c: tvp7002: rearrange header inclusion alphabetically
  media: i2c: tvp7002: add support for asynchronous probing
  media: i2c: tvp7002: add OF support

 .../devicetree/bindings/media/i2c/tvp7002.txt      |   42 ++++++++++
 drivers/media/i2c/tvp7002.c                        |   82 ++++++++++++++++----
 include/media/tvp7002.h                            |   44 +++++------
 3 files changed, 130 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt

-- 
1.7.4.1

