Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1EJkgPu000653
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 14:46:42 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1EJkLPO001167
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 14:46:21 -0500
Date: Thu, 14 Feb 2008 17:46:02 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <bphilips@suse.de>
Message-ID: <20080214174602.4ed91987@gaivota>
In-Reply-To: <20080213202055.GA26352@plankton.ifup.org>
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
	<20080205080038.GB8232@plankton.ifup.org>
	<20080205102409.4b7acb01@gaivota>
	<20080213202055.GA26352@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>
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

On Wed, 13 Feb 2008 12:20:55 -0800
Brandon Philips <bphilips@suse.de> wrote:

> On 10:24 Tue 05 Feb 2008, Mauro Carvalho Chehab wrote:
> > Maybe we've took the wrong direction when we've decided to select
> > mercurial. It were better and easier to use, on that time, but the -git
> > improvements happened too fast.
> 
> We should consider a move to a full-tree git.  Particularly, it would be
> nice to be have v4l-dvb merging/building against other subsystems in the
> linux-next tree:
> 
>   http://lkml.org/lkml/2008/2/11/512
> 
> Also, it would save the silly pain of things like this meye.h thing and
> pulling in fixes from the rest of the community that patches against git
> trees.

Just a few personal notes about my comment about git x hg and your request:

There are two separate things to discuss.

One is the SCM used by v4l/dvb. 

>From my personal experience with both, -git is currently much more advanced
than -hg. Git suffered lots of newer updates and feature additions, while hg
still didn't arise version 1.0 (the original plan from the developers were to
release version 1.0 in 2005, if my memories are not failing). 

AFAIK, Mercurial still lacks branches and a proper way to clone a tree without
needing to copy all files to the newer copy. This means that having lots of
repositories will mean to spend a large amount of disk space.

On the other hand, you can clone a git, with '-l' option. The common patches
won't be cloned, resulting on a very small repository.

Also, -git tree-way merge is much better than the way mercurial deals with.

-git trees have two different meta-tags to represent the tree owner _and_ the
patch author. A patch can be committed by a maintainer, preserving author's
ownership. On Mercurial, there's only one meta-tag. So, each developer needs to
manually add a line with:
	From: someone <some@email>
To represent the missing authorship. I need some scripts to convert this "From"
artificial field into an Author, before generating the -git.

Another point on -hg is that adding a SOB on a patch will change its MD5.
Mercurial will start to think that the patch with SOB is different from the one
without. The practical result of this is that SOB's can't be applied on trees
that are cloned. This affects mostly v4l-dvb tree, but also may cause some harm
if there are two developers working at the same code, collaborating one with the
other, and both adding SOB/reviewed-by. That's why the official master tree is
our kernelstyle -git: it is the only tree were I can safely add SOB (including
the maintainers's ones), reviewed-by, fix missing authorships, etc.

Lastly, on -git, _every_ merge produces a log. So, it is very easy to backtrack
tree merges. On mercurial, a merge commit happens only when the developer's
tree is not based against tip. So, you can't safely track if a patch were
merged from another tree, or if the patch came from email, committed by the
tree maintainer.

Technically, it would be possible to migrate to -git, preserving the way our
repository is built.

Yet, I don't believe that the gains would be enough to compensate the amount of
effort from all to develop and learn new procedures for their usage.

-

The other issue is to abandon our building system and just use -git.

This will likely cause a lack of users for testing the patchsets. This doesn't
seem to be a good idea.

-

So, I don't think we should move from -hg to -git.

-

About linux-next, this is really a good idea. I've already implemented a
linux-next -git tree for v4l-dvb. This tree is generated at the same time I
generate the master -git. Since I update this often, I think this will work
properly.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
