Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarro.2783@gmail.com>) id 1JZXgi-000471-Vw
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 21:36:40 +0100
Received: by ti-out-0910.google.com with SMTP id y6so1364964tia.13
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 13:36:31 -0700 (PDT)
Message-ID: <abf3e5070803121336k1f2c9dc5s1962b1401cce1091@mail.gmail.com>
Date: Thu, 13 Mar 2008 07:36:31 +1100
From: "Jarryd Beck" <jarro.2783@gmail.com>
To: mkrufky@linuxtv.org
In-Reply-To: <47D7F16F.4070604@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <47D7E260.4030502@iki.fi> <47D7F16F.4070604@linuxtv.org>
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

>  >>
>  >> Jarryd,
>  >>
>  >> I've analyzed the snoop that you've taken of the windows driver, and I
>  >> conclude that the driver is basically doing exactly the same that the
>  >> linux driver would do.  The only thing that I cannot verify is whether
>  >> or not the tda18211 uses the same table values as the tda18271c1.
>  >> Based on the traffic in your snoop, it looks like the exact same
>  >> algorithm is used, but based on a new set of tables -- I will not be
>  >> able to confirm that without a tda18211 datasheet.  The only thing
>  >> that you can do is try the tda18271 driver and hopefully it will work.
>  >>
>  >> Have you tried to tune yet?  There is a space in your channels.conf,
>  >> "7 Digital" -- you may want to change that to something like,
>  >> "7Digital" so that command line applications will work.
>  >>
>
>
>
> Antti Palosaari wrote:
>  > hello
>  > I looked sniffs and find correct demodulator initialization values for
>  > this NXP tuner. Copy & paste correct table from attached file and try.
>  > Hopefully it works. I compared your sniff to mt2060 and qt1010 based
>  > devices and there was still some minor differences to check.
>  >
>  > regards,
>  > Antti
>  >
>
>  Antti,
>
>  Please remember not to top-post.
>
>  Jarryd,
>
>  I have done further analysis on the snoop logs.  Not only is the driver
>  using the same protocol as the tda18271 linux driver, it also seems to
>  use the same table values as used with the tda18271c1 -- The linux
>  driver should work on your tuner without any modification at all.
>
>  Regards,
>
>  Mike
>

I've got another tuner which works, so I know I'm tuning correctly, it just
doesn't actually tune. I tried with mplayer, it just sat there saying
dvb_tune Freq: 219500000 and did nothing. It also made my whole
computer go really slow, I don't know what it was actually doing.

Antti, as I said I've never done anything like this before so I have no
idea what I'm doing, so I have no idea where to paste which table.

Jarryd.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
