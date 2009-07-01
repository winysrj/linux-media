Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64317 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZGAHad (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2009 03:30:33 -0400
Received: by ewy6 with SMTP id 6so863619ewy.37
        for <linux-media@vger.kernel.org>; Wed, 01 Jul 2009 00:30:35 -0700 (PDT)
Date: Wed, 1 Jul 2009 09:30:27 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Andrej Falout <andrej@falout.org>
cc: linux-media@vger.kernel.org
Subject: Re: Digital Audio Broadcast (DAB) devices support
In-Reply-To: <c21478f30906301936u40ac989fj9e2824b209ab2346@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0907010911570.5262@ybpnyubfg.ybpnyqbznva>
References: <c21478f30906301936u40ac989fj9e2824b209ab2346@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 1 Jul 2009, Andrej Falout wrote:

> Does V4L framework support DAB devices?

Jein.  The V4L framework at present lacks some of what is needed
to control and de-encode the Eureka 147 DAB/DAB+ family 
broadcasts.

However, there is at least one set of chipmaker's devices out
there which can be used under Linux, making use of a vendor-
supplied library to take care of the tuning and demultiplexing
of one audio stream.  This chipmaker, Siano, is present in this
forum, and either has already, or is in the progress of submitting
patches to make it trivial to use their devices.  (I've stopped
following closely)

Search the list archives, as well as those of the original
linux-dvb list, for pointers to their library and documentation,
as well as to patches which I've successfully applied months ago.

As far as devices with this family of chip, the only one I am
aware of is the Terratec Cinergy Piranha, which I believe has
been discontinued, and I'm not sure how widely through the world
it has been available.  I don't know of others, and while I have
read that at least one other chip manufacturer has a combination-
format chipset in production, I don't know which products might
contain it, or whether support under linux is possible.


There is also a `dabusb' device available in the kernel, but
this is for one particular device, and probably not that
relevant to today's products.



As far as extending the V4L framework to handle DAB, that will
need someone far more familiar with the DAB family, and with the
devices now available which can receive it, than I am.

However, I can presently receive broadcasts under linux with the
vendor-provided software, which is a start, and enough to keep
me quiet.


barry bouwsma
