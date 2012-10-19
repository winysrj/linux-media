Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63374 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2JSRZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 13:25:31 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so588163pbb.19
        for <linux-media@vger.kernel.org>; Fri, 19 Oct 2012 10:25:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1584362.BsWDphDTBL@avalon>
References: <090701cd8c4e$be38bea0$3aaa3be0$@gmail.com>
	<4949132.OD6tNZX2Jk@avalon>
	<CAFqH_53G_jt1LdTiHtqnGKkqK8mmCOgt-ypQzpzjwpdytpsgzQ@mail.gmail.com>
	<1584362.BsWDphDTBL@avalon>
Date: Fri, 19 Oct 2012 19:25:31 +0200
Message-ID: <CAFqH_50zPse3mdQZ7=c0Xha+qgVm9msrpWLebFvTe5hWQcUhxg@mail.gmail.com>
Subject: Re: Using omap3-isp-live example application on beagleboard with DVI
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: John Weber <rjohnweber@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

2012/10/19 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Enric,
>
> On Wednesday 17 October 2012 11:35:37 Enric Balletbo Serra wrote:
>> 2012/10/17 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>
> [snip]
>
>> > Instead of failing what would be more interesting would be to get the
>> > application to work in 16bpp mode as well. For that you will need to paint
>> > the frame buffer with a 16bpp color, and set the colorkey to the same
>> > value. Would you be able to try that ?
>>
>> New patch attached, comments are welcome as I'm newbie with video devices.
>
> Thank you for the patch. In the future could you please send patches inline
> instead of attached (git send-email is a very useful tool for that) ? It would
> make review easier.
>

Ok, I'll do.

> You can get the bpp value directly from the frame buffer API without going
> through sysfs. I've modified your patch accordingly, have added support for
> 24bpp as well and pushed the result to the repository.
>

Cool, I liked your patch, today I learned a bit more.


Regards,

Enric Balletbo
