Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KiY2A-0005YI-5D
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 19:20:14 +0200
From: Darron Broad <darron@kewl.org>
To: Anders Semb Hermansen <anders@ginandtonic.no>
In-reply-to: <F70AC72F-8DF3-4A9A-BFA1-A4FED9D3EABC@ginandtonic.no> 
References: <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no>
	<5584.1222273099@kewl.org>
	<F70AC72F-8DF3-4A9A-BFA1-A4FED9D3EABC@ginandtonic.no>
Date: Wed, 24 Sep 2008 18:20:10 +0100
Message-ID: <6380.1222276810@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 and analogue tv
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <F70AC72F-8DF3-4A9A-BFA1-A4FED9D3EABC@ginandtonic.no>, Anders Semb Hermansen wrote:

hi.

>Den 24. sep.. 2008 kl. 18.18 skrev Darron Broad:
><snip>
>> I haven't tested analogue in mythtv, only dvb-s. My only testing has  
>> been
>> done with TVTIME for analogue. What happens when you try that?
>
>It seems to work ok. I struggeld a bit to get sound. Need to run this  
>also:
>arecord -f dat -D hw:2,0 | aplay -f dat -

This is how i test also.

>I saw this in my logs, but it seems to work okay (maybe these came  
>when I was trying difference sox and arecord/aplay commands):
>
>Sep 24 18:53:46 xpc kernel: [  769.020260] cx88[0]: irq aud [0x1001]  
>dn_risci1* dn_sync*

It looks like `dn_sync' is triggering that log. I don't know
anything about this but docs suggest it's a buffer underrun.
I am sure someone else can explain in full.

<snip>
>
>Does this mean that mythtv is doing something weird or maybe just  
>using the v4l api in a different way which the driver cannot handle?

This is feasable. I will take a look if I get the time but this
is more than likely to be when I have other reasons to look
at mythtv so don't expect an immediate response :-)

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
