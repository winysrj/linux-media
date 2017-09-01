Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:53086 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752258AbdIATly (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 15:41:54 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Olli Salonen <olli.salonen@iki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] [media] SP2: Adjustments for two function implementations
Message-ID: <6142ca34-fcda-f2b6-bc35-dbbde0d34378@users.sourceforge.net>
Date: Fri, 1 Sep 2017 21:41:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 1 Sep 2017 21:31:23 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Delete an error message for a failed memory allocation
  Improve a size determination
  Adjust a jump target
  Adjust three null pointer checks

 drivers/media/dvb-frontends/sp2.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

-- 
2.14.1
