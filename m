Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZCIW4A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 18:56:00 -0400
Date: Mon, 9 Mar 2009 19:55:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: wk <handygewinnspiel@gmx.de>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: V4L2 spec
Message-ID: <20090309195519.17f26f72@pedra.chehab.org>
In-Reply-To: <412bdbff0903091510n5e000675sfa7b983c9b855123@mail.gmail.com>
References: <200903061523.15766.hverkuil@xs4all.nl>
	<49B14D3C.3010001@gmx.de>
	<alpine.LRH.2.00.0903090803010.6607@caramujo.chehab.org>
	<49B59230.1090305@gmx.de>
	<412bdbff0903091510n5e000675sfa7b983c9b855123@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Winfried,

On Mon, 9 Mar 2009 18:10:56 -0400
Devin Heitmueller <devin.heitmueller@gmail.com> wrote:

> On Mon, Mar 9, 2009 at 6:03 PM, wk <handygewinnspiel@gmx.de> wrote:
> > Its a bad idea to expect someone else, the magic volunteer, doing work with
> > *deep impact* on the dvb driver API structure or documentation.
> > Working on this topic determines complete usability of the driver, so MAIN
> > DEVELOPERS have to REVIEW and CONTRIBUTE.
> > If they think, that they cannot do such work in parallel, they should to
> > stop work on drivers for some time.
> 
> Cut me a $25,000 check and I'll happily do it.  Otherwise, don't tell
> a bunch of volunteer developers how they should be spending their
> time.  What you happen to think is the important is not necessarily
> what developers feel is the most valuable use of their time.
> 
> The reality is that there is *some* value a developer can contribute
> in reviewing the content and providing feedback and a *TON* of grunt
> work involved that can be done by anybody who takes the time to learn
> docbook.  If someone wants to volunteer to do the former, I'm sure
> some developers would be willing to do the latter.

I agree with Devin. 

The format conversion itself doesn't aggregate value to the spec. It is just a
format conversion. Even the merge between V4L and DVB specs doesn't aggregate
much value, per se. The value of a merged docbook with V4L and DVB will appear
when some new chapters will be added, mentioning how a hybrid driver should
work to provide both APIs, and maybe creating some additional functions to
control the hybrid behaviour (if needed).

I doubt that you'll find a main developer to do the docbook conversion work,
instead of spending his time developing. There are a number of reasons for
that, including that developers are good with C language but are probably not
familiar with docbook/latex languages. Also, they are not as skilled on writing
a book in English than on writing a C file. A proof of this is that most of the
work on both V4L and DVB APIs were done by a very small subset of people.

So, the better is to have someone more focused with documentation that will do
the hard work, with the support of the developers that will review and help
with the contents of the document, fixing the non-compliances (at the code, or
by proposing a patch to the docs).

Cheers,
Mauro
