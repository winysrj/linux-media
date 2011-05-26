Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48294 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab1EZJkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 05:40:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with power managament.
Date: Thu, 26 May 2011 11:40:23 +0200
Cc: javier Martin <javier.martin@vista-silicon.com>,
	Koen Kooi <koen@beagleboard.org>, beagleboard@googlegroups.com,
	linux-media@vger.kernel.org, carlighting@yahoo.co.nz
References: <1306322212-26879-1-git-send-email-javier.martin@vista-silicon.com> <BANLkTikon2uw4DWcsXLCnLD1crfbV7HP_Q@mail.gmail.com> <Pine.LNX.4.64.1105261135080.9307@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105261135080.9307@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261140.24081.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 26 May 2011 11:35:59 Guennadi Liakhovetski wrote:
> On Thu, 26 May 2011, javier Martin wrote:
> > Are you using a LI-5M03 module?
> > (https://www.leopardimaging.com/Beagle_Board_xM_Camera.html)
> > I also added pull ups to the I2C2 line so that I could communicate with
> > mt9p031.
> 
> Hm, strange, I didn't have to solder anything.

You can also turn the OMAP3 internal pull-ups. Depending on who you ask, 
that's usually way simpler than soldering resistors :-)

-- 
Regards,

Laurent Pinchart
