Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796Ab0J1Sww (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 14:52:52 -0400
Message-ID: <4CC9C67C.8040102@redhat.com>
Date: Thu, 28 Oct 2010 16:52:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.26 and up: ERRORS
References: <201010271905.o9RJ504u021145@smtp-vbr1.xs4all.nl> <4CC94D5A.3090504@redhat.com> <4CC9BA90.2080805@hoogenraad.net>
In-Reply-To: <4CC9BA90.2080805@hoogenraad.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jan,

Em 28-10-2010 16:01, Jan Hoogenraad escreveu:
> Douglas:
> 
> First of all thank you for the support you have done so far.
> 
> Hans:
> 
> Is it possible to build the tar from
> http://git.linuxtv.org/mchehab/new_build.git
> automatically each night, just like the way the hg archive was built ?
> I don't have sufficient processing power to run that.
> 
> Mauro:
> 
> I'm willing to give the mercurial conversion a shot.
> I do not know a lot about v4l, but tend to be able to resolve this kind of release-type issues.
> 
> The way it seems to me is that first new_build.git should compile for all releases that the hg archive supported.

We still lack a maintainer for the new_build ;) I think we need to have someone
with time looking on it, before flooding the ML's with breakage reports.
I did the initial work: the tree is compiling, and I did a basic test with a few
drivers on v2.6.32, but, unfortunately, I won't have time to maintain it.
So, someone needs to head it. A few already talked to me about maintaining it
it in priv, but didn't manifest yet publicly, because they're still analysing it.
Also, so far, I received only one patch not made by me.

Currently, the new_build tree covers kernel versions from .32 to .36, but, if nobody 
handles it, the backport patches will break with the time. Probably, some API will
change on .37, requiring a new backport patch. In the meantime, someone may change 
one of the backported lines, breaking those patches.

The good news is that there are just a few backport patches to maintain:
8 patches were enough for 2.6.32 (plus the v4l/compat.h logic).

It is up to the one that takes the maintainership to decide what will be the minimum
supported version. 

IMHO, 2.6.32 is a good choice, as it has a long-maintained stable version and almost all 
major distros are using it as basis for their newest version (and anyone 'crazy' enough 
to use an experimental, pre -rc version, is likely using a brand new distribution ;) ).

> Then I'd like some support from you as to transfer all current HG branches to the git line.
> In principle, that should be fixed by the maintainers. If the new_build.git complies well, 
> that should be relatively straightforward.
> 
> For me, it would be great if Mauro could transfer these branches automatically at that time to git.

I can't do it, due to several reasons:

1) it would be a huge manual effort;
2) Trees will require up-port to the latest git version;
3) some trees are there mostly due to historic reasons;
4) developers need to rebase their drivers to the latest git, and test on their hardware if the
   up-port didn't break anything;
5) developers should be ok on migrating to git;

I sent already a procedure for everybody with an account at linuxtv explaining how to create
a git tree there. If they have any doubts, it is just a matter of pinging me, in priv.

Cheers,
Mauro
