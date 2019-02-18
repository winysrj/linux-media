Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC790C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 09:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4381218AD
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 09:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfBRJyn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 04:54:43 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44442 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbfBRJyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 04:54:43 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id BA069634C7B
        for <linux-media@vger.kernel.org>; Mon, 18 Feb 2019 11:53:49 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gvfcT-0003gK-JN
        for linux-media@vger.kernel.org; Mon, 18 Feb 2019 11:53:49 +0200
Date:   Mon, 18 Feb 2019 11:53:49 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for 5.1] Ov7740 fix
Message-ID: <20190218095349.3d6hrjp2xjuc6ttq@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

If it's not too late, it'd be nice to get this little fix to 5.1.

Please pull.


The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:

  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-5.1-6-sign

for you to fetch changes up to 7cbaae4a5e86df4cb822a49ec7f80f9f50099bd4:

  media: ov7740: fix runtime pm initialization (2019-02-18 11:13:15 +0200)

----------------------------------------------------------------
ov7740 fix

----------------------------------------------------------------
Akinobu Mita (1):
      media: ov7740: fix runtime pm initialization

 drivers/media/i2c/ov7740.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
Sakari Ailus
