Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34904 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbeCZPQ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 11:16:59 -0400
Received: by mail-wm0-f44.google.com with SMTP id r82so16295713wme.0
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2018 08:16:58 -0700 (PDT)
Date: Mon, 26 Mar 2018 17:16:54 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: christian.koenig@amd.com
Cc: Daniel Vetter <daniel@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, sumit.semwal@linaro.org
Subject: Re: [PATCH] dma-buf: use parameter structure for dma_buf_attach
Message-ID: <20180326151654.GV14155@phenom.ffwll.local>
References: <20180325113451.2425-1-christian.koenig@amd.com>
 <20180326083638.GS14155@phenom.ffwll.local>
 <0242b504-87cd-2c80-ad86-868622c3c681@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0242b504-87cd-2c80-ad86-868622c3c681@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 26, 2018 at 12:47:01PM +0200, Christian König wrote:
> Am 26.03.2018 um 10:36 schrieb Daniel Vetter:
> > On Sun, Mar 25, 2018 at 01:34:51PM +0200, Christian König wrote:
> [SNIP]
> > > -	attach->dev = dev;
> > > +	attach->dev = info->dev;
> > >   	attach->dmabuf = dmabuf;
> > > +	attach->priv = info->priv;
> > The ->priv field is for the exporter, not the importer. See e.g.
> > drm_gem_map_attach. You can't let the importer set this now too, so needs
> > to be removed from the info struct.
> 
> Crap, in this case I need to add an importer_priv field because we now need
> to map from the attachment to it's importer object as well.
> 
> Thanks for noticing this.

Maybe add the importer_priv field only in the series that actually adds
it, not in this prep patch. You can mention all the fields you need here
in the commit message for justification.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
