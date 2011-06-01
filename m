Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:44380 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1FAWHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 18:07:08 -0400
Date: Thu, 2 Jun 2011 01:07:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Bastian Hecht <hechtb@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Felix v. Hundelshausen" <felix.v.hundelshausen@live.de>
Subject: Re: Capabilities of the Omap3 ISP driver
Message-ID: <20110601220703.GA6073@valkosipuli.localdomain>
References: <BANLkTineUffG1yd3Ey30wr0xzAj3_Zd1KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTineUffG1yd3Ey30wr0xzAj3_Zd1KQ@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, May 29, 2011 at 03:27:23PM +0200, Bastian Hecht wrote:
> Hello Laurent,
> 
> I'm on to a project that needs two synced separate small cameras for
> stereovision. It's for harvesting tomatoes in fact :)
> 
> I was thinking about realizing this on an DM3730 with 2 aptina csi2
> cameras that are used in snapshot mode. The questions that arise are:
> 
> - is the ISP driver capable of running 2 concurrent cameras?
> - is it possible to simulate a kind of video stream that is externally
> triggered (I would use a gpio line that simply triggers 10 times a
> sec) or would there arise problems with the csi2 protocoll (timeouts
> or similar)?

Hi Bastian,

As Laurent poonted out, the DM3730 doesn't support CSI2. This is really
unfortunate as many sensors tend to use that interface nowadays. I wonder if
there would be alternative sensors available that would use parallel
interface instead. On the other hand, then you can't receive two streams
simultaneously using a single OMAP without special arrangements.

If interleaved exposure start is out of question you'll need more than one
OMAP. :I Or somehow get OMAP 36x0s. They do have dual CSI2 receivers.

To the latter question: I don't think the CSI2 protocol has any issues with
this kind of use.

Kind regards,

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
