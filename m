Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oroitburd@gmail.com>) id 1Kuup1-00012J-Oj
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 21:05:49 +0100
Received: by fg-out-1718.google.com with SMTP id e21so2439008fga.25
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 13:05:44 -0700 (PDT)
Message-ID: <b42fca4d0810281305l6e741c25ia25e1f3f348761d5@mail.gmail.com>
Date: Tue, 28 Oct 2008 21:05:44 +0100
From: "oleg roitburd" <oroitburd@gmail.com>
To: "Alex Betis" <alex.betis@gmail.com>
In-Reply-To: <c74595dc0810281223j25d78c9eqbcbed70a1b495b43@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<b42fca4d0810280227n44d53f03hfaa8237793fc1db9@mail.gmail.com>
	<c74595dc0810281223j25d78c9eqbcbed70a1b495b43@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
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

Hi,

2008/10/28 Alex Betis <alex.betis@gmail.com>:
> Hi Oleg,
>
> I had plans to do most of the things you've requested, but had no time and
> decided to release the utility without those options so it will be tested.
> I'll send an update when it will be ready.

Fine. Thx

>
> A question about modulation. Can you point me to a place that describe what
> modulation number N means what?
> "man 5 vdr" lists the options, but its impossible to understand the mapping:
> "M   Modulation (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16, 32, 64, 128, 256,
> 512, 998, 1024)"

Small snipet from VDR/channels.c
-------------------------------snip------------------------------
const tChannelParameterMap ModulationValues[] = {
  {  16, QAM_16,   "QAM16" },
  {  32, QAM_32,   "QAM32" },
  {  64, QAM_64,   "QAM64" },
  { 128, QAM_128,  "QAM128" },
  { 256, QAM_256,  "QAM256" },
  {   2, QPSK,     "QPSK" },
  {   5, PSK_8,    "8PSK" },
  {   6, APSK_16,  "16APSK" },
  {  10, VSB_8,    "VSB8" },
  {  11, VSB_16,   "VSB16" },
  { 998, QAM_AUTO, "QAMAUTO" },
  { -1 }
  };
-------------------------------------------snap----------------------------
>
> FEC you can specify in the frequency file as "AUTO", "1/3", "2/3" and so on.
> I'll update README to make it clear. All frequency files samples show that
> option.

i have seen, that FEC will be set if FEC is in initial file.
If transponder was found via NIT it will be not set

Regards
Oleg Roitburd

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
