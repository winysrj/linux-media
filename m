Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:48829 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab3CUJLI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 05:11:08 -0400
Date: Thu, 21 Mar 2013 10:10:59 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v6 1/7] media: V4L2: add temporary clock helpers
Message-ID: <20130321101059.03e9f811@crub>
In-Reply-To: <CA+V-a8vgthS2kh4bAH_pKNWkFTy+4xrAva5wdF58qT10Ni5nUg@mail.gmail.com>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de>
	<1363382873-20077-2-git-send-email-g.liakhovetski@gmx.de>
	<CA+V-a8vgthS2kh4bAH_pKNWkFTy+4xrAva5wdF58qT10Ni5nUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 21 Mar 2013 13:49:50 +0530
Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
...
> >  drivers/media/v4l2-core/Makefile   |    2 +-
> >  drivers/media/v4l2-core/v4l2-clk.c |  184 ++++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-clk.h           |   55 +++++++++++
> >  3 files changed, 240 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
> >  create mode 100644 include/media/v4l2-clk.h
> >
> While trying out this patch I got following error (using 3.9-rc3):-
> 
> drivers/media/v4l2-core/v4l2-clk.c: In function 'v4l2_clk_register':
> drivers/media/v4l2-core/v4l2-clk.c:134:2: error: implicit declaration
> of function 'kzalloc'
> drivers/media/v4l2-core/v4l2-clk.c:134:6: warning: assignment makes
> pointer from integer without a cast
> drivers/media/v4l2-core/v4l2-clk.c:162:2: error: implicit declaration
> of function 'kfree'
> make[3]: *** [drivers/media/v4l2-core/v4l2-clk.o] Error 1
> make[2]: *** [drivers/media/v4l2-core] Error 2

please try adding

#include <linux/slab.h>

in the affected file.

Thanks,

Anatolij
