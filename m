Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45596 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1EWIAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 04:00:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [beagleboard] [PATCH v2 2/2] OMAP3BEAGLE: Add support for mt9p031 sensor driver.
Date: Mon, 23 May 2011 10:00:31 +0200
Cc: Koen Kooi <koen@beagleboard.org>,
	"beagleboard@googlegroups.com Board" <beagleboard@googlegroups.com>,
	Jason Kridner <jkridner@beagleboard.org>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz, linux-arm-kernel@lists.infradead.org
References: <1305899272-31839-1-git-send-email-javier.martin@vista-silicon.com> <DDCBBAA2-C49C-4952-9D1B-519D8A3AB41E@beagleboard.org> <BANLkTi=ZHyk1+otf2i0qp47Zvvo4nfYk6A@mail.gmail.com>
In-Reply-To: <BANLkTi=ZHyk1+otf2i0qp47Zvvo4nfYk6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231000.32194.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Monday 23 May 2011 09:01:07 javier Martin wrote:
> On 20 May 2011 17:57, Koen Kooi <koen@beagleboard.org> wrote:
> > In previous patch sets we put that in a seperate file
> > (omap3beagle-camera.c) so we don't clutter up the board file with all
> > the different sensor drivers. Would it make sense to do the same with
> > the current patches? It looks like MCF cuts down a lot on the
> > boilerplace needed already.
> 
> I sent my first patch using that approach but I was told to move it to
> the board code.
> Please, don't make undo the changes. Or at least, let's discuss this
> seriously so that we all agree on what is the best way of doing it and
> I don't have to change it every time.

What we really need here is a modular way to support sensors on pluggable 
expansion boards. Not all Beagleboard users will have an MT9P031 connected to 
the OMAP3 ISP, so that must not be hardcoded in board code. As the sensor 
boards are not runtime detectable, one solution would be to compile part of 
the code as a module. Regulator definitions and I2C2 bus registration (and 
possibly GPIO initialization) can be left in board code.

-- 
Regards,

Laurent Pinchart
