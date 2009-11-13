Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3377 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbZKMHVO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 02:21:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Subject: Re: V4L/DVB (12859): go7007: semaphore -> mutex conversion
Date: Fri, 13 Nov 2009 08:21:13 +0100
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg KH <gregkh@suse.de>, Ross Cohen <rcohen@snurgle.org>,
	linux-media@vger.kernel.org
References: <200909211659.n8LGxVXZ000601@hera.kernel.org> <200911130101.29882.s.L-H@gmx.de>
In-Reply-To: <200911130101.29882.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911130821.13559.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 13 November 2009 01:01:27 Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Friday 13 November 2009, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/linus/fd9a40da1db372833e1af6397d2f6c94ceff3dad
> > Commit:     fd9a40da1db372833e1af6397d2f6c94ceff3dad
> > Parent:     028d4c989ab9e839471739332d185f8f158b0043
> > Author:     Mauro Carvalho Chehab <mchehab@redhat.com>
> > AuthorDate: Tue Sep 15 11:07:59 2009 -0300
> > Committer:  Mauro Carvalho Chehab <mchehab@redhat.com>
> > CommitDate: Sat Sep 19 00:13:37 2009 -0300
> > 
> >     V4L/DVB (12859): go7007: semaphore -> mutex conversion
> >     
> >     Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> As already noticed by Pascal Terjan <pterjan@gmail.com>
> 	http://lkml.indiana.edu/hypermail/linux/kernel/0909.3/00062.html
> go7007 currently fails to build in 2.6.32-rc6-git5
> 
>   LD      drivers/staging/go7007/built-in.o                                                      
>   CC [M]  drivers/staging/go7007/go7007-v4l2.o                                                   
>   CC [M]  drivers/staging/go7007/go7007-driver.o                                                 
>   CC [M]  drivers/staging/go7007/go7007-i2c.o                                                    
>   CC [M]  drivers/staging/go7007/go7007-fw.o                                                     
>   CC [M]  drivers/staging/go7007/snd-go7007.o                                                    
>   CC [M]  drivers/staging/go7007/s2250-board.o                                                   
> drivers/staging/go7007/s2250-board.c:24:26: error: s2250-loader.h: No such file or directory     
> drivers/staging/go7007/s2250-board.c: In function 'read_reg_fp':                                 
> drivers/staging/go7007/s2250-board.c:264: warning: passing argument 1 of 'down_interruptible' from incompatible pointer type                                                                      
> drivers/staging/go7007/s2250-board.c:273: warning: passing argument 1 of 'up' from incompatible pointer type                                                                                      
> drivers/staging/go7007/s2250-board.c: In function 's2250_init':                                  
> drivers/staging/go7007/s2250-board.c:670: error: implicit declaration of function 's2250loader_init'                                                                                              
> drivers/staging/go7007/s2250-board.c:676: error: implicit declaration of function 's2250loader_cleanup'                                                                                           
> make[6]: *** [drivers/staging/go7007/s2250-board.o] Error 1                                      
> make[5]: *** [drivers/staging/go7007] Error 2                                                    
> make[4]: *** [drivers/staging] Error 2                                                           
> make[3]: *** [drivers] Error 2        
> 
> >  drivers/staging/go7007/go7007-driver.c |   12 +++---
> >  drivers/staging/go7007/go7007-i2c.c    |   12 +++---
> >  drivers/staging/go7007/go7007-priv.h   |    6 +-
> >  drivers/staging/go7007/go7007-usb.c    |   10 ++--
> >  drivers/staging/go7007/go7007-v4l2.c   |   66 ++++++++++++++++----------------
> >  drivers/staging/go7007/go7007.txt      |    4 +-
> >  drivers/staging/go7007/s2250-board.c   |   18 ++++-----
> >  drivers/staging/go7007/s2250-loader.c  |    8 ++--
> >  drivers/staging/go7007/snd-go7007.c    |    2 +-
> >  9 files changed, 68 insertions(+), 70 deletions(-)
> 
> [...]
> > diff --git a/drivers/staging/go7007/s2250-board.c b/drivers/staging/go7007/s2250-board.c
> > index b398db4..f35f077 100644
> > --- a/drivers/staging/go7007/s2250-board.c
> > +++ b/drivers/staging/go7007/s2250-board.c
> > @@ -21,12 +21,10 @@
> >  #include <linux/i2c.h>
> >  #include <linux/videodev2.h>
> >  #include <media/v4l2-common.h>
> > +#include "s2250-loader.h"
> 
> s2250-loader.h is neither available in 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> nor
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> although it seems to have been included in Hans' initial pull request 
> 	http://www.mail-archive.com/linux-media@vger.kernel.org/msg09506.html
> 
> >  #include "go7007-priv.h"
> >  #include "wis-i2c.h"
> >  
> > -extern int s2250loader_init(void);
> > -extern void s2250loader_cleanup(void);
> > -
> >  #define TLV320_ADDRESS      0x34
> >  #define VPX322_ADDR_ANALOGCONTROL1	0x02
> >  #define VPX322_ADDR_BRIGHTNESS0		0x0127
> [...]
> 
> This is a regression since 2.6.31.
> 
> Regards
> 	Stefan Lippers-Hollmann
> 

Thanks for reporting this. I have already received patches and will review
and queue them this weekend. I wasn't aware that 2.6.32 was also broken,
so this will be a high-prio item for me.

We should catch these things with the daily build process that we have, but
the daily build is effectively broken at the moment. I hope to address that
this weekend as well to get that back on track. I've been just too busy the
last two months to give it the attention it needs :-(

This is the second compilation error that was introduced in 2.6.32. I found
another one in the davinci drivers. This is really bad...

Fellow v4l-dvb developers: please don't let me be the only one who pays
attention to the daily build report! Just the fact that it is running on
my computer doesn't mean that I have to be the one to fix issues!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
