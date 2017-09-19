Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:48506 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750822AbdISNJZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 09:09:25 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8JD99hG006009
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 14:09:24 +0100
Received: from mail-wm0-f69.google.com (mail-wm0-f69.google.com [74.125.82.69])
        by mx07-00252a01.pphosted.com with ESMTP id 2d0sc01jc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 14:09:24 +0100
Received: by mail-wm0-f69.google.com with SMTP id r136so3865666wmf.4
        for <linux-media@vger.kernel.org>; Tue, 19 Sep 2017 06:09:24 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH 0/3] [media] tc358743: Support for a wider range of inputs
Date: Tue, 19 Sep 2017 14:08:50 +0100
Message-Id: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Three minor changes to the TC358743 HDMI to CSI2 bridge chip driver.
- Correct the clock mode reported via g_mbus_config to match that set.
- Increase the FIFO level to allow resolutions lower than 720P60 to work.
- Add settings for a new link frequency of 972Mbit/s. This allows
  1080P50 UYVY to work on two lanes (useful on the Raspberry Pi which
  only brings out two CSI2 lanes to the camera connector).

I'd like to extend the last one to dynamically calculate all the values
for an arbitrary link speed, but time hasn't allowed as yet.

Dave Stevenson (3):
  [media] tc358743: Correct clock mode reported in g_mbus_config
  [media] tc358743: Increase FIFO level to 300.
  [media] tc358743: Add support for 972Mbit/s link freq.

 drivers/media/i2c/tc358743.c | 62 +++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 18 deletions(-)

-- 
2.7.4
