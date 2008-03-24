Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <w3ird_n3rd@gmx.net>) id 1JdpCg-0001Si-94
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 17:07:19 +0100
Message-ID: <47E7D194.80603@gmx.net>
Date: Mon, 24 Mar 2008 17:06:44 +0100
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: Patrik Hansson <patrik@wintergatan.com>
References: <8ad9209c0803240521s5426c957te42339397aac06ab@mail.gmail.com>
In-Reply-To: <8ad9209c0803240521s5426c957te42339397aac06ab@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Adding timestamp to femon
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

On 03/24/2008 01:21 PM, Patrik Hansson wrote:
> Hello
> I couldn't find a mailinglist for dvb-apps so i hope this is ok.
> 
> I would like to add timestamp to the output of femon -H in some way.
> This so I can monitor ber value over a long timeperiod and see the
> timedifference between some very high ber-values.
> 
> I found a patch from 2005 but was unable to manually use the code in
> dvb-apps/utils/femon/femon.c
> I have zero skill in c/c++ but for someone with some skill i would
> belive it would be very easy ?
> 
> Ps. If there is a better place for this kind of question please tell me. Ds.
> 
> / Patrik
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

Hi,

I had a similar issue, but solved it. Not sure if this works with a 
recent femon, but if it doesn't you should be able to make some changes 
to my method to make it work. Here's the trick:

1. Tune to whatever you want to measure.
2. Execute in a terminal: "femon -h -c 3600 > filename.signal". 3600 is 
for one hour, if you want to test for e.g. 10 hours enter 36000. The 
resulting file will usually be under 5MB so don't worry. Good advice: 
put the current time in the filename because brains are unreliable.
3. That's quite a bit to read. But we can do it faster:

Total amount of errors: "cat filename.signal | grep -c unc[^\s][^0]". 
You might need to change the regex for other femon versions.

All errors and when they occured: "cat filename.signal | grep -n 
unc[^\s][^0]". -n will make it show line numbers. If the first error, 
for example, is on line 1800 that means the first error occured half an 
hour after the start of the measurement.

Hope this helps.

P. van Gaans

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
