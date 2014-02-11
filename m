Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:46114 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaBKOyE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 09:54:04 -0500
Date: Tue, 11 Feb 2014 15:54:00 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: OMAP3 ISP capabilities
Message-ID: <alpine.DEB.2.01.1402111543380.6474@pmeerw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

some quick question about the OMAP3 ISP pipeline capabilities:

(1) can the OMAP3 ISP CCDC output concurrently to memory AND the resizer 
in YUV mode? I think the answer is no due to hardware limitation

(2) in RAW mode, I think it should be possible to connect pad 1 of the 
OMAP3 ISP CCDC to CCDC output and pad 2 to the ISP preview and 
subsequently to the resizer? so two stream can be read concurrently from 
video2 and video6?

(3) it should be possible to use the ISP resizer input / output 
(memory-to-memory) independently; it there any example code doing this?

thanks, regards, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
