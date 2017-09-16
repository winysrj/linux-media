Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:61740 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751259AbdIPSbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 14:31:01 -0400
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] IT913X: Adjustments for two function
 implementations
Message-ID: <0ad553a6-9aca-d20b-48df-4084d80e2223@users.sourceforge.net>
Date: Sat, 16 Sep 2017 20:30:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 20:12:34 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete two error messages for a failed memory allocation
  Improve three size determinations

 drivers/media/tuners/it913x.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
2.14.1
