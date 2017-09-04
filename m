Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:51415 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753953AbdIDUET (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 16:04:19 -0400
To: linux-media@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Songjun Wu <songjun.wu@microchip.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/6] [media] Atmel: Adjustments for seven function
 implementations
Message-ID: <88d0739c-fdc1-9d7d-fe53-b7c2eeed1849@users.sourceforge.net>
Date: Mon, 4 Sep 2017 22:04:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 4 Sep 2017 21:44:55 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (6):
  Delete an error message for a failed memory allocation in isc_formats_init()
  Improve a size determination in isc_formats_init()
  Adjust three checks for null pointers
  Delete an error message for a failed memory allocation in two functions
  Improve three size determinations
  Adjust a null pointer check in three functions

 drivers/media/platform/atmel/atmel-isc.c | 12 +++++-------
 drivers/media/platform/atmel/atmel-isi.c | 20 ++++++++------------
 2 files changed, 13 insertions(+), 19 deletions(-)

-- 
2.14.1
