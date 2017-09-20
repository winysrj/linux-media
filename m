Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:55402 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751009AbdITGdn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 02:33:43 -0400
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] [media] pvrusb2-ioread: Fine-tuning for eight function
 implementations
Message-ID: <c8117427-6d4d-0a1c-96c7-56e25d838b3e@users.sourceforge.net>
Date: Wed, 20 Sep 2017 08:33:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 08:28:48 +0200

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Use common error handling code in pvr2_ioread_get_buffer()
  Delete an unnecessary check before kfree() in two functions
  Delete unnecessary braces in six functions

 drivers/media/usb/pvrusb2/pvrusb2-ioread.c | 60 +++++++++++++-----------------
 1 file changed, 25 insertions(+), 35 deletions(-)

-- 
2.14.1
