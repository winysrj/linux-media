Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KkN8Y-0003n4-Nl
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 20:06:23 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7Y002JEY9HHK60@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 29 Sep 2008 14:05:47 -0400 (EDT)
Date: Mon, 29 Sep 2008 14:05:41 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <e32e0e5d0809280829l690d076epe62f4d131806a65a@mail.gmail.com>
To: Tim Lucas <lucastim@gmail.com>
Message-id: <48E118F5.5090501@linuxtv.org>
MIME-version: 1.0
References: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
	<48D34C69.6050700@linuxtv.org>
	<e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
	<e32e0e5d0809232050s1d0257e3m30c9c055e9d32dd6@mail.gmail.com>
	<48DA9330.6070005@linuxtv.org>
	<e32e0e5d0809241315rd423c0dj553812167194d4a3@mail.gmail.com>
	<48DADA06.9000105@linuxtv.org>
	<e32e0e5d0809251807l6f0080c3j673af97821454581@mail.gmail.com>
	<e32e0e5d0809280829l690d076epe62f4d131806a65a@mail.gmail.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
 FusionHDTV7 Dual Express (Read this one)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Tim Lucas wrote:
> On Thu, Sep 25, 2008 at 6:07 PM, Tim Lucas <lucastim@gmail.com 
> <mailto:lucastim@gmail.com>> wrote:
> 
>     OK, so I tested both s-video and composite inputs.  I get video for
>     s-video, but not composite.  The video seems to flicker a little bit
>     in tv time.  I just have standard rca cables plugged in for audio,
>     but I can;t get any sound.
>     I tried changing the "tuner-type" to 0xc2, 0xc4, and 0x61.  All
>     three gave the same results.
> 
>          --Tim
> 
> 
> So the good news was that the s-video was working.  I want to make sure 
> that I hooked up the sound correctly.  I can't imagine that there is any 
> other way than the rca cables.  So what is next?

That's a great step forward. That means the tv input will probably 
produce the correct input if the tuner is set correctly.

Switch to this tree http://linuxtv.org/hg/~stoth/cx23885-audio and try 
again with the svideo and audio tests.

Mijhail Moreyra wrote some HVR1500 audio patches, which I have not 
tested yet. Do these produce audio for you via the svideo and breakout 
RCA audio input cable?


> 
> The only things that I can adjust in cx23885-cards.c is the "tuner-type" 
>  I've tried various suggestions, but had no luck.  Are there other 
> parameters that can be changed?  

Look at how the HVR1500 analog tuner is setup in this tree, it may help 
- especially with the tuner setup.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
