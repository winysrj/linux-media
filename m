Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jnj2T-0003Rx-9h
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 01:33:43 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Date: Mon, 21 Apr 2008 01:32:16 +0200
References: <4803E9A2.30804@t-online.de>
In-Reply-To: <4803E9A2.30804@t-online.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804210132.17281@orion.escape-edv.de>
Cc: LInux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] tda10086: Testers wanted
Reply-To: linux-dvb@linuxtv.org
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

Hartmut Hackmann wrote:
> Hi, folks
> 
> In my personal repository at
> http://linuxtv.org/hg/~hhackmann/v4l-dvb/
> there are 2 changes that affect all DVB-S cards with tda10086
> - The reference frequency (crystal) of the tda10086 now is an option
>    of the tda10086_config struct. This is necessary i.e. for cards with the
>    SD1878 tuner.
>    I adapted the driver for these boards:
>     - TT Budget-S-1401
>     - Pinnacle 400e / Technotrend USB
>     - Lifeview Flydvb Trio
>     - Medion MD8800
>     - Lifeview Flydvbs LR300
>     - Philips Snake
>     - MD7134 (Bridge 2 - works now)
> 
> - The bandwidth of the tda826x baseband filter is now set according to the
>    expected symbol rate. The boards with this tuner now should work with
>    transponders providing a higher symbol rate than usual.
>    This patch was provided by Oliver Endriss.
> 
> I tried to make the changes backward compatibe but since i can't test these
> cards, i need your feedback.

Sorry, I have no hardware to test your patches.

> Oliver: there was no signature in your patch. But of corse i mentioned you
> in the log. I hope that's ok for you.

I don't care, but beware that the lawyers @LKML might send you to jail.
:D

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
