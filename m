Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep27-int.chello.at ([62.179.121.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rscheidegger_lists@hispeed.ch>) id 1KBFFf-0002ie-Rg
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 22:36:32 +0200
Message-ID: <48615AB0.9000202@hispeed.ch>
Date: Tue, 24 Jun 2008 22:36:00 +0200
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
References: <4861501B.9050507@kolumbus.fi>
In-Reply-To: <4861501B.9050507@kolumbus.fi>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Ticlkess Mantis remote control implementation
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

On 24.06.2008 21:50, Marko Ristola wrote:
> Hi,
> 
> I have still my own version of Manu's jusst.de/mantis driver that is 
> based on v4l-dvb-linuxtv main branch,
> mainly because I use so new Linux kernels.
> I have done the following improvement lately:
> 
> I implemented a remote control patch, that doesn't poll the remote 
> control all the time.
> It polls the remote control only if you press the button (a tickless 
> version, you know).
> It surprised me, that the actual implementation was really small, it 
> took very few lines of code.
> 
You're not the first to think that the constant polling is not
necessary, too bad these things always get lost because they aren't
integrated in the official driver...

http://www.linuxtv.org/pipermail/linux-dvb/2008-May/026102.html

Roland


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
