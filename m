Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04F4C64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 20:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BA2820892
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 20:26:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BA2820892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mess.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbeLFU0q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 15:26:46 -0500
Received: from gofer.mess.org ([88.97.38.141]:42849 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbeLFU02 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 15:26:28 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id A5674607A9; Thu,  6 Dec 2018 20:26:27 +0000 (GMT)
Date:   Thu, 6 Dec 2018 20:26:27 +0000
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.21] Two DVB patches
Message-ID: <20181206202627.ncavxzz2xkqd264h@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Two small dvb fixes which would be nice to have in 4.21.

Thanks,
Sean

The following changes since commit 3c28b91380dd1183347d32d87d820818031ebecf:

  media: stkwebcam: Bugfix for wrong return values (2018-12-05 14:10:48 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.21d

for you to fetch changes up to 92ca069d61c96701c8660c114bbf8b772b4a33db:

  media: lmedm04: Move interrupt buffer to priv buffer. (2018-12-06 20:15:14 +0000)

----------------------------------------------------------------
Malcolm Priestley (2):
      media: lmedm04: Add missing usb_free_urb to free interrupt urb.
      media: lmedm04: Move interrupt buffer to priv buffer.

 drivers/media/usb/dvb-usb-v2/lmedm04.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)
