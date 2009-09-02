Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:35074 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753828AbZIBXaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 19:30:06 -0400
Subject: Re: (EC168) PC Basic TNT USB Basic V5 ( France ) recognized but no
	channel tuning
From: hermann pitton <hermann-pitton@arcor.de>
To: Morvan Le Meut <mlemeut@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
In-Reply-To: <4A9EF92B.2000506@gmail.com>
References: <4A9EC8B3.10904@gmail.com> <4A9EEBB2.60709@iki.fi>
	 <4A9EF92B.2000506@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 03 Sep 2009 01:12:52 +0200
Message-Id: <1251933172.3253.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Donnerstag, den 03.09.2009, 01:00 +0200 schrieb Morvan Le Meut:
> Antti Palosaari a écrit :
> >
> > Did you used the firmware from the CD? It will not work because it 
> > does not have "warm" USB ID, it is all zero and due to that device 
> > will disappear from driver perspective.
> > You should use that firmware:
> > http://palosaari.fi/linux/v4l-dvb/firmware/ec168/
> >
> > Antti
> I tried both with the same result. ( I'm not ruling out user error since 
> i've a similar problem with an HVR 1110 (sold as a 1100 ) but it is 
> strange that only my newest TV cards have problems ). Maybe i should try 
> it with Windows to check if the card itself works.
> 

Hi Morvan,

HVR 1100 and HVR 1110 are totally different boards.

How does GNU/Linux detect the board on your recent kernel?

Sorry, I might be in delay reading previous messages.

Even on the HVR 1110 we have unclear situations, concerning that some of
them might have an additional LowNoiseAmplifier, which needs to be
configured correctly, and others not.

It might even be the case, that there are at least three different types
of such LNAs recently, and we don't know how to detect them.

All needing a different setup.

Please copy/paste device related dmesg output.

I still have not give up on it, that we might be able to identify those
different devices in the future.

Until somebody tells me better ...

Cheers,
Hermann




