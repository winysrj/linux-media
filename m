Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75186C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 09:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BFC321019
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 09:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfCNJ20 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 05:28:26 -0400
Received: from gofer.mess.org ([88.97.38.141]:53887 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfCNJ20 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 05:28:26 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 21CE760DAC; Thu, 14 Mar 2019 09:28:25 +0000 (GMT)
Date:   Thu, 14 Mar 2019 09:28:24 +0000
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL FOR v5.2] Some DVB and RC fixes
Message-ID: <20190314092824.7xzpj5hqmahotpqb@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Just some minor fixes and device support for Avermedia TD310.

Thanks,

Sean

The following changes since commit 15d90a6ae98e6d2c68497b44a491cb9efbb98ab1:

  media: dvb/earth-pt1: fix wrong initialization for demod blocks (2019-03-04 06:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v5.2a

for you to fetch changes up to d6fee965452adf8e8aedc448fc3d1e4f870e51ed:

  media: em28xx-input: make const array addr_list static (2019-03-11 21:57:08 +0000)

----------------------------------------------------------------
Andreas Kemnade (1):
      media: dvb: init i2c already in it930x_frontend_attach

Colin Ian King (1):
      media: em28xx-input: make const array addr_list static

James Hutchinson (1):
      media: m88ds3103: serialize reset messages in m88ds3103_set_frontend

Jose Alberto Reguero (1):
      media: dvb: Add support for the Avermedia TD310

Kangjie Lu (1):
      media: si2165: fix a missing check of return value

Nicholas Mc Guire (1):
      media: cx23885: check allocation return

Stefan Brüns (1):
      media: dvbsky: Avoid leaking dvb frontend

YueHaibing (2):
      media: rc: remove unused including <linux/version.h>
      media: serial_ir: Fix use-after-free in serial_ir_init_module

 drivers/media/dvb-frontends/m88ds3103.c |   9 ++-
 drivers/media/dvb-frontends/si2165.c    |   8 ++-
 drivers/media/pci/cx23885/cx23885-dvb.c |   5 +-
 drivers/media/rc/ir-rcmm-decoder.c      |   1 -
 drivers/media/rc/serial_ir.c            |   9 +--
 drivers/media/usb/dvb-usb-v2/af9035.c   | 104 +++++++++++++++++---------------
 drivers/media/usb/dvb-usb-v2/af9035.h   |  12 ++++
 drivers/media/usb/dvb-usb-v2/dvbsky.c   |  18 +++---
 drivers/media/usb/em28xx/em28xx-input.c |   2 +-
 include/media/dvb-usb-ids.h             |   1 +
 10 files changed, 93 insertions(+), 76 deletions(-)
