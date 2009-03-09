Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3238 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbZCIWoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 18:44:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: V4L2 spec
Date: Mon, 9 Mar 2009 23:44:04 +0100
Cc: wk <handygewinnspiel@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <200903061523.15766.hverkuil@xs4all.nl> <49B59230.1090305@gmx.de> <412bdbff0903091510n5e000675sfa7b983c9b855123@mail.gmail.com>
In-Reply-To: <412bdbff0903091510n5e000675sfa7b983c9b855123@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903092344.04805.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 09 March 2009 23:10:56 Devin Heitmueller wrote:
> On Mon, Mar 9, 2009 at 6:03 PM, wk <handygewinnspiel@gmx.de> wrote:
> > Its a bad idea to expect someone else, the magic volunteer, doing work
> > with *deep impact* on the dvb driver API structure or documentation.
> > Working on this topic determines complete usability of the driver, so
> > MAIN DEVELOPERS have to REVIEW and CONTRIBUTE.
> > If they think, that they cannot do such work in parallel, they should
> > to stop work on drivers for some time.
>
> Cut me a $25,000 check and I'll happily do it.  Otherwise, don't tell
> a bunch of volunteer developers how they should be spending their
> time.  What you happen to think is the important is not necessarily
> what developers feel is the most valuable use of their time.

Hear, hear.

> The reality is that there is *some* value a developer can contribute
> in reviewing the content and providing feedback and a *TON* of grunt
> work involved that can be done by anybody who takes the time to learn
> docbook.  If someone wants to volunteer to do the former, I'm sure
> some developers would be willing to do the latter.

Indeed. If someone could do the 'grunt' work of converting the dvb doc into 
DocBook and integrating it into the existing v4l docbook, then that will no 
doubt get a flow of patches and gradual improvements started from the main 
developers. In addition, simply asking them to clarify bits of the 
documentation will generally result in answers and you can then put that 
into the doc.

None of this requires in-depth knowledge, but only motivation and the time 
to do this work.

You can probably partially automate the conversion with some homebrewn 
one-off perl scripts (or whatever your favorite script language is). But 
it's still a lot of manual labor.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
