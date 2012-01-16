Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56660 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab2APMpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 07:45:20 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [GIT PULL] davinci vpif pull request
Date: Mon, 16 Jan 2012 12:45:05 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F7531741938@DBDE01.ent.ti.com>
References: <E99FAA59F8D8D34D8A118DD37F7C8F7501B481@DBDE01.ent.ti.com>
 <4F14108F.5050505@redhat.com>
In-Reply-To: <4F14108F.5050505@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
On Mon, Jan 16, 2012 at 17:27:03, Mauro Carvalho Chehab wrote:
> Em 11-01-2012 09:39, Hadli, Manjunath escreveu:
> > Hi Mauro,
> >   Can you please pull the following patch which removes some unnecessary inclusion
> >   of machine specific header files from the main driver files?
> >  
> >   This patch has undergone sufficient review already. It is just a cleanup patch and I don't
> >   expect any functionality to break because of this. The reason I did not club this with the
> >   3 previous patches was because one of the previous patches on which this is dependent,
> >   is now pulled in by Arnd.
> > 
> >  Thanks and Regards,
> > -Manju
> > 
> >  
> > The following changes since commit e343a895a9f342f239c5e3c5ffc6c0b1707e6244:
> >   Linus Torvalds (1):
> >         Merge tag 'for-linus' of git://git.kernel.org/.../mst/vhost
> > 
> > are available in the git repository at:
> > 
> >   git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git for-mauro-v3.3
> > 
> > Manjunath Hadli (1):
> >       davinci: vpif: remove machine specific header file inclusion 
> > from the driver
> 
> This patch is outdated and doesn't apply anymore. Could you please rebase it over my tree, branch "staging/for_v3.3"?
This patch needs a recent accepted commit by Arnd which is available on
http://git.linuxtv.org/linux-2.6.git but not on staging.
Are you planning to rebase you staging tree to latest? When you do that this 
Patch will apply. Please let me know if there is any other way you want me to do?

Regards,
-Manju
> 
> Thanks!
> Mauro
> 
> > 
> >  drivers/media/video/davinci/vpif.h         |    2 --
> >  drivers/media/video/davinci/vpif_display.c |    2 --
> >  include/media/davinci/vpif_types.h         |    2 ++
> >  3 files changed, 2 insertions(+), 4 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" 
> > in the body of a message to majordomo@vger.kernel.org More majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> 

