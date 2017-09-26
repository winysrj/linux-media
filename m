Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:62215 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935241AbdIZL0Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 07:26:24 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/6] [media] TDA8261: Fine-tuning for five function
 implementations
Message-ID: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Date: Tue, 26 Sep 2017 13:26:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 26 Sep 2017 13:20:12 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (6):
  Use common error handling code in tda8261_set_params()
  Improve a size determination in tda8261_attach()
  Return directly after a failed kzalloc() in tda8261_attach()
  Delete an unnecessary variable initialisation in tda8261_attach()
  Adjust three function calls together with a variable assignment
  Delete an unnecessary variable initialisation in three functions

 drivers/media/dvb-frontends/tda8261.c | 47 +++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 22 deletions(-)

-- 
2.14.1
