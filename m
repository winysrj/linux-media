Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:56938 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932609Ab2IFSAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 14:00:18 -0400
Message-ID: <5048E4A4.40901@gmx.net>
Date: Thu, 06 Sep 2012 20:00:04 +0200
From: Andreas Nagel <andreasnagel@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Integrate camera interface of OMAP3530 in Angstrom Linux
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am using an embedded module called TAO-3530 from Technexion, which has 
an OMAP3530 processor.
This processor has a camera interface, which is part of the ISP 
submodule. For an ongoing project I want to capture a video signal from 
this interface. After several days of excessive research I still don't 
know, how to access it.
I configured the Angstrom kernel (2.6.32), so that the driver for OMAP 3 
camera controller (and all other OMAP 3 related things) is integrated, 
but I don't see any new device nodes in the filesystem.

I also found some rumors, that the Media Controller Framework or driver 
provides the device node /dev/media0, but I was not able to install it.
I use OpenEmbedded, but I don't have a recipe for Media Controller. On 
the Angstrom website ( http://www.angstrom-distribution.org/repo/ ) 
there's actually a package called "media-ctl", but due to the missing 
recipe, i can't install it. Can't say, I am an expert in OE.

Can you help me point out, what's necessary to make the camera interface 
accessible?

Best regards,
Andreas

