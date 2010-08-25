Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39980 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0HYT0z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 15:26:55 -0400
Received: by iwn5 with SMTP id 5so829066iwn.19
        for <linux-media@vger.kernel.org>; Wed, 25 Aug 2010 12:26:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C74B78B.3020101@hoogenraad.net>
References: <AANLkTi=-ai2mZHiEmiEpKq9A-CifSPQDagrE03gDqpHv@mail.gmail.com>
	<AANLkTikZD32LC12bT9wPBQ5+uO3Msd8Sw5Cwkq5y3bkB@mail.gmail.com>
	<4C581BB6.7000303@redhat.com>
	<AANLkTi=i57wxwOEEEm4dXydpmePrhS11MYqVCW+nz=XB@mail.gmail.com>
	<AANLkTikMHF6pjqznLi5qWHtc9kFk7jb1G1KmeKsvfLKg@mail.gmail.com>
	<AANLkTim=ggkFgLZPqAKOzUv54NCMzxXYCropm_2XYXeX@mail.gmail.com>
	<AANLkTik7sWGM+x0uOr734=M=Ux1KsXQ9JJNqF98oN7-t@mail.gmail.com>
	<4C7425C9.1010908@hoogenraad.net>
	<AANLkTinA1r87W+4J=MRV5i6M6BD-c+KTWnYqyBd7WCQA@mail.gmail.com>
	<4C74B78B.3020101@hoogenraad.net>
Date: Wed, 25 Aug 2010 16:26:54 -0300
Message-ID: <AANLkTim3bq6h-oFY+TKoog-TKOzQ-w4MR0CVdcL4OjcD@mail.gmail.com>
Subject: Re: V4L hg tree fails to compile against kernel 2.6.28
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Cc: linux-media <linux-media@vger.kernel.org>,
	VDR User <user.vdr@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello Jan,

On Wed, Aug 25, 2010 at 3:26 AM, Jan Hoogenraad
<jan-conceptronic@hoogenraad.net> wrote:
> Thanks for your help. I pulled the code
>
> Actually, now the function definition in compat.h causes a compilation
> error: see first text below.
>
> I fixed that by inserting
> #include <linux/err.h>
> at line 38 in compat.h in my local branch
>
> After that, compilation succeeds.


Thanks, applied.

> Now, the device will not install, as dvb_usb cannot install anymore.
> see second text below.
>
> Therefore, I have replaced the __kmalloc_track_caller with kmalloc (as it
> was in dvb_demux.c before the change 2ceef3d75547 at line 49
>
> can you make both changes in the hg branch ?

This one won't be required because the idea is support until kernel 2.6.26.
Please check my next email about hg x announcement.

Thanks for checking it, your help is appreciate.

Cheers
Douglas
