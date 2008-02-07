Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1JN728-0001Gm-IA
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 14:43:20 +0100
Received: from nico2.od.loc (89.97.249.170) by relay-pt1.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 47AA585D00006E70 for linux-dvb@linuxtv.org;
	Thu, 7 Feb 2008 14:43:17 +0100
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 7 Feb 2008 14:43:17 +0100
References: <47AB0A20.2020000@kliese.wattle.id.au>
In-Reply-To: <47AB0A20.2020000@kliese.wattle.id.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802071443.17432.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] MSI TV@nywhere A/D v1.1 mostly working
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thursday 07 February 2008 14:39:44 Russell Kliese wrote:

> Analog TV worked without a problem (even with the older drivers).
>
> There is still a problem with the digital decoder. Sometimes it
> works fine (I can scan for channels and can run tzap to view a
> channel using mplayer). However, sometimes these commands don't
> work. I've noticed the following when running dmesg:
>
>
> [ 6318.055521] tda1004x: found firmware revision 20 -- ok
>
> I suspect that the card is failing to work because the firmware
> sometimes isn't being uploaded for some reason. Does anybody have
> any ideas why or what I could do to try and fix this?
>
> Hopefully this problem can be sorted out and another card can be
> added to the list of supported DVB-T cards. Yay!

afaik the last fw for the 10046 demodulator is version 29, that
you can extract from the lifeview drivers

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
