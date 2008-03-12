Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1JZYDF-0001ak-T4
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 22:10:14 +0100
Message-ID: <47D846A1.9010701@linuxtv.org>
From: mkrufky@linuxtv.org
To: jarro.2783@gmail.com
Date: Wed, 12 Mar 2008 17:09:53 -0400
MIME-Version: 1.0
in-reply-to: <abf3e5070803121407n59f7be10k55d7a256f60f2178@mail.gmail.com>
Cc: crope@iki.fi, linux-dvb@linuxtv.org
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

Jarryd Beck wrote:
> On Thu, Mar 13, 2008 at 7:54 AM, Michael Krufky <mkrufky@linuxtv.org>
wrote:
>   
>> On Wed, Mar 12, 2008 at 4:36 PM, Jarryd Beck <jarro.2783@gmail.com>
wrote:
>>  >
>>  > >  >>
>>  >  >  >> Jarryd,
>>  >  >  >>
>>  >  >  >> I've analyzed the snoop that you've taken of the windows
driver, and I
>>  >  >  >> conclude that the driver is basically doing exactly the same
that the
>>  >  >  >> linux driver would do.  The only thing that I cannot verify is
whether
>>  >  >  >> or not the tda18211 uses the same table values as the
tda18271c1.
>>  >  >  >> Based on the traffic in your snoop, it looks like the exact
same
>>  >  >  >> algorithm is used, but based on a new set of tables -- I will
not be
>>  >  >  >> able to confirm that without a tda18211 datasheet.  The only
thing
>>  >  >  >> that you can do is try the tda18271 driver and hopefully it
will work.
>>  >  >  >>
>>  >  >  >> Have you tried to tune yet?  There is a space in your
channels.conf,
>>  >  >  >> "7 Digital" -- you may want to change that to something like,
>>  >  >  >> "7Digital" so that command line applications will work.
>>  >  >  >>
>>  >  >
>>  >  >
>>  >  >
>>  >  > Antti Palosaari wrote:
>>  >  >  > hello
>>  >  >  > I looked sniffs and find correct demodulator initialization
values for
>>  >  >  > this NXP tuner. Copy & paste correct table from attached file
and try.
>>  >  >  > Hopefully it works. I compared your sniff to mt2060 and qt1010
based
>>  >  >  > devices and there was still some minor differences to check.
>>  >  >  >
>>  >  >  > regards,
>>  >  >  > Antti
>>  >  >  >
>>  >  >
>>  >  >  Antti,
>>  >  >
>>  >  >  Please remember not to top-post.
>>  >  >
>>  >  >  Jarryd,
>>  >  >
>>  >  >  I have done further analysis on the snoop logs.  Not only is the
driver
>>  >  >  using the same protocol as the tda18271 linux driver, it also
seems to
>>  >  >  use the same table values as used with the tda18271c1 -- The linux
>>  >  >  driver should work on your tuner without any modification at all.
>>  >  >
>>  >  >  Regards,
>>  >  >
>>  >  >  Mike
>>  >  >
>>  >
>>  >  I've got another tuner which works, so I know I'm tuning correctly,
it just
>>  >  doesn't actually tune. I tried with mplayer, it just sat there saying
>>  >  dvb_tune Freq: 219500000 and did nothing. It also made my whole
>>  >  computer go really slow, I don't know what it was actually doing.
>>  >
>>  >  Antti, as I said I've never done anything like this before so I have
no
>>  >  idea what I'm doing, so I have no idea where to paste which table.
>>
>>  Please try using tzap.  This will show you FE status once every
>>  second.  Let it run for a whole minute -- maybe there is some noise
>>  that may cause it to take a longer time to lock (if that's the case,
>>  then there are some tweaks that we can do.)  Show us the femon output
>>  produced by running tzap.
>>
>>  -Mike
>>
>>     
>
> $ tzap -a 2 "TEN Digital"
> using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
> tuning to 219500000 Hz
> video pid 0x0200, audio pid 0x028a
> status 01 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>
> $ femon -a 2
> using '/dev/dvb/adapter2/frontend0'
> FE: Afatech AF9013 DVB-T (TERRESTRIAL)
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 01 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
>
> The status 00 lines were from before I started tzap, after I started tzap
> it did nothing for half a minute, then printed the status 01 line, then
> sat there for another half a minute, and I killed it at that point.
> My computer was also taking quite a few seconds to respond to
> me pressing the keyboard for the whole time I was tuning it.
>
> Jarryd.
>   
What shows in dmesg during the above?

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
