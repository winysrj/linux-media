Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38851 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751095AbeCOJai (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 05:30:38 -0400
Received: by mail-wm0-f67.google.com with SMTP id z9so9036787wmb.3
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2018 02:30:37 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: mchehab@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH 0/2] cec: stm32: add wakeup support
Date: Thu, 15 Mar 2018 10:29:47 +0100
Message-Id: <20180315092949.9895-1-benjamin.gaignard@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CEC hardware block is enable to resume the system if a command is received
on data lane.
Prior to implement suspend/resume functions a patch simplify clock management
int the driver by introducting pm_runtime{suspend/resume} functions.

Benjamin Gaignard (2):
  cec: stm32: simplify clock management
  cec: stm32: add suspend/resume functions

 drivers/media/platform/stm32/stm32-cec.c | 112 ++++++++++++++++++++++---------
 1 file changed, 82 insertions(+), 30 deletions(-)

-- 
2.15.0
