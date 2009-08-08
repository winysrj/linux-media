Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2591 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbZHHIzf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 04:55:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Direct v4l-dvb master commits
Date: Sat, 8 Aug 2009 10:55:24 +0200
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197380908051158i52af640cn1b87bfe90c0890b8@mail.gmail.com> <20090807132841.51372e65@caramujo.chehab.org>
In-Reply-To: <20090807132841.51372e65@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908081055.25229.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 August 2009 18:28:41 Mauro Carvalho Chehab wrote:
> Em Wed, 5 Aug 2009 14:58:23 -0400
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
> > On a related note, is there some rationale you can offer as to why you
> > are committing patches directly into the v4l-dvb mainline without any
> > peer review, unlike *every* other developer in the linuxtv project?  I
> > know it may seem redundant to you since you are the person acting on
> > the PULL requests, but it would provide an opportunity for the other
> > developers to offer comments on your patches *before* they go into the
> > mainline.
> 
> This were already answered on some previous msgs at the ML: hg commits mailing
> lists give the opportunity for people to review what were committed at the
> staging tree, since every patch is automatically mailbombed to the mailing
> list. The mainline tree is my -git. It is delayed over -hg to give opportunity
> for people to review the committed patches. Also, I'm not the kind of person
> that use to talk to himself. Starting sending pull requests from me to myself
> will probably get me a free ticket to a mental care services :-d

I have to say that I really disagree with that. The hg master v4l-dvb tree is
what everyone develops against. So when bad patches go in without having had
the opportunity for a review, then that will affect all of us.

There is also no way to remove such a broken patch from the master tree.
Once it is in it can only be removed by committing a revert patch.

Now, I have no problem with you committing trivial fixes directly into the
master repository, but anything non-trivial should also get the chance to
be reviewed by others. It's not talking to yourself, it's asking for a review
before you commit, just like we all do. Just post a pull request and if
there are no comments after 24 hours, then commit.

Two cases that come to mind that irritated me were the commit of the cx231xx
driver without subdev support out of nowhere a few months ago and your
addition of --get/set-param support in v4l2-ctl just a few days ago which had
several bugs (fixed in my pending v4l-dvb-misc tree).

If these commits were posted as pull requests then I would have reviewed them
first and any issues would have been fixed before they entered the master repo.

There is also the human factor to consider: it can be demotivating (or at
least irritating) if your own pull requests are still queued after several
days and you see the maintainer doing big commits out of the blue at the
same time.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
