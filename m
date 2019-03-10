Return-Path: <SRS0=zy/9=RN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CB2C43381
	for <linux-media@archiver.kernel.org>; Sun, 10 Mar 2019 13:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD0D6207E0
	for <linux-media@archiver.kernel.org>; Sun, 10 Mar 2019 13:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfCJNYQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 10 Mar 2019 09:24:16 -0400
Received: from gofer.mess.org ([88.97.38.141]:60699 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbfCJNYQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Mar 2019 09:24:16 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id BB1C86028F; Sun, 10 Mar 2019 13:24:14 +0000 (GMT)
Date:   Sun, 10 Mar 2019 13:24:14 +0000
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v5.1] seco build fix
Message-ID: <20190310132414.ixnfgwq6vytlwz4f@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

The seco-cec RC part fails to build if rc-core is configured as a module but
seco-cec is not. This was not true in v5.0, but only since commit f27dd0ad6885.

Thanks,
Sean

The following changes since commit 15d90a6ae98e6d2c68497b44a491cb9efbb98ab1:

  media: dvb/earth-pt1: fix wrong initialization for demod blocks (2019-03-04 06:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v5.1e

for you to fetch changes up to 28fac8473cf6d55f97df3f3d317311cb4e60e18f:

  media: seco: depend on CONFIG_RC_CORE=y when not a module (2019-03-10 13:21:00 +0000)

----------------------------------------------------------------
Sean Young (1):
      media: seco: depend on CONFIG_RC_CORE=y when not a module

 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
