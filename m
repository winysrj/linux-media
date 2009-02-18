Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53934 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751034AbZBRACH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 19:02:07 -0500
Date: Wed, 18 Feb 2009 01:02:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Agustin <gatoguan-os@yahoo.com>,
	Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH/RFC 0/4] i.MX31 camera host driver + IPU updates
In-Reply-To: <499B2A60.9080009@epfl.ch>
Message-ID: <alpine.DEB.2.00.0902180044120.6986@axis700.grange>
References: <50561.11594.qm@web32108.mail.mud.yahoo.com> <499B2A60.9080009@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Having answered to Agustin's and Val's emails, I realised, that I actually 
can (and should) post my current patches for review / test. Of these 4 
patches the first is just FYI / for testing. It will be sumbitted later to 
the dmaengine queue. The second one is the actual camera host driver, 
updated for current IPU-dmaengine and soc-camera APIs. The third one is an 
example of platform data, it will have to be updated. The forth one is an 
update to the mt9t031 driver, in case anyone is using it. It might need a 
one-line update, I think, there's a small problem with cropping there.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
