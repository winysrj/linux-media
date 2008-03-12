Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1JZXyR-0007ih-P5
	for linux-dvb@linuxtv.org; Wed, 12 Mar 2008 21:54:58 +0100
Received: by ug-out-1314.google.com with SMTP id o29so357843ugd.20
	for <linux-dvb@linuxtv.org>; Wed, 12 Mar 2008 13:54:52 -0700 (PDT)
Message-ID: <37219a840803121354r61e49f0fk2f85b052748f2df7@mail.gmail.com>
Date: Wed, 12 Mar 2008 16:54:50 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Jarryd Beck" <jarro.2783@gmail.com>
In-Reply-To: <abf3e5070803121336k1f2c9dc5s1962b1401cce1091@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47D7E260.4030502@iki.fi> <47D7F16F.4070604@linuxtv.org>
	<abf3e5070803121336k1f2c9dc5s1962b1401cce1091@mail.gmail.com>
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

On Wed, Mar 12, 2008 at 4:36 PM, Jarryd Beck <jarro.2783@gmail.com> wrote:
>
> >  >>
>  >  >> Jarryd,
>  >  >>
>  >  >> I've analyzed the snoop that you've taken of the windows driver, and I
>  >  >> conclude that the driver is basically doing exactly the same that the
>  >  >> linux driver would do.  The only thing that I cannot verify is whether
>  >  >> or not the tda18211 uses the same table values as the tda18271c1.
>  >  >> Based on the traffic in your snoop, it looks like the exact same
>  >  >> algorithm is used, but based on a new set of tables -- I will not be
>  >  >> able to confirm that without a tda18211 datasheet.  The only thing
>  >  >> that you can do is try the tda18271 driver and hopefully it will work.
>  >  >>
>  >  >> Have you tried to tune yet?  There is a space in your channels.conf,
>  >  >> "7 Digital" -- you may want to change that to something like,
>  >  >> "7Digital" so that command line applications will work.
>  >  >>
>  >
>  >
>  >
>  > Antti Palosaari wrote:
>  >  > hello
>  >  > I looked sniffs and find correct demodulator initialization values for
>  >  > this NXP tuner. Copy & paste correct table from attached file and try.
>  >  > Hopefully it works. I compared your sniff to mt2060 and qt1010 based
>  >  > devices and there was still some minor differences to check.
>  >  >
>  >  > regards,
>  >  > Antti
>  >  >
>  >
>  >  Antti,
>  >
>  >  Please remember not to top-post.
>  >
>  >  Jarryd,
>  >
>  >  I have done further analysis on the snoop logs.  Not only is the driver
>  >  using the same protocol as the tda18271 linux driver, it also seems to
>  >  use the same table values as used with the tda18271c1 -- The linux
>  >  driver should work on your tuner without any modification at all.
>  >
>  >  Regards,
>  >
>  >  Mike
>  >
>
>  I've got another tuner which works, so I know I'm tuning correctly, it just
>  doesn't actually tune. I tried with mplayer, it just sat there saying
>  dvb_tune Freq: 219500000 and did nothing. It also made my whole
>  computer go really slow, I don't know what it was actually doing.
>
>  Antti, as I said I've never done anything like this before so I have no
>  idea what I'm doing, so I have no idea where to paste which table.

Please try using tzap.  This will show you FE status once every
second.  Let it run for a whole minute -- maybe there is some noise
that may cause it to take a longer time to lock (if that's the case,
then there are some tweaks that we can do.)  Show us the femon output
produced by running tzap.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
