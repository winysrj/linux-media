Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:24767 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0FXWmp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 18:42:45 -0400
Received: by fg-out-1718.google.com with SMTP id d23so2202394fga.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jun 2010 15:42:44 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 25 Jun 2010 00:42:42 +0200
Message-ID: <AANLkTim5-Cc-ijE1U7M1DWSF8hcj8svSH30a0YVM4qv9@mail.gmail.com>
Subject: [PATCH] Terratec Cinergy 250 PCI support
From: Jean-Michel Grimaldi <jm@via.ecp.fr>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I have a Terratec Cinergy 250 PCI video card, and a small
modification in saa7134-cards.c is needed for it to work. I built the
patch on 2.6.34 version (I sent the modification to the maintainer in
early 2009 but got no feedback):

-- saa7134-cards.old.c	2010-06-25 00:31:16.000000000 +0200
+++ saa7134-cards.new.c	2010-06-25 00:30:52.000000000 +0200
@@ -2833,7 +2833,7 @@
 			.tv   = 1,
 		},{
 			.name = name_svideo,  /* NOT tested */
-			.vmux = 8,
+			.vmux = 3,
 			.amux = LINE1,
 		}},
 		.radio = {

Thanks for taking it into account in future kernels.

-- 
Jean-Michel
