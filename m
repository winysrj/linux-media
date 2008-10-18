Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1KrCTz-00036B-I6
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 16:08:44 +0200
Received: by rv-out-0506.google.com with SMTP id b25so960353rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 18 Oct 2008 07:08:38 -0700 (PDT)
Message-ID: <854d46170810180708l5d109c9chdd97399f2f3c60e0@mail.gmail.com>
Date: Sat, 18 Oct 2008 16:08:37 +0200
From: "Faruk A" <fa@elwak.com>
To: "Dominik Kuhlen" <dkuhlen@gmx.net>
In-Reply-To: <200810181405.42620.dkuhlen@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <200810181405.42620.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API pctv452e stb0899 simples2apitune
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

Hi Dominik!


> - fast and always lock for DVB-S (up to 8MHz frequency offset allowed) (only tested with symrates: 22 and 27.5)

yes channel lock is very fast and it always locks, i had no problem
locking on DVB-S with 30000 symrate.

> - DVB-S2 checked 19.2E 11915 H 27500 only (I cant test others)

it locks fine on 13E DVB-S2 channels (27500)

> - PCTV452e LED  green: FE open    orange: FE closed
>  does the TT S2 3600 (3650CI) also have this led and is it attached to the same GPIO?

The LED is working on TT-S2-3650CI

> also attached simples2apitune which is same as simpledvbtune but for S2API

simples2apitune is not working for me on both DVB-S and DVB-S2.

[faruk@archer simples2apitune]$ ./simples2apitune -f 10975 -p h -s 27500
using '/dev/dvb/adapter0/frontend0' as frontend
frontend fd=3: type=0 name=STB0899 Multistandard
ioclt: FE_SET_VOLTAGE : 1
Low band
set tone: 0
set symbol rate: 27500000 Sym/s
set frequency: 1225000 kHz
do tune....
tuning qpsk failed

Dominik are you too facing packet losses from TS?

Thanks
Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
