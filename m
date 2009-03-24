Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4355 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbZCXMZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 08:25:38 -0400
Message-ID: <63406.62.70.2.252.1237897523.squirrel@webmail.xs4all.nl>
Date: Tue, 24 Mar 2009 13:25:23 +0100 (CET)
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Trent Piepho" <xyzzy@speakeasy.org>
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Devin Heitmueller" <devin.heitmueller@gmail.com>,
	"Hans Werner" <hwerner4@gmx.de>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Sat, 21 Mar 2009, Mauro Carvalho Chehab wrote:
>> > When this thread was started, it was about dropping support for
>> > kernels < 2.6.22.  However, it has turned into a thread about moving
>> > to git and dropping support for *all* kernels less than the bleeding
>> > edge -rc candidate (only supporting them through a backport system for
>> > testers).  The two are very different things.
>
> Yes they are very different things.  I do not like a poll about dropping
> the current build system being disguised as a poll about dropping support
> for very old kernels.  How about a new poll, "should developers be
> required
> to have multiple systems and spend the majority of their time recompiling
> new kernels and testing nvidia and wireless drivers?"

The poll was just about dropping support for old kernels. Nothing more,
nothing less. There were a few who commented that they wouldn't mind
dropping all compatibility, but those were very much a minority. I for one
want to keep the compatibility code in one way or another so we can
support the last X kernels and make life easy for ourselves and for our
users.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

