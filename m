Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37655 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757635Ab3FCW6h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jun 2013 18:58:37 -0400
Received: from dyn3-82-128-191-187.psoas.suomi.net ([82.128.191.187] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1Ujdi0-0003KP-J2
	for linux-media@vger.kernel.org; Tue, 04 Jun 2013 01:58:36 +0300
Message-ID: <51AD1F76.8010406@iki.fi>
Date: Tue, 04 Jun 2013 01:57:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.11] minor af9035 changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit aa4f608478acb7ed69dfcff4f3c404100b78ac49:

   Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k 
(2013-06-03 18:09:42 +0900)

are available in the git repository at:


   git://linuxtv.org/anttip/media_tree.git af9035

for you to fetch changes up to fa0dbea859c1e52f74264e465609e3a1a32a92f2:

   af9035: correct TS mode handling (2013-06-04 01:39:51 +0300)

----------------------------------------------------------------
Antti Palosaari (4):
       af9035: implement I2C adapter read operation
       af9035: make checkpatch.pl happy!
       af9035: minor log writing changes
       af9035: correct TS mode handling

  drivers/media/usb/dvb-usb-v2/af9035.c | 66 
++++++++++++++++++++++++++++++++++++++++++++----------------------
  drivers/media/usb/dvb-usb-v2/af9035.h | 11 ++++++++---
  2 files changed, 52 insertions(+), 25 deletions(-)

-- 
http://palosaari.fi/
