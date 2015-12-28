Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:65073 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbbL1QZN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 11:25:13 -0500
Subject: [PATCH 0/2] [media] r820t: Fine-tuning for generic_set_freq()
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56816256.70304@users.sourceforge.net>
Date: Mon, 28 Dec 2015 17:24:54 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Dec 2015 17:18:34 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Delete an unnecessary variable initialisation
  Better exception handling

 drivers/media/tuners/r820t.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

-- 
2.6.3

