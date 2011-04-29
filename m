Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:57077 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab1D2RFN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 13:05:13 -0400
Message-ID: <4DBAEFC5.8080707@iki.fi>
Date: Fri, 29 Apr 2011 20:05:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL FOR 2.6.40] Anysee
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Mauro,

PULL following patches for the 2.6.40.

This basically adds support for two Anysee satellite models:
1. E30 S2 Plus
2. E7 S2


t. Antti

The following changes since commit f5bc5d1d4730bce69fbfdc8949ff50b49c70d934:

   anysee: add more info about known board configs (2011-04-13 02:17:11 
+0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git anysee

Antti Palosaari (3):
       cx24116: add config option to split firmware download
       anysee: add support for Anysee E30 S2 Plus
       anysee: add support for Anysee E7 S2

  drivers/media/dvb/dvb-usb/Kconfig     |    4 +
  drivers/media/dvb/dvb-usb/anysee.c    |  103 
+++++++++++++++++++++++++++++++++
  drivers/media/dvb/dvb-usb/anysee.h    |    1 +
  drivers/media/dvb/frontends/cx24116.c |   17 +++++-
  drivers/media/dvb/frontends/cx24116.h |    3 +
  5 files changed, 125 insertions(+), 3 deletions(-)

-- 
http://palosaari.fi/
