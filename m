Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:56611 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754854Ab0JEJxb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Oct 2010 05:53:31 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1P34DN-0007vn-BK
	for linux-media@vger.kernel.org; Tue, 05 Oct 2010 11:53:41 +0200
Date: Tue, 5 Oct 2010 11:53:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] V4L: add an IMX074 sensor driver
Message-ID: <Pine.LNX.4.64.1010041801060.5668@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The first patch just adds a chip ID, the second one the actual driver. To 
be pushed for 2.6.37, unless objections appear.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
