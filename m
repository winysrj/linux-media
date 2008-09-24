Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gordons.ginandtonic.no ([195.159.29.69])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anders@ginandtonic.no>) id 1KiXlL-0003yu-CM
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 19:02:52 +0200
Message-Id: <F70AC72F-8DF3-4A9A-BFA1-A4FED9D3EABC@ginandtonic.no>
From: Anders Semb Hermansen <anders@ginandtonic.no>
To: Darron Broad <darron@kewl.org>
In-Reply-To: <5584.1222273099@kewl.org>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Wed, 24 Sep 2008 19:02:11 +0200
References: <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no>
	<5584.1222273099@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-4000 and analogue tv
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

Den 24. sep.. 2008 kl. 18.18 skrev Darron Broad:
<snip>
> I haven't tested analogue in mythtv, only dvb-s. My only testing has  
> been
> done with TVTIME for analogue. What happens when you try that?

It seems to work ok. I struggeld a bit to get sound. Need to run this  
also:
arecord -f dat -D hw:2,0 | aplay -f dat -

I saw this in my logs, but it seems to work okay (maybe these came  
when I was trying difference sox and arecord/aplay commands):

Sep 24 18:53:46 xpc kernel: [  769.020260] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020269] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020277] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020286] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020294] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020310] cx88[0]: irq aud [0x1000]  
dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020318] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020327] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020335] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020343] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020352] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020362] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020375] cx88[0]: irq aud [0x1000]  
dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020382] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020391] cx88[0]: irq aud [0x1000]  
dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020399] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020407] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020416] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020424] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020439] cx88[0]: irq aud [0x1000]  
dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020447] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020456] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020464] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020473] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 18:53:46 xpc kernel: [  769.020481] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*


Does this mean that mythtv is doing something weird or maybe just  
using the v4l api in a different way which the driver cannot handle?


Thanks for your response,
Anders


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
