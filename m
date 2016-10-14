Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:52826 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753866AbcJNLkZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 07:40:25 -0400
Subject: [PATCH 0/5] [media] winbond-cir: Fine-tuning for four function
 implementations
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-media@vger.kernel.org,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Date: Fri, 14 Oct 2016 13:40:09 +0200
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 14 Oct 2016 13:24:35 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (5):
  Use kmalloc_array() in wbcir_tx()
  Move a variable assignment in wbcir_tx()
  Move assignments for three variables in wbcir_shutdown()
  One variable and its check less in wbcir_shutdown() after error detection
  Move a variable assignment in two functions

 drivers/media/rc/winbond-cir.c | 95 +++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 51 deletions(-)

-- 
2.10.1

