Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37213 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 00/14] IT9135 changes
Date: Sat,  9 Aug 2014 23:26:58 +0300
Message-Id: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some changes related to IT9135 chip versions. Mostly for better
sensitivity but also power management. I am considering to send
some of these to stable +3.15 too, but not sure yet...

These patches are available on Git tree also:
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=af9035

Antti

Antti Palosaari (10):
  af9033: feed clock to RF tuner
  af9033: provide dyn0_clk clock source
  af9035: enable AF9033 demod clock source for IT9135
  it913x: fix tuner sleep power leak
  it913x: avoid division by zero on error case
  it913x: fix IT9135 AX sleep
  af9035: remove AVerMedia eeprom override
  af9035: make checkpatch.pl happy
  af9033: make checkpatch.pl happy
  it913x: make checkpatch.pl happy

Bimow Chen (3):
  get_dvb_firmware: Update firmware of ITEtech IT9135
  af9033: update IT9135 tuner inittabs
  it913x: init tuner on attach

Malcolm Priestley (1):
  af9035: new IDs: add support for PCTV 78e and PCTV 79e

 Documentation/dvb/get_dvb_firmware        | 24 ++++++++++---------
 drivers/media/dvb-core/dvb-usb-ids.h      |  2 ++
 drivers/media/dvb-frontends/af9033.c      | 37 ++++++++++++++++++----------
 drivers/media/dvb-frontends/af9033.h      |  5 ++++
 drivers/media/dvb-frontends/af9033_priv.h | 20 +++++++---------
 drivers/media/tuners/tuner_it913x.c       | 20 ++++++++++++++--
 drivers/media/tuners/tuner_it913x_priv.h  | 12 +++++++++-
 drivers/media/usb/dvb-usb-v2/af9035.c     | 40 +++++++++++++------------------
 8 files changed, 100 insertions(+), 60 deletions(-)

-- 
http://palosaari.fi/

