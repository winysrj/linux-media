Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46784 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab0H0GB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 02:01:29 -0400
Received: by iwn5 with SMTP id 5so2286244iwn.19
        for <linux-media@vger.kernel.org>; Thu, 26 Aug 2010 23:01:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C76C662.3070003@hoogenraad.net>
References: <4C1D1228.1090702@holzeisen.de>
	<4C5BA16C.7060808@hoogenraad.net>
	<5a5511b4767b245485b150836b1526f0.squirrel@holzeisen.de>
	<4C760DBC.5000605@hoogenraad.net>
	<4C768B43.9080403@holzeisen.de>
	<4C76C662.3070003@hoogenraad.net>
Date: Fri, 27 Aug 2010 03:01:28 -0300
Message-ID: <AANLkTikQV03w6MBOVdirrg3kLBw52HbnJmC4BLfeUObO@mail.gmail.com>
Subject: Re: HG has errors on kernel 2.6.32
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: linux-media@vger.kernel.org, Thomas Holzeisen <thomas@holzeisen.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Jan,

On Thu, Aug 26, 2010 at 4:54 PM, Jan Hoogenraad
<jan-conceptronic@hoogenraad.net> wrote:
> Douglas:
>
> I see on that
> http://www.xs4all.nl/~hverkuil/logs/Thursday.log
> that building linux-2.6.32 yields ERRORS
>
> skip_spaces has only been included in string.h starting from linux-2.6.33.
>
> Should I have a look on how to fix this, or do you want to do this ?

It's up to you.  I can fix it, easily.

> --
>
> second request: can we do some small changes to avoid the compiler warnings
> ?

I will check on the git tree which patch touch on this and commit it. As
backport tree, I cannot commit anything besides on existing source of git tree.

Thanks
Douglas
