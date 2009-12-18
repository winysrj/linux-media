Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58646 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752157AbZLRG7j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 01:59:39 -0500
Date: Fri, 18 Dec 2009 07:59:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Created files in patch comment intended?
Message-ID: <Pine.LNX.4.64.0912180756580.4406@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Looking at how my mediabus patches got committed into the mainline, I 
noticed, that the add-mediabus patch contains a list of added files 
between the patch description and the Sob's:

     create mode 100644 drivers/media/video/soc_mediabus.c
     create mode 100644 include/media/soc_mediabus.h
     create mode 100644 include/media/v4l2-mediabus.h

Is this intended, and if yes - why? If not, maybe you'd like to fix this 
in your hg-git export scripts.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
