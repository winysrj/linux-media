Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MEaJAs023533
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 10:36:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MEa4Bc018520
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 10:36:05 -0400
Date: Tue, 22 Apr 2008 11:35:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20080422113539.0b3002f9@gaivota>
In-Reply-To: <20080422062938.0e491c0c.akpm@linux-foundation.org>
References: <20080421081639.GE26724@vidsoft.de>
	<20080421223751.GD9073@plankton.ifup.org>
	<1208822912.10519.24.camel@pc10.localdom.local>
	<20080422062938.0e491c0c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	stable@kernel.org
Subject: Re: 2.6.25 regression: vivi - scheduling while atomic
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

> > > > This happenes on a vanilla 2.6.25 with loaded nvidia graphics module.
> > > > System architecture is x86_64. If it matters I'll try to reproduce this
> > > > error on a non tainted kernel.
> > > 
> > > No need to reproduce on a non-tainted Kernel.  This is a known issue
> > > with patches merged into the v4l-dvb tree several weeks ago but it seems
> > > to not have made it into 2.6.25 :(
> > > 
> > >  http://linuxtv.org/hg/v4l-dvb/rev/06eb92ed0b18
> > >  http://linuxtv.org/hg/v4l-dvb/rev/c50180f4ddfc
> > > 
> > > I can rebase the patches for 2.6.25 but they are too big to go into the
> > > stable 2.6.25 tree...

Unfortunately, the tests for the patches fixing several videobuf issues
finished later on -rc9, when Linus were releasing 2.6.25. 

I should send the videobuf patches to Linus tree, together with other patches,
probably today. After that, I think we should backport the fixes for 2.6.25,
and test it again, with vanilla 2.6.25.

The issue here is that videobuf suffered several changes on this development
cycle. Probably, only a few of those patches are needed to fix the issue. So,
we need to handle this with care, to avoid the risk of damaging other drivers that
relies on videobuf.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
