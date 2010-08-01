Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0HAUS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 16:18:26 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o71KIQYh022900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Aug 2010 16:18:26 -0400
Received: from pedra (vpn-10-244.rdu.redhat.com [10.11.10.244])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o71KIMmb018029
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 1 Aug 2010 16:18:25 -0400
Date: Sun, 1 Aug 2010 17:17:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/6] More patches for Remote Controllers
Message-ID: <20100801171721.668d52db@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series contain basically two groups of changes:
	1) some fixes for dib0700 IR handling;
	2) rewrite of siano IR implementation to use rc-core.

Mauro Carvalho Chehab (6):
  V4L/DVB: dib0700: properly implement IR change_protocol
  V4L/DVB: dib0700: Fix RC protocol logic to properly handle NEC/NECx
    and RC-5
  V4L/DVB: smsusb: enable IR port for Hauppauge WinTV MiniStick
  V4L/DVB: standardize names at rc-dib0700 tables
  V4L/DVB: sms: properly initialize IR phys and IR name
  V4L/DVB: sms: Convert IR support to use the Remote Controller core

 drivers/media/IR/ir-keytable.c              |    5 +-
 drivers/media/IR/keymaps/rc-dib0700-nec.c   |   12 +-
 drivers/media/IR/keymaps/rc-dib0700-rc5.c   |   12 +-
 drivers/media/dvb/dvb-usb/dib0700.h         |    1 +
 drivers/media/dvb/dvb-usb/dib0700_core.c    |  115 +++++++-----
 drivers/media/dvb/dvb-usb/dib0700_devices.c |  118 ++++++++++--
 drivers/media/dvb/dvb-usb/dvb-usb.h         |    2 +
 drivers/media/dvb/siano/sms-cards.c         |    2 +
 drivers/media/dvb/siano/sms-cards.h         |    2 +-
 drivers/media/dvb/siano/smsir.c             |  267 ++++-----------------------
 drivers/media/dvb/siano/smsir.h             |   63 ++-----
 drivers/media/dvb/siano/smsusb.c            |    3 +-
 12 files changed, 244 insertions(+), 358 deletions(-)

