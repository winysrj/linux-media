Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:58279 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab1EYVno (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 17:43:44 -0400
Message-ID: <4DDD780C.30205@iki.fi>
Date: Thu, 26 May 2011 00:43:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 2.6.40] Anysee
References: <4DBAEFC5.8080707@iki.fi> <4DC178C8.4040603@redhat.com>
In-Reply-To: <4DC178C8.4040603@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Mauro,

Two new models and some fixes.


The following changes since commit 87cf028f3aa1ed51fe29c36df548aa714dc7438f:

   [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control 
through GPIO reworked (2011-05-21 11:10:28 -0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git anysee

Antti Palosaari (4):
       anysee: return EOPNOTSUPP for unsupported I2C messages
       anysee: add support for Anysee E7 PTC
       anysee: add support for Anysee E7 PS2
       anysee: style issues, comments, etc.

  drivers/media/dvb/dvb-usb/anysee.c |   86 
++++++++++++++++++++++++++----------
  drivers/media/dvb/dvb-usb/anysee.h |   16 ++++---
  2 files changed, 71 insertions(+), 31 deletions(-)


t. Antti
-- 
http://palosaari.fi/
