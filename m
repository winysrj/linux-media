Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:46749 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443AbZHCIkE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Aug 2009 04:40:04 -0400
Date: Mon, 3 Aug 2009 10:39:54 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Andy Walls <awalls@radix.net>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
Message-ID: <20090803103954.7150909e@tele>
In-Reply-To: <alpine.LNX.2.00.0908021302390.29819@banach.math.auburn.edu>
References: <20090418183124.1c9160e3@free.fr>
	<alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu>
	<20090802103350.19657a07@tele>
	<alpine.LNX.2.00.0908021302390.29819@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2 Aug 2009 14:12:28 -0500 (CDT)
Theodore Kilgore <kilgota@banach.math.auburn.edu> wrote:

	[snip]
> > - as there is only one vend:prod, one line is enough in gspca.txt.  
> 
> This is a question about which I have been curious for quite some
> time, and I think that now is a good time to ask it.
> 
> Just what policy do we have about this? The information which links
> brand and model to driver ought to be presented somewhere. If it does
> not go into gspca.txt then where exactly is the appropriate place to
> put said information?
	[snip]

Hi Theodore,

gspca.txt has been defined only to know which subdriver has to be
generated for a webcam that a user already owns.

The trade name of the webcams are often not clear enough (look at all
the Creative varieties). So, the user has just to plug her webcam and
with the vend:prod ID, she will know which driver she has to generate
(you may say that there are already tools which do the job, as easycam,
but I do not think they are often used).

The device list of the other drivers (CARDLIST.xx) are not sorted and
their format (numbered list) does not facilitate this job. So, I
prefered a list sorted by vend:prod.

In gspca.txt, the 3rd column contains the webcam names. As you can see,
it is a comma separated list, so, you may put here all the names you may
know. But, is it useful? I think that the webcam names should be only
in the file usb.ids which comes with the usbutils.

To go further, there should be a general file which should contain all
the usb (and pci) devices and their associated drivers. This
information exists in /lib/modules/`uname -r`/modules.usbmap when all
drivers are generated. So, we just need a tool (and a guy!) to maintain
this general file...

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
