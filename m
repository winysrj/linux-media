Return-path: <linux-media-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:36475 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1HDN03 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 09:26:29 -0400
Date: Thu, 4 Aug 2011 15:26:19 +0200
From: Florian Mickler <florian@mickler.org>
To: cedric.dewijs@telfort.nl
Cc: linux-media@vger.kernel.org,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	olivier.grenie@dibcom.fr
Subject: Re: Betr: [linux-dvb] dib0700 hangs when usb receiver is unplugged
 while	watching TV
Message-ID: <20110804152619.698ac9a2@schatten.dmk.lab>
In-Reply-To: <4E095BE300005B2C@mta-nl-9.mail.tiscali.sys>
References: <4DF7665C00004DEC@mta-nl-1.mail.tiscali.sys>
	<4E095BE300005B2C@mta-nl-9.mail.tiscali.sys>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To the best of my knowledge, you did. I cc'd Patrick and Olivier who are involved
with dibxxxx ... 


On Sun, 10 Jul 2011 09:22:05 +0200
cedric.dewijs@telfort.nl wrote:

> 
> >-- Oorspronkelijk bericht --
> >Date: Fri, 24 Jun 2011 11:01:37 +0200
> >From: cedric.dewijs@telfort.nl
> >To: linux-dvb@linuxtv.org
> >Subject: [linux-dvb] dib0700 hangs when usb receiver is unplugged while
> >	watching TV
> >Reply-To: linux-media@vger.kernel.org
> >
> >
> >Hi All,
> >
> >I have the PCTV nanostick solo. This works perfectly, but when I pull out
> >the stick while i'm watching TV, the driver crashes. When I replug the stick,
> >there's no reaction in dmesg.
> >
> >To reproduce:
> >1)plugin the stick
> >1a)scan channels with scan, see also 
> >https://wiki.archlinux.org/index.php/Digitenne#Configure_Sasc-ng
> >2)use tzap, cat and mplayer to watch TV
> >3)unplug the stick
> >4)watch the fireworks in /var/log/everything.log (dmesg)
> 
> Hi All,
> 
> Did I post the above message in the correct mailing list?
> 
> Best regards,
> Cedric


