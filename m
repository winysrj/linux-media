Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82717C169C4
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 16:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB422183F
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 16:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbfBCQEE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 11:04:04 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:33220 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfBCQED (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Feb 2019 11:04:03 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id 9547A5FD06; Mon,  4 Feb 2019 00:04:01 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Yong Deng <yong.deng@magewell.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] media: sun6i: One regmap fix and support RGB565 and JPEG
Date:   Mon,  4 Feb 2019 00:03:55 +0800
Message-Id: <20190203160358.21050-1-wens@csie.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi everyone,

This series is adds support for two (three if you count big / little
endian) media bus formats to the sun6i-csi driver. There's also a small
fix for an exception I encountered while working on this.

Both modes were tested using an OV5640 sensor. To use JPEG, the patch
"media: ov5640: Set JPEG output timings when outputting JPEG data" from
my "media: ov5640: JPEG and test pattern improvements" series is also
needed.

I prepared this series on 1/18, alone with the "media: ov5640: Set JPEG
output timings when outputting JPEG data", but ended up forgetting to
send out this one.

Please have a look.


Regards
ChenYu

Chen-Yu Tsai (3):
  media: sun6i: Fix CSI regmap's max_register
  media: sun6i: Add support for RGB565 formats
  media: sun6i: Add support for JPEG media bus format

 .../platform/sunxi/sun6i-csi/sun6i_csi.c      | 27 ++++++++++++++++---
 .../platform/sunxi/sun6i-csi/sun6i_csi.h      |  3 +++
 .../platform/sunxi/sun6i-csi/sun6i_video.c    |  3 +++
 3 files changed, 30 insertions(+), 3 deletions(-)

-- 
2.20.1

