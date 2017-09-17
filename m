Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50926 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750746AbdIQGzw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 02:55:52 -0400
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] Si2157: Adjustments for two function
 implementations
Message-ID: <87f4a386-ac11-87f5-2d22-7bfc0593de34@users.sourceforge.net>
Date: Sun, 17 Sep 2017 08:55:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 08:48:24 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation
  Improve a size determination in two functions

 drivers/media/tuners/si2157.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.14.1
