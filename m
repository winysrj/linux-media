Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58769 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab2AQGgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 01:36:33 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [GIT PULL] davinci vpif pull request
Date: Tue, 17 Jan 2012 06:36:19 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F7531742407@DBDE01.ent.ti.com>
References: <E99FAA59F8D8D34D8A118DD37F7C8F7501B481@DBDE01.ent.ti.com>
 <4F14108F.5050505@redhat.com>
 <E99FAA59F8D8D34D8A118DD37F7C8F7531741938@DBDE01.ent.ti.com>
 <4F141E79.1040800@redhat.com>
 <E99FAA59F8D8D34D8A118DD37F7C8F7531742182@DBDE01.ent.ti.com>
 <4F14234C.5000404@redhat.com>
In-Reply-To: <4F14234C.5000404@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
On Mon, Jan 16, 2012 at 18:47:00, Mauro Carvalho Chehab wrote:
> Em 16-01-2012 11:06, Hadli, Manjunath escreveu:
> > Mauro,
> > On Mon, Jan 16, 2012 at 18:26:25, Mauro Carvalho Chehab wrote:
> >> Em 16-01-2012 10:45, Hadli, Manjunath escreveu:
> >>> Mauro,
> >>> On Mon, Jan 16, 2012 at 17:27:03, Mauro Carvalho Chehab wrote:
> >>>> Em 11-01-2012 09:39, Hadli, Manjunath escreveu:
> >>>>> Hi Mauro,
> >>>>>   Can you please pull the following patch which removes some unnecessary inclusion
> >>>>>   of machine specific header files from the main driver files?
> >>>>>  
> >>>>>   This patch has undergone sufficient review already. It is just a cleanup patch and I don't
> >>>>>   expect any functionality to break because of this. The reason I did not club this with the
> >>>>>   3 previous patches was because one of the previous patches on which this is dependent,
> >>>>>   is now pulled in by Arnd.
> >>>>>
> >>>>>  Thanks and Regards,
> >>>>> -Manju
> >>>>>
> >>>>>  
> >>>>> The following changes since commit e343a895a9f342f239c5e3c5ffc6c0b1707e6244:
> >>>>>   Linus Torvalds (1):
> >>>>>         Merge tag 'for-linus' of 
> >>>>> git://git.kernel.org/.../mst/vhost
> >>>>>
> >>>>> are available in the git repository at:
> >>>>>
> >>>>>   git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git
> >>>>> for-mauro-v3.3
> >>>>>
> >>>>> Manjunath Hadli (1):
> >>>>>       davinci: vpif: remove machine specific header file inclusion 
> >>>>> from the driver
> >>>>
> >>>> This patch is outdated and doesn't apply anymore. Could you please rebase it over my tree, branch "staging/for_v3.3"?
> >>> This patch needs a recent accepted commit by Arnd which is available 
> >>> on http://git.linuxtv.org/linux-2.6.git but not on staging.
> >>
> >> This tree is just a daily-updated copy of Linus one. It is mirrored there just to minimize the object copies at the other local trees.
> >>
> >>> Are you planning to rebase you staging tree to latest? When you do 
> >>> that this Patch will apply. Please let me know if there is any other way you want me to do?
> >>
> >> Linus doesn't like when someone merge from a random place at his tree.
> >> I'll merge from his tree at -rc1, but I'm not intending to merge it earlier than that, except if there are some strong reasons for that.
> > Indeed, there are quite a few patches waiting to be pulled which are 
> > dependent on this patch. I would urge you to pull this as early as possible.
> 
> Are those features target for 3.4? It is late for adding new features for 3.3.
> 
> If they aren't for 3.3, merging at 3.3-rc1 should be ok for your needs.
  They are intended for 3.4. Merging at v3.3-rc1 is OK.

Regards,
-Manju

> Otherwise, you need to point me the exact patch at Linus tree you need me to pull, and properly justify the need for this patch, and submit it together with the other ones you're needing for 3.3.
> > 
> > Rgds,
> > -Manju
> >>
> >> Anyway, if you prefer to send this patch through Arnd's tree, feel free to add my acked-by: on that:
> >>
> >> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>>
> >>> Regards,
> >>> -Manju
> >>>>
> >>>> Thanks!
> >>>> Mauro
> >>>>
> >>>>>
> >>>>>  drivers/media/video/davinci/vpif.h         |    2 --
> >>>>>  drivers/media/video/davinci/vpif_display.c |    2 --
> >>>>>  include/media/davinci/vpif_types.h         |    2 ++
> >>>>>  3 files changed, 2 insertions(+), 4 deletions(-)
> >>>>> --
> >>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> >>>>> in the body of a message to majordomo@vger.kernel.org More 
> >>>>> majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>>
> >>>>
> >>>
> >>
> >>
> > 
> 
> 

