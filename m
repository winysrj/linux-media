Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaAFNE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 08:04:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2] tuner-xc2028: Fix xc3028 timeouts
Date: Mon,  6 Jan 2014 08:01:31 -0200
Message-Id: <1389002493-20134-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When xc2028/3028 is powered down, it won't response to any command, until
a firmware is loaded. That means that reading frontend status will fail
with a timeout.

Also, any trial to put the device to sleep twice will fail.

This small series fix those two bugs.

Mauro Carvalho Chehab (2):
  tuner-xc2028: Don't try to sleep twice
  tuner-xc2028: Don't read status if device is powered down

 drivers/media/tuners/tuner-xc2028.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

-- 
1.8.3.1

