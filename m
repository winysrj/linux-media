Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32107.mail.mud.yahoo.com ([68.142.207.121]:31860 "HELO
	web32107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751473AbZBSL5R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 06:57:17 -0500
Date: Thu, 19 Feb 2009 03:57:15 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
Reply-To: gatoguan-os@yahoo.com
Subject: Re: [PATCH 2/4] soc-camera: camera host driver for i.MX3x SoCs
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <900217.19195.qm@web32107.mail.mud.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,
---- Mensaje original ----
> De: Sascha Hauer <s.hauer@pengutronix.de>
> On Wed, Feb 18, 2009 at 01:03:38AM +0100, Guennadi Liakhovetski wrote:
> > From: Guennadi Liakhovetski 
> > 
> > Tested with 8 bit Bayer and 8 bit monochrome video.
> > 
> > Signed-off-by: Guennadi Liakhovetski 
> > ---
> 
> Acked-by: Sascha Hauer 
> for the platform part. I can't say much to the driver itself.
> 
> Sascha
> 
> > 
> > This is how I expect this driver to appear in my pull request. So, please, 
> > review, test heavily :-)

I want to test it but while applying to mxc-master branch I observed that you use it on top of, at least, framebuffer stuff: #include <mach/mx3fb.h>.

Should I apply fb patchset in order to make this one work? (Otherwise, I can proceed with a minor merging effort.)

I am already using your drivers in their original version, I can get some new pictures with this one pretty soon.

--Agustín.
