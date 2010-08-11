Return-path: <mchehab@pedra>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:24321 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0HKLpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Aug 2010 07:45:11 -0400
Subject: Re: A problem with http://git.linuxtv.org/media_tree.git
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: ext Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <1281526453.14489.50.camel@masi.mnp.nokia.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <201008091838.13247.hverkuil@xs4all.nl>
	 <1281425501.14489.7.camel@masi.mnp.nokia.com>
	 <b141c1c6bfc03ce320b94add5bb5f9fc.squirrel@webmail.xs4all.nl>
	 <1281441830.14489.27.camel@masi.mnp.nokia.com>
	 <4C614294.7080101@redhat.com>
	 <1281518486.14489.43.camel@masi.mnp.nokia.com>
	 <757d559ab06463d8b5e662b9aeeec701.squirrel@webmail.xs4all.nl>
	 <1281526453.14489.50.camel@masi.mnp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 14:44:33 +0300
Message-ID: <1281527073.14489.59.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi again.

On Wed, 2010-08-11 at 14:34 +0300, Matti J. Aaltonen wrote:
> Hello.
> 
> On Wed, 2010-08-11 at 12:56 +0200, ext Hans Verkuil wrote:
> > > Hi.
> > >
> > > I cloned your tree at 	http://linuxtv.org/git/media_tree.git and checked
> > > out the origin/staging/v2.6.37 branch and the
> > > Documentation/video4linux/v4l2-controls.txt  just isn't there. I asked
> > > one of my colleagues to do the same and the result was also the same.
> > 
> > The file is in the v2.6.36 branch. It hasn't been merged yet in the
> > v2.6.37 branch.
> 
> 37 above was a typo, sorry. My point was that we couldn't find it in the
> origin/staging/v2.6.36 branch... and that the branch lags behind of what
> can be seen via the git web interface...
> 
> B.R.
> Matti

I'd suggest - if that's not too much trouble - that you'd clone the tree
using http (from http://linuxtv.org/git/media_tree.git) and then checked
out the 36 branch and see that it works for you and then post the
command you used and then I'll admit what I did wrong - if necessary:-)

Cheers,
Matti

> 
> > 
> > Regards,
> > 
> >         Hans
> > 
> > >
> > > The latest commit in this branch is:
> > >
> > > commit 80f1bb8ad61b56597ef2557cc7c67d8876247e6d
> > > Merge: 2763aca... fc1caf6...
> > > Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> > > Date:   Fri Aug 6 10:50:25 2010 -0300
> > >
> > > Please check what's wrong...
> > >
> > > Thanks,
> > > Matti A.
> > >
> > >
> > >
> > 
> > 
> 


