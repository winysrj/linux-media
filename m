Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:33768 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506Ab0C1Qgm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 12:36:42 -0400
Message-ID: <2835345.1269794199129.JavaMail.ngmail@webmail15.arcor-online.net>
Date: Sun, 28 Mar 2010 18:36:39 +0200 (CEST)
From: Stefan Ringel <stefan.ringel@arcor.de>
To: gtellalov@bigfoot.com, stefan.ringel@arcor.de
Subject: Aw: Re: Re: Hauppauge WinTV HVR-900H
Cc: linux-media@vger.kernel.org
In-Reply-To: <20100328153759.GA2893@joro.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
References: <20100328153759.GA2893@joro.homelinux.org> <20100328120729.GB6153@joro.homelinux.org>
 <20100328105145.GA2427@joro.homelinux.org>
 <27890244.1269777077513.JavaMail.ngmail@webmail18.arcor-online.net>
 <23371307.1269778330976.JavaMail.ngmail@webmail11.arcor-online.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 


----- Original Nachricht ----
Von:     George Tellalov <gtellalov@bigfoot.com>
An:      Stefan Ringel <stefan.ringel@arcor.de>
Datum:   28.03.2010 17:37
Betreff: Re: Re: Hauppauge WinTV HVR-900H

> On Sun, Mar 28, 2010 at 02:12:10PM +0200, Stefan Ringel wrote:
> >  
> > 
> > 
> > ----- Original Nachricht ----
> > Von:     George Tellalov <gtellalov@bigfoot.com>
> > An:      Stefan Ringel <stefan.ringel@arcor.de>
> > Datum:   28.03.2010 14:07
> > Betreff: Re: Hauppauge WinTV HVR-900H
> > 
> > > On Sun, Mar 28, 2010 at 01:51:17PM +0200, Stefan Ringel wrote:
> > > >  
> > > > In what for mode, analog or dvb-t?
> > > > 
> > > 
> > > The test? It was in analog mode using tvtime.
> > > 
> > 
> > And the dmsg log (with debug info), so we can see what wrong is. What for
> options have you set in the .config file?
> > 
> 
> Okay the same result with 2.6.33. I'm attaching my .config and dmesg's
> output.
> I also have debug=9 output but I'm not sure if it's appropriate to attach
> it
> here. Maybe I should gzip it?
> 

I said debug, but I see no debug info for tm6000 is it "modprobe tm6000 debug=1 debug_i2c=3". From what havew you debug activated? Have you a crash dump in the dmesg log? Can tvtime crash, and if tvtime crashed, then send it to tvtime project (ask Devin Heitmueller). 

Stefan Ringel <stefan.ringel@arcor.de>
