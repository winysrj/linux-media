Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:57306 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932515AbeFKJ3n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 05:29:43 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <devicetree@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Hugues Fruchet" <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 0/2] OV5640 hflip, vflip and module orientation support
Date: Mon, 11 Jun 2018 11:29:15 +0200
Message-ID: <1528709357-7251-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch serie relates to flip and mirror at sensor level through
registers "TIMING TC REG20/REG21".

The first commit implements HFLIP and VFLIP V4L2 controls
allowing V4L2 client to change horizontal and vertical flip
before or during streaming.

The second commit allows to inform driver of the physical
orientation of the sensor module through devicetree "rotation"
optional properties as defined by Sakari in media/video-interfaces.txt:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg132345.html

Hugues Fruchet (2):
  media: ov5640: add HFLIP/VFLIP controls support
  media: ov5640: add support of module orientation

 .../devicetree/bindings/media/i2c/ov5640.txt       |   3 +
 drivers/media/i2c/ov5640.c                         | 127 ++++++++++++++++++---
 2 files changed, 112 insertions(+), 18 deletions(-)

-- 
1.9.1
