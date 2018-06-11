Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44970 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932453AbeFKJuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 05:50:54 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH 0/4] Revisit and fix DCMI buffers handling
Date: Mon, 11 Jun 2018 11:50:23 +0200
Message-ID: <1528710627-8566-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Revisit and fix DCMI buffers handling.

Hugues Fruchet (4):
  media: stm32-dcmi: do not fall into error on buffer starvation
  media: stm32-dcmi: return buffer in error state on dma error
  media: stm32-dcmi: clarify state logic on buffer starvation
  media: stm32-dcmi: revisit buffer list management

 drivers/media/platform/stm32/stm32-dcmi.c | 80 ++++++++++++++++---------------
 1 file changed, 41 insertions(+), 39 deletions(-)

-- 
1.9.1
