Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52693 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaG1K3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 06:29:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.sourceforge.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Michael Dietschi <michael.dietschi@inunum.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap3isp with DM3730 not working?!
Date: Mon, 28 Jul 2014 12:29:29 +0200
Message-ID: <1915586.ZFV4ecW0Zg@avalon>
In-Reply-To: <CA+2YH7sDWOP-JLEQLuCEmacSN85C2NZKfU+KoG9KP3ejVUQkWg@mail.gmail.com>
References: <53D12786.5050906@InUnum.com> <20140728072043.GW16460@valkosipuli.retiisi.org.uk> <CA+2YH7sDWOP-JLEQLuCEmacSN85C2NZKfU+KoG9KP3ejVUQkWg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Monday 28 July 2014 10:30:17 Enrico wrote:
> On Mon, Jul 28, 2014 at 9:20 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Thu, Jul 24, 2014 at 05:57:30PM +0200, Enrico wrote:
> >> On Thu, Jul 24, 2014 at 5:34 PM, Michael Dietschi wrote:
> >>> Hello,
> >>> 
> >>> I have built a Poky image for Gumstix Overo and added support for a
> >>> TVP5151 module like described here http://www.sleepyrobot.com/?p=253.
> >>> It does work well with an Overo board which hosts an OMAP3530 SoC. But
> >>> when I try with an Overo hosting a DM3730 it does not work: yavta just
> >>> seems to wait forever :(
> >>> 
> >>> I did track it down to the point that IRQ0STATUS_CCDC_VD0_IRQ seems
> >>> never be set but always IRQ0STATUS_CCDC_VD1_IRQ
> > 
> > VD1 takes place in 2/3 of the frame, and VD0 in the beginning of the last
> > line. You could check perhaps if you do get VD0 if you set it to take
> > place on the previous line (i.e. the register value being height - 3;
> > please see ccdc_configure() in ispccdc.c).
> > 
> > I have to admit I haven't used the parallel interface so perhaps others
> > could have more insightful comments on how to debug this.
> > 
> >> > Can someone please give me a hint?
> >> 
> >> It's strange that you get the vd1_irq because it should not be set by
> >> the driver and never trigger...
> > 
> > Both VD0 and VD1 are used by the omap3isp driver, but in different points
> > of the frame.
> 
> Hi Sakari,
> 
> that's true in "normal" mode, but with bt656 patches VD1 is not used.

That's not correct, VD1 is used in both modes. In BT.656 mode VD1 is even used 
to increment the frame counter in place of the HS_VS interrupt.

-- 
Regards,

Laurent Pinchart

