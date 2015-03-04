Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:43855 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbbCDODk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 09:03:40 -0500
Received: by igbhn18 with SMTP id hn18so36863636igb.2
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2015 06:03:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNXOAJR6tV6PGL4-zqeE-Kx0BYgOxZpEfRvN6fmv9_wMKA@mail.gmail.com>
References: <CALzAhNXOAJR6tV6PGL4-zqeE-Kx0BYgOxZpEfRvN6fmv9_wMKA@mail.gmail.com>
Date: Wed, 4 Mar 2015 16:03:39 +0200
Message-ID: <CAAZRmGx4syvsxS58mARytXdz11NzQpVYf7ob=rzVA7sASMT=5A@mail.gmail.com>
Subject: Re: HVR2205 / HVR2255 support
From: Olli Salonen <olli.salonen@iki.fi>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steven,

Great to hear! The LGDT3306A went into the media_tree yesterday as far
as I can see, together with my HVR-955Q patches.

Coincidentally, I've been working with HVR-2205 and HVR-2215 as well
and have looked into the HVR-2255 a bit too. I'll also be travelling
(luckily on leisure) for next 10 days or so, but can submit the
HVR-2215 patches on top of your patches afterwards then unless you
have HVR-2215 support already.

Cheers,
-olli



On 4 March 2015 at 15:43, Steven Toth <stoth@kernellabs.com> wrote:
> Mauro, what's the plan to pull the LGDT3306A branch into tip? The
> SAA7164/HVR2255 driver need this for demod support.
>
> Hey folks, an update on this.
>
> So I have the green-light to release my HVR2205 and HVR2255 board
> related patches. I started merging them into tip earlier this week.
> The HVR2205 is operational for DVB-T, although I have not tested
> analog tv as yet.
>
> The HVR2255 is the next on the list, I expect this to be trivial once
> the HVR2205 work is complete.
>
> Annoyingly, I'm traveling on business for the next 10 days or so. I
> can't complete the work until I return - but I expect to complete this
> entire exercise by 21st of this month.... So hold on a little longer
> and keep watching this mailing list for further updates.
>
> Thanks,
>
> - Steve
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
