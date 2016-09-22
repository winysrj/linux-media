Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932916AbcIVG51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 02:57:27 -0400
Date: Thu, 22 Sep 2016 08:57:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Baoyou Xie <baoyou.xie@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, xie.baoyou@zte.com.cn,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dma-buf/sw_sync: mark sync_timeline_create() static
Message-ID: <20160922065731.GA16298@kroah.com>
References: <1474202961-10099-1-git-send-email-baoyou.xie@linaro.org>
 <20160920111338.GE13275@joana>
 <CAO_48GFTkpvKLZghbOtNu=CUB61tZx0q6uC1JPVRMB1rPiSPqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GFTkpvKLZghbOtNu=CUB61tZx0q6uC1JPVRMB1rPiSPqA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 20, 2016 at 06:23:33PM +0530, Sumit Semwal wrote:
> Hi Baoyou,
> 
> On 20 September 2016 at 16:43, Gustavo Padovan <gustavo@padovan.org> wrote:
> > 2016-09-18 Baoyou Xie <baoyou.xie@linaro.org>:
> >
> >> We get 1 warning when building kernel with W=1:
> >> drivers/dma-buf/sw_sync.c:87:23: warning: no previous prototype for 'sync_timeline_create' [-Wmissing-prototypes]
> >>
> >> In fact, this function is only used in the file in which it is
> >> declared and don't need a declaration, but can be made static.
> >> So this patch marks it 'static'.
> >>
> >> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> >> ---
> >>  drivers/dma-buf/sw_sync.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Thanks for finding this.
> 
> Thanks for the patch; this doesn't apply to mainline yet, since the
> de-staging of sw_sync code is queued for 4.9 via Greg-KH's tree.
> CC'ing him.
> 
> Greg, would it be possible to please take this via your tree?

If someone resends it to me with the needed acks and reviewed-by, I
will.

thanks,

greg k-h
