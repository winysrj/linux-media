Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:39021 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756730Ab0DODif (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 23:38:35 -0400
Subject: Re: Kworld Plus TV Hybrid PCI (DVB-T 210SE)
From: hermann pitton <hermann-pitton@arcor.de>
To: 0123peter@gmail.com
Cc: linux-media@vger.kernel.org
In-Reply-To: <iou897-qu3.ln1@psd.motzarella.org>
References: <4B94CF9B.3060000@gmail.com>
	 <1268777563.5120.57.camel@pc07.localdom.local>
	 <0h2e77-gjl.ln1@psd.motzarella.org>
	 <1269298611.5158.20.camel@pc07.localdom.local>
	 <0uh687-4c1.ln1@psd.motzarella.org>
	 <1269895933.3176.12.camel@pc07.localdom.local>
	 <iou897-qu3.ln1@psd.motzarella.org>
Content-Type: text/plain
Date: Thu, 15 Apr 2010 05:32:30 +0200
Message-Id: <1271302350.3184.16.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

to be honest, there is a little too much delay on those reports.

> > did not even notice a problem with Trent's prior patch.
> > The same is also at vivi.
> > 
> >> Should I have a file called /etc/modprobe.d/TVanywhereAD 
> >> that contains the line, 
> >> 
> >> options saa7134 card=94 gpio_tracking i2c_debug=1
> >> 
> >> and then watch the command line output of "kaffeine"?  
> 
> I've found a GUI that allows tweaking lots of module parameters 
> that I have never heard of.  Card=94 in the config file, 
> gpio_tracking and i2c_debug are set to "1" in the GUI.  
> 
> Strange things are appearing in dmesg and syslog.  I assume that 
> [snip]
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> i2c-adapter i2c-0: Invalid 7-bit address 0x7a
> saa7133[0]: i2c xfer: < 8e ERROR: NO_DEVICE
> [snip]
> is significant.  

No, not at all for my knowledge.

> > If you want to produce debug output for failing firmware loading from
> > file after a cold boot, yes, you might eventually be able to see that
> > failing tuner initialization brings down i2c.
> > 
> > If it is a additional new regression, then mercurial bisect can find the
> > patch in question fairly quick.
> 
> That sounds like something that I should be able to do, if only 
> I'd read the instructions.  

It is totally up to you and all others with that hardware.

Since already in some multiple broken conditions, never working without
flaws previously, I would suggest not to wait any longer, until some
sort of hadron collider is available ...

First try in all known ways.

We likely don't have the budget for anything else that soon ;)

Cheers,
Hermann


