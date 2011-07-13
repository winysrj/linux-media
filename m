Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51506 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751732Ab1GMWAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 18:00:25 -0400
Date: Wed, 13 Jul 2011 15:00:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH 1/9] stringify: add HEX_STRING()
Message-Id: <20110713150023.0dde9ef4.rdunlap@xenotime.net>
In-Reply-To: <CACqU3MWBb4J8rmaRv23=-_=GXppGSUdqmOqeXoqWi4ZJ7ZYewg@mail.gmail.com>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
	<CACqU3MWBb4J8rmaRv23=-_=GXppGSUdqmOqeXoqWi4ZJ7ZYewg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 13 Jul 2011 17:49:48 -0400 Arnaud Lacombe wrote:

> Hi,
> 
> On Sun, Jul 10, 2011 at 3:51 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> >
> > Add HEX_STRING(value) to stringify.h so that drivers can
> > convert kconfig hex values (without leading "0x") to useful
> > hex constants.
> >
> > Several drivers/media/radio/ drivers need this. �I haven't
> > checked if any other drivers need to do this.
> >
> > Alternatively, kconfig could produce hex config symbols with
> > leading "0x".
> >
> Actually, I used to have a patch to make hex value have a mandatory
> "0x" prefix, in the Kconfig. I even fixed all the issue in the tree,
> it never make it to the tree (not sure why). Here's the relevant
> thread:
> 
> https://patchwork.kernel.org/patch/380591/
> https://patchwork.kernel.org/patch/380621/
> https://patchwork.kernel.org/patch/380601/
> 

I prefer that this be fixed in kconfig, so long as it won't cause
any other issues.  That's why I mentioned it.

> 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > ---
> > �include/linux/stringify.h | � �7 +++++++
> > �1 file changed, 7 insertions(+)
> >
> > NOTE: The other 8 patches are on lkml and linux-media mailing lists.
> >
> > --- linux-next-20110707.orig/include/linux/stringify.h
> > +++ linux-next-20110707/include/linux/stringify.h
> > @@ -9,4 +9,11 @@
> > �#define __stringify_1(x...) � �#x
> > �#define __stringify(x...) � � �__stringify_1(x)
> >
> > +/*
> > + * HEX_STRING(value) is useful for CONFIG_ values that are in hex,
> > + * but kconfig does not put a leading "0x" on them.
> > + */
> > +#define HEXSTRINGVALUE(h, value) � � � h##value
> > +#define HEX_STRING(value) � � � � � � �HEXSTRINGVALUE(0x, value)
> > +
> that seems hackish...

It's a common idiom for concatenating strings in the kernel.

How would you do it without (instead of) a kconfig fix/patch?

> > �#endif /* !__LINUX_STRINGIFY_H */
> > --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
