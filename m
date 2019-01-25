Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD66C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 07:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C5042184B
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 07:01:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="iSMhlvcL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfAYHBL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 02:01:11 -0500
Received: from condef-04.nifty.com ([202.248.20.69]:49882 "EHLO
        condef-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfAYHBL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 02:01:11 -0500
Received: from conuserg-10.nifty.com ([10.126.8.73])by condef-04.nifty.com with ESMTP id x0P6urFT013391
        for <linux-media@vger.kernel.org>; Fri, 25 Jan 2019 15:56:55 +0900
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id x0P6sNWn014857;
        Fri, 25 Jan 2019 15:54:24 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com x0P6sNWn014857
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1548399265;
        bh=kOFx2JtTztRNzevV/1XzwIagjECo3SMM4V/39EhMnQo=;
        h=From:To:Cc:Subject:Date:From;
        b=iSMhlvcLLuDzzMVrbnPuv8WfWzETeB4UyKz9HKWhNE/IfbUPXMRbERobKnwXFLGmd
         cIKiTnJcK6n94Hm7AmXViRtUWerr1tZyblXO/Z6ARr0Kd+ByA90fbwzI4PZ8C6B3tA
         gqthXvT9fcj5C/4lw+iyumyysPLWLLnx02IxNjbqECv+C5fuwjcYNS1cJCRLSbwzND
         2rP3zjnP9iI6fgpP4xYI29Q5K/ojbv4X2UOKBxsrXP7gPeFtaAwm2Gk7VXaLIczq57
         qSkuIX5hpoXvS3PZCPxabvZJlttsVMteIDNUs/EQC9CNm8PQ+HFKdHiFdiwVNG59et
         IjjH+RpLdDc1g==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Patrice Chotard <patrice.chotard@st.com>,
        Akihiro Tsukada <tskd08@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel@vger.kernel.org, Abylay Ospan <aospan@netup.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sergey Kozlov <serjk@netup.ru>, Mike Isely <isely@pobox.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/3] media: clean-up header search paths and add $(srctree)/ prefix
Date:   Fri, 25 Jan 2019 15:54:16 +0900
Message-Id: <1548399259-17750-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

My main motivation is to get rid of crappy header search path manipulation
from Kbuild core.

Before that, I want to do as many treewide cleanups as possible.

If you are interested in the big picture of this work,
the full patch set is available at:
git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git build-test



Masahiro Yamada (3):
  media: coda: remove -I$(src) header search path
  media: remove unneeded header search paths
  media: prefix header search paths with $(srctree)/

 drivers/media/common/b2c2/Makefile            | 4 ++--
 drivers/media/dvb-frontends/cxd2880/Makefile  | 2 --
 drivers/media/i2c/smiapp/Makefile             | 2 +-
 drivers/media/mmc/siano/Makefile              | 3 +--
 drivers/media/pci/b2c2/Makefile               | 2 +-
 drivers/media/pci/bt8xx/Makefile              | 5 ++---
 drivers/media/pci/cx18/Makefile               | 4 ++--
 drivers/media/pci/cx23885/Makefile            | 4 ++--
 drivers/media/pci/cx88/Makefile               | 4 ++--
 drivers/media/pci/ddbridge/Makefile           | 4 ++--
 drivers/media/pci/dm1105/Makefile             | 2 +-
 drivers/media/pci/mantis/Makefile             | 2 +-
 drivers/media/pci/netup_unidvb/Makefile       | 2 +-
 drivers/media/pci/ngene/Makefile              | 4 ++--
 drivers/media/pci/pluto2/Makefile             | 2 +-
 drivers/media/pci/pt1/Makefile                | 4 ++--
 drivers/media/pci/pt3/Makefile                | 4 ++--
 drivers/media/pci/smipcie/Makefile            | 5 ++---
 drivers/media/pci/ttpci/Makefile              | 4 ++--
 drivers/media/platform/coda/Makefile          | 2 --
 drivers/media/platform/coda/coda-h264.c       | 3 ++-
 drivers/media/platform/coda/trace.h           | 2 +-
 drivers/media/platform/sti/c8sectpfe/Makefile | 5 ++---
 drivers/media/radio/Makefile                  | 2 --
 drivers/media/spi/Makefile                    | 4 +---
 drivers/media/usb/as102/Makefile              | 2 +-
 drivers/media/usb/au0828/Makefile             | 4 ++--
 drivers/media/usb/b2c2/Makefile               | 2 +-
 drivers/media/usb/cx231xx/Makefile            | 5 ++---
 drivers/media/usb/em28xx/Makefile             | 4 ++--
 drivers/media/usb/go7007/Makefile             | 2 +-
 drivers/media/usb/pvrusb2/Makefile            | 4 ++--
 drivers/media/usb/siano/Makefile              | 2 +-
 drivers/media/usb/tm6000/Makefile             | 4 ++--
 drivers/media/usb/ttusb-budget/Makefile       | 2 +-
 drivers/media/usb/usbvision/Makefile          | 2 --
 36 files changed, 50 insertions(+), 64 deletions(-)

-- 
2.7.4

