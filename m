Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:4475 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZGAIM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2009 04:12:57 -0400
Received: by an-out-0708.google.com with SMTP id d40so1490986and.1
        for <linux-media@vger.kernel.org>; Wed, 01 Jul 2009 01:12:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0907010911570.5262@ybpnyubfg.ybpnyqbznva>
References: <c21478f30906301936u40ac989fj9e2824b209ab2346@mail.gmail.com>
	 <alpine.DEB.2.01.0907010911570.5262@ybpnyubfg.ybpnyqbznva>
Date: Wed, 1 Jul 2009 18:12:58 +1000
Message-ID: <c21478f30907010112v5780b345icb22fdbb94dd84dd@mail.gmail.com>
Subject: Re: Digital Audio Broadcast (DAB) devices support
From: Andrej Falout <andrej@falout.org>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for that Barry, it seems Terratec Cinergy Piranha was indeed
discontinued, as I cant find it in shops anywhere? It's still on the
web site (http://www.terratec.net/en/products/Cinergy_Piranha_1668.html)

EyeTV even has built-in support for it :

http://forums.mactalk.com.au/11/32929-eyetv-2-5-1-a.html

But on Terratec site, there is no mention of Linux drivers for this product.

Shame. I would be happy with that one.

Anyone else know of something equivalent that works on Linux?

Cheers,
Andrej Falout


On Wed, Jul 1, 2009 at 5:30 PM, BOUWSMA Barry<freebeer.bouwsma@gmail.com> wrote:
> On Wed, 1 Jul 2009, Andrej Falout wrote:
>
>> Does V4L framework support DAB devices?
>
> Jein.  The V4L framework at present lacks some of what is needed
> to control and de-encode the Eureka 147 DAB/DAB+ family
> broadcasts.
>
> However, there is at least one set of chipmaker's devices out
> there which can be used under Linux, making use of a vendor-
> supplied library to take care of the tuning and demultiplexing
> of one audio stream.  This chipmaker, Siano, is present in this
> forum, and either has already, or is in the progress of submitting
> patches to make it trivial to use their devices.  (I've stopped
> following closely)
>
> Search the list archives, as well as those of the original
> linux-dvb list, for pointers to their library and documentation,
> as well as to patches which I've successfully applied months ago.
>
> As far as devices with this family of chip, the only one I am
> aware of is the Terratec Cinergy Piranha, which I believe has
> been discontinued, and I'm not sure how widely through the world
> it has been available.  I don't know of others, and while I have
> read that at least one other chip manufacturer has a combination-
> format chipset in production, I don't know which products might
> contain it, or whether support under linux is possible.
>
>
> There is also a `dabusb' device available in the kernel, but
> this is for one particular device, and probably not that
> relevant to today's products.
>
>
>
> As far as extending the V4L framework to handle DAB, that will
> need someone far more familiar with the DAB family, and with the
> devices now available which can receive it, than I am.
>
> However, I can presently receive broadcasts under linux with the
> vendor-provided software, which is a start, and enough to keep
> me quiet.
>
>
> barry bouwsma
>
