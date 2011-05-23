Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47425 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1EWJO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 05:14:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Koen Kooi <koen@beagleboard.org>
Subject: Re: [beagleboard] [PATCH v2 2/2] OMAP3BEAGLE: Add support for mt9p031 sensor driver.
Date: Mon, 23 May 2011 11:14:40 +0200
Cc: javier Martin <javier.martin@vista-silicon.com>,
	"beagleboard@googlegroups.com Board" <beagleboard@googlegroups.com>,
	Jason Kridner <jkridner@beagleboard.org>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz, linux-arm-kernel@lists.infradead.org
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com> <201105231000.32194.laurent.pinchart@ideasonboard.com> <5C643F76-F34A-4921-A406-B5123CC391A3@beagleboard.org>
In-Reply-To: <5C643F76-F34A-4921-A406-B5123CC391A3@beagleboard.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231114.41247.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Koen,

On Monday 23 May 2011 10:55:53 Koen Kooi wrote:
> Op 23 mei 2011, om 10:00 heeft Laurent Pinchart het volgende geschreven:
> > On Monday 23 May 2011 09:01:07 javier Martin wrote:
> >> On 20 May 2011 17:57, Koen Kooi <koen@beagleboard.org> wrote:
> >>> In previous patch sets we put that in a seperate file
> >>> (omap3beagle-camera.c) so we don't clutter up the board file with all
> >>> the different sensor drivers. Would it make sense to do the same with
> >>> the current patches? It looks like MCF cuts down a lot on the
> >>> boilerplace needed already.
> >> 
> >> I sent my first patch using that approach but I was told to move it to
> >> the board code.
> >> Please, don't make undo the changes. Or at least, let's discuss this
> >> seriously so that we all agree on what is the best way of doing it and
> >> I don't have to change it every time.
> > 
> > What we really need here is a modular way to support sensors on pluggable
> > expansion boards. Not all Beagleboard users will have an MT9P031
> > connected to the OMAP3 ISP, so that must not be hardcoded in board code.
> > As the sensor boards are not runtime detectable
> 
> Well, they are runtime detectable, you just need to read the ID register on
> the sensor and they all share the same I2C address. Once you have the
> sensor ID you can (re)setup the I2C.

I don't think we can guarantee that all sensor boards that will ever be 
plugged into the Beagleboard will have a sensor ID register readable from a 
single I2C address at a single register offset.

> But doing that in linux seems to be impossible with the current I2C
> infrastructure.
> 
> What we (beagleboard.org) are doing now:
> 
> 1) set a bootarg in uboot e.g. camera=llbcm5mp
> 2) read bootarg in linux boardfile and setup i2c
> 
> What we are going to do medium term:
> 
> 1) read ID in uboot, set bootarg
> 2) read bootarg in linux boardfile
> 
> Long term 1) will probably do some devicetree magic. The goal is to plug in
> a sensor and boot, no manual modprobing, it just works.

Device tree is definitely the way to go. using the camera parameter in board 
code to register the correct camera sounds good to me.

-- 
Regards,

Laurent Pinchart
