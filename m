Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbZJNMb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 08:31:56 -0400
Date: Wed, 14 Oct 2009 09:30:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ali Abdallah <aliov@xfce.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppage WinTV-HVR-900H
Message-ID: <20091014093038.423f3304@pedra.chehab.org>
In-Reply-To: <4AD5D5F2.9080102@xfce.org>
References: <4ACDF829.3010500@xfce.org>
	<37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>
	<4ACDFED9.30606@xfce.org>
	<829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>
	<4ACE2D5B.4080603@xfce.org>
	<829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>
	<4ACF03BA.4070505@xfce.org>
	<829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>
	<4ACF714A.2090209@xfce.org>
	<829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>
	<4AD5D5F2.9080102@xfce.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 14 Oct 2009 13:45:22 +0000
Ali Abdallah <aliov@xfce.org> escreveu:

> Follow up, i manager to get the hvr 900 instead the 900H, and i got the 
> same result with the analog signal, i tried with my friend's windows 
> system, same result, no analog channels detected, however i got all the 
> channels a hvr pci card, so i expect these USB keys needs really a very 
> strong signal, so there is no problem in the driver, sorry for the 
> noise, hopefully the 900H will get a driver soon.

The PC cards generally require stronger signals than TV sets. PCI cards are
worse, since there are lots of interference inside the PC box.

It should be noticed that several tuner drivers don't have signal detection (or not
have it implemented). This is the case of xc3028, so you'll need to turn off
signal detection while tuning, and be sure that you're loading the proper frequency
table used on your Country.



Cheers,
Mauro
