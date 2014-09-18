Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36562 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbaIRMtP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 08:49:15 -0400
Date: Thu, 18 Sep 2014 09:49:09 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH v2] [media] BZ#84401: Revert "[media] v4l: vb2: Don't
 return POLLERR during transient buffer underruns"
Message-ID: <20140918094909.5147bd1e@recife.lan>
In-Reply-To: <541ACE4E.1040308@cisco.com>
References: <1410826255-2025-1-git-send-email-m.chehab@samsung.com>
	<20140918070619.32d4e4b1@recife.lan>
	<541AAFA6.6080605@cisco.com>
	<20140918075005.11bd495f@recife.lan>
	<541ACAF9.4030204@cisco.com>
	<20140918091516.42dc6bb3@recife.lan>
	<541ACE4E.1040308@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 Sep 2014 14:21:34 +0200
Hans Verkuil <hansverk@cisco.com> escreveu:

> 
> 
> On 09/18/14 14:15, Mauro Carvalho Chehab wrote:
> > Em Thu, 18 Sep 2014 14:07:21 +0200
> > Hans Verkuil <hansverk@cisco.com> escreveu:
> > 
> >> My patch is the *only* fix for that since that's the one that addresses
> >> the real issue.
> >>
> >> One option is to merge my fix for 3.18 with a CC to stable for 3.16.
> >>
> >> That way it will be in the tree for longer.
> >>
> >> Again, the revert that you did won't solve the regression at all. Please
> >> revert the revert.
> > 
> > Well, some patch that went between 3.15 and 3.16 broke VBI. If it was
> > not this patch, what's the patch that broke it?
> 
> The conversion of saa7134 to vb2 in 3.16 broke the VBI support in saa7134.
> 
> It turns out that vb2 NEVER did this right.
> 
> Remember that saa7134 was only the second driver with VBI support (after
> em28xx) that was converted to vb2, and that this issue only happens with
> teletext applications that do not call STREAMON before calling poll().
> 
> They rely on the fact that poll returns POLLERR to call STREAMON. Ugly
> as hell, and not normal behavior for applications.
> 
> So that explains why it was never found before.

I don't doubt that your fix solved this specific VBI issue.

What I don't know is what else it broke (if any). If you take a look
at the videobuf-core, the check for an empty queue that you've removed
is also there. So, the special handling if the list is empty is at kernel
for a long time:

7a7d9a89d0307 drivers/media/video/videobuf-core.c     (Mauro Carvalho Chehab 2007-08-23 16:26:14 -0300 1125)    if (q->streaming) {
7a7d9a89d0307 drivers/media/video/videobuf-core.c     (Mauro Carvalho Chehab 2007-08-23 16:26:14 -0300 1126)            if (!list_empty(&q->stream))

This changeset was merged on v2.6.24. Before that, the videobuf1
monolithic code were also using it. So, I won't doubt that this check
is there since the start of V4L2 API.

Changing the syscall behavior of such an old code is really risky
and can bring all sorts of unpredictable results.

I won't apply any change like that without a comprehensive test,
checking every single application to be at least 99.999% sure that
it won't cause even more regressions.

So, until we proof that nothing bad happens, and keep this code
for test for a reasonable amount of time, I'm nacking your VB2 
change patch.

We need to find a solution that will make VB2 to act just like
VB1 with regards to poll() syscall, and not to redefine the
V4L2 API and apply a partial half-baked, not mature hack on it.

> Note that em28xx (converted to vb2 quite some time before) fails as well.
> So this regression has been there since 3.9 (when em28xx was converted).
> I tested my fix with em28xx as well and that will worked fine.
> 
> Regards,
> 
> 	Hans
