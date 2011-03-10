Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33122 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1CJQAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 11:00:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: mt9p031 support for Beagleboard.
Date: Thu, 10 Mar 2011 17:01:19 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <AANLkTi=8iEa4ZXvh1SqL8XdHuB2YcDAxXAqouJA2JriV@mail.gmail.com> <201103101644.23547.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404E1F52A88@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E1F52A88@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101701.19396.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 10 March 2011 16:47:46 Hiremath, Vaibhav wrote:
> On Thursday, March 10, 2011 9:14 PM Laurent Pinchart wrote:
> >
> > I'm curious about the Beagleboard code, as the camera module is an
> > expansion board you obviously can't hardcode support for it in the board
> > file. How do you plan to handle that ?
> 
> I did not understand your concern here, I already have MT9V113 sensor
> running with Media-controller (YUV format) on top of beagleXm board.

It's easy to patch the board-omap3beagle.c file to support the sensor, but how 
can that patch be pushed to mainline ? We have a wide range of sensors that 
can be connected to the Beagleboard, so this needs to be somehow configurable.

-- 
Regards,

Laurent Pinchart
