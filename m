Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37388 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753337AbdLGMll (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Dec 2017 07:41:41 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 0/5] Add OV5640 parallel interface and RGB565/YUYV support
Date: Thu, 7 Dec 2017 13:40:48 +0100
Message-ID: <1512650453-24476-1-git-send-email-hugues.fruchet@st.com>
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
version 3:
  - Move chip identifier check at probe according to Fabio Estevam comment:
    https://www.mail-archive.com/linux-media@vger.kernel.org/msg122575.html
  - Use 16 bits register read for this check as per Steve Longerbeam comment:
    https://www.mail-archive.com/linux-media@vger.kernel.org/msg122692.html
  - Update bindings to document parallel mode support as per Fabio Estevam comment:
    https://www.mail-archive.com/linux-media@vger.kernel.org/msg122576.html
  - Enable the whole 10 bits parallel output and document 8/10 bits support
    in ov5640_set_stream_dvp() to answer to Steve Longerbeam comment:
    https://www.mail-archive.com/linux-media@vger.kernel.org/msg122693.html

version 2:
  - Fix comments from Sakari Ailus:
    https://www.mail-archive.com/linux-media@vger.kernel.org/msg122259.html
  - Revisit ov5640_set_stream_dvp() to only configure DVP at streamon
  - Revisit ov5640_set_stream_dvp() implementation with fewer register settings

version 1:
  - Initial submission

Hugues Fruchet (5):
  media: ov5640: switch to gpiod_set_value_cansleep()
  media: ov5640: check chip id
  media: dt-bindings: ov5640: add support of DVP parallel interface
  media: ov5640: add support of DVP parallel interface
  media: ov5640: add support of RGB565 and YUYV formats

 .../devicetree/bindings/media/i2c/ov5640.txt       |  27 +-
 drivers/media/i2c/ov5640.c                         | 291 +++++++++++++++++----
 2 files changed, 271 insertions(+), 47 deletions(-)

-- 
1.9.1
