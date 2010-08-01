Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab0HAN1b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 09:27:31 -0400
Date: Sun, 1 Aug 2010 10:27:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: patrick.boettcher@desy.de,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] Automatically set RC/NEC protocols on dib0700
Message-ID: <20100801102747.7151c367@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set implements rc-core change_protocol callback. With this,
the dib0700 driver will automatically set the right protocol, depending on
the device model, and, if the user wants, the table can be easily replaced
at userspace, via ir-keytable application, available at v4l-utils git tree.

Mauro Carvalho Chehab (3):
  V4L/DVB: dib0700: break keytable into NEC and RC-5 variants
  V4L/DVB: dib0700: properly implement IR change_protocol
  V4L/DVB: dib0700: Fix RC protocol logic to properly handle NEC/NECx
    and RC-5

 drivers/media/IR/keymaps/Makefile           |    3 +-
 drivers/media/IR/keymaps/rc-dib0700-big.c   |  314 ---------------------------
 drivers/media/IR/keymaps/rc-dib0700-nec.c   |  124 +++++++++++
 drivers/media/IR/keymaps/rc-dib0700-rc5.c   |  235 ++++++++++++++++++++
 drivers/media/dvb/dvb-usb/dib0700.h         |    1 +
 drivers/media/dvb/dvb-usb/dib0700_core.c    |  115 ++++++----
 drivers/media/dvb/dvb-usb/dib0700_devices.c |  183 +++++++++++++---
 drivers/media/dvb/dvb-usb/dvb-usb.h         |    2 +
 include/media/rc-map.h                      |    5 +-
 9 files changed, 588 insertions(+), 394 deletions(-)
 delete mode 100644 drivers/media/IR/keymaps/rc-dib0700-big.c
 create mode 100644 drivers/media/IR/keymaps/rc-dib0700-nec.c
 create mode 100644 drivers/media/IR/keymaps/rc-dib0700-rc5.c

