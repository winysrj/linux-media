Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zdenek.kabelac@gmail.com>) id 1LIjyD-0006jx-Pv
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 14:21:46 +0100
Received: by bwz11 with SMTP id 11so13723699bwz.17
	for <linux-dvb@linuxtv.org>; Fri, 02 Jan 2009 05:21:12 -0800 (PST)
Message-ID: <c4e36d110901020521l2628634al68d1b5a76884aec3@mail.gmail.com>
Date: Fri, 2 Jan 2009 14:21:11 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Kuba Irzabek" <vega01@wp.pl>
In-Reply-To: <495E00B9.8000202@wp.pl>
MIME-Version: 1.0
Content-Disposition: inline
References: <495E00B9.8000202@wp.pl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AverTV Hybrid Volar HX (A827)
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

2009/1/2 Kuba Irzabek <vega01@wp.pl>:
> Hello,
>
> I noticed some posts from quite a long time ago from people interested
> in running AverTV A827 under Linux. Is anyone still interested or
> working on it? I'm currently mainly interested in getting the analog TV
> part working.
>
> Regards,
>
> Kuba Irzabek

Hi

Currently we have some progress with DVB-T part of this device - the
only problem is, it's using uncommon USB comunication protocol I've
not yet seen in other dvb usb tuner - it send BULK request and expect
Interrupt responce and I'm not yet big expert on USB programming - and
it needs some time.

Are you experienced USB programmer ?

It might allow us to get at least DVB-T part functional really soon then.

AFAIK there is no work done on Analog part.

Zdenek

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
