Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB972TIg019358
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 02:02:29 -0500
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB972Big006271
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 02:02:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Tue, 9 Dec 2008 08:02:00 +0100
References: <200811271536.46779.laurent.pinchart@skynet.be>
	<200812082339.14889.laurent.pinchart@skynet.be>
	<20081208205809.417473c4@pedra.chehab.org>
In-Reply-To: <20081208205809.417473c4@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812090802.00580.hverkuil@xs4all.nl>
Cc: Michael Schimek <mschimek@gmx.at>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/4] Add zoom and privacy controls
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Monday 08 December 2008 23:58:09 Mauro Carvalho Chehab wrote:
> On Mon, 8 Dec 2008 23:39:14 +0100
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > The documentation part of the patch can't be pushed through
> > mercurial, and I didn't want to submit it separately.
>
> I know.
>
> > I will have to resubmit the patches anyway as Hans found a few
> > mistakes. I will send them by e-mail and ask for an ack, and I'll
> > then send a pull request.
>
> Ok.
>
> > Where should the documentation part of the patchset go ? Why isn't
> > the documentation stored in a repository ?
>
> Historical reasons. I would love to have this at kernel tree, but
> some work is probably required. The doc seems to big to be there, at
> the way it is.

What do you mean, "too big to be there"? The only thing that prevents me 
from putting it in the tree is that I can't build it! See my "Building 
v4l2spec docbook problems" mail on this list.

I'd love to get it in the repo myself. Note that I'm not sure whether we 
should put it under linux/Documentation, though. I intended to have it 
in its own directory and that we only publish the generated results on 
the linuxtv.org website.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
