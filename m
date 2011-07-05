Return-path: <mchehab@pedra>
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:36015 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab1GELlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 07:41:45 -0400
Message-ID: <4E12F3DE.5030109@cam.ac.uk>
Date: Tue, 05 Jul 2011 12:22:06 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: omap3isp: known causes of "CCDC won't become idle!
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

I'm just trying to get an mt9v034 sensor working on a beagle xm.
Everything more or less works, except that after a random number
of frames of capture, I tend to get won't become idle messages
and the vd0 and vd1 interrupts tend to turn up at same time.

I was just wondering if there are any known issues with the ccdc
driver / silicon that might explain this?

I also note that it appears to be impossible to disable HS_VS_IRQ
despite the datasheet claiming this can be done.  Is this a known
issue?

Thanks,

Jonathan
