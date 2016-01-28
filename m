Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:39618 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbcA1HZ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 02:25:58 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: Support Intersil/Techwell TW686x-based video capture cards
References: <1451183213-2733-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<569CE27F.6090702@xs4all.nl>
	<CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
	<m31t96j8u4.fsf@t19.piap.pl>
	<CAAEAJfBM_vVBVRd3P0kJ1QLzk-M==L=x6CS0ggXgRX=7K_aK_A@mail.gmail.com>
	<m3si1kioa9.fsf@t19.piap.pl>
	<CAAEAJfC_Sa_6opADoz0Ab8NrmhX+cjNmSK_Nw_Ne9nk-ROaj0Q@mail.gmail.com>
	<m3io2gfksk.fsf@t19.piap.pl>
	<CAAEAJfDb84ZbRkq9GVOmeWp=vpn_GBX9Fx0w+aGnZ9n29PsR8A@mail.gmail.com>
Date: Thu, 28 Jan 2016 08:25:55 +0100
In-Reply-To: <CAAEAJfDb84ZbRkq9GVOmeWp=vpn_GBX9Fx0w+aGnZ9n29PsR8A@mail.gmail.com>
	(Ezequiel Garcia's message of "Wed, 27 Jan 2016 09:14:49 -0300")
Message-ID: <m3a8nqf9mk.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> writes:

> Since your driver is not merged, there's no real benefit in my sending
> me patches against it.

And it's not merged because you stated that you have produced
a rewritten driver, using my driver just as a reference, and I was naive
enough to believe it and let it go.

> Since I just submitted a v2 driver that seems to be ready to be
> merged, how about I just add DMA s-g support so you get all the
> functionality you need?
>
> This option sounds much easier than you going through all the pain of
> cleaning up your driver.

Do I really have to answer such questions?

One can't simply take someone's code, replace the MODULE_AUTHOR,
twist a bit to suit his needs, and send it as his own.

In my country, it wouldn't be even legal.



I have at least one similar situation here. I'm using frame grabber
drivers for an I.MX6 processor on-chip feature. The problem is, the
author hasn't yet managed (for years now) to have this functionality
merged into the official tree. Obviously, I'm putting some considerable
work in it. Does this mean I'm free to grab it as my own and request
that it is to be merged instead? No, I have to wait until the original
work is merged, and only then I can ask for my patches to be applied
(in the form of changes, not a raw driver code).
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
