Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.244])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JeBsv-0004cp-Hx
	for linux-dvb@linuxtv.org; Tue, 25 Mar 2008 17:20:34 +0100
Received: by an-out-0708.google.com with SMTP id d18so2634714and.125
	for <linux-dvb@linuxtv.org>; Tue, 25 Mar 2008 09:20:14 -0700 (PDT)
Message-ID: <d9def9db0803250920k1e113c2cuf2d7d842ada7d7ad@mail.gmail.com>
Date: Tue, 25 Mar 2008 17:20:12 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Aidan Thornton" <makosoft@googlemail.com>
In-Reply-To: <c8b4dbe10803250911l4499dcfatb4d11184437e9c1@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <c8b4dbe10803241504t68d96ec9m8a4edb7b34c1d6ef@mail.gmail.com>
	<d9def9db0803241604mc1c9d1g1144af2f7619192a@mail.gmail.com>
	<c8b4dbe10803250911l4499dcfatb4d11184437e9c1@mail.gmail.com>
Cc: DVB ML <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DVB-T support for original (A1C0) HVR-900
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

>
> Hi,
>
> I've deliberately avoided adding code for VBI - it's just too
> difficult to get right on em28xx due to interesting buffer management
> and locking issues. (For example, have you fixed the issue that causes
> a kernel panic when recording analog video with MythTV? That was a
> particularly interesting one.) In any case, that's another issue
> entirely - this code is for DVB-T support.
>
> Also, just because this device isn't being sold anymore doesn't mean
> it's not worth adding - there are other, fairly similar devices still
> on sale. Unfortunately, I don't have access to newer hardware, and
> most of the people with the access and knowledge don't seem to want to
> have anything to do with it. (Why do I have a feeling that you have a
> hand in this?) However, adding support should be easy - all the
> necessary code exists and has done for a while (even drx397xd support
> for the Pinnacle 330e and the new HVR-900).
>

The drx397x is only one chip of a series of newer ones which will
follow in future.

> Mainly, though, I'm doing it for my own benefit - I have this
> hardware, and the changes are small and self-contained enough that I
> should be able to stay up-to-date with upstream and keep newer kernels
> working with minimal effort. (This tree is actually an updated version
> of code I've been using for the past few months on PAL-I and DVB-T,
> but didn't publish due to a bug with switching from digital to
> analog.)
>

it's fine that you do it on your own purpose for yourself, although
there's much more development going on on the other side.

> (By the way, I still reckon your userspace code is a dead end, at
> least as far as getting anything merged into the kernel. I think I may
> have already explained why.)
>

There are several reasons for going that way I'm not up for waiting 2
years till something is implemented because some people don't want to
discuss certain things. It's like discussing issues with a wall.
This is the main point why I'm going the other way since this is
simply no option, and everyone can see the result in earlier supported
devices.

The thing you're doing is of course based on my work again and even in
future you cannot avoid to base things on that. As long as this root
problem isn't solved I don't see any other way, and I'm definitely not
the one who will delay any further devices anymore.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
