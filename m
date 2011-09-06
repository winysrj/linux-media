Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47502 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1IFIsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 04:48:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.berlios.de>
Subject: Re: Getting started with OMAP3 ISP
Date: Tue, 6 Sep 2011 10:48:03 +0200
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>,
	Hans de Goede <hdegoede@redhat.com>
References: <4E56734A.3080001@mlbassoc.com> <201109021327.59221.laurent.pinchart@ideasonboard.com> <CA+2YH7vEWijtbwuX_JsDwLtkGNLEbUBDBFadqT3wWtQWTJnfzA@mail.gmail.com>
In-Reply-To: <CA+2YH7vEWijtbwuX_JsDwLtkGNLEbUBDBFadqT3wWtQWTJnfzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061048.03550.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

(CC'ing Hans de Goede)

On Monday 05 September 2011 18:37:04 Enrico wrote:
> On Fri, Sep 2, 2011 at 1:27 PM, Laurent Pinchart wrote:
> > On Friday 02 September 2011 11:02:23 Enrico wrote:
> >> Right now my problem is that i can't get the isp to generate
> >> interrupts, i think there is some isp configuration error.
> > 
> > If your device generates interlaced images that's not surprising, as the
> > CCDC will only receive half the number of lines it expects.
> 
> Yes that was the first thing i tried, anyway now i have it finally
> working. Well at least yavta doesn't hang, do you know some
> application to see raw yuv images?

Hans, could libv4lconvert be used to implement a command line format 
conversion tool ? From a quick look at it it requires a V4L2 device, could 
that limitation be easily lifted ?

> Now the problem is that the fix is weird...as you suggested you must
> use half height values for VD0 and VD1 (2/3) interrupts, problem is
> that it only works if you DISABLE vd1 interrupt.
> If it is enabled the vd1_isr is run (once) and nothing else happens.

Have you set VD0 at half height and VD1 at 1/3 height ?

-- 
Regards,

Laurent Pinchart
