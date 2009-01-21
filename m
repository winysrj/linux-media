Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <d.dalton@iinet.net.au>) id 1LPR7r-0003Hp-6A
	for linux-dvb@linuxtv.org; Wed, 21 Jan 2009 01:39:25 +0100
Date: Wed, 21 Jan 2009 11:39:15 +1100
From: Daniel Dalton <d.dalton@iinet.net.au>
To: linux-dvb@linuxtv.org
Message-ID: <20090121003915.GA6120@debian-hp.lan>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi>
	<20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49765448.8060108@iki.fi>
Subject: Re: [linux-dvb] getting started with msi tv card
Reply-To: linux-media@vger.kernel.org
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

Hi Antti,

On Wed, Jan 21, 2009 at 12:46:32AM +0200, Antti Palosaari wrote:
> Yes, should work out of the box. No need to install any driver, driver 
> is included in your Kernel.

/dev/dvb/adapter0/ is created. so does this mean the right modules have
been loaded?

> >> However, tuner performance is not very good. With weak signal it works 
> >> better than strong. All remote keys are not working because driver does 
> >> not upload IR-table to the chip.
> > 
> > ok
> 
> I have newer one, gl861 5581, and this is the version which have remote 
> problem. I think older Megasky have all remote buttons functional.

Ah good

> 
> > Mplayer works with this card? Great!
> > 
> > How would I begin configuring it for mplayer then?
> 
> I think mplayer is not very user friendly, try Kaffeine or Me-TV 
> instead. Kaffeine have own channel scanner so it is very easy to 
> configure. Otherwise you will need initial tuning file and then scan to 
> get channels.conf. Try google for more info.

I've been googling, and have played with w_scan and me-tv.
Kaffeine unfortunately is qt and won't work with braille/speech, but
me-tv does. So I got sighted help to scan for channels in kaffeine, the
scan didn't find any channels.
Next, I ran the w_scan program, and that as well failed to find any
channels. Finally, I ran me-tv and that as well failed. (I selected my
location for me-tv).

So, how do I get w_scan or me-tv to find some channels? It's probably
not worth talking about kaffeine as I won't be able to use this. I'm
plugging my usb receiver into a tv connection in my home which a
standard tv would plug into.

Any ideas?

Thanks very much for your help,

Daniel.


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
