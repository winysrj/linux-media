Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46823 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814AbZKKRbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 12:31:06 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Martin Michlmayr <tbm@cyrius.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 11 Nov 2009 23:00:58 +0530
Subject: RE: [PATCH] videobuf-dma-contig.c: add missing #include
Message-ID: <19F8576C6E063C45BE387C64729E73940436F94665@dbde02.ent.ti.com>
References: <20091031102850.GA3850@deprecation.cyrius.com>
 <20091111155329.GA3731@deprecation.cyrius.com>
In-Reply-To: <20091111155329.GA3731@deprecation.cyrius.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Martin Michlmayr
> Sent: Wednesday, November 11, 2009 9:24 PM
> To: linux-media@vger.kernel.org
> Cc: Mauro Carvalho Chehab
> Subject: Re: [PATCH] videobuf-dma-contig.c: add missing #include
> 
> Are there any comments regarding the build fix I submitted?  This
> issue is still there, as you can see at
> http://www.xs4all.nl/~hverkuil/logs/Tuesday.log
> 
[Hiremath, Vaibhav] Tested by me, and it is required, since this is breaking the build. Should get merged.

Thanks,
Vaibhav

> * Martin Michlmayr <tbm@cyrius.com> [2009-10-31 10:28]:
> > media/video/videobuf-dma-contig.c fails to compile on ARM
> Versatile
> > like this:
> >  | videobuf-dma-contig.c: In function
> 'videobuf_dma_contig_user_get':
> >  | videobuf-dma-contig.c:139: error: dereferencing pointer to
> incomplete type
> >  | videobuf-dma-contig.c:184: error: dereferencing pointer to
> incomplete type
> >  | make[8]: *** [drivers/media/video/videobuf-dma-contig.o] Error
> 1
> >
> > Looking at the preprocessed source, I noticed that there was no
> definition
> > for struct task_struct.
> >
> > Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
> >
> > --- a/drivers/media/video/videobuf-dma-contig.c	2009-10-31
> 10:22:42.000000000 +0000
> > +++ b/drivers/media/video/videobuf-dma-contig.c	2009-10-31
> 10:24:40.000000000 +0000
> > @@ -19,6 +19,7 @@
> >  #include <linux/mm.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/dma-mapping.h>
> > +#include <linux/sched.h>
> >  #include <media/videobuf-dma-contig.h>
> >
> >  struct videobuf_dma_contig_memory {
> >
> > --
> > Martin Michlmayr
> > http://www.cyrius.com/
> 
> --
> Martin Michlmayr
> http://www.cyrius.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

