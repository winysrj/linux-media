Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JbdYf-0004fD-8P
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 16:16:59 +0100
Message-ID: <47DFDCC4.4090001@iki.fi>
Date: Tue, 18 Mar 2008 17:16:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Albert Comerma <albert.comerma@gmail.com>
References: <ea4209750803180734m67c0990byabb81bb2ec52d992@mail.gmail.com>
In-Reply-To: <ea4209750803180734m67c0990byabb81bb2ec52d992@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib7770 tunner
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

Albert Comerma wrote:
> Hi all, having a look to the pinnacle card of Andrea Barberio, we find 
> out that it uses a dib7770-PA with integrated tuner. It seems to load 
> correctly the firmware but we don't know how to comunicate with the 
> tuner. Anybody knows which tuner we should use? and if we can work with 
> this chip as other Dibcom7700 just changing the tuner? And finally, 
> there is the firmware stuff, it should use the same dibcom firmware as 
> other devices?

dib7770 is 3 in 1 solution, usb-bridge + demodulator + tuner. You can 
try dib7070 tuner driver. STK7070P looks rather similar (but less 
integrated).

Regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
