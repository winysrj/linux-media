Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5D4C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 22:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D72C21841
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 22:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfBHWPX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 17:15:23 -0500
Received: from gofer.mess.org ([88.97.38.141]:55335 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbfBHWPX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 17:15:23 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 3805E603E8; Fri,  8 Feb 2019 22:15:22 +0000 (GMT)
Date:   Fri, 8 Feb 2019 22:15:22 +0000
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL FOR v5.1] RC fixes
Message-ID: <20190208221521.77vwne4szl4f4qp3@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here are the last RC fixes for 5.1.

Thanks,

Sean

The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:

  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v5.1b

for you to fetch changes up to a82c3d00eaee0b18d3fe8e62bdde7e349d72ec97:

  media: smipcie: add universal ir capability (2019-02-08 21:56:54 +0000)

----------------------------------------------------------------
Matthias Reichl (1):
      media: rc: ir-rc6-decoder: enable toggle bit for Zotac remotes

Patrick Lerda (2):
      media: rc: rcmm decoder and encoder
      media: smipcie: add universal ir capability

 MAINTAINERS                              |   5 +
 drivers/media/pci/smipcie/smipcie-ir.c   | 132 ++++++----------
 drivers/media/pci/smipcie/smipcie.h      |   1 -
 drivers/media/rc/Kconfig                 |  13 ++
 drivers/media/rc/Makefile                |   1 +
 drivers/media/rc/ir-rc6-decoder.c        |   2 +
 drivers/media/rc/ir-rcmm-decoder.c       | 254 +++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h          |   5 +
 drivers/media/rc/rc-main.c               |   9 ++
 include/media/rc-map.h                   |  14 +-
 include/uapi/linux/lirc.h                |   6 +
 tools/include/uapi/linux/lirc.h          |  12 ++
 tools/testing/selftests/ir/ir_loopback.c |   9 ++
 13 files changed, 372 insertions(+), 91 deletions(-)
 create mode 100644 drivers/media/rc/ir-rcmm-decoder.c
