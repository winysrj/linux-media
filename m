Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51917 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593Ab2G3WKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 18:10:50 -0400
Subject: Re: Asus PVR-416
From: Andy Walls <awalls@md.metrocast.net>
To: Jerry Haggard <xen2xen1@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Mon, 30 Jul 2012 18:10:45 -0400
In-Reply-To: <501668B2.3050107@gmail.com>
References: <501668B2.3050107@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1343686247.2486.8.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-07-30 at 06:57 -0400, Jerry Haggard wrote:
> I've been trying to get an ASUS PVR-416 card to work with MythTV .25 on 
> Scientific Linux 6.  I have a bttv card working, my setup works in 
> general, etc, and the driver attempts to load.  But when I check dmesg, 
> I keep getting firmware load errors and checksum errors. I've tried 
> every firmware I could find.  I've used the one from Atrpms, I've 
> downloaded the correctly named firmware from ivtv, but no luck.  Anyone 
> know anything about this card?  I've tried cutting the drivers myself 
> like it says in the direcitons at mythtv.org. This is supposed to be a 
> supported card, does anyone have any experience with it?

No experience with it.  It is supposedly a Blackbird design supported by
the cx88 driver.

My standard response for legacy PCI cards that are responding somewhat,
but aren't working properly, is to

1. remove all the legacy PCI cards from all the slots
2. blow the dust out of all the slots
3. if feasible, reseat only the 1 card and test again
4. reseat all the cards and test again

Since legacy PCI uses reflected wave switching, dust in any one slot can
cause problems.  It's a troubleshooting step that's easy enough to do.

If that doesn't work, we would need to see the output of dmesg
and/or /var/log/messages when the module is being loaded and the
firmware loaded.  If providing logs, please don't just grep on the
'cx88' lines, since other modules are involved in getting the card
working.

Regards,
Andy

