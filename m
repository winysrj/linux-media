Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54209 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751289AbZHYLFn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 07:05:43 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1MftqV-0001mN-D2
	for linux-media@vger.kernel.org; Tue, 25 Aug 2009 13:05:47 +0200
Date: Tue, 25 Aug 2009 13:05:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] soc-camera: moving towards v4l2-subdev
Message-ID: <Pine.LNX.4.64.0908251258410.4810@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm about to post a pull-request for a series of 37 patches, of which the 
last three I haven't posted yet, so, doing this now. In principle, nothing 
ground-breaking, the last one is just checkpatch cleanup. The first two 
are removing more members from soc-camera device interface.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
