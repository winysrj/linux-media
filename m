Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8BBC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 11:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41BB0214C6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 11:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfAJLSx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 06:18:53 -0500
Received: from gofer.mess.org ([88.97.38.141]:36985 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbfAJLSx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 06:18:53 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id F31F4600E8; Thu, 10 Jan 2019 11:18:51 +0000 (GMT)
Date:   Thu, 10 Jan 2019 11:18:51 +0000
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL FOR v5.1] Various fixes
Message-ID: <20190110111851.7ncrfzuayab5mqig@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here are some of the dvb fixes and the rc fixes for 5.1. Please pull.

Thanks,

Sean

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v5.1a

for you to fetch changes up to 959614504ebff677711d271792f7c1ffee818e86:

  media: dvb: Add check on sp8870_readreg (2019-01-10 11:11:13 +0000)

----------------------------------------------------------------
Aditya Pakki (2):
      media: dvb: add return value check on Write16
      media: dvb: Add check on sp8870_readreg

Arnd Bergmann (1):
      media: seco-cec: fix RC_CORE dependency

Colin Ian King (1):
      media: cxd2880-spi: fix two memory leaks of dvb_spi

Ettore Chimenti (1):
      media: secocec: fix ir address shift

Kangjie Lu (2):
      media: lgdt3306a: fix a missing check of return value
      media: mt312: fix a missing check of mt312 reset

 drivers/media/dvb-frontends/drxd_hard.c    | 30 +++++++++++++++++++-----------
 drivers/media/dvb-frontends/lgdt3306a.c    |  5 ++++-
 drivers/media/dvb-frontends/mt312.c        |  4 +++-
 drivers/media/dvb-frontends/sp8870.c       |  4 +++-
 drivers/media/platform/Kconfig             |  2 +-
 drivers/media/platform/seco-cec/seco-cec.h |  2 +-
 drivers/media/spi/cxd2880-spi.c            |  8 +++++---
 7 files changed, 36 insertions(+), 19 deletions(-)
