Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:49514 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbdH2FbG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 01:31:06 -0400
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Antoine Jacquet <royale@zerezo.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] [media] zr364xx: Adjustments for some function
 implementations
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
Date: Tue, 29 Aug 2017 07:30:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Aug 2017 07:17:07 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Delete an error message for a failed memory allocation in two functions
  Improve a size determination in zr364xx_probe()
  Adjust ten checks for null pointers
  Fix a typo in a comment line of the file header

 drivers/media/usb/zr364xx/zr364xx.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

-- 
2.14.1
