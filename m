Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43344 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbcGWLcY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2016 07:32:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 4/4] [media] cx23885-cardlist.rst: add a new card
Date: Sat, 23 Jul 2016 08:31:54 -0300
Message-Id: <d271d3d9b333c94cd54a12fa506e17772a04617c.1469273428.git.mchehab@s-opensource.com>
In-Reply-To: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
References: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
In-Reply-To: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
References: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add card Hauppauge WinTV-QuadHD-DVB to the list.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx23885-cardlist.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/media/v4l-drivers/cx23885-cardlist.rst b/Documentation/media/v4l-drivers/cx23885-cardlist.rst
index fe1583ee8541..ded3b9139317 100644
--- a/Documentation/media/v4l-drivers/cx23885-cardlist.rst
+++ b/Documentation/media/v4l-drivers/cx23885-cardlist.rst
@@ -59,3 +59,4 @@ cx23885 cards list
 	 53 -> Hauppauge WinTV Starburst                           [0070:c12a]
 	 54 -> ViewCast 260e                                       [1576:0260]
 	 55 -> ViewCast 460e                                       [1576:0460]
+	 56 -> Hauppauge WinTV-QuadHD-DVB                          [0070:6a28,0070:6b28]
-- 
2.7.4

