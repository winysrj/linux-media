Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns218.ovh.net ([213.186.34.114])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <webdev@chaosmedia.org>) id 1KZPOh-000324-U8
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 14:17:44 +0200
Received: from localhost (localhost [127.0.0.1])
	by ns218.ovh.net (Postfix) with ESMTP id 5582B4E83D
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 14:17:00 +0200 (CEST)
Received: from ns218.ovh.net ([127.0.0.1])
	by localhost (ns218.ovh.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k5hwWpbbu2mR for <linux-dvb@linuxtv.org>;
	Sat, 30 Aug 2008 14:17:00 +0200 (CEST)
Received: from [192.168.0.50] (droid.chaosmedia.org [82.225.228.49])
	by ns218.ovh.net (Postfix) with ESMTP id 1BCE18524
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 14:17:00 +0200 (CEST)
Message-ID: <48B93A3B.6090301@chaosmedia.org>
Date: Sat, 30 Aug 2008 14:16:59 +0200
From: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <48B8400A.9030409@linuxtv.org>
In-Reply-To: <48B8400A.9030409@linuxtv.org>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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


It's not my place to judge if the problem is moving in the right 
direction or not but it's a good thing that something happens.
I'll trust the experienced devs whom acked this proposal.

Writting a multiproto patch for kaffeine to get dvb-s2 support, got me 
to learn a bit about v4l-dvb api and multiproto. Again i'm no 
experienced coder, i followed some examples to keep v4l-dvb backward 
compatibility and it wasn't really a walk in the park nor was it really 
necessary now that i look at it, either your use multiproto or you don't 
and if you do, patch your app and build it again.
But well it's working and that's what was most important to me, to get 
it working "asap".

So as Christophe Thommeret wrote, who helped a lot dealing with 
kaffeine, i'll support whichever api is going to bring dvb-s2 and new 
dvb hardware support to the kernel.

In the meantime i'll keep using and maintaining my multiproto patch as 
it's curently done with most other applications, so end users don't have 
to wait for the whole kernel thing to get completed.

And of course if or when the new api has to be tested and modifications 
to be done on the application side, i'll join the effort.

Marc.

Acked-by: Marc Delcambre <webdev@chaosmedia.org>



Steven Toth wrote:
> Regarding the multiproto situation:
>
> .....
>
> We're not asking you for technical help, although we'd like that  :) ,
> we're just asking for your encouragement to move away from multiproto.
>
> If you feel that you want to support our movement then please help us by
> acking this email.
>
> Regards - Steve, Mike, Patrick and Mauro.
>
> Acked-by: Patrick Boettcher <pb@linuxtv.org>
> Acked-by: Michael Krufky <mkrufky@linuxtv.org>
> Acked-by: Steven Toth <stoth@linuxtv.org>
> Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>
> * [1]. Rather than point out the issues with multiproto here, take a
> look at the patches and/or read the comments on the mailing lists.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
