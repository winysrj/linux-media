Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:58881 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbZCKOv3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 10:51:29 -0400
Subject: Re: Improve DKMS build of v4l-dvb?
From: Alain Kalker <miki@dds.nl>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <412bdbff0903110714o6f92c8cax96009226d033c611@mail.gmail.com>
References: <1236612894.5982.72.camel@miki-desktop>
	 <20090309204308.10c9afc6@pedra.chehab.org>
	 <1236771396.5991.24.camel@miki-desktop>
	 <alpine.LRH.2.00.0903110842570.1207@pedra.chehab.org>
	 <412bdbff0903110714o6f92c8cax96009226d033c611@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 15:51:24 +0100
Message-Id: <1236783084.5991.61.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op woensdag 11-03-2009 om 10:14 uur [tijdzone -0400], schreef Devin
Heitmueller:
> I hate to be the one to point this out, but isn't the notion of
> automatically rebuilding the modules for *your* hardware broken right
> from the start?  What this would mean that if I own a laptop and my
> USB based capture device happens to not be connected when I upgrade my
> kernel, then my drivers are going to be screwed up?

Not at all. Hardware detection needs to be done only once: when you
first plug in a new device. The result of this detection is then used to
generate a dkms.conf file, which specifies exactly which driver needs to
be (re-)built.
During initial install, and whenever you upgrade your kernel (Whether
you have the device plugged in or not), DKMS will (re-)build the driver
to match the (current or new) kernel and install its modules on your
system. Whenever you plug in your device, the modules making up its
driver will get loaded.

Kind regards,

Alain

