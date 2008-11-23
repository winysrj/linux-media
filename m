Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.232])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kevinlux@gmail.com>) id 1L4JgP-0006UN-FD
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 19:27:47 +0100
Received: by rv-out-0506.google.com with SMTP id b25so1808475rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 10:27:39 -0800 (PST)
Message-ID: <8567605f0811231027w4bca54dej414d353e31ff1e5f@mail.gmail.com>
Date: Sun, 23 Nov 2008 19:27:39 +0100
From: "kevinlux -" <kevinlux@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <8567605f0811160257i66ea44a1i8b16a45c1580d5a9@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <8567605f0811160257i66ea44a1i8b16a45c1580d5a9@mail.gmail.com>
Subject: Re: [linux-dvb] pinnacle 310i doesn't works very well
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

Hi Guys,
hi talked with Harmut Hackam, on his opinion "something is broken in the
tuner callback mechanism again. this is used to control the so called
LNA via a GPIO pin - a tricky mechanism and difficult to debug."
Should I post also in a val4linux mailing list?? Or someone can help me here?
I think it's a problem of all card of  << saa7133 >> with tuner  <<
tda829x 2-004b >> (i have also tried an Asus My Cinema Dual TV Tuner
same chips and tuner and SAME Problems. )
Thanks in advance.

cheers
kev


2008/11/16, kevinlux - <kevinlux@gmail.com>:
> Hi all. I have a pinnacle card, 310i card from 3 years, but now with
>  recent drivers (updated yesterday) it works not so good. With the my
>  previous driver (dvb mercurial December 2007 on kernel 2.6.24)
>  everythings was good. Infact at moment under Window OS i can see more
>  channels respect to Linux.
>  I also try with another usb device inlinux and i'm able to see all
>  those channels that i can't view with my pinnacle 310i board.
>  Someone can help me or can confirm my version??
>
>  Thanks in advance.
>  Cheers
>
>  kev
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
