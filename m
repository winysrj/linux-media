Return-path: <mchehab@localhost>
Received: from mail.kapsi.fi ([217.30.184.167]:55607 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab1GLXKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 19:10:41 -0400
Message-ID: <4E1CD46D.5050408@iki.fi>
Date: Wed, 13 Jul 2011 02:10:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, Juergen Lock <nox@jelal.kn-bremen.de>,
	Emilio David Diaus Lopez <reality_es@yahoo.es>
Subject: [GIT PULL FOR 3.0.1] AF9015 changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Moikka Mauro,

Send these to the next possible Kernel as normal changes.

t. Antti


The following changes since commit 0fce922ba851a74cc8bff7084a0a910e521345f2:

   Merge commit '2c53b436a30867eb6b47dd7bab23ba638d1fb0d2' into af9015 
(2011-06-15 14:37:52 +0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git af9015

Antti Palosaari (5):
       af9015: map remote for MSI DIGIVOX Duo
       af9015: small optimization
       af9015: add more I2C msg checks
       af9015: remove old FW based IR polling code
       af9015: remove 2nd I2C-adapter

Emilio David Diaus Lopez (1):
       af9015: add support for Sveon STV22 [1b80:e401]

Juergen Lock (1):
       af9015: setup rc keytable for LC-Power LC-USB-DVBT

  drivers/media/dvb/dvb-usb/af9015.c      |  135 
+++++++++++--------------------
  drivers/media/dvb/dvb-usb/af9015.h      |    1 -
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
  3 files changed, 48 insertions(+), 89 deletions(-)


-- 
http://palosaari.fi/
