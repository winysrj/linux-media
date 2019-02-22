Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFFCC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB3752075A
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 11:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfBVLjZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:39:25 -0500
Received: from gofer.mess.org ([88.97.38.141]:49127 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfBVLjZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 06:39:25 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 3851F604A1; Fri, 22 Feb 2019 11:39:24 +0000 (GMT)
Date:   Fri, 22 Feb 2019 11:39:24 +0000
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v5.1] RC fix
Message-ID: <20190222113923.e7p3iymqufmkagzj@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

A revert of a commit which caused problems.

Thanks
Sean

The following changes since commit 9fabe1d108ca4755a880de43f751f1c054f8894d:

  media: ipu3-mmu: fix some kernel-doc macros (2019-02-19 09:00:42 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v5.1c

for you to fetch changes up to f02f2c180ebb88d216bab9290b7c5ba7d17f45e6:

  Revert "media: rc: some events are dropped by userspace" (2019-02-22 09:28:41 +0000)

----------------------------------------------------------------
Sean Young (1):
      Revert "media: rc: some events are dropped by userspace"

 drivers/media/rc/rc-main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)
