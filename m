Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:49851 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754273AbdK2RLl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 12:11:41 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2 0/4] Add OV5640 parallel interface and RGB565/YUYV support
Date: Wed, 29 Nov 2017 18:11:08 +0100
Message-ID: <1511975472-26659-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enhance OV5640 CSI driver to support also DVP parallel interface.
Add RGB565 (LE & BE) and YUV422 YUYV format in addition to existing
YUV422 UYVY format.
Some other improvements on chip identifier check and removal
of warnings in powering phase around gpio handling.

===========
= history =
===========
version 2:
  - Fix comments from Sakari Ailus:
	https://www.mail-archive.com/linux-media@vger.kernel.org/msg122259.html
  - Revisit ov5640_set_stream_dvp() to only configure DVP at streamon
  - Revisit ov5640_set_stream_dvp() implementation with fewer register settings

version 1:
  - Initial submission

Hugues Fruchet (4):
  media: ov5640: switch to gpiod_set_value_cansleep()
  media: ov5640: check chip id
  media: ov5640: add support of DVP parallel interface
  media: ov5640: add support of RGB565 and YUYV formats

 drivers/media/i2c/ov5640.c | 213 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 183 insertions(+), 30 deletions(-)

-- 
1.9.1
