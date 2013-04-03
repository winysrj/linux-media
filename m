Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760050Ab3DCLMA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Apr 2013 07:12:00 -0400
Date: Wed, 3 Apr 2013 08:11:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Patch update notification: 6 patches updated
Message-ID: <20130403081154.30b17878@redhat.com>
In-Reply-To: <CA+V-a8syAyjYtNSSVzunvgt+hFSXpY+L77htTt4egp0wt2GDPA@mail.gmail.com>
References: <20130403103301.9548.49850@www.linuxtv.org>
	<CA+V-a8syAyjYtNSSVzunvgt+hFSXpY+L77htTt4egp0wt2GDPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Em Wed, 3 Apr 2013 16:12:09 +0530
Prabhakar Lad <prabhakar.csengg@gmail.com> escreveu:

> Hi Mauro,

We're starting to work this week with media sub-mainainers. It will
take some time for all sub-maintainers to work the same way. In the
specific case of those patches, Hans is the sub-maintainer that will be
taking care of them.

I'll ask him to double check the status of the patches below.

Thanks,
Mauro

> On Wed, Apr 3, 2013 at 4:03 PM, Patchwork <patchwork@linuxtv.org> wrote:
> > Hello,
> >
> > The following patches (submitted by you) have been updated in patchwork:
> >
> >  * [v3] davinci: vpif: add pm_runtime support
> >      - http://patchwork.linuxtv.org/patch/17737/
> >     was: New
> >     now: Not Applicable
> >
> >  * [v2,3/3] davinic: vpss: trivial cleanup
> >      - http://patchwork.linuxtv.org/patch/17733/
> >     was: New
> >     now: Not Applicable
> >
> >  * [v2,2/3] media: davinci: vpbe: venc: move the enabling of vpss clocks to driver
> >      - http://patchwork.linuxtv.org/patch/17731/
> >     was: New
> >     now: Not Applicable
> >
> >  * davinci: vpif: add pm_runtime support
> >      - http://patchwork.linuxtv.org/patch/17692/
> >     was: Under Review
> >     now: Not Applicable
> >
> This should 'suppressed'
> 
> >  * [v2,1/3] media: davinci: vpss: enable vpss clocks
> >      - http://patchwork.linuxtv.org/patch/17732/
> >     was: New
> >     now: Not Applicable
> >
> >  * [v2] davinci: vpif: add pm_runtime support
> >      - http://patchwork.linuxtv.org/patch/17719/
> >     was: New
> >     now: Not Applicable
> >
> This should 'suppressed' .
> 
> And the rest of the patches are intended  to go via  media-tree.git.
> 
> Regards,
> --Prabhakar
> 
> > This email is a notification only - you do not need to respond.
> >
> > -
> >
> > Patches submitted to linux-media@vger.kernel.org have the following
> > possible states:
> >
> > New: Patches not yet reviewed (typically new patches);
> >
> > Under review: When it is expected that someone is reviewing it (typically,
> >               the driver's author or maintainer). Unfortunately, patchwork
> >               doesn't have a field to indicate who is the driver maintainer.
> >               If in doubt about who is the driver maintainer please check the
> >               MAINTAINERS file or ask at the ML;
> >
> > Superseded: when the same patch is sent twice, or a new version of the
> >             same patch is sent, and the maintainer identified it, the first
> >             version is marked as such. It is also used when a patch was
> >             superseeded by a git pull request.
> >
> > Obsoleted: patch doesn't apply anymore, because the modified code doesn't
> >            exist anymore.
> >
> > Changes requested: when someone requests changes at the patch;
> >
> > Rejected: When the patch is wrong or doesn't apply. Most of the
> >           time, 'rejected' and 'changes requested' means the same thing
> >           for the developer: he'll need to re-work on the patch.
> >
> > RFC: patches marked as such and other patches that are also RFC, but the
> >      patch author was not nice enough to mark them as such. That includes:
> >         - patches sent by a driver's maintainer who send patches
> >           via git pull requests;
> >         - patches with a very active community (typically from developers
> >           working with embedded devices), where lots of versions are
> >           needed for the driver maintainer and/or the community to be
> >           happy with.
> >
> > Not Applicable: for patches that aren't meant to be applicable via
> >                 the media-tree.git.
> >
> > Accepted: when some driver maintainer says that the patch will be applied
> >           via his tree, or when everything is ok and it got applied
> >           either at the main tree or via some other tree (fixes tree;
> >           some other maintainer's tree - when it belongs to other subsystems,
> >           etc);
> >
> > If you think any status change is a mistake, please send an email to the ML.
> >
> > -
> >
> > This is an automated mail sent by the patchwork system at
> > patchwork.linuxtv.org. To stop receiving these notifications, edit
> > your mail settings at:
> >   http://patchwork.linuxtv.org/mail/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
