Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <w3ird_n3rd@gmx.net>) id 1K83v1-0001vM-FL
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 03:54:10 +0200
Message-ID: <4855C780.9040501@gmx.net>
Date: Mon, 16 Jun 2008 03:53:04 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <4852C2FE.6040107@gmx.net>
In-Reply-To: <4852C2FE.6040107@gmx.net>
Subject: Re: [linux-dvb] Technisat Airstar USB round two
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

On 06/13/2008 08:57 PM, P. van Gaans wrote:
> Approximately a year ago I tried to make this USB DVB-T box work. But it 
> wouldn't. With a little more knowledge today I tried again with v4l-dvb 
> from hg, but it still won't go. I get this when I plug it in:
> 
> [ 3083.152125] usb 1-2: new full speed USB device using ohci_hcd and 
> address 4
> [ 3083.253055] usb 1-2: configuration #1 chosen from 1 choice
> [ 3083.258204] flexcop_usb: running at FULL speed.
> [ 3083.501399] DVB: registering new adapter (FlexCop Digital TV device)
> [ 3083.502758] b2c2-flexcop: MAC address = 00:d0:d7:09:e7:70
> [ 3083.516842] CX24123: wrong demod revision: 0
> [ 3083.612219] b2c2-flexcop: found 'Zarlink MT352 DVB-T' .
> [ 3083.612226] DVB: registering frontend 1 (Zarlink MT352 DVB-T)...
> [ 3083.612261] b2c2-flexcop: initialization of 'Air2PC/AirStar 2 DVB-T' 
> at the 'USB' bus controlled by a 'FlexCopIII' complete
> [ 3083.621757] flexcop_usb: Technisat/B2C2 FlexCop II/IIb/III Digital TV 
> USB Driver successfully initialized and connected.
> 
> Note the "CX24123: wrong demod revision: 0". What's with that? It looks 
> like something is wrong.
> 
> I get this when I unplug it:
> 
> [ 3081.464885] flexcop_usb: iso frame descriptor 0 has an error: -62
> [ 3081.464887]
> [ 3081.464892] flexcop_usb: iso frame descriptor 1 has an error: -62
> [ 3081.464893]
> [ 3081.464895] flexcop_usb: iso frame descriptor 2 has an error: -62
> [ 3081.464896]
> [ 3081.464897] flexcop_usb: iso frame descriptor 3 has an error: -62
> [ 3081.464898]
> [ 3081.468884] flexcop_usb: iso frame descriptor 0 has an error: -62
> [ 3081.468886]
> [ 3081.468891] flexcop_usb: iso frame descriptor 1 has an error: -62
> [ 3081.468892]
> [ 3081.468894] flexcop_usb: iso frame descriptor 2 has an error: -62
> [ 3081.468895]
> [ 3081.468896] flexcop_usb: iso frame descriptor 3 has an error: -62
> [ 3081.468897]
> [ 3081.472876] flexcop_usb: iso frame descriptor 0 has an error: -62
> [ 3081.472877]
> [ 3081.472879] flexcop_usb: iso frame descriptor 1 has an error: -62
> [ 3081.472880]
> [ 3081.472881] flexcop_usb: iso frame descriptor 2 has an error: -62
> [ 3081.472882]
> [ 3081.472883] flexcop_usb: iso frame descriptor 3 has an error: -62
> [ 3081.472885]
> [ 3081.475209] usb 1-2: USB disconnect, address 3
> [ 3081.479869] flexcop_usb: iso frame descriptor 0 has an error: -62
> [ 3081.479871]
> [ 3081.479873] flexcop_usb: iso frame descriptor 1 has an error: -62
> [ 3081.479874]
> [ 3081.479875] flexcop_usb: iso frame descriptor 2 has an error: -62
> [ 3081.479876]
> [ 3081.479877] flexcop_usb: iso frame descriptor 3 has an error: -18
> [ 3081.479878]
> [ 3081.479880] flexcop_usb: iso frame descriptor 0 has an error: -18
> [ 3081.479881]
> [ 3081.479883] flexcop_usb: iso frame descriptor 1 has an error: -18
> [ 3081.479884]
> [ 3081.479885] flexcop_usb: iso frame descriptor 2 has an error: -18
> [ 3081.479886]
> [ 3081.479887] flexcop_usb: iso frame descriptor 3 has an error: -18
> [ 3081.479888]
> [ 3081.479890] flexcop_usb: iso frame descriptor 0 has an error: -18
> [ 3081.479891]
> [ 3081.479892] flexcop_usb: iso frame descriptor 1 has an error: -18
> [ 3081.479893]
> [ 3081.479895] flexcop_usb: iso frame descriptor 2 has an error: -18
> [ 3081.479896]
> [ 3081.479897] flexcop_usb: iso frame descriptor 3 has an error: -18
> [ 3081.479898]
> [ 3081.479900] flexcop_usb: iso frame descriptor 0 has an error: -18
> [ 3081.479901]
> [ 3081.479902] flexcop_usb: iso frame descriptor 1 has an error: -18
> [ 3081.479903]
> [ 3081.479904] flexcop_usb: iso frame descriptor 2 has an error: -18
> [ 3081.479905]
> [ 3081.479906] flexcop_usb: iso frame descriptor 3 has an error: -18
> [ 3081.479907]
> [ 3081.480307] flexcop_usb: Technisat/B2C2 FlexCop II/IIb/III Digital TV 
> USB Driver successfully deinitialized and disconnected.
> 
> I think it doesn't like being unplugged. The problem is still the same: 
> I see the device in /dev/dvb and in Kaffeine, when I try to watch a 
> channel I see the ACT LED on the device blink a bit, but the LOCK LED 
> will never light up and I never get to watch anything. Using Ubuntu 8.04.
> 
> P.
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

Doesn't anyone have any idea, or even care about this device? I can't 
find any Conexant chip in there, unless it would be inside the tuner.

If nobody cares about it (I see only one secondhand Airstar USB on eBay 
and it looks different from mine), I'll sell mine and forget about it. 
Otherwise.. Please post.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
