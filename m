Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:54646 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030905Ab2CSO4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 10:56:45 -0400
Message-ID: <4F67492D.4040200@xenotime.net>
Date: Mon, 19 Mar 2012 07:56:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Claus Olesen <ceolesen@gmail.com>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: build errors in radio subsystem
References: <CAGa-wNOgmviyhOQbfmXP-O9272CyVSTJOgLK7S7MtRUuC8UcYw@mail.gmail.com>
In-Reply-To: <CAGa-wNOgmviyhOQbfmXP-O9272CyVSTJOgLK7S7MtRUuC8UcYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2012 02:45 AM, Claus Olesen wrote:

> I just got a kernel update that doesn't work for my PCTV 290e's so I
> pulled and build the media_build tree and got the below errors which I
> also got a week ago when I did the same after the previous kernel
> update and I'm just reporting this without knowing how often errors
> are fixed or for help if something is wrong at my end. The errors went
> away after I inserted include of slab.h in those files.

Mauro,
Please merge Hans's media-isa patch from Feb. 29.

Subject: [PATCH] Add missing slab.h to fix linux-next compile errors

Thanks.

> /media_build/v4l/radio-isa.c:246:3: error: implicit declaration of
> function 'kfree' [-Werror=implicit-function-declaration]
> /media_build/v4l/radio-aztech.c:72:9: error: implicit declaration of
> function 'kzalloc' [-Werror=implicit-function-declaration]
> media_build/v4l/radio-rtrack2.c:46:2: error: implicit declaration of
> function 'kzalloc' [-Werror=implicit-function-declaration]
> media_build/v4l/radio-typhoon.c:76:9: error: implicit declaration of
> function 'kzalloc' [-Werror=implicit-function-declaration]
> media_build/v4l/radio-terratec.c:57:2: error: implicit declaration of
> function 'kzalloc' [-Werror=implicit-function-declaration]
> media_build/v4l/radio-aimslab.c:67:9: error: implicit declaration of
> function 'kzalloc' [-Werror=implicit-function-declaration]
> media_build/v4l/radio-zoltrix.c:80:9: error: implicit declaration of
> function 'kzalloc' [-Werror=implicit-function-declaration]
> media_build/v4l/radio-gemtek.c:183:9: error: implicit declaration of
> function 'kzalloc' [-Werror=implicit-function-declaration]
> media_build/v4l/radio-trust.c:57:9: error: implicit declaration of
> function 'kzalloc' [-Werror=implicit-function-declaration]
> --


-- 
~Randy
