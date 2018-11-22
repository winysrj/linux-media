Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54076 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730540AbeKWJYn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 04:24:43 -0500
Date: Thu, 22 Nov 2018 20:43:05 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.18] v2: Various fixes/improvements
Message-ID: <20181122204305.532d4108@coco.lan>
In-Reply-To: <a0d2f06b-391c-6308-89e6-64865eadf0b6@xs4all.nl>
References: <b9c05ebb-6cb3-d6b3-f2e4-48720f3a05bd@xs4all.nl>
        <20181122185207.3e50acb1@coco.lan>
        <a0d2f06b-391c-6308-89e6-64865eadf0b6@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Thu, 22 Nov 2018 23:26:07 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 11/22/2018 09:52 PM, Mauro Carvalho Chehab wrote:
> > Em Tue, 8 May 2018 12:48:45 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> Fixes/improvements all over the place.
> >>
> >> Changes since v1:
> >>
> >> Replaced "media: media-device: fix ioctl function types" with the v2 version
> >> of that patch. My fault, I missed Sakari's request for a change of v1.  
> > 
> > You should seriously review how you're adding SOBs... there are
> > even some like:
> > 
> > Signed-off-by Hans Verkuil <hans.verkuil>
> > Reported-by: syzbot+69780d144754b8071f4b@syzkaller.appspotmail.com
> > Cc: <stable@vger.kernel.org>      # for v4.20 and up
> > Signed-off-by Hans Verkuil <hansverk@cisco.com>  
> 
> You seem to have replied to a different git pull request (v4.18?!) then
> what these lines above indicate, but it appears that this refers to patch
> "vim2m: use cancel_delayed_work_sync instead of flush_schedule_work".
> 
> It looks like I just completely mistyped the SoB in that patch. Nothing to do
> with the xs4all vs cisco SoBs and AFAICS it is an issue just with that patch.
> 
> Regarding those, the core problem is that I want to show that what I'm doing is
> paid for by Cisco, but I don't want to use the cisco email address to actually
> send patches, pull requests, etc., since that requires a vpn which is really annoying.
> 
> I've made a new email alias hverkuil-cisco@xs4all.nl (I'm not allowed to use a '+'
> unfortunately) and I think I will use that as my git email address to avoid
> cisco.com entirely.

Yeah, I know the drill. I had to do about the same in order to mark
that my work is sponsored by Samsung.

> Regarding the outstanding pull requests with SoB/Author mismatches: should I redo
> those and repost? It's a pain, but if you want it I'll do that tomorrow.

Yes, please.

If it was just to remove a duplicated SoB from another e-mail (or a typo
outside the e-mail part), I would gladly do when merging (probably using git
filter or something scripteable tooling), but I don't feel comfortable to
replace an e-mail address on commits.

Thanks,
Mauro
