Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:54880 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752399AbdIBNFK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 09:05:10 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] [media] ADV7...: Adjustments for four function
 implementations
Message-ID: <0e67e095-4931-b78f-a925-7335326ab69c@users.sourceforge.net>
Date: Sat, 2 Sep 2017 15:04:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 14:49:43 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Delete an error message for a failed memory allocation in adv76xx_probe()
  Adjust a null pointer check in three functions
  Delete an error message for a failed memory allocation in adv7842_probe()
  Improve a size determination in adv7842_probe()

 drivers/media/i2c/adv7604.c | 10 ++++------
 drivers/media/i2c/adv7842.c |  6 ++----
 2 files changed, 6 insertions(+), 10 deletions(-)

-- 
2.14.1
