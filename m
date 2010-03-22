Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:53355 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227Ab0CVW5w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 18:57:52 -0400
Subject: Re: Kworld Plus TV Hybrid PCI (DVB-T 210SE)
From: hermann pitton <hermann-pitton@arcor.de>
To: 0123peter@gmail.com
Cc: linux-media@vger.kernel.org,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <0h2e77-gjl.ln1@psd.motzarella.org>
References: <4B94CF9B.3060000@gmail.com>
	 <1268777563.5120.57.camel@pc07.localdom.local>
	 <0h2e77-gjl.ln1@psd.motzarella.org>
Content-Type: text/plain
Date: Mon, 22 Mar 2010 23:56:51 +0100
Message-Id: <1269298611.5158.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Am Samstag, den 20.03.2010, 16:20 +1100 schrieb 0123peter@gmail.com:
> on Wed, 17 Mar 2010 09:12 am
> in the Usenet newsgroup gmane.linux.drivers.video-input-infrastructure
> hermann pitton wrote:
> 
> [snip]
> > 
> > unfortunately the problem with these cards is known, but no good
> > solution for now.
> > 
> > Best description is from Hartmut and starts here.
> > 
> > http://www.spinics.net/lists/linux-dvb/msg26683.html
> > 
> [snip]
> 
> Interesting link.  I have one of the cards mentioned 
> (an MSI TV(at)nywhere A/D hybrid).  I've decided not to throw it away.  

to not leave you without any response at least.

In hind sight, seeing how unfortunate using such devices can be, mainly
because of being forced to try at random again with a cold boot after
some i2c war brought down the tuner, we better should have such only in
a still experimental league and not as supported.

This was not foreseeable in such rudeness and neither Hartmut nor me
have such devices.

The Asus triple OEM 3in1 I have does not have any problems with loading
firmware from file, the others do all get it from eeprom.

So, actually nobody is investigating on it with real hardware.

Maybe you can catch something with gpio_tracking and i2c_debug=1.
I would expect that the complex analog tuner initialization gets broken
somehow. This is at least known to be good to bring all down.

Cheers,
Hermann




 

