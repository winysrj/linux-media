Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58890 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab3CUJNc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 05:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130321101059.03e9f811@crub>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de>
 <1363382873-20077-2-git-send-email-g.liakhovetski@gmx.de> <CA+V-a8vgthS2kh4bAH_pKNWkFTy+4xrAva5wdF58qT10Ni5nUg@mail.gmail.com>
 <20130321101059.03e9f811@crub>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 21 Mar 2013 14:43:11 +0530
Message-ID: <CA+V-a8tMkphQGwOVnqEv11h+FfC+=-W=ewFCYpwg8OD-gNyFbw@mail.gmail.com>
Subject: Re: [PATCH v6 1/7] media: V4L2: add temporary clock helpers
To: Anatolij Gustschin <agust@denx.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Anatolij,

On Thu, Mar 21, 2013 at 2:40 PM, Anatolij Gustschin <agust@denx.de> wrote:
> On Thu, 21 Mar 2013 13:49:50 +0530
> Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
> ...
>> >  drivers/media/v4l2-core/Makefile   |    2 +-
>> >  drivers/media/v4l2-core/v4l2-clk.c |  184 ++++++++++++++++++++++++++++++++++++
>> >  include/media/v4l2-clk.h           |   55 +++++++++++
>> >  3 files changed, 240 insertions(+), 1 deletions(-)
>> >  create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
>> >  create mode 100644 include/media/v4l2-clk.h
>> >
>> While trying out this patch I got following error (using 3.9-rc3):-
>>
>> drivers/media/v4l2-core/v4l2-clk.c: In function 'v4l2_clk_register':
>> drivers/media/v4l2-core/v4l2-clk.c:134:2: error: implicit declaration
>> of function 'kzalloc'
>> drivers/media/v4l2-core/v4l2-clk.c:134:6: warning: assignment makes
>> pointer from integer without a cast
>> drivers/media/v4l2-core/v4l2-clk.c:162:2: error: implicit declaration
>> of function 'kfree'
>> make[3]: *** [drivers/media/v4l2-core/v4l2-clk.o] Error 1
>> make[2]: *** [drivers/media/v4l2-core] Error 2
>
> please try adding
>
> #include <linux/slab.h>
>
> in the affected file.
>
Thanks for pointing it :), I have already fixed it.
Just wanted to point Guennadi so that he could fix it in his next version.

Cheers,
--Prabhakar

> Thanks,
>
> Anatolij
