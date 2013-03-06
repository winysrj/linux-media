Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:21686 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3CFTff (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 14:35:35 -0500
Date: Wed, 6 Mar 2013 20:35:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: TerraTec Cinergy T PCIe Dual not working
Message-ID: <20130306203525.3d7b0588@endymion.delvare>
In-Reply-To: <513785C5.8040702@schinagl.nl>
References: <20130306142713.6a68179a@endymion.delvare>
	<51374B6D.9010805@schinagl.nl>
	<20130306160335.01cc5cd4@endymion.delvare>
	<513785C5.8040702@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

On Wed, 06 Mar 2013 19:07:01 +0100, Oliver Schinagl wrote:
> On 03/06/13 16:03, Jean Delvare wrote:
> > It turns out that my problem is the antenna. I was using the antenna I
> > have been using with my previous card, which is an internal DVB-T
> > antenna with amplification (external power supply.) I get zero signal
> > with that. But using the Terratec-provided cheap "stick" antenna, I get
> > signal again, with reasonable quality (although not as stable as with
> > the old card and the powered antenna.) I also get signal (but not all
> > channels) with my original antenna _unpowered_ (thus signal not
> > amplified.)
> >
> > I admit I don't quite understand. I would understand that a bad,
> > unpowered antenna causes no signal to be sensed. But how is it possible
> > that a supposedly better, powered antenna causes that kind of issue?
> >
> > Oliver, out of curiosity, what antenna are you using? The
> > Terratec-provided one, or another one?
>
> Right now, I use 11cm stripped coax :) But that's because I live 600 
> meters from the broadcasting tower. This actually gives me the best 
> reception. The mini antenna that came with the thing worked quite well, 
> but the wire was a bit short.
> 
> Besides that I did use a powered antenna for a while, without the power 
> connected, because it actually dampens the signal. That worked quite 
> well for a while. Using it powered, with an external power source, 
> actually made it much worse.

My experience matches yours exactly. Thanks for confirming. I wonder if
this is a limitation of the Linux drivers (not adjusting the tuner
sensibility to the signal strength) or a hardware characteristic.

-- 
Jean Delvare
