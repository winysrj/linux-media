Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JOEKm-0000GN-PF
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 16:43:12 +0100
Received: by wa-out-1112.google.com with SMTP id m28so1512051wag.13
	for <linux-dvb@linuxtv.org>; Sun, 10 Feb 2008 07:43:07 -0800 (PST)
Message-ID: <8ad9209c0802100743q6942ce28pf8e44f2220ff2753@mail.gmail.com>
Date: Sun, 10 Feb 2008 16:43:06 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1202403104.5780.42.camel@eddie.sth.aptilo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47A98F3D.9070306@raceme.org> <1202326173.20362.23.camel@youkaida>
	<1202327817.20362.28.camel@youkaida>
	<1202330097.4825.3.camel@anden.nu> <47AB1FC0.8000707@raceme.org>
	<1202403104.5780.42.camel@eddie.sth.aptilo.com>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Just wanted to say that I=B4m experiencing the same.
Using latest rev (the one with patches merged) + unknown remote key patch.
Ubuntu 7.10

Also having a lot of "prebuffer timeout 10 times" i the middle of shows.


On Feb 7, 2008 5:51 PM, Jonas Anden <jonas@anden.nu> wrote:
> > Do you have a way to automate this ? Ie to detect that a tuner is gone ?
>
> No, I have yet to find any log message that says things aren't OK.
>
> Mythbackend seems to just fail its recordings and not create the
> recording file, which is kind of annoying. In my point of view, it would
> be better if mythbackend would *crash*, since this would make the other
> backend (which uses analog tuners) take over the recording. It wouldn't
> be the same quality, but at least the show would be recorded...
>
>   // J
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
