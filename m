Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:51504 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbeEBHic (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2018 03:38:32 -0400
Received: by mail-wm0-f46.google.com with SMTP id j4so21041033wme.1
        for <linux-media@vger.kernel.org>; Wed, 02 May 2018 00:38:31 -0700 (PDT)
Date: Wed, 2 May 2018 09:38:27 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Eric Anholt <eric@anholt.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 01/17] dma-fence: Some kerneldoc polish for
 dma-fence.h
Message-ID: <20180502073827.GV12521@phenom.ffwll.local>
References: <20180427061724.28497-1-daniel.vetter@ffwll.ch>
 <20180427061724.28497-2-daniel.vetter@ffwll.ch>
 <877eoozisz.fsf@anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877eoozisz.fsf@anholt.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 30, 2018 at 10:49:00AM -0700, Eric Anholt wrote:
> Daniel Vetter <daniel.vetter@ffwll.ch> writes:
> > +	/**
> > +	 * @fill_driver_data:
> > +	 *
> > +	 * Callback to fill in free-form debug info Returns amount of bytes
> > +	 * filled, or negative error on failure.
> 
> Maybe this "Returns" should be on a new line?  Or at least a '.' in
> between.

Indeed I've missed this, thanks for spotting it. Done both&applied.

Thanks, Daniel

> 
> Other than that,
> 
> Reviewed-by: Eric Anholt <eric@anholt.net>
> 
> Thanks!



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
