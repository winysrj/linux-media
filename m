Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:50141 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab0JWKtb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 06:49:31 -0400
Message-ID: <4CC2BDB7.1010502@iki.fi>
Date: Sat, 23 Oct 2010 13:49:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
CC: Renura Enterprises Pty Ltd <renura@digitalnow.com.au>,
	Bernard Giannetti <thebernmeister@hotmail.com>
Subject: [GIT PULL FOR 2.6.37] af9015 new device and remote controller changes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Moikka Mauro,

PULL following changes to the 2.6.37-RC1.

t. Antti

The following changes since commit a348e9110ddb5d494e060d989b35dd1f35359d58:

   [media] cx25840: fix problem with Terratec Grabster AV400 (2010-10-18 
04:11:44 -0200)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git af9015

Antti Palosaari (4):
       af9015: RC fixes and improvements
       DigitalNow TinyTwin remote controller
       af9015: map DigitalNow TinyTwin v2 remote
       af9015: support for DigitalNow TinyTwin v3 [1f4d:9016]

  drivers/media/IR/keymaps/Makefile                 |    1 +
  drivers/media/IR/keymaps/rc-digitalnow-tinytwin.c |   98 
+++++++++++++++++++++
  drivers/media/dvb/dvb-usb/af9015.c                |   88 
+++++++++----------
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h           |    2 +
  include/media/rc-map.h                            |    1 +
  5 files changed, 142 insertions(+), 48 deletions(-)
  create mode 100644 drivers/media/IR/keymaps/rc-digitalnow-tinytwin.c

-- 
http://palosaari.fi/
