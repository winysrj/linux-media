Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1LPEox-0001y7-8f
	for linux-dvb@linuxtv.org; Tue, 20 Jan 2009 12:31:04 +0100
Message-ID: <4975B5F1.7000306@iki.fi>
Date: Tue, 20 Jan 2009 13:30:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
References: <20090120091952.GB6792@debian-hp.lan>
In-Reply-To: <20090120091952.GB6792@debian-hp.lan>
Cc: linux-dvb@linuxtv.org
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

Daniel Dalton wrote:
> Could someone please let me know what I have to do to get my msi 5580
> usb digital tv tuner working with linux?
> What drivers do I need? What software, what should I do to test it and
> is it possible to use the remote once it is up and running?

It should work with v4l-dvb / Kernel newer than about two years. 
However, tuner performance is not very good. With weak signal it works 
better than strong. All remote keys are not working because driver does 
not upload IR-table to the chip.

> Finally, I'm vission impared, so are there any programs for controling
> the tv either command line based or gtk? I can't use qt applications.
> If qt is my only option it's fine, I'll figure out a way for handling
> this once the card is working.

Totem, Me-TV, Kaffeine, mplayer, Xine.

> Also, does this card allow for reccording?

yes

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
