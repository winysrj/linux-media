Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3E3C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C96B2087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 08:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbfARIwn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 03:52:43 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:58310 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbfARIwM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 03:52:12 -0500
Received: by wens.csie.org (Postfix, from userid 1000)
        id 634475FD01; Fri, 18 Jan 2019 16:52:09 +0800 (CST)
From:   Chen-Yu Tsai <wens@csie.org>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 0/6] media: ov5640: JPEG and test pattern improvements
Date:   Fri, 18 Jan 2019 16:52:00 +0800
Message-Id: <20190118085206.2598-1-wens@csie.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi everyone,

This series improves the JPEG compression output mode handling of the
OV5640 sensor, and adds some more test patterns for users to use.

The JPEG compression output mode of the sensor works, but the data
framing is incorrect. Additional registers need to be set to configure
the framing / timing of the data. This was found when adding support for
JPEG_1X8 for the sun6i CSI sensor interface driver (improvements which
I'll send in a separate series). Because the default timings might not
be the same as the resolution timings, the capture device would either
truncate or pad each line as it is captured. This corrupts the JPEG
data. With the timings fixed, the captured data is once again a
continuous JPEG file.

While using the test pattern for testing, I found that the test pattern
was superimposed on top of an actual captured image. This made it
slightly harder to compare results, as the underlying image would change
with scenery and static from the sensor. Disabling the transparency
feature makes the result a "true" test pattern.

I also added the "rolling bar" variant of the color bar test pattern,
which is much better for testing video captures, as the image changes
in a predictable way, instead of being static.

Finally, another test pattern, "color squares", along with a rolling bar
variant, were added as an alternative.

Patch 1 is some simple code movement, in preparation for the next patch.

Patch 2 adds definitions for the test pattern configuration register, to
be used in the next patch.

Patch 3 disables the transparency feature of the test pattern generator.

Patch 4 adds more test pattern options.

Patch 5 fixes the JPEG compression output data framing.

Patch 6 consolidates the JPEG compression mode setting in one place,
instead of being listed in the register dumps.

Please have a look.


Regards
ChenYu


Chen-Yu Tsai (6):
  media: ov5640: Move test_pattern_menu before
    ov5640_set_ctrl_test_pattern
  media: ov5640: Add register definition for test pattern register
  media: ov5640: Disable transparent feature for test pattern
  media: ov5640: Add three more test patterns
  media: ov5640: Set JPEG output timings when outputting JPEG data
  media: ov5640: Consolidate JPEG compression mode setting

 drivers/media/i2c/ov5640.c | 95 ++++++++++++++++++++++++++++++--------
 1 file changed, 77 insertions(+), 18 deletions(-)

-- 
2.20.1

