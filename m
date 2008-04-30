Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3U027Mt001630
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 20:02:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3U01m2d019222
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 20:01:53 -0400
Date: Tue, 29 Apr 2008 21:00:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Message-ID: <20080429210003.14f6c9c7@gaivota>
In-Reply-To: <37219a840804291649q36638464ye2d57cf8184580a4@mail.gmail.com>
References: <20080429185009.716c3284@gaivota>
	<37219a840804291649q36638464ye2d57cf8184580a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates and fixes
 for 2.6.26
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, 29 Apr 2008 19:49:24 -0400
"Michael Krufky" <mkrufky@linuxtv.org> wrote:

> On Tue, Apr 29, 2008 at 5:50 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > Linus,
> >
> >  Please pull from:
> >         ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git master
> >
> >  For the following:
> >
> >    - Fixes on mtm001, mtv022, pvrusb2, ivtv, cx88 and saa7134;
> >    - new board additions on saa7134 and ivtv;
> >    - load tuners only when needed;
> >    - reorganization of tuner drivers that are shared between DVB and V4L;
> >    - Addition of a new driver for Conexant CX23418 MPEG encoder chip (cx18).
> 
> [snip]
> 
> >  Mauro Carvalho Chehab (9):
> >       Rename common tuner Kconfig names to use the same
> >
> >  Michael Krufky (4):
> >       V4L/DVB (7789): tuner: remove static dependencies on analog tuner sub-modules
> 
> 
> Linus has already merged the changes (thank you, Linus) ... However,
> there is a bug.
> 
> My "remove static dependencies on analog tuner sub-modules" patch was
> applied after Mauro's "Rename common tuner Kconfig names to use the
> same" patch.
> 
> My patch has conditional behavior, based on CONFIG_DVB_CORE_ATTACH,
> which was renamed to CONFIG_MEDIA_ATTACH in Mauro's patch.
> 
> To fix this, we need to do:
> 
> sed -i s/"CONFIG_DVB_CORE_ATTACH"/"CONFIG_MEDIA_ATTACH"/1
> drivers/media/video/tuner-core.c
> 
> The issue will cause invalid module use counts upon unloading analog
> tuner modules, if CONFIG_MEDIA_ATTACH is enabled.
> 
> I would be happy to fix this myself, but Mauro's patch has not yet
> been backported into the linuxtv.org repository.
> 
> Mauro, can you do the above fix and send it in to Linus?

Sure. Merge conflicts... bah...

I'll also double check if there aren't also other conflicts. It is just a
matter or run the sed script again ;)


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
