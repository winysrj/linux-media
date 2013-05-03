Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:43747 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762722Ab3ECII7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 04:08:59 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: mchehab@redhat.com
Cc: ezequiel.garcia@free-electrons.com, linux-media@vger.kernel.org,
	jonjon.arnearne@gmail.com
Subject: [PATCH V4 0/3] saa7115: add the gm7113c chip
Date: Fri,  3 May 2013 10:11:55 +0200
Message-Id: <1367568718-4129-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The purpose of this patch is to add support for the gm7113c chip in the saa7115 driver.
The gm7113c chip is a chinese clone of the Philips/NXP saa7113 chip.
The chip is found in several cheap usb video capture devices.

This is the forth version of a patch-set previously posted by Mauro,
the first verson was posted on 26 April, and can be found here:
http://www.spinics.net/lists/linux-media/msg63079.html

The second version was posted by Mauro on 26 April, and can be found here:
http://www.spinics.net/lists/linux-media/msg63087.html

The third version was posted by me on 29 April and had a bad cover-letter:
http://www.spinics.net/lists/linux-media/msg63163.html

This version has a better cover-letter and I've added a commit message to the last patch.

Jon Arne Jørgensen (3):
  saa7115: move the autodetection code out of the probe function
  saa7115: add detection code for gm7113c
  saa7115: Add register setup and config for gm7113c

 drivers/media/i2c/saa7115.c     | 206 +++++++++++++++++++++++++++++-----------
 include/media/v4l2-chip-ident.h |   2 +
 2 files changed, 153 insertions(+), 55 deletions(-)

-- 
1.8.2.1

