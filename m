Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBANFt2j015074
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 18:15:55 -0500
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBANFeUs008884
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 18:15:40 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 11 Dec 2008 00:15:45 +0100
References: <200811271536.46779.laurent.pinchart@skynet.be>
	<200812082339.14889.laurent.pinchart@skynet.be>
	<20081208205809.417473c4@pedra.chehab.org>
In-Reply-To: <20081208205809.417473c4@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812110015.45547.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Michael Schimek <mschimek@gmx.at>
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

Hi Mauro,

On Monday 08 December 2008, Mauro Carvalho Chehab wrote:
> On Mon, 8 Dec 2008 23:39:14 +0100
>
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> > The documentation part of the patch can't be pushed through mercurial,
> > and I didn't want to submit it separately.
>
> I know.
>
> > I will have to resubmit the patches anyway as Hans found a few mistakes.
> > I will send them by e-mail and ask for an ack, and I'll then send a pull
> > request.
>
> Ok.
>
> > Where should the documentation part of the patchset go ? Why isn't
> > the documentation stored in a repository ?
>
> Historical reasons. I would love to have this at kernel tree, but some work
> is probably required. The doc seems to big to be there, at the way it is.

I agree with Hans here, moving the doc to the hg repository would make patch 
submission easier, even if it lives outside the kernel tree.

> > As a side note, is there an equivalent to git reset in Mercurial ? I know
> > about hg undo but that only supports one level of undo, and once
> > modifications have been pushed to my linuxtv.org repository there's no
> > way back. How would I have had to proceed if I had pushed the patchset to
> > linuxtv.org ? Would I have had to dump the repository, create a brand new
> > one by cloning and reapply modifications ?
>
> There are a few ways to work with. If you have "mq" extension enabled, you
> can do "hg strip" to remove a set of patches. I think you may also convert
> a commit into a quilt-like patch.

I'll try that. What happens to the patch queue when I push changes to 
linuxtv.org ? Do they have to be merged first ? If so it wouldn't really 
solve my initial problem (or rather worry) as I still wouldn't be able to 
undo changes pushed the my linuxtv.org repository.

> Another option on mercurial 1.1 (just released) is the "hg rebase" command
> and "hg bookmarks". The second one is probably the closest feature from
> what we have in -git. I never tested it.
>
> Please, take come care with those features. I had a bad experience some
> days ago experimenting mercurial 1.1 with rebase and bookmarks. So, I
> recommend you to test they into a cloned repository and test for a while
> before using on production.

Thanks for the information.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
