Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaAJLhQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 06:37:16 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 0/3] em28xx: improve I2C code
Date: Fri, 10 Jan 2014 06:33:37 -0200
Message-Id: <1389342820-12605-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a series of cleanup patches for em28xx I2C. It was originally
part of a series of patches meant to split em28xx V4L2 module, but it
made sense to submit as a separate patch set.

Part of the original series were already merged, as the patches there
were ok.

The first patch on this series caused lots of discussions. I think we
finally got an agreement on it.

The other two patches were just rebased, as the context lines change
due to the changes on the first patch.

Mauro Carvalho Chehab (3):
  [media] em28xx-i2c: Fix error code for I2C error transfers
  [media] em28xx: cleanup I2C debug messages
  [media] em28xx: add timeout debug information if i2c_debug enabled

 drivers/media/usb/em28xx/em28xx-i2c.c | 138 ++++++++++++++++++++--------------
 1 file changed, 83 insertions(+), 55 deletions(-)

-- 
1.8.3.1

