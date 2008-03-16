Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JagiX-0004lw-Ia
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 01:27:17 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1664045tia.13
	for <linux-dvb@linuxtv.org>; Sat, 15 Mar 2008 17:27:08 -0700 (PDT)
Message-ID: <abf3e5070803151727o55dcc0d1q82bac14352330fd7@mail.gmail.com>
Date: Sun, 16 Mar 2008 11:27:08 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <47DC64F4.9070403@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
References: <abf3e5070803121412i322041fbyede6c5a727827c7f@mail.gmail.com>
	<47DA0F01.8010707@iki.fi> <47DA7008.8010404@linuxtv.org>
	<47DAC42D.7010306@iki.fi> <47DAC4BE.5090805@iki.fi>
	<abf3e5070803150606g7d9cd8f2g76f34196362d2974@mail.gmail.com>
	<abf3e5070803150621k501c451lc7fc8a74efcf0977@mail.gmail.com>
	<47DBDB9F.5060107@iki.fi>
	<abf3e5070803151642ub259f5bx18f067fc153cce89@mail.gmail.com>
	<47DC64F4.9070403@iki.fi>
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
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

On Sun, Mar 16, 2008 at 11:08 AM, Antti Palosaari <crope@iki.fi> wrote:
> Jarryd Beck wrote:
>  > On Sun, Mar 16, 2008 at 1:22 AM, Antti Palosaari <crope@iki.fi> wrote:
>
> >> Frequency control values of the demodulator seems to be ok now. Also adc
>  >> and coeff looks correct. It is hard to say where is problem...
>  >> Can you test if demodulator can detect TPS parameter automatically? You
>  >> can do that inserting AUTO to initial tuning file, for example set FEC
>  >> AUTO. And then "scan tuning-file"
>  >
>
> > Sorry I'm completely lost at this point, are you talking about adding something
>  > to /usr/share/dvb-apps/dvb-t/au-sydney_north_shore and then running
>  > scandvb, or are you talking about something else?
>
>  yes, adding parameters to tuning-file. I added some AUTO parameters, use
>  attached file to scan. Try "scan au-Sydney_North_Shore_test", hopefully
>  it says something more that tuning failed. It is good indicator if there
>  is even PID-filter timeouts.
>
>  I have no idea how to debug more. Without device it is rather hard to
>  test many things. It will help a little if we know is tuner locked.
>  Mike, is it easy to add debug writing for tuner to indicate if tuner is
>  locked or not locked? I have used that method earlier with mt2060 tuner...
>
>  Good luck for Kimi and Heikki todays F1 Australian GP:)
>
>
>
>  regards
>  Antti
>  --
>  http://palosaari.fi/
>
> # Australia / Sydney / North Shore (aka Artarmon/Gore Hill/Willoughby)
>  #
>  # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
>  #
>  # ABC VHF12
>  T 226500000 7MHz 3/4 NONE QAM64 AUTO 1/16 NONE
>  # Seven VHF6
>  T 177500000 7MHz AUTO NONE QAM64 8k 1/16 NONE
>  # Nine VHF8
>  T 191625000 7MHz 3/4 NONE AUTO 8k 1/16 NONE
>  # Ten VHF11
>  T 219500000 7MHz 3/4 NONE QAM64 8k AUTO NONE
>  # SBS UHF34
>  T 571500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
>  # D44 UHF35
>  T 578500000 7MHz 2/3 NONE QAM64 8k 1/32 NONE
>
>

Here's the first frequency it tuned to, as you can see the
one you set auto on is still auto, it didn't seem to autodetect
anything. It was the same for all the other frequencies as well.

>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
