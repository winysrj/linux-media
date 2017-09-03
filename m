Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:55003 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751765AbdICOB2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 10:01:28 -0400
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pan Bian <bianpan2016@163.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] Motion Eye: Adjustments for meye_probe()
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <4370c644-e440-1268-089b-8a8686bbcd5c@users.sourceforge.net>
Date: Sun, 3 Sep 2017 16:01:03 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 3 Sep 2017 15:54:45 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete three error messages for a failed memory allocation
  Adjust two function calls together with a variable assignment

 drivers/media/pci/meye/meye.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

-- 
2.14.1
