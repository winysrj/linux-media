Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60031 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbbL1Ogz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 09:36:55 -0500
Subject: [PATCH 0/2] [media] m88rs6000t: Fine-tuning for some function
 implementations
References: <566ABCD9.1060404@users.sourceforge.net>
 <5680FDB3.7060305@users.sourceforge.net>
 <alpine.DEB.2.10.1512281019050.2702@hadrien>
 <56810F56.4080306@users.sourceforge.net>
 <alpine.DEB.2.10.1512281134590.2702@hadrien>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <568148FD.7080209@users.sourceforge.net>
Date: Mon, 28 Dec 2015 15:36:45 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1512281134590.2702@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Dec 2015 15:32:20 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Better exception handling in five functions
  Refactoring for m88rs6000t_sleep()

 drivers/media/tuners/m88rs6000t.c | 165 +++++++++++++++++++-------------------
 1 file changed, 83 insertions(+), 82 deletions(-)

-- 
2.6.3

