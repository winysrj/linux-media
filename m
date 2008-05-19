Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1Jy3nN-000753-PK
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 13:44:50 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Mon, 19 May 2008 13:44:14 +0200
References: <617be8890805171034t539f9c67qe339f7b4f79d8e62@mail.gmail.com>
	<36e8a7020805171423q42051749y5f6c82da88b695cd@mail.gmail.com>
In-Reply-To: <36e8a7020805171423q42051749y5f6c82da88b695cd@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805191344.14445.zzam@gentoo.org>
Cc: Eduard Huguet <eduardhc@gmail.com>
Subject: Re: [linux-dvb] merhaba: About Avermedia DVB-S Hybrid+FM A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Samstag, 17. Mai 2008, bvidinli wrote:
> Hi,
> thank you for your answer,
>
> may i ask,
>
> what is meant by "analog  input", it is mentioned on logs that:" only
> analog inputs supported yet.." like that..
> is that mean: s-video, composit ?
>
Yeah. The patch already merged into v4l-dvb repository and also merged into =

kernel 2.6.26 does only support s-video and compite input of both A700 card=
s =

(Avermedia AverTV dvb-s Pro and AverTV DVB-S Hybrid+FM).

The other pending patches do add support for DVB-S input to both card =

versions. But this is not yet ready for being merged.
At least here the tuning is not yet reliable for some frequencies (or does =
get =

no lock depending very hardly on some tuner gain settings). But most =

transponders of Astra-19.2=B0E I can get a good lock.

This is the latest version of the patch: =

http://dev.gentoo.org/~zzam/dvb/a700_full_20080519.diff


About RF analog input I cannot do much, as I do not have the hardware, and =
for =

XC2028 tuner one needs to check out the GPIO configuration.

If you would like to help you could try out or trace gpio lines some way to =

get RF input running. As far as I know to get XC2028 running you need to fi=
nd =

out which pin does reset the tuner to finish firmware uploading.

Regards
Matthias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
