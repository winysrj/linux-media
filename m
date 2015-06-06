Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50671 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbbFFL10 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:27:26 -0400
Message-ID: <5572D91A.5060706@iki.fi>
Date: Sat, 06 Jun 2015 14:27:22 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [GIT PULL 4.2] error handling fixes
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There drivers were converted during 4.2 from media attach to I2C client 
binding. Media attach returns always only NULL on error case, but I2C 
probe uses error codes, so copy & pasting and some error statuses were 
missing.

Antti

The following changes since commit 839aa56d077972170a074bcbe31bf0d7eba37b24:

   [media] v4l2-ioctl: log buffer type 0 correctly (2015-06-06 07:43:49 
-0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git 4.2_fixes

for you to fetch changes up to fac47f02e68f2b718c0280d372d633cb9798b2c5:

   fc2580: add missing error status when probe() fails (2015-06-06 
14:15:34 +0300)

----------------------------------------------------------------
Antti Palosaari (2):
       tda10071: add missing error status when probe() fails
       fc2580: add missing error status when probe() fails

Dan Carpenter (1):
       m88ds3103: a couple missing error codes

  drivers/media/dvb-frontends/m88ds3103.c |  5 ++++-
  drivers/media/dvb-frontends/tda10071.c  | 18 +++++++++++++++---
  drivers/media/tuners/fc2580.c           |  1 +
  3 files changed, 20 insertions(+), 4 deletions(-)

-- 
http://palosaari.fi/
