Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59406 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbcFGTEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 15:04:14 -0400
Received: from dyn3-82-128-184-205.psoas.suomi.net ([82.128.184.205] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <crope@iki.fi>)
	id 1bAMIM-0004P7-Qn
	for linux-media@vger.kernel.org; Tue, 07 Jun 2016 22:04:11 +0300
To: LMML <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL 4.8] af9035
Message-ID: <ba41ecf5-d862-5f17-f8ab-9ca2e85287ee@iki.fi>
Date: Tue, 7 Jun 2016 22:04:10 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 94d0eaa419871a6e2783f8c131b1d76d5f2a5524:

   [media] mn88472: move out of staging to media (2016-06-07 15:46:47 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9035

for you to fetch changes up to 04c5e503b7f0e1dc3bb40b2ed1f4ab7e6e43e5fd:

   af9035: fix logging (2016-06-07 22:02:33 +0300)

----------------------------------------------------------------
Alessandro Radicati (2):
       af9035: I2C combined write + read transaction fix
       af9035: fix for MXL5007T devices with I2C read issues

Antti Palosaari (1):
       af9035: fix logging

  drivers/media/usb/dvb-usb-v2/af9035.c | 227 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------
  drivers/media/usb/dvb-usb-v2/af9035.h |   1 +
  2 files changed, 133 insertions(+), 95 deletions(-)


-- 
http://palosaari.fi/
