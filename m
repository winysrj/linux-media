Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57129 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751197AbdIOR21 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 13:28:27 -0400
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] STM32-DCMI: Adjustments for three function
 implementations
Message-ID: <730b535e-39a5-2c2b-f463-e76da967a723@users.sourceforge.net>
Date: Fri, 15 Sep 2017 19:27:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 19:01:23 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation in two functions
  Improve four size determinations

 drivers/media/platform/stm32/stm32-dcmi.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

-- 
2.14.1
