Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JYX6N-0000xl-KU
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 02:46:56 +0100
Message-ID: <47D49309.8020607@linuxtv.org>
Date: Sun, 09 Mar 2008 21:46:49 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Jarryd Beck <jarro.2783@gmail.com>
References: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>
In-Reply-To: <abf3e5070803091836g6415112ete553958792f54d@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] NXP 18211HDC1 tuner
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

Jarryd Beck wrote:
> Would someone be interested in writing tuner drivers for the NXP
> 18211HDC1 tuner?
> I recently bought the Winfast DTV Dongle Gold which uses an AF9015
> chip and the NXP tuner.
> I've managed to get it working up to the point of needing the tuner,
> after that nothing works.
> I have no idea how to write tuner code, so if someone is interested, I
> can supply all the
> info I've got about the card and test whatever you write.
>
> Jarryd.

Try the tda18271 driver -- I am under the impression that the tda18211 
is a dvb-t only subset of the tda18271, but I dont have a tda18211 to 
test with and find out, nor do I have a tda18211 spec to look at.  :-(

Good Luck,

Mike


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
