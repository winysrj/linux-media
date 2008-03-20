Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns.bog.msu.ru ([213.131.20.1] ident=1005)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1JcNhH-0004gO-Ol
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 17:32:56 +0100
Received: from ldvb (helo=localhost)
	by ns.bog.msu.ru with local-esmtp (Exim 4.69)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1JcNiD-0003xj-6h
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 19:33:53 +0300
Date: Thu, 20 Mar 2008 19:33:53 +0300 (MSK)
From: ldvb@ns.bog.msu.ru
To: linux-dvb@linuxtv.org
In-Reply-To: <200803200118.26462@orion.escape-edv.de>
Message-ID: <Pine.LNX.4.62.0803201931260.12540@ns.bog.msu.ru>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<Pine.LNX.4.62.0803141819410.8859@ns.bog.msu.ru>
	<Pine.LNX.4.62.0803171305520.18849@ns.bog.msu.ru>
	<200803200118.26462@orion.escape-edv.de>
MIME-Version: 1.0
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
 transponder fails
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


On Thu, 20 Mar 2008, Oliver Endriss wrote:

> Sorry, if you want to have your problem fixed, you have dig through the
> register programming of the frontend driver. Use an i2c sniffer and
> compare the register settings of the the windows driver with those of
> the linux driver...
> If you want to experiment with some parameters, you might have a look at
> changeset
>  http://linuxtv.org/hg/v4l-dvb/rev/8a19aa788239
> Maybe you can find a better register setting which fixes your problem.

Increased baseband cut-off helps! (tda826*.c)
so, making it
buf[6] = 0xfe;
solves the problem.
Maybe, I'll check other values.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
