Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:60157 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbZJOLOR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 07:14:17 -0400
Received: by fxm27 with SMTP id 27so947115fxm.17
        for <linux-media@vger.kernel.org>; Thu, 15 Oct 2009 04:13:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091015104509.GO6384@www.viadmin.org>
References: <23582ca0910140607v54a15d46y7ac834a3b6255af3@mail.gmail.com>
	 <20091015104509.GO6384@www.viadmin.org>
Date: Thu, 15 Oct 2009 13:13:39 +0200
Message-ID: <23582ca0910150413l10246d04v19306a257c8f36c6@mail.gmail.com>
Subject: Re: [linux-dvb] request driver for cards
From: Theunis Potgieter <theunis.potgieter@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/10/2009, H. Langos <henrik-dvb@prak.org> wrote:
> On Wed, Oct 14, 2009 at 03:07:00PM +0200, Theunis Potgieter wrote:
>  > Hi, what is the procedure to request drivers for specific new, perhaps
>  > unknown supported cards?
>
>
> The "procedure" is to hit google with something
>  like "linux <vendor> <model>" and see what you find. :-)
>
I meant to say: Where do I ask for a new driver to be written for an
unsupported card. Or Perhaps the card is already supported and I just
couldn't see it from a singular view. (linuxtv.org, mailing list,
Google)

>  Especially links to mailing list archives like linux-media and linux-dvb
>  are worth a read.
>
>
I joined linux-dvb@linuxtv.org recently and I was informed that the
mailing list is deprecated and I should join this mailing list
instead. (you will see my first mail on their list too)

>
>  > Perhaps I shouldn't waste time if I could find a dual/twin tuner card for
>  > dvb-s or dvb-s2. Are there any recommended twin-tuner pci-e cards that is
>  > support and can actually be bought by the average consumer?
>
>
> Did you risk a look at any of those?
>
>  http://www.linuxtv.org/wiki/index.php/DVB-S_PCI_Cards
>  http://www.linuxtv.org/wiki/index.php/DVB-S_PCIe_Cards
>  http://www.linuxtv.org/wiki/index.php/DVB-S2_PCI_Cards
>  http://www.linuxtv.org/wiki/index.php/DVB-S2_PCIe_Cards
>

I did visit those, and I couldn't find any sellers of the twin tuner
cards on  http://www.linuxtv.org/wiki/index.php/DVB-S2_PCIe_Cards :(
They would be perfect. Exept I can't find where to buy these. Perhaps
they are re-branded and somebody here knows this already?

This site http://www.linuxtv.org/wiki/index.php/DVB-S_PCI_Cards does
not list the Compro S300 neither the KWorld dvb-s 100. I just happened
to grep -i kworld /usr/src/linux/drivers/media/dvb/*/* and found
KWorld to be somewhat supported. Great so I know that one. How to
approach Compro S300?

The problem is this: Either I setup my old penium 3 machine with 5 pci
slots (which I try to avoid) or buy a new machine with only 2 pci
slots and 2 pci-e 1x slots. The options becomes limited on new
machines if you want 4 or more tuners in the same machine. So I need
some advice if it is feasible to run 5 dvb-s single tuner cards in a
pentium3 or 5 tuners (2 twin tuner cards and single card) on an atom
based machine?

>  I suspect they might contain some usable informaion. You should however
>  take into account that most developers don't care to update a bazillion
>  different places after they added support for a particular devices. So
>  in most cases there will be a brief announcment on the developers
>  mailinglist and the code is the documentation.
>

I recently joined this mailing list and will be a lookout for anything
related to twin tuner cards sent by developers. Or if somebody knows
just reply to this thread.

Thanks for the help.

>  cheers
>  -henrik
>
