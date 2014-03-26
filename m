Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:59060 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaCZGiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Mar 2014 02:38:23 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: =?utf-8?Q?Andr=C3=A9?= Roth <neolynx@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH 11/11] libdvbv5: fix PMT parser
References: <1395771601-3509-1-git-send-email-neolynx@gmail.com>
	<1395771601-3509-11-git-send-email-neolynx@gmail.com>
	<87vbv2c87u.fsf@nemi.mork.no>
	<20140325222222.0fd23199@neutrino.exnihilo>
Date: Wed, 26 Mar 2014 07:38:15 +0100
In-Reply-To: <20140325222222.0fd23199@neutrino.exnihilo> (=?utf-8?Q?=22And?=
 =?utf-8?Q?r=C3=A9?= Roth"'s
	message of "Tue, 25 Mar 2014 22:22:22 +0100")
Message-ID: <87r45pcvmw.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

André Roth <neolynx@gmail.com> writes:

> On Tue, 25 Mar 2014 21:51:49 +0100
> Bjørn Mork <bjorn@mork.no> wrote:
>
>> > - * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
>> > - * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
>> > + * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
>> >   *
>> >   * This program is free software; you can redistribute it and/or
>> >   * modify it under the terms of the GNU General Public License
>> 
>> This copyright change looked strange to me.  Accidental deletion?
>
> Hi Bjørn,
>
> thanks for pointing this out.
> originally I was adding mauro to my dvb files as the "owner" of dvb in
> v4l. mauro then stated on some files that this was not his code and as
> the PMT is originally my code, I corrected this here.
>
> @mauro: please correct me if I'm wrong...

Correcting the copyright is of course fine, but I think it would be good
to document that in the patch description so people like me don't end up
asking unnecessary questions :-)

> I'm a bit confused about the copyright year and author. Is this still
> needed in the age of git ? What is the policy for them ?

IANAL.  But looking at this from a practical point of view, I believe
that this info is useful whether it is required or not.  Reading the
copyright owner(s) out of a git log can be a lot of work, and it isn't
necessariliy correct either - your copyright can be assigned to
e.g. your employer or to the FSF.  It's also difficult to judge who of
many contributors have made changes big enough to make them copyright
owners.  Some changes can be small in code size but still major, while
other changes can touch almost every line but still only be a minor
editorial fixup.

And why is it useful who owns a copyright and when the copyrighted work
was produced? If relicensing your code ever becomes a question, then we
need to know who to contact.  You might think that relicensing isn't
going to happen.  But there are real world examples where code has ended
up beeing linked to libraries with a GPL conflicting license, and
therefore needed an exception. The classical example is linking with
openssl.

And the year is useful because copyright expires some years (depending
on country of origin, but typical 50) after the authors death.  You
write code that will live forever, right? :-)


Bjørn
