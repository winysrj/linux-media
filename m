Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50819 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZGVSAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 14:00:02 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-media@vger.kernel.org, linux-uvc-devel@lists.berlios.de
Subject: [PATCH 0/2] uvcvideo: Multiple streaming interfaces support
Date: Wed, 22 Jul 2009 19:58:11 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221958.12027.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

this patch series introduces support for multiple streaming interfaces in a 
single UVC device. This will mainly be used by devices that can stream 
compressed and preview video concurrently (think about MPEG2-TS and MJPEG), 
but could also accommodate USB-to-USB devices such as hardware codecs.

I've tested the patches here and haven't noticed any issue (otherwise I 
wouldn't be sending them :-)). However, testing with devices exposing multiple 
streaming interfaces was limited as I don't own any such device.

Before sending them to mainline, I would like to make sure the patches don't 
introduce any regression for the single streaming interface case. Please patch 
your V4L tree (you might need the uvcvideo tree until Mauro pulls the two last 
changesets I've submitted) and report bugs and other issues.

Mauro, I'd like this to go to 2.6.32. If nobody reports any blocking issue, 
can you apply the patches before submitting your 2.6.32 pull request to Linus 
? Depending on the timing I might apply them to my tree and ask you to pull if 
I get enough positive feedback before the merge window opens.

Regards,

Laurent Pinchart

