Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60247 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaHRMEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 08:04:36 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2] au0828: Fix a bug when loading firmware with Dvico USB stick
Date: Mon, 18 Aug 2014 06:51:27 -0500
Message-Id: <1408362689-25583-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to have the tuner type filed for all devices, for the
logic inside the I2C core to work. So, warrant that tuner type
can be used by all entries and add the proper values there.

Mauro Carvalho Chehab (2):
  au0828: explicitly identify boards with analog TV
  au0828: fill tuner type on all boards

 drivers/media/usb/au0828/au0828-cards.c | 22 +++++++++-------------
 drivers/media/usb/au0828/au0828.h       |  1 +
 2 files changed, 10 insertions(+), 13 deletions(-)

-- 
1.9.3

