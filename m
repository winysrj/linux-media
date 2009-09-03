Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:33883 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932423AbZICXCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 19:02:36 -0400
Subject: Re: (EC168) PC Basic TNT USB Basic V5 ( France ) recognized but no
	channel tuning
From: hermann pitton <hermann-pitton@arcor.de>
To: Morvan Le Meut <mlemeut@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4A9F56B4.9000809@gmail.com>
References: <4A9EC8B3.10904@gmail.com> <4A9EEBB2.60709@iki.fi>
	 <4A9EF92B.2000506@gmail.com> <1251933172.3253.14.camel@pc07.localdom.local>
	 <4A9F56B4.9000809@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2009 00:45:12 +0200
Message-Id: <1252017912.3252.22.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Donnerstag, den 03.09.2009, 07:40 +0200 schrieb Morvan Le Meut:
> hermann pitton a écrit :
> > Hi Morvan,
> >
> > HVR 1100 and HVR 1110 are totally different boards.
> >
> > How does GNU/Linux detect the board on your recent kernel?
> >
> > Sorry, I might be in delay reading previous messages.
> >
> > Even on the HVR 1110 we have unclear situations, concerning that some of
> > them might have an additional LowNoiseAmplifier, which needs to be
> > configured correctly, and others not.
> >
> > It might even be the case, that there are at least three different types
> > of such LNAs recently, and we don't know how to detect them.
> >
> > All needing a different setup.
> >
> > Please copy/paste device related dmesg output.
> >
> > I still have not give up on it, that we might be able to identify those
> > different devices in the future.
> >
> > Until somebody tells me better ...
> >
> > Cheers,
> > Hermann
> >
> >
> >   
> it is a 1110 one ( triangular shaped ) but it may be a new design or 
> something else. I don't have it here for the moment so i can't give 
> exact info but i tried the "card=104" and "card=156" options ( no 
> autodetection )  with no result ( analog TV and DVB  didn't work ).
>  ( In the meantime, it's back in its box, waiting for a day where it 
> will work with my mythbuntu box :) )
> 

Without knowing the kernel version on your mythbuntu I can't tell
anything.

For what I know so far, all HVR 1110 variants should be supported with
recent v4l-dvb code.

We run into some maintenance trouble, because we don't know on which of
those are additional LNAs, maybe even different types of LNAs.

Currently it looks like that we have some Pinnacle 310i devices broken
in favour to have in detail unknown HVR 1110 boards working with LNA
support.

It would be much better to escape from such and not to add more and more
unclear hardware on it.

For broken Pinnacle LNA devices are patches to test available to get
them back, others still do work unchanged, also to enable antenna
voltage for those in need of it is possible.

You should try your HVR 1110 variant with recent code and report again
with details from dmesg for it, if it still should fail.

Cheers,
Hermann


