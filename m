Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CB6C04EB8
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 19:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FA812081C
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 19:36:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FA812081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mess.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbeLDTgj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 14:36:39 -0500
Received: from gofer.mess.org ([88.97.38.141]:54371 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbeLDTgj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Dec 2018 14:36:39 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 52B9860825; Tue,  4 Dec 2018 19:36:38 +0000 (GMT)
Date:   Tue, 4 Dec 2018 19:36:38 +0000
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.21] more dvb fixes
Message-ID: <20181204193637.oprzpqjpfeo2i2xj@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

I think these are the all the outstanding dvb patches for the kernel.

Thanks,

Sean

The following changes since commit 9b90dc85c718443a3e573a0ccf55900ff4fa73ae:

  media: seco-cec: add missing header file to fix build (2018-12-03 15:11:00 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.21c

for you to fetch changes up to 669c1d49153a4db43320ba6dcae16a321f5f4ed4:

  media: usb: dvb-usb: remove old friio driver (2018-12-04 19:23:20 +0000)

----------------------------------------------------------------
Corentin Labbe (1):
      media: usb: dvb-usb: remove old friio driver

Malcolm Priestley (2):
      media: lmedm04: Move usb buffer to lme2510_state.
      media: lmedm04: use dvb_usbv2_generic_rw_locked

Nikita Gerasimov (1):
      media: rtl28xxu: add support for Sony CXD2837ER slave demod

Sean Young (1):
      media: dib7000p: Remove dead code

 drivers/media/dvb-frontends/dib7000p.c  |   7 +-
 drivers/media/usb/dvb-usb-v2/Kconfig    |   1 +
 drivers/media/usb/dvb-usb-v2/lmedm04.c  |  73 +----
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |  40 ++-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   4 +-
 drivers/media/usb/dvb-usb/friio-fe.c    | 440 ---------------------------
 drivers/media/usb/dvb-usb/friio.c       | 522 --------------------------------
 drivers/media/usb/dvb-usb/friio.h       |  99 ------
 8 files changed, 60 insertions(+), 1126 deletions(-)
 delete mode 100644 drivers/media/usb/dvb-usb/friio-fe.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.h
