Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.228])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hansson.patrik@gmail.com>) id 1JRvFj-0005bc-0g
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 21:09:15 +0100
Received: by wr-out-0506.google.com with SMTP id 68so2658507wra.13
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 12:09:11 -0800 (PST)
Message-ID: <8ad9209c0802201209j78094465i62f70f7c4ee2eeef@mail.gmail.com>
Date: Wed, 20 Feb 2008 21:09:09 +0100
From: "Patrik Hansson" <patrik@wintergatan.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1203517472.6682.37.camel@acropora>
MIME-Version: 1.0
Content-Disposition: inline
References: <1203434275.6870.25.camel@tux> <1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
	<1203495773.7026.15.camel@tux> <1203496068.7026.19.camel@tux>
	<950c7d180802200436s68bab78ej3eb01a93090c313f@mail.gmail.com>
	<1203513814.6682.30.camel@acropora>
	<950c7d180802200543w31d157eag6e3d8277d60fa412@mail.gmail.com>
	<1203516921.6602.11.camel@tux> <1203517472.6682.37.camel@acropora>
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700 ir
	receiver
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

Just got the latest v4l-dvb and used the patch and compiled.
Yea, now holding down the button works! :)
Nice Job!

On Feb 20, 2008 3:24 PM, Nicolas Will <nico@youplala.net> wrote:
>
> On Wed, 2008-02-20 at 15:15 +0100, Filippo Argiolas wrote:
> > It seems that your remote does not use the toggle bit. I don't know
> > why
> > since afaik it is a feature of the rc5 protocol.
> > By the way you can try to make some test writing the keymap on your
> > own.
> > Just edit dib0700_devices.c about at line 400, look at the other
> > keymaps
> > to have a model:
> > for example if the key you logged was the UP key you have to add a
> > line
> > like:
> > { 0x13, 0x7E, KEY_UP },
> > and so on for the other keys, after that see if the keymap works with
> > evtest.
>
> Between this discussion and some wiki rework I have been doing today on
> all dib0700 equipped hardware, i am starting to understand where Patrick
> was coming from regarding all that hard-coding of specific remote
> keys...
>
> Nico
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
