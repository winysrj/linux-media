Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0EJNpj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 09:45:39 -0400
Date: Mon, 10 May 2010 06:45:20 -0700
From: Sarah Sharp <sarah.a.sharp@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	LMML <linux-media@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Status of the patches under review (85 patches) and some misc
 notes about the devel procedures
Message-ID: <20100510134520.GA6213@xanatos>
References: <20100507093916.2e2ef8e3@pedra>
 <20100508083127.73a72af7@tele>
 <4BE5E995.4070003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE5E995.4070003@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 08, 2010 at 03:45:41PM -0700, Mauro Carvalho Chehab wrote:
> Jean-Francois Moine wrote:
> > On Fri, 7 May 2010 09:39:16 -0300
> > Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> > 
> >> 		== Gspca patches - Waiting Jean-Francois Moine
> >> <moinejf@free.fr> submission/review == 
> >>
> >> Feb,24 2010: gspca pac7302: add USB PID range based on
> >> heuristics                   http://patchwork.kernel.org/patch/81612
> >> May, 3 2010: gspca: Try a less bandwidth-intensive alt
> >> setting.                     http://patchwork.kernel.org/patch/96514
> > 
> > Hello Mauro,
> > 
> > I don't think the patch about pac7302 should be applied.
> 
> > 
> > The patch about the gspca main is in my last git pull request.
> 
> (c/c Sarah)
> 
> I also didn't like this patch strategy. It seems a sort of workaround
> for xHCI, instead of a proper fix.
> 
> I'll mark this patch as rejected, and wait for a proper fix.

This isn't a work around for a bug in the xHCI host.  The bandwidth
checking is a feature.  It allows the host to reject a new interface if
other devices are already taking up too much of the bus bandwidth.  I
expect that all drivers that use interrupt or isochronous will have to
fall back to a different alternate interface setting if they can.

Now, Alan Stern and I have been talking about making a different API for
drivers to request a specific polling rate and frame list length for an
endpoint.  However, I expect that the call would have to be either
before or part of the call to usb_set_interface(), because of how the
xHCI hardware tracks endpoints.  So even if we had the ideal interface,
the drivers would still need code like this to fall back to
less-bandwidth intensive alternate settings.

Is there a different way you think we should handle running out of
bandwidth?

Sarah Sharp
