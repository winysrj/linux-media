Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:17950 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932599AbdKPNmQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 08:42:16 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v1 0/4] Add OV5640 parallel interface and RGB565/YUYV support
Date: Thu, 16 Nov 2017 14:41:38 +0100
Message-ID: <1510839702-2454-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enhance OV5640 CSI driver to support also DVP parallel interface.
Add RGB565 (LE & BE) and YUV422 YUYV format in addition to existing
YUV422 UYVY format.
Some other improvements on chip identifier check and removal
of warnings in powering phase around gpio handling.

Hugues Fruchet (4):
  media: ov5640: switch to gpiod_set_value_cansleep()
  media: ov5640: check chip id
  media: ov5640: add support of DVP parallel interface
  media: ov5640: add support of RGB565 and YUYV formats

 drivers/media/i2c/ov5640.c | 229 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 198 insertions(+), 31 deletions(-)

-- 
1.9.1
