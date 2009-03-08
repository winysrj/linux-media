Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:45925 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZCHRKo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 13:10:44 -0400
Date: Sun, 8 Mar 2009 12:23:04 -0500 (CDT)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
cc: Cc:;
Subject: [PATCH] for the file libv4lconvert/mr97310a.c 
Message-ID: <alpine.LNX.2.00.0903081217500.8834@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This patch introduces an offset of 12 bytes before starting the 
decompression of a frame. This needs to be done to compensate for a change 
in the gspca driver, where headers are now preserved instead of 
suppressed.


Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
--------------------------------------------------------------------------
--- mr97310a.c.old	2009-03-01 15:37:38.000000000 -0600
+++ mr97310a.c.new	2009-02-18 22:39:48.000000000 -0600
@@ -102,6 +102,9 @@ void v4lconvert_decode_mr97310a(const un
  	if (!decoder_initialized)
  		init_mr97310a_decoder();

+	/* remove the header */
+	inp += 12;
+
  	bitpos = 0;

  	/* main decoding loop */
