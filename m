Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server30.ukservers.net ([217.10.138.207])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@nzbaxters.com>) id 1KIHFl-0000np-5i
	for linux-dvb@linuxtv.org; Mon, 14 Jul 2008 08:09:44 +0200
Message-ID: <000301c8e578$1dbcd550$7501010a@ad.sytec.com>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: "Arthur Konovalov" <artlov@gmail.com>, "linux-dvb" <linux-dvb@linuxtv.org>
References: <20080615192300.90886244.SiestaGomez@web.de>	<4855F6B0.8060507@gmail.com><1213620050.6543.6.camel@pascal>	<20080616142616.75F9C3BC99@waldorfmail.homeip.net><1213626832.6543.23.camel@pascal>
	<4856B6FD.1080906@gmail.com>
Date: Mon, 14 Jul 2008 14:31:00 +1200
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

> Sigmund Augdal wrote:
>> Both transponders reported to not tune here has different symbolrates
>> from what I used for my testing. Maybe this is relevant in some way.
>> Could you please compare this with the channels that did tune to see if
>> there is a pattern?
>
> From my side i can add that all frequency from local cable provider's
> works with c-1501 except one:
> 274
> 282
> 290
> 298
> 306
> 314
> 386 NO LOCK
> 394
> 402
> 410
> All channels QAM64 and SR 6875.
>
> In the same PC I have second DVB-C card (KNC One DVB-C), which sharing
> same cable with c-1501 and there no problem with reception and signal's
> strength. This is reason why I did not discover current problem earlier. 
> :(
>
> Arthur

Did you have any luck tying this down?

I have a few channels which show no signal strength and won't lock, but it 
works on my other C-2300 and C-1500 cards.

Also, have a problem getting stable sound.  I switch to a new channel (with 
VDR) and the sound cuts in/out/in/out/in - and occasionally just in/out (ie 
no sound)

Have the current/latest changes been committed?  Or is there a latest patch 
floating around for v4l-dvb?? 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
