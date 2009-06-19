Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:42432 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbZFSMlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 08:41:14 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Use kzalloc for frontend states to have struct dvb_frontend properly initialized
Date: Fri, 19 Jun 2009 14:41:12 +0200
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Steven Toth <stoth@linuxtv.org>
References: <200906191321.05477.zzam@gentoo.org> <4A3B809D.7050709@linuxtv.org>
In-Reply-To: <4A3B809D.7050709@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906191441.13521.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Freitag, 19. Juni 2009, Andreas Oberritter wrote:
> Hello Matthias,
>
> Matthias Schwarzott wrote:
> > This patch changes most frontend drivers to allocate their state
> > structure via kzalloc and not kmalloc. This is done to properly
> > initialize the embedded "struct dvb_frontend frontend" field, that they
> > all have.
> >
> > The visible effect of this struct being uninitalized is, that the member
> > "id" that is used to set the name of kernel thread is totally random.
> >
> > [...]
> >
> > Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
>
> I still think that this id doesn't belong into struct dvb_frontend and
> should be private to the drivers, but using kzalloc is a good idea in
> every case. Did you verify that none of the drivers does an additional
> memset?
Yes, I did verify that. There are no memset calls for that memory.

> If so, you can add my "Acked-by: Andreas Oberritter 
> <obi@linuxtv.org>".
>
Regards
Matthias
