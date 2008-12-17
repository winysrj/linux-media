Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBHEC4P2009182
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 09:12:04 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBHEBqmA021724
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 09:11:52 -0500
Date: Wed, 17 Dec 2008 15:12:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080214174602.4ed91987@gaivota>
Message-ID: <Pine.LNX.4.64.0812171444420.5465@axis700.grange>
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
	<20080205102409.4b7acb01@gaivota>
	<20080213202055.GA26352@plankton.ifup.org>
	<20080214174602.4ed91987@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, v4lm <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] Moving to git for v4l-dvb
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

Sorry for reviving this almost-a-year-old thread, but after my last 
failure to formst hg-commits correctly, I'd like to have this clarified 
before causing Mauro extra manual editing of my commits again.

On Thu, 14 Feb 2008, Mauro Carvalho Chehab wrote:

[snip]

> -git trees have two different meta-tags to represent the tree owner _and_ the
> patch author. A patch can be committed by a maintainer, preserving author's
> ownership. On Mercurial, there's only one meta-tag. So, each developer needs to
> manually add a line with:
> 	From: someone <some@email>
> To represent the missing authorship. I need some scripts to convert this "From"
> artificial field into an Author, before generating the -git.

later

On Tue, 22 Apr 2008, Mauro Carvalho Chehab wrote:

> In general, you ask me to pull a patch series with yours and also third part
> patches. Please, be sure to add a "From: " line at the patch, since Mercurial
> has no meta-tag to indicate patch authorship. The only meta tag for someone is
> "user". We use this meta-tag to help tracking from what tree a changeset were 
> merged.

and recently

On Mon, 8 Dec 2008, Mauro Carvalho Chehab wrote:

> On -git, you have two different fields: the committer and the patch author.
> Since mercurial has just one field, we should take some care, since, depending
> on the way you import things into mercurial, you may lead to bad author
> attribution.
> 
> To avoid this risk, we've added an extra tag on all mercurial commits. Also, my
> -git import scripts don't automatically merge any patch that comes without the 
> "from" field. Those patches require manual work to forward. This way, I have a 
> double check procedure there.

So, what should a patch header look like to be imported into hg per "hg 
import" for later push to linuxtv to be pulled by Mauro?

Looks like it should have two "From: " lines - one will be used by hg for 
the user field and should contain my address, the second "From: " line 
should contain the actual patch author? All quotes above mention only one 
"From: ", and this is what a git-format-patch produces, but it looks like 
this single "From: " is then consumed by hg to form its "user" field, so 
nothing is left for a subsequent re-export to git.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
