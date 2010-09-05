Return-path: <mchehab@localhost>
Received: from mailout-de.gmx.net ([213.165.64.23]:46103 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753193Ab0IERJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Sep 2010 13:09:32 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1OsIj0-0002G9-1O
	for linux-media@vger.kernel.org; Sun, 05 Sep 2010 19:09:50 +0200
Date: Sun, 5 Sep 2010 19:09:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [Q] camera test pattern as an alternative input?
Message-ID: <Pine.LNX.4.64.1009051852250.434@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

In a currently running mt9m111 thread we're discussing ways to activate 
one of camera's (sensor's) test patterns. A module parameter has been 
proposed, earlier this has been done by just using the infamous 
VIDIOC_DBG_S_REGISTER. But then it occurred to me, that there has been 
previously such a discussion and it has been proposed to assign 
alternative inputs to various test patterns. So, you just issue a 
VIDIOC_S_INPUT to switch between the actual video input and one of test 
patterns. Can anyone else remember such a discussion or maybe just knows 
examples of such drivers? A couple of grep attempts haven't revealed 
anything. Is this a good idea?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
