Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZFAQbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 12:31:37 -0400
Date: Mon, 1 Jun 2009 13:31:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx device mode detection based on endpoints
Message-ID: <20090601133133.6395a1fb@pedra.chehab.org>
In-Reply-To: <d9def9db0906010907t52c49c22mc238dedd71b067cd@mail.gmail.com>
References: <d9def9db0905230704n4f8b725aj3dc3021187d5ae12@mail.gmail.com>
	<d9def9db0905230749r3e39de5m3f4e1c28c1d596bd@mail.gmail.com>
	<d9def9db0905230805h5258a9b6h7920a5bd4ce62e7c@mail.gmail.com>
	<829197380906010819s8cfdfedn9d47dbfef0ca1d04@mail.gmail.com>
	<20090601130433.66c34e32@gmail.com>
	<d9def9db0906010907t52c49c22mc238dedd71b067cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Jun 2009 18:07:24 +0200
Markus Rechberger <mrechberger@gmail.com> escreveu:

> >> I spent some time reviewing this patch, and the patch's content does
> >> not seem to match your description of its functionality.  Further,
> >> this patch appears to be a combination of a number of several
> >> different changes, rather than being broken into separate patches.
> >>
> >> First off, I totally agree that the analog subsystem should not be
> >> loaded on devices such as em287[0-4].  I was going to do this work
> >> (using the chip id to determine analog support) but just had not had a
> >> chance to doing the necessary testing to ensure it did not break
> >> anything.
> >>
> >> The patch appears to be primarily for devices that are not supported
> >> in the kernel.  In fact, the logic as written *only* gets used for
> >> unknown devices.  Further, the code that doesn't create the frontend
> >> device has no application in the kernel.  All devices currently in the
> >> kernel make use of the dvb frontend interface, so there is no
> >> practical application to loading the driver and setting up the isoc
> >> handlers but blocking access to the dvb frontend device.
> >>
> >> Aside from the code that selectively disables analog support, the
> >> patch only seems to advance compatibility with your userland em28xx
> >> framework while providing no benefit to the in-kernel driver.
> >>
> >> Regarding the possibility of custom firmware, we currently do not have
> >> any devices in the in-kernel driver that make use of custom firmware.
> >> If you could tell me how to check for custom firmware versus the
> >> default vendor firmware, I could potentially do a patch that uses the
> >> vendor registers unless custom firmware is installed, at which point
> >> we could have custom logic (such as using the endpoint definition).
> >> However, given there are no such devices in-kernel, this is not a high
> >> priority as far as I am concerned.
> >>
> >> For what it's worth, I did add an additional patch to allow the user
> >> to disable the 480Mbps check via a modprobe option (to avoid a
> >> regression for any of your existing customers), and I will be checking
> >> in the code to properly compute the isoc size for em2874/em2884 based
> >> on the vendor registers (even though there are currently no supported
> >> devices in the kernel that require it currently).  However, I do not
> >> believe the patch you have proposed is appropriate for inclusion in
> >> the mainline kernel.
> >
> > Agree with you Devin.
> >
> > Also, the patch does a lot of changes instead of break it in several
> > patches.
> >
> 
> do you want smaller patches?

Markus,

Please break it into smaller patches, being one patch per change. This makes
easier for me to review and for people to comment each one of the addressed issues.



Cheers,
Mauro
