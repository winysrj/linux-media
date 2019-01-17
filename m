Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED038C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3C1520855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 15:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfAQP3m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:29:42 -0500
Received: from gofer.mess.org ([88.97.38.141]:56073 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfAQP3m (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 10:29:42 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id D63796031C; Thu, 17 Jan 2019 15:29:39 +0000 (GMT)
From:   Sean Young <sean@mess.org>
To:     Patrick Lerda <patrick9876@free.fr>, linux-media@vger.kernel.org
Subject: [PATCH 0/2] rcmm with minor tweaks and selftest
Date:   Thu, 17 Jan 2019 15:29:37 +0000
Message-Id: <cover.1547738495.git.sean@mess.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Patrick,

I've made some very minor/cosmetic changes and added rcmm to the selftest;
I didn't want to just add them to the tree without showing to you first.

Let me know what you think.

Thanks
Sean

Patrick Lerda (1):
  media: rc: rcmm decoder and encoder

Sean Young (1):
  selftests: Use lirc.h from kernel tree, not from system

 MAINTAINERS                              |   5 +
 drivers/media/rc/Kconfig                 |  13 ++
 drivers/media/rc/Makefile                |   1 +
 drivers/media/rc/ir-rcmm-decoder.c       | 254 +++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h          |   5 +
 drivers/media/rc/rc-main.c               |   9 +
 include/media/rc-map.h                   |  14 +-
 include/uapi/linux/lirc.h                |   6 +
 tools/include/uapi/linux/lirc.h          |  12 ++
 tools/testing/selftests/ir/Makefile      |   2 +
 tools/testing/selftests/ir/ir_loopback.c |   9 +
 11 files changed, 327 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/rc/ir-rcmm-decoder.c

-- 
2.20.1

