Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3980 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1APUuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 15:50:11 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id p0GKo6gm060236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 16 Jan 2011 21:50:10 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] v4l2-ctrls: fix missing read-only check causing kernel oops
Date: Sun, 16 Jan 2011 21:50:00 +0100
References: <201101161636.34558.hverkuil@xs4all.nl> <201101161855.22328.hverkuil@xs4all.nl>
In-Reply-To: <201101161855.22328.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101162150.00958.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, January 16, 2011 18:55:22 Hans Verkuil wrote:
> On Sunday, January 16, 2011 16:36:34 Hans Verkuil wrote:
> > Hi Mauro,
> > 
> > This fixes a nasty little bug that I just found with v4l2-compliance.
> > 
> > I'm writing lots of compliance tests for control handling at the moment and
> > the results are rather, erm, disheartening to use a polite word :-(
> 
> Added this fix as well:
> 
>       v4l2-ctrls: queryctrl shouldn't attempt to replace V4L2_CID_PRIVATE_BASE IDs

And these three to fix DocBook issues:

      DocBook/v4l: fix validation error in dev-rds.xml
      DocBook/v4l: fix validation errors
      DocBook/v4l: update V4L2 revision and update copyright years.

Those validation errors aren't seen when you build the documentation normally
(make DOCBOOKS=media.xml htmldocs) since the DocBook makefile uses the xmlto
--skip-validation option :-(

But for the daily build I always do a:

xmlto html-nochunks -m <path-to-repo>/Documentation/DocBook/stylesheet.xsl \
	-o Documentation/DocBook/media Documentation/DocBook/media.xml

which creates a one-page media.html in Documentation/DocBook/media. That's the
version I upload every day since I like this nochunks version much better than
having to click through a zillion links.

And since I don't use the skip-validation option I see these errors.

Regards,

	Hans

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit a9ac9ac36d6b199074f9545b25154fa4771ed3f4:
> >   Hans Verkuil (1):
> >         [media] v4l2-ctrls: v4l2_ctrl_handler_setup must set is_new to 1
> > 
> > are available in the git repository at:
> > 
> >   ssh://linuxtv.org/git/hverkuil/media_tree.git ctrl-fix
> > 
> > Hans Verkuil (1):
> >       v4l2-ctrls: fix missing 'read-only' check
> > 
> >  drivers/media/video/v4l2-ctrls.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
