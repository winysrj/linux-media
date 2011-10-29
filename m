Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:61011 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab1J2RDp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Oct 2011 13:03:45 -0400
Date: Sat, 29 Oct 2011 20:00:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [RESEND PATCH 4/14] staging/media/as102: checkpatch fixes
Message-ID: <20111029170032.GI14881@longonot.mountain>
References: <20111016105731.09d66f03@stein>
 <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
 <4E9ADFAE.8050208@redhat.com>
 <20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
 <20111018111151.635ac39e.chmooreck@poczta.onet.pl>
 <20111018215146.1fbc223f@darkstar>
 <4EABD3E2.3070302@gmail.com>
 <4EABFCF8.2010003@poczta.onet.pl>
 <4EAC2914.1010508@poczta.onet.pl>
 <4EAC2C5A.4010506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAC2C5A.4010506@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 29, 2011 at 06:39:54PM +0200, Sylwester Nawrocki wrote:
> >> Hi Sylwester,
> >>
> >> I'is based on
> >> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git kernel-3.1.0-git9+
> >>
> >> All patches are working on newly created driver directory drivers/staging/media/as102
> >> (exception is 13/14: staging/Makefile and staging/Kconfig) and they apply cleanly in
> >>  my tree. Let me know why they doesn't on yours and i'll try to fix them.
> > One more thing... patches starting from 4/14 in patchwork have
> > 
> > "To unsubscribe from this list: send the line "unsubscribe linux-media" in..."
> > 
> > on the end.
> > 
> > Isn't this making them wrong ?
> 
> This shouldn't be an issue, I've also used patches saved directly form an e-mail client
> which didn't have this text appended and the patch didn't apply in same way. 

I get this error when I try apply them.

patching file drivers/staging/media/as102/as10x_cmd.c
patch: **** malformed patch at line 696: _______________________________________________

I'm applying with "patch" not with "git am".

regards,
dan carpenter

