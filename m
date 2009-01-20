Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <d.dalton@iinet.net.au>) id 1LPOkY-0003iI-FB
	for linux-dvb@linuxtv.org; Tue, 20 Jan 2009 23:07:13 +0100
Date: Wed, 21 Jan 2009 09:07:01 +1100
From: Daniel Dalton <d.dalton@iinet.net.au>
To: linux-dvb@linuxtv.org
Message-ID: <20090120220701.GB4150@debian-hp.lan>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4975B5F1.7000306@iki.fi>
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

On Tue, Jan 20, 2009 at 01:30:57PM +0200, Antti Palosaari wrote:
> Daniel Dalton wrote:
> > Could someone please let me know what I have to do to get my msi 5580
> > usb digital tv tuner working with linux?
> > What drivers do I need? What software, what should I do to test it and
> > is it possible to use the remote once it is up and running?
> 
> It should work with v4l-dvb / Kernel newer than about two years. 

So... My 2.6.26-1 kernel out of aptitude (debian lenny), should work?

> However, tuner performance is not very good. With weak signal it works 
> better than strong. All remote keys are not working because driver does 
> not upload IR-table to the chip.

ok

> 
> > Finally, I'm vission impared, so are there any programs for controling
> > the tv either command line based or gtk? I can't use qt applications.
> > If qt is my only option it's fine, I'll figure out a way for handling
> > this once the card is working.
> 
> Totem, Me-TV, Kaffeine, mplayer, Xine.

Mplayer works with this card? Great!

How would I begin configuring it for mplayer then?

Thanks very much for your help.

Cheers,
Daniel.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
