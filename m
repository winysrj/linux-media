Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33168 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752458AbcHWGBk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 02:01:40 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so16525184wme.0
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 23:01:40 -0700 (PDT)
Date: Tue, 23 Aug 2016 08:01:35 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, markus.heiser@darmarit.de,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
Message-ID: <20160823060135.GJ24290@phenom.ffwll.local>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
 <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org>
 <20160822124930.02dbbafc@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160822124930.02dbbafc@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 22, 2016 at 12:49:30PM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 22 Aug 2016 20:41:45 +0530
> Sumit Semwal <sumit.semwal@linaro.org> escreveu:
> 
> > Include dma-buf sphinx documentation into top level index.
> > 
> > Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> > ---
> >  Documentation/index.rst | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/index.rst b/Documentation/index.rst
> > index e0fc72963e87..8d05070122c2 100644
> > --- a/Documentation/index.rst
> > +++ b/Documentation/index.rst
> > @@ -14,6 +14,8 @@ Contents:
> >     :maxdepth: 2
> >  
> >     kernel-documentation
> > +   dma-buf/intro
> > +   dma-buf/guide
> >     media/media_uapi
> >     media/media_kapi
> >     media/dvb-drivers/index
> 
> IMHO, the best would be, instead, to add an index with a toctree
> with both intro and guide, and add dma-buf/index instead.
> 
> We did that for media too (patches not merged upstream yet), together
> with a patchset that will allow building just a subset of the books.

I'm also not too sure about whether dma-buf really should be it's own
subdirectory. It's plucked from the device-drivers.tmpl, I think an
overall device-drivers/ for all the misc subsystems and support code would
be better. Then one toc there, which fans out to either kernel-doc and
overview docs.
-Daniel

> 
> Regards,
> Mauro
> 
> PS.: That's the content of our index.rst file, at
> Documentation/media/index.rst:
> 
> Linux Media Subsystem Documentation
> ===================================
> 
> Contents:
> 
> .. toctree::
>    :maxdepth: 2
> 
>    media_uapi
>    media_kapi
>    dvb-drivers/index
>    v4l-drivers/index
> 
> .. only::  subproject
> 
>    Indices
>    =======
> 
>    * :ref:`genindex`
> 
> 
> Thanks,
> Mauro
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
