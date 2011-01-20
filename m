Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:64672 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab1ATXCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 18:02:48 -0500
Date: Fri, 21 Jan 2011 00:02:46 +0100
From: Martin Hostettler <martin@neutronstar.dyndns.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH V2] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale
	sensors
Message-ID: <20110120230246.GE13173@neutronstar.dyndns.org>
References: <1295386062-10618-1-git-send-email-martin@neutronstar.dyndns.org> <201101190027.19904.laurent.pinchart@ideasonboard.com> <20110119174759.GA13173@neutronstar.dyndns.org> <201101201537.50841.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101201537.50841.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 20, 2011 at 03:37:50PM +0100, Laurent Pinchart wrote:
> Hi Martin,
> 
> On Wednesday 19 January 2011 18:47:59 martin@neutronstar.dyndns.org wrote:
> > But the only clean solution i can think of is setting it to 0
> > unconditionally.
> > I'm not sure what this default should acomplish, so maybe i'm missing
> > something here, but i think the right value if dc substraction is needed
> > would be highly sensor specific?
> > I think all other of these postprocessing features for the CCDC default to
> > off, so it would make sense to default this to off too.
> > 
> > The overenginered solution would be to maintain a different value for each
> > bus width and let the user change the setting for the buswidth of the
> > currently linked sensor. In a way this would make sense,
> > because the DC substraction is fundamentally dependent on the bus size i
> > think. But i don't think anyone would want such complexity.
> > 
> > But i think it wouldn't be nice if every user of an 8bit sensor needs to
> > set this manually just to get the sensor working in a sane way (for 8bit
> > substracting 64 is insane, for wider buses it's different)
> > 
> > So how to proceed with this?
> 
> My personal opinion (at least for now) is that we should set the default value 
> to 0. I'll see if I can convince people at Nokia that it would be the right 
> way to go. If so I'll apply a patch for that.
> 

Yes, that would be great, thanks.

I'll resend the patch with this part removed.

regards,
 - Martin Hostettler
