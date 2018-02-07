Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37632 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754061AbeBGRgO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 12:36:14 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1 0/3] STM32 DCMI redundant code & trace cleanup
Date: Wed, 7 Feb 2018 18:35:33 +0100
Message-ID: <1518024936-2455-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove some redundant code and fix/enhance some
error trace points.

Hugues Fruchet (3):
  media: stm32-dcmi: remove redundant capture enable
  media: stm32-dcmi: remove redundant clear of interrupt flags
  media: stm32-dcmi: improve error trace points

 drivers/media/platform/stm32/stm32-dcmi.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

-- 
1.9.1
