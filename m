Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:63665 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751220AbdH1KJD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 06:09:03 -0400
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] [media] Cypress: Adjustments for cypress_load_firmware()
Message-ID: <f95552e6-edf1-ceed-0c16-c8d23b8309ea@users.sourceforge.net>
Date: Mon, 28 Aug 2017 12:08:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Aug 2017 12:00:21 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an error message for a failed memory allocation
  Improve a size determination

 drivers/media/common/cypress_firmware.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.14.1
