Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:33081 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759053Ab3D2UiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 16:38:03 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: mchehab@redhat.com
Cc: ezequiel.garcia@free-electrons.com, linux-media@vger.kernel.org,
	jonjon.arnearne@gmail.com
Subject: [PATCH 0/3] saa7115: add detection code for gm7113c 
Date: Mon, 29 Apr 2013 22:41:06 +0200
Message-Id: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second version of a patch-set previously posted by Mauro,
the first verseon was posted on 26 April, and can be found here:
http://www.spinics.net/lists/linux-media/msg63079.html

The purpose of this patch is to add support for the gm7113c chip in the saa7115 driver.
The gm7113c chip is a chinese clone of the Philips/NXP saa7113 chip.
The chip is found in several cheap usb video capture devices.

 drivers/media/i2c/saa7115.c     | 207 +++++++++++++++++++++++++++++-----------
 include/media/v4l2-chip-ident.h |   2 +
 2 files changed, 155 insertions(+), 54 deletions(-)

