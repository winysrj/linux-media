Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:51154 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCZLgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 07:36:55 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3100DEDK9H3790@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 26 Mar 2014 07:36:53 -0400 (EDT)
Date: Wed, 26 Mar 2014 08:36:48 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 11/11] libdvbv5: fix PMT parser
Message-id: <20140326083648.4a432272@samsung.com>
In-reply-to: <87r45pcvmw.fsf@nemi.mork.no>
References: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
 <1395771601-3509-11-git-send-email-neolynx@gmail.com>
 <87vbv2c87u.fsf@nemi.mork.no> <20140325222222.0fd23199@neutrino.exnihilo>
 <87r45pcvmw.fsf@nemi.mork.no>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Mar 2014 07:38:15 +0100
Bjørn Mork <bjorn@mork.no> escreveu:

> André Roth <neolynx@gmail.com> writes:
> 
> > On Tue, 25 Mar 2014 21:51:49 +0100
> > Bjørn Mork <bjorn@mork.no> wrote:
> >
> >> > - * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
> >> > - * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
> >> > + * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
> >> >   *
> >> >   * This program is free software; you can redistribute it and/or
> >> >   * modify it under the terms of the GNU General Public License
> >> 
> >> This copyright change looked strange to me.  Accidental deletion?
> >
> > Hi Bjørn,
> >
> > thanks for pointing this out.
> > originally I was adding mauro to my dvb files as the "owner" of dvb in
> > v4l. mauro then stated on some files that this was not his code and as
> > the PMT is originally my code, I corrected this here.
> >
> > @mauro: please correct me if I'm wrong...
> 
> Correcting the copyright is of course fine, but I think it would be good
> to document that in the patch description so people like me don't end up
> asking unnecessary questions :-)

Yeah, a proper documentation always help.

Btw, what we generally do here is to extend the copyright timestamp,
instead of just replacing, like:

Copyright (c) 2012-2014 

> 
> > I'm a bit confused about the copyright year and author. Is this still
> > needed in the age of git ? What is the policy for them ?
> 
> IANAL.  But looking at this from a practical point of view, I believe
> that this info is useful whether it is required or not.  Reading the
> copyright owner(s) out of a git log can be a lot of work, and it isn't
> necessariliy correct either - your copyright can be assigned to
> e.g. your employer or to the FSF.  It's also difficult to judge who of
> many contributors have made changes big enough to make them copyright
> owners.  Some changes can be small in code size but still major, while
> other changes can touch almost every line but still only be a minor
> editorial fixup.

The copyright laws were written to cover all sorts of intelectual
work, and were written originally to cover music, painting, literature
work. There are actually two kinds of copyrights: moral rights and
economic rights. 

The GPL license (and all other sorts of licensing) deals with the
economic rights. A copyright line, however, can, IMO, serve for both
purposes: to tell the authorship and to identify who owns the
economic rights and who is licensing them under GPL.

If you develop something under your work contract, your employer likely
has property rights. 

Yet, you still owns the moral rights[1]. On most Countries, it is
not even possible to transfer them to someone else.

[1] http://en.wikipedia.org/wiki/Moral_rights

That warrants that a book written by, let's say, Julio Verne, will
always be copyrighted by him, no matter if he (or his family)
sold the economic rights, or if his books are already in public
domain or not.

> And why is it useful who owns a copyright and when the copyrighted work
> was produced? If relicensing your code ever becomes a question, then we
> need to know who to contact.  You might think that relicensing isn't
> going to happen.  But there are real world examples where code has ended
> up beeing linked to libraries with a GPL conflicting license, and
> therefore needed an exception. The classical example is linking with
> openssl.
> 
> And the year is useful because copyright expires some years (depending
> on country of origin, but typical 50) after the authors death.  You
> write code that will live forever, right? :-)

Yeah, the property rights expires. 

The moral rights, however, never expire: if someone uses part of the
Illiad (written around the 8th Century BC by Homero) on his work, he 
can't claim any rights on it, because that part of the text will forever
belong to Homero.

> 
> 
> Bjørn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Regards,
Mauro
