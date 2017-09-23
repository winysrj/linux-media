Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:62585 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdIWTnV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 15:43:21 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Todor Tomov <todor.tomov@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] camss-csid: Fine-tuning for three function
 implementations
Message-ID: <168ff884-7ace-c548-7f90-d4f2910bb337@users.sourceforge.net>
Date: Sat, 23 Sep 2017 21:43:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 23 Sep 2017 21:24:56 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Use common error handling code in csid_set_power()
  Reduce the scope for a variable in csid_set_power()
  Adjust a null pointer check in two functions

 .../media/platform/qcom/camss-8x16/camss-csid.c    | 26 +++++++++++-----------
 1 file changed, 13 insertions(+), 13 deletions(-)

-- 
2.14.1
