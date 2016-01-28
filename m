Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40465 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932762AbcA1HoC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 02:44:02 -0500
Subject: Re: [PATCH] media: Support Intersil/Techwell TW686x-based video
 capture cards
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
References: <1451183213-2733-1-git-send-email-ezequiel@vanguardiasur.com.ar>
 <569CE27F.6090702@xs4all.nl>
 <CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
 <m31t96j8u4.fsf@t19.piap.pl>
 <CAAEAJfBM_vVBVRd3P0kJ1QLzk-M==L=x6CS0ggXgRX=7K_aK_A@mail.gmail.com>
 <m3si1kioa9.fsf@t19.piap.pl>
 <CAAEAJfC_Sa_6opADoz0Ab8NrmhX+cjNmSK_Nw_Ne9nk-ROaj0Q@mail.gmail.com>
 <m3io2gfksk.fsf@t19.piap.pl>
 <CAAEAJfDb84ZbRkq9GVOmeWp=vpn_GBX9Fx0w+aGnZ9n29PsR8A@mail.gmail.com>
 <m3a8nqf9mk.fsf@t19.piap.pl>
Cc: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56A9C6BC.6040208@xs4all.nl>
Date: Thu, 28 Jan 2016 08:43:56 +0100
MIME-Version: 1.0
In-Reply-To: <m3a8nqf9mk.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/2016 08:25 AM, Krzysztof Hałasa wrote:
> Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> writes:
> 
>> Since your driver is not merged, there's no real benefit in my sending
>> me patches against it.
> 
> And it's not merged because you stated that you have produced
> a rewritten driver, using my driver just as a reference, and I was naive
> enough to believe it and let it go.
> 
>> Since I just submitted a v2 driver that seems to be ready to be
>> merged, how about I just add DMA s-g support so you get all the
>> functionality you need?
>>
>> This option sounds much easier than you going through all the pain of
>> cleaning up your driver.
> 
> Do I really have to answer such questions?
> 
> One can't simply take someone's code, replace the MODULE_AUTHOR,
> twist a bit to suit his needs, and send it as his own.

As long as copyright notices are retained (and that also includes a
MODULE_AUTHOR: Ezequiel, if you removed that than you should put it
back and add a second MODULE_AUTHOR with your name), then you are free
to do so if the code is licensed under a GPL.

> In my country, it wouldn't be even legal.

It's legal for the GPL license since that gives explicit permission.

> 
> 
> 
> I have at least one similar situation here. I'm using frame grabber
> drivers for an I.MX6 processor on-chip feature. The problem is, the
> author hasn't yet managed (for years now) to have this functionality
> merged into the official tree. Obviously, I'm putting some considerable
> work in it. Does this mean I'm free to grab it as my own and request
> that it is to be merged instead? No, I have to wait until the original
> work is merged, and only then I can ask for my patches to be applied
> (in the form of changes, not a raw driver code).

Wrong. As long as the original code is distributed as GPL you can
certainly take it, fix it and ask for it to be merged.

This happens all the time if the original author has left the scene, or has
no time or interest to follow-up on his patches.

>From the point of view as a reviewer and all things being equal the first
who comes up with a decent driver that passes the quality tests will get
merged.

In this particular case I've asked Ezequiel to put back the functionality
that he removed, since I thought that was a reasonable compromise (i.e.
you're both unhappy, so that's only half the misery for each :-) ).

For future reference: if someone posts code to a kernel mailinglist and does
not fix any comments made on the code in, let's say, 1-2 months, then
someone else might just step in. Once posted you lose control over your
code (they are kernel drivers, so always GPL). Normally nobody wants to
take over the code unless no visible progress is made for a few months.

Anyway, what's done is done.

Regards,

	Hans
