Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:65375 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938615AbcLVT50 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 14:57:26 -0500
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] pvrusb2-io: Fine-tuning for some function
 implementations
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <e08ae52b-3db5-4f9a-bc8b-c5abf7700856@users.sourceforge.net>
Date: Thu, 22 Dec 2016 20:57:02 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 22 Dec 2016 20:48:04 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use kmalloc_array()
  Add some spaces for better code readability

 drivers/media/usb/pvrusb2/pvrusb2-io.c | 123 +++++++++++++++++----------------
 1 file changed, 62 insertions(+), 61 deletions(-)

-- 
2.11.0

