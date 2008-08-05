Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m75FhPJ2006775
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 11:43:32 -0400
Received: from smtp6.pp.htv.fi (smtp6.pp.htv.fi [213.243.153.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m75FgjQs000588
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 11:42:51 -0400
Date: Tue, 5 Aug 2008 18:41:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <20080805154122.GC22895@cs181140183.pp.htv.fi>
References: <20080806012357.55625daf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080806012357.55625daf.sfr@canb.auug.org.au>
Cc: linux-mips@linux-mips.org, video4linux-list@redhat.com,
	LKML <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	v4l-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: v4l/mips build problem
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

On Wed, Aug 06, 2008 at 01:23:57AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Linus' current tree gets the following error during a mips allmodconfig
> build:
> 
> drivers/media/video/vino.c:4364: error: implicit declaration of function `video_usercopy'

Andrew fixed it with drivers-media-video-vinoc-needs-v4l2-ioctlh.patch 
in -mm.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
