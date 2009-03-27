Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759319AbZC0QvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 12:51:07 -0400
Date: Fri, 27 Mar 2009 13:50:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Darius Augulis <augulis.darius@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
Message-ID: <20090327135055.7e3e7aaf@pedra.chehab.org>
In-Reply-To: <49CCD72F.3070603@gmail.com>
References: <49C89F00.1020402@gmail.com>
	<Pine.LNX.4.64.0903261405520.5438@axis700.grange>
	<49CBD53C.6060700@gmail.com>
	<20090326170910.6926d8de@pedra.chehab.org>
	<49CC9E53.9070805@gmail.com>
	<20090327075625.276376b1@pedra.chehab.org>
	<49CCD72F.3070603@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Mar 2009 15:39:59 +0200
Darius Augulis <augulis.darius@gmail.com> wrote:

> Mauro Carvalho Chehab wrote:
>  > On Fri, 27 Mar 2009 11:37:23 +0200
>  > Darius Augulis <augulis.darius@gmail.com> wrote:
>  >
>  >> Mauro Carvalho Chehab wrote:
>  >>> Hi Darius,
>  >>>
>  >>> Please always base your patches against the last v4l-dvb tree or linux-next.
>  >>> This is specially important those days, where v4l core is suffering several
>  >>> changes.
>  >
>  > Btw, you shouldn't be c/c a list that requires subscription. Every time I send
>  > something, I got such errors:
> 
> I sent it to ARM Linux ML, because it has lot of ARM stuff and there are people who maintain ARM/MXC.
> You probably could remove some CC from your reply message?

If the subject is important to ARM people, the reply messages should be there
as well. Otherwise you shouldn't c/c it since the beginning ;)

Subscribers only list are not good for patches discussion, and aren't
recommended by Linux practices. 

The issues become evident on such discussions where more than one
subsystem is envolved. 

We've switched this year to linux-media@vger.kernel.org mainly due to that: the
anti-spam filters at VGER are so efficient that we don't need to be
subscribers-only anymore. I suggest that you try to argue with ARM list
maintainer to do the same. 

At the mean time, please c/c only lists that don't require subscriptions, since
people shouldn't be forced to subscribe just to reply an email, and it is not
polite to send emails refusing their comments.

Cheers,
Mauro
