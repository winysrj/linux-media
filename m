Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614EDC07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 22:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6DAF20838
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 22:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6DAF20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=iki.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbeLGWdA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 17:33:00 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44068 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726008AbeLGWdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 17:33:00 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 681C6634C89
        for <linux-media@vger.kernel.org>; Sat,  8 Dec 2018 00:32:42 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gVOfq-0000pB-6r
        for linux-media@vger.kernel.org; Sat, 08 Dec 2018 00:32:42 +0200
Date:   Sat, 8 Dec 2018 00:32:42 +0200
From:   sakari.ailus@iki.fi
To:     linux-media@vger.kernel.org
Subject: [GIT FIXES for 4.20] Fwnode parsing fix
Message-ID: <20181207223241.xqiphnudzfzvse2v@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here's a patch that fixes clearing fwnode flags. The patch that broke it is
only in 4.20.

Please pull.


The following changes since commit 078ab3ea2c3bb69cb989d52346fefa1246055e5b:

  media: Add a Kconfig option for the Request API (2018-12-05 13:07:43 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/fixes-4.20-1-sign

for you to fetch changes up to 7add7222d1741afb448a386c3085f38da801fd50:

  media: v4l2-fwnode: Fix setting V4L2_MBUS_DATA_ACTIVE_HIGH/LOW flag (2018-12-08 00:27:15 +0200)

----------------------------------------------------------------
clear correct fwnode flags

----------------------------------------------------------------
Ondrej Jirman (1):
      media: v4l2-fwnode: Fix setting V4L2_MBUS_DATA_ACTIVE_HIGH/LOW flag

 drivers/media/v4l2-core/v4l2-fwnode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Sakari Ailus
