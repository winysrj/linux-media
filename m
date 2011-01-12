Return-path: <mchehab@pedra>
Received: from web63402.mail.re1.yahoo.com ([69.147.97.42]:46966 "HELO
	web63402.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932675Ab1ALD2u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 22:28:50 -0500
Message-ID: <518438.15436.qm@web63402.mail.re1.yahoo.com>
Date: Tue, 11 Jan 2011 19:22:08 -0800 (PST)
From: oblib <oblib5@yahoo.com>
Subject: Re: Working on Avermedia Duet A188 (saa716x and lgdt3304)
To: linux-media@vger.kernel.org
Cc: mkrufky@linuxtv.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--- On Sat, 4/3/10, oblib wrote:

> From: oblib
> Subject: Working Avermedia Duet A188 (saa716x and lgdt3304)
> To: linux-media@vger.kernel.org
> Cc: mrechberger@empiatech.com
> Date: Saturday, April 3, 2010, 7:33 AM
> I'm trying to get the Avermedia Duet
> A188 up and working again (see the list about a year ago)
> and I'm running into the same problem. I'm using Manu's
> SAA716x driver, and I've modified the budget version to
> identify with my card. I copied the vp1028 frontend attach
> function and modified it to call lgdt3304_attach. 
> 
> When I compile and load, I get two dvb adaptors with
> frontends, but of course it can't tune successfully because
> I don't know the i2c address to pass to lgdt3304_attach.
> This where I need some help. I don't see any other driver
> using the lgdt3304, and even if there was another one, the
> i2c address wouldn't be the same. How do I determine the
> address? It's a ubyte value, so I could even manually try
> all 256 addresses, but I don't know how to tell if it's
> successfully addressed or not.
> 
> Also, seeing as I don't see anyone else using this driver
> and it's got comments saying "not yet tested," will the
> driver even work correctly for this application if I get the
> right address? If not, how do I fix it?
> 
> Thanks in advance for the help!
> 
> 

I'd like to try this again, as my last working tuner died this week. I've had this card sitting around for over a year hoping for support, but it doesn't look like anyone else is working on it.

What kind of information is needed to make the card work? Will I need to find firmware somewhere? It looks like the basics are there with Manu's work on the SAA716x and Jared and Michael's work on the LGDT3304, but how do I customize these to work with the A188?

Any help would be appreciated, thanks!

Oblib


      
