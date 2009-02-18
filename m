Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:43254 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZBRPji (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 10:39:38 -0500
Date: Wed, 18 Feb 2009 09:39:36 -0600
From: David Engel <david@istwok.net>
To: Andreas <linuxdreas@dslextreme.com>
Cc: linux-media@vger.kernel.org
Subject: Re: PVR x50 corrupts ATSC 115 streams
Message-ID: <20090218153936.GD15359@opus.istwok.net>
References: <200902180441.40316.linuxdreas@dslextreme.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902180441.40316.linuxdreas@dslextreme.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2009 at 04:41:40AM -0800, Andreas wrote:
> Am Dienstag, 17. Februar 2009 21:19:45 schrieben Sie:
> [...]
> > So what does all of this indicate?  My original hunch was that it's a
> > problem with the x50 hardware or driver (at least in combination with
> > my motherboard).  I think I'm back to that conclusion.
> >
> > BTW, in my testing last night, I tried changing the PCI latency timer
> > on the x50 cards.  I thought maybe it was holding off access to the
> > 115 cards.  Changing that had no effect.
> 
> Just to let you know that you're not alone:
> I had a simiilar problem with the combination of an AverMedia A180 and 
> two Asus Falcon (they use the ivtv drivers and firmware). Whenever one 
> of the Falcons was recording, I got blips and dropouts on the 
> AverMedia. I chalked it off to a flaky mainboard and seperated the 
> Falcons and the Avermedia in two different computers. A while later I 

That does sound like the same problem.

> got a new mainboard and additional ATSC tuner cards. As long as I had 
> two of the ATSC tuner cards installed, the recordings were ok, except 
> for an occasional dropout. But when I put a third ATSC tuner in, the 
> recordings were barely watchable. After I put two ATSC tuners (2x 

That sounds troubling since my current plan is to eventually remove
the PVR x50 cards altogether and use 3 ATCS 115s in the one system.

David
-- 
David Engel
david@istwok.net
