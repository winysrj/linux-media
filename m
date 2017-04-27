Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33406 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937220AbdD0V1w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 17:27:52 -0400
Received: by mail-qk0-f196.google.com with SMTP id o85so6568754qkh.0
        for <linux-media@vger.kernel.org>; Thu, 27 Apr 2017 14:27:52 -0700 (PDT)
Date: Thu, 27 Apr 2017 18:27:48 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>
Cc: Andres Rodriguez <andresx7@gmail.com>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: avoid scheduling on fence status query v2
Message-ID: <20170427212748.GD2568@joana>
References: <20170426144620.3560-1-andresx7@gmail.com>
 <92c9bc96-cf60-f246-a82e-47653472521e@vodafone.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <92c9bc96-cf60-f246-a82e-47653472521e@vodafone.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-04-26 Christian König <deathsimple@vodafone.de>:

> Am 26.04.2017 um 16:46 schrieb Andres Rodriguez:
> > When a timeout of zero is specified, the caller is only interested in
> > the fence status.
> > 
> > In the current implementation, dma_fence_default_wait will always call
> > schedule_timeout() at least once for an unsignaled fence. This adds a
> > significant overhead to a fence status query.
> > 
> > Avoid this overhead by returning early if a zero timeout is specified.
> > 
> > v2: move early return after enable_signaling
> > 
> > Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> 
> Reviewed-by: Christian König <christian.koenig@amd.com>

pushed to drm-misc-next. Thanks all.

Gustavo
