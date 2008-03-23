Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morgan.torvolt@gmail.com>) id 1JdOK2-0002Q7-Qd
	for linux-dvb@linuxtv.org; Sun, 23 Mar 2008 12:25:10 +0100
Received: by wa-out-1112.google.com with SMTP id m28so2818729wag.13
	for <linux-dvb@linuxtv.org>; Sun, 23 Mar 2008 04:25:01 -0700 (PDT)
Message-ID: <3cc3561f0803230425p60486919m9685f4a145df7635@mail.gmail.com>
Date: Sun, 23 Mar 2008 15:25:00 +0400
From: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
To: "Andrea Giuliano" <sarkiaponius@alice.it>
In-Reply-To: <47E56272.8050307@alice.it>
MIME-Version: 1.0
Content-Disposition: inline
References: <47E56272.8050307@alice.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help needed...
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

On 22/03/2008, Andrea Giuliano <sarkiaponius@alice.it> wrote:
> Hi,
>
>  I can szap many free channels from Hotbird 13E, but none on some
>  frequencies. For example, if the "test" file just contains the line:
>
>     S 11766000 V 27500000 2/3
>
>  that I took from http://www.lyngsat.com/hotbird.html as many other which
>  instead work percectly, the command:
>
>     scan test > channels.conf
>
>  alway gives the following output:
>
>  scanning prova
>  using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  initial transponder 11766000 V 27500000 2
>   >>> tune to: 11766:v:0:27500
>  WARNING: >>> tuning failed!!!
>   >>> tune to: 11766:v:0:27500 (tuning failed)
>  WARNING: >>> tuning failed!!!
>  ERROR: initial tuning failed
>  dumping lists (0 services)
>  Done.
>
>  On the other hand, if I put manually some lines in channels.conf for
>  such a frequency, I can zap to those channels, but in most cases I watch
>  a different channel, not the one I expected to see.
>
>  This doesn't happen on other frequencies.
>
>  May be of some help the fact that I'm writing from Italy, and I cannot
>  get channels from the scan for the most important italian channels: in
>  particular, none of RAI network, nor Mediaset network, the biggest
>  network in Italy.
>
>  Also, the signal became rather good after I bought an amplifier.
>  Actually, I can see and record perfectly fine many channels. I don't
>  think I have signal strength problems.
>
>  Any hint will be very much appreciated.
>
>  Best regards.
>
>  --
>  Andrea
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>  _______________________________________________
>  linux-dvb mailing list
>  linux-dvb@linuxtv.org
>  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

Getting a different mux is only possible int a few very special cases.
1. Your LNB is 90 degrees off, giving vertical where you should have
horizontal and vice verca.
2. You get the wrong polarization or frequency, possibly because of a
too long cable dampening the 18V or something like that so that the
LNB does not switch.

This is easy to check actually. Use zap to go to the "wrong" mux, and
then use dvbscan -c (scan current mux) to get a listing of the
channels on the mux. Then locate the mux using lyngsat. You will then
see if there is a difference in polarization or frequency that can be
explained by a error in lo frequency (if the frequency is off by
10600-9750=850MHz) or polarization. I am quite confident that you will
find one of these to be the case. The frequency can be a bit away from
850MHz since the tuner is usually able to achieve sync with a lot of
offset (I have seen a tuner sync with more than 15MHz offset).

The error can as mentioned be caused by a long cable, but a faulty LNB
or tuner-card is of course also a possible explaination. Check if an
ordinary stb works.

-Morgan-

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
