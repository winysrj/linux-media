Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:64864 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbdIOQAt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 12:00:49 -0400
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Patrice Chotard <patrice.chotard@st.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] C8SECTPFE: Adjustments for
 c8sectpfe_frontend_attach()
Message-ID: <3e5fcfbe-828a-8c15-12d4-c74e8a1f20f1@users.sourceforge.net>
Date: Fri, 15 Sep 2017 18:00:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 17:55:43 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation
  Improve two size determinations

 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

-- 
2.14.1
