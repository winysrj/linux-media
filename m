Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:54482 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0JQVck (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 17:32:40 -0400
Message-ID: <4CBB6B75.8020209@iki.fi>
Date: Mon, 18 Oct 2010 00:32:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [GIT PULL FOR 2.6.37] Anysee RC core
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Mauro,

Put Anysee remote to the RC core.

t. Antti


The following changes since commit 4c235b8ba0c25fab25163600da9dbbb082fcf62a:

   V4L/DVB: gp8psk: Add support for the Genpix Skywalker-2 (2010-10-16 
15:37:13 -0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git anysee

Antti Palosaari (2):
       Anysee remote controller
       anysee: switch to RC core

  drivers/media/IR/keymaps/Makefile    |    1 +
  drivers/media/IR/keymaps/rc-anysee.c |   93 
++++++++++++++++++++++++++++++++++
  drivers/media/dvb/dvb-usb/anysee.c   |   87 
++++++++------------------------
  include/media/rc-map.h               |    1 +
  4 files changed, 116 insertions(+), 66 deletions(-)
  create mode 100644 drivers/media/IR/keymaps/rc-anysee.c

-- 
http://palosaari.fi/
