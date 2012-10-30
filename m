Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab2J3ODJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 10:03:09 -0400
Date: Tue, 30 Oct 2012 12:03:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
Message-ID: <20121030120300.2b316451@redhat.com>
In-Reply-To: <CAGoCfiw+G2CnGJSum2k9M80XizKSTfw34gXZOkOZBp_OvSTtjQ@mail.gmail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
	<20121028175752.447c39d5@redhat.com>
	<508EA1B8.3070304@googlemail.com>
	<20121029180348.7e7967aa@redhat.com>
	<508EF1CF.8090602@googlemail.com>
	<20121030010012.30e1d2de@redhat.com>
	<20121030020619.6e854f70@redhat.com>
	<CAGoCfiw+G2CnGJSum2k9M80XizKSTfw34gXZOkOZBp_OvSTtjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 30 Oct 2012 09:08:15 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Tue, Oct 30, 2012 at 12:06 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Did a git bisect. The last patch where the bug doesn't occur is this
> > changeset:
> >         em28xx: add module parameter for selection of the preferred USB transfer type
> >
> > That means that this changeset broke it:
> >
> >         em28xx: use common urb data copying function for vbi and non-vbi devices
> 
> Oh good, when I saw the subject line for that patch, I got worried.
> Looking at the patch, it seems like he just calls the VBI version for
> both cases assuming the VBI version is a complete superset of the
> non-VBI version, which it is clearly not.
> 
> That whole patch should just be reverted. 

I didn't apply Frank's patch yet. So, no need to revert ;) Also, the test
is still incomplete, as I didn't check if the existing webcam support is
still working. I also didn't review each individual changes (although,
on a quick glance, except for those two final patches, nothing bad popped-up). 

I'll likely finish testing and will review it only after my return
back from ELCE.

> If he's going to spend the
> time to refactor the code to allow the VBI version to be used for both
> then fine, but blindly calling the VBI version without making real
> code changes is *NOT* going to work.

Yes.

> Frank, good job in naming your patch - it made me scream "WAIT!" when
> I saw it.  Bad job for blindly submitting a code change without any
> idea whether it actually worked.  ;-)
> 
> I know developers have the tendency to look at code and say "oh,
> that's ugly, I should change that."  However it's more important that
> it actually work than it be pretty.
> 
> Devin
> 


-- 
Regards,
Mauro
