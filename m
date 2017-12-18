Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36059 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965441AbdLRRU3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 12:20:29 -0500
Date: Mon, 18 Dec 2017 15:20:05 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 19/24] media: vb2-core: Improve kernel-doc markups
Message-ID: <20171218152005.6241e72a@vento.lan>
In-Reply-To: <20171010133234.ax3ra6qfvj6cemui@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
        <acc10ada9169725a9136f9c039fe68cb0f355131.1507544011.git.mchehab@s-opensource.com>
        <20171010133234.ax3ra6qfvj6cemui@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Oct 2017 16:32:34 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Mon, Oct 09, 2017 at 07:19:25AM -0300, Mauro Carvalho Chehab wrote:
> > There are several issues on the current markups:
> > - lack of cross-references;
> > - wrong cross-references;
> > - lack of a period of the end of several phrases;
> > - Some descriptions can be enhanced.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  include/media/videobuf2-core.h | 376 ++++++++++++++++++++++-------------------
> >  1 file changed, 204 insertions(+), 172 deletions(-)
> > 
> > diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> > index 0308d8439049..e145f1475ffe 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h  
> 
> ...
> 
> >  /**
> >   * vb2_core_queue_init() - initialize a videobuf2 queue
> > - * @q:		videobuf2 queue; this structure should be allocated in driver
> > + * @q:		pointer to &struct vb2_queue with videobuf2 queue.
> > + *		This structure should be allocated in driver
> >   *
> >   * The &vb2_queue structure should be allocated by the driver. The driver is
> >   * responsible of clearing it's content and setting initial values for some
> >   * required entries before calling this function.
> > - * q->ops, q->mem_ops, q->type and q->io_modes are mandatory. Please refer
> > - * to the struct vb2_queue description in include/media/videobuf2-core.h
> > - * for more information.
> > + *
> > + * .. note::
> > + *
> > + *    The following fields at @q should be set before calling this function:  
> 
> should -> shall
> 
> I bet there's a lot of that in the documentation elsewhere, including this
> patch.

Yes, there are, and not only on this file (where it uses should
everywhere).

I prefer to do such change globally.

For now, I'll apply this patch as-is.

Thanks,
Mauro
