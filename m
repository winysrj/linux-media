Return-Path: <SRS0=tbWQ=RG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F926C43381
	for <linux-media@archiver.kernel.org>; Sun,  3 Mar 2019 13:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D5BD20836
	for <linux-media@archiver.kernel.org>; Sun,  3 Mar 2019 13:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbfCCNIF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Mar 2019 08:08:05 -0500
Received: from gofer.mess.org ([88.97.38.141]:53627 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbfCCNIF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Mar 2019 08:08:05 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id CEF4A60298; Sun,  3 Mar 2019 13:08:03 +0000 (GMT)
Date:   Sun, 3 Mar 2019 13:08:03 +0000
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v5.1] pt1 fix
Message-ID: <20190303130803.lfs2ymhfox3utyk5@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

A late fix for pt1 dvb driver.

Thanks,
Sean

The following changes since commit 26b190053ec0db030697e2e19a8f8f13550b9ff7:

  media: a few more typos at staging, pci, platform, radio and usb (2019-03-01 10:02:25 -0500)

are available in the Git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v5.1d

for you to fetch changes up to 8a615cf98b40958bf9ca0a425fc61ea6739d9e74:

  media: dvb/earth-pt1: fix wrong initialization for demod blocks (2019-03-03 10:46:32 +0000)

----------------------------------------------------------------
Akihiro Tsukada (1):
      media: dvb/earth-pt1: fix wrong initialization for demod blocks

 drivers/media/pci/pt1/pt1.c | 54 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 6 deletions(-)
