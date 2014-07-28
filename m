Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58765 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750903AbaG1HVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 03:21:22 -0400
Date: Mon, 28 Jul 2014 10:20:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Enrico <ebutera@users.sourceforge.net>
Cc: Michael Dietschi <michael.dietschi@inunum.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: omap3isp with DM3730 not working?!
Message-ID: <20140728072043.GW16460@valkosipuli.retiisi.org.uk>
References: <53D12786.5050906@InUnum.com>
 <CA+2YH7v8bQG4K2Gz8aB9_BOHwuK_1nGDxU102S7EBnsMGEuwKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+2YH7v8bQG4K2Gz8aB9_BOHwuK_1nGDxU102S7EBnsMGEuwKA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico and Michael,

On Thu, Jul 24, 2014 at 05:57:30PM +0200, Enrico wrote:
> On Thu, Jul 24, 2014 at 5:34 PM, Michael Dietschi
> <michael.dietschi@inunum.com> wrote:
> > Hello,
> >
> > I have built a Poky image for Gumstix Overo and added support for a TVP5151
> > module like described here http://www.sleepyrobot.com/?p=253.
> > It does work well with an Overo board which hosts an OMAP3530 SoC. But when
> > I try with an Overo hosting a DM3730 it does not work: yavta just seems to
> > wait forever :(
> >
> > I did track it down to the point that IRQ0STATUS_CCDC_VD0_IRQ seems never be
> > set but always IRQ0STATUS_CCDC_VD1_IRQ

VD1 takes place in 2/3 of the frame, and VD0 in the beginning of the last
line. You could check perhaps if you do get VD0 if you set it to take place
on the previous line (i.e. the register value being height - 3; please see
ccdc_configure() in ispccdc.c).

I have to admit I haven't used the parallel interface so perhaps others
could have more insightful comments on how to debug this.

> > Can someone please give me a hint?
> 
> It's strange that you get the vd1_irq because it should not be set by
> the driver and never trigger...

Both VD0 and VD1 are used by the omap3isp driver, but in different points of
the frame.

> Anyway maybe a different pinmux where the camera pins are not setup correctly?

This is unlikely to be at least the source of all issues since VD1 is seen.

Cc Laurent.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
