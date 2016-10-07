Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:51321 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752123AbcJGTob (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 15:44:31 -0400
Subject: [PATCH 0/2] [media] dvb-tc90522: Fine-tuning for two function
 implementations
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-media@vger.kernel.org, Akihiro Tsukada <tskd08@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <906cc86f-bac0-fd47-8a6f-d3310b10fd08@users.sourceforge.net>
Date: Fri, 7 Oct 2016 21:43:56 +0200
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 7 Oct 2016 21:38:12 +0200

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use kmalloc_array()
  Rename a jump label

 drivers/media/dvb-frontends/tc90522.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

-- 
2.10.1

