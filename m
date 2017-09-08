Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:53774 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756652AbdIHTlO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 15:41:14 -0400
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] Freescale VIU: Adjustments for five function
 implementations
Message-ID: <bf912679-c695-c9c0-a464-3bd3e976fa8a@users.sourceforge.net>
Date: Fri, 8 Sep 2017 21:40:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 8 Sep 2017 21:28:12 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Delete an error message for a failed memory allocation in viu_of_probe()
  Improve two size determinations in viu_of_probe()
  Adjust six checks for null pointers

 drivers/media/platform/fsl-viu.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

-- 
2.14.1
