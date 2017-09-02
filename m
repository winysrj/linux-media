Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:59899 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752684AbdIBPrp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 11:47:45 -0400
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/7] [media] OmniVision: Adjustments for four function
 implementations
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <c9f2ba21-c742-e1e8-26d9-a56c51c56d65@users.sourceforge.net>
Date: Sat, 2 Sep 2017 17:47:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 17:01:23 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (7):
  Delete an error message for a failed memory allocation in ov2640_probe()
  Improve a size determination in ov2640_probe()
  Delete an error message for a failed memory allocation in ov6650_probe()
  Delete an error message for a failed memory allocation in ov9640_probe()
  Improve a size determination in ov9640_probe()
  Delete an error message for a failed memory allocation in ov9740_probe()
  Improve a size determination in ov9740_probe()

 drivers/media/i2c/ov2640.c            | 7 ++-----
 drivers/media/i2c/ov6650.c            | 5 +----
 drivers/media/i2c/soc_camera/ov9640.c | 7 ++-----
 drivers/media/i2c/soc_camera/ov9740.c | 6 ++----
 4 files changed, 7 insertions(+), 18 deletions(-)

-- 
2.14.1
