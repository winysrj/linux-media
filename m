Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60222 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab2GKEiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 00:38:04 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: RE: [GIT PULL FOR v3.5] davicni: vpfe:media controller based
 capture driver for dm365
Date: Wed, 11 Jul 2012 04:37:54 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E93C45A@DBDE01.ent.ti.com>
References: <E99FAA59F8D8D34D8A118DD37F7C8F753E939B62@DBDE01.ent.ti.com>
 <4FF5C50E.6080109@redhat.com>
In-Reply-To: <4FF5C50E.6080109@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, Jul 05, 2012 at 22:17:10, Mauro Carvalho Chehab wrote:
> Em 04-07-2012 02:01, Hadli, Manjunath escreveu:
> > Mauro,
> > Can you please pull the patches? Let me know if anything needs to be done
> > from my side.
> > 
> > -Manju
> > 
> > 
> > On Thu, May 31, 2012 at 17:42:24, Hadli, Manjunath wrote:
> >> Mauro,
> >>   The following patch set adds the media controller based driver TI dm365 SoC.
> >> Patches have gone through RFC and reviews and are pending for some time.
> >>
> >> The main support added here:
> >> -CCDC capture
> >> -Previewer
> >> -Resizer
> >> -AEW/AF
> >> -Some media formats supported on dm365
> >> -PIX_FORMATs supported on dm365
> >>
> >>
> >> ---
> >> The following changes since commit a01ee165a132fadb57659d26246e340d6ac53265:
> >>
> >>    Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd (2012-05-28 13:10:41 -0700)
> >>
> >> are available in the git repository at:
> >>
> >>    git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git pull_dm365_mc_for_mauro
> >>
> >> Manjunath Hadli (19):
> >>        media: add new mediabus format enums for dm365
> >>        v4l2: add new pixel formats supported on dm365
> >>        davinci: vpfe: add dm3xx IPIPEIF hardware support module
> >>        davinci: vpfe: add IPIPE hardware layer support
> >>        davinci: vpfe: add IPIPE support for media controller driver
> 
> $ grep copy_ `quilt next`|wc -l
> 53
> 
> Wow! There's a lot of undocumented userspace API stuff there! Am I missing something?
> 
  As discussed on IRC, I'll send a documentation patch to the mailing list
  and on acceptance of this patch I'll issue a new pull request along with
  the documentation patch and current patch set.

Thx,
--Manju

> Regards,
> Mauro
> 

