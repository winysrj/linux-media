Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47614 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382Ab2EGSoq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 14:44:46 -0400
Message-ID: <4FA81818.1000006@iki.fi>
Date: Mon, 07 May 2012 21:44:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
CC: Gianluca Gennari <gennarone@gmail.com>,
	=?windows-1252?Q?Michael_B=FC?= =?windows-1252?Q?sch?=
	<m@bues.ch>, Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [GIT PULL FOR 3.5] AF9035/AF9033
References: <4F75A7FE.8090405@iki.fi>
In-Reply-To: <4F75A7FE.8090405@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Mauro,

Some AF9035/AF9033 changes for the 3.5!

Do you have idea about last date for the 3.5 PULL requests?

regards
Antti



The following changes since commit cd58ef79264198a905367d19b1a110c2f6ac1156:

   af9035: disable frontend0 I2C-gate control (2012-04-06 13:09:23 +0300)

are available in the git repository at:
   git://linuxtv.org/anttip/media_tree.git af9035

Antti Palosaari (5):
       af9035: various small changes for af9035_ctrl_msg()
       af9035: remove unused struct
       af9035: move device configuration to the state
       af9035: remove one config parameter
       af9035: add few new reference design USB IDs

Hans-Frieder Vogt (2):
       af9035: add remote control support
       af9033: implement ber and ucb functions

  drivers/media/dvb/dvb-usb/af9035.c      |  174 
++++++++++++++++++++++---------
  drivers/media/dvb/dvb-usb/af9035.h      |   23 ++---
  drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    7 +-
  drivers/media/dvb/frontends/af9033.c    |   65 +++++++++++-
  4 files changed, 202 insertions(+), 67 deletions(-)


-- 
http://palosaari.fi/
