Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:56395 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752901AbcLMHyT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 02:54:19 -0500
Date: Tue, 13 Dec 2016 07:54:16 +0000
From: Sean Young <sean@mess.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-media@vger.kernel.org, Sifan Naeem <sifan.naeem@imgtec.com>
Subject: Re: [PATCH v5 02/18] [media] img-ir: use new wakeup_protocols sysfs
 mechanism
Message-ID: <20161213075416.GA27738@gofer.mess.org>
References: <cover.1481575826.git.sean@mess.org>
 <074994409ca834b6fcd950e7da60456247f12ce5.1481575826.git.sean@mess.org>
 <20161212223115.GB30099@jhogan-linux.le.imgtec.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161212223115.GB30099@jhogan-linux.le.imgtec.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James,

On Mon, Dec 12, 2016 at 10:31:15PM +0000, James Hogan wrote:
> On Mon, Dec 12, 2016 at 09:13:43PM +0000, Sean Young wrote:
> > Rather than guessing what variant a scancode is from its length,
> > use the new wakeup_protocol.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > Cc: James Hogan <james.hogan@imgtec.com>
> > Cc: Sifan Naeem <sifan.naeem@imgtec.com>
> > ---
> >  drivers/media/rc/img-ir/img-ir-hw.c    |  2 +-
> >  drivers/media/rc/img-ir/img-ir-hw.h    |  2 +-
> >  drivers/media/rc/img-ir/img-ir-jvc.c   |  2 +-
> >  drivers/media/rc/img-ir/img-ir-nec.c   |  6 +++---
> >  drivers/media/rc/img-ir/img-ir-rc5.c   |  2 +-
> >  drivers/media/rc/img-ir/img-ir-rc6.c   |  2 +-
> >  drivers/media/rc/img-ir/img-ir-sanyo.c |  2 +-
> >  drivers/media/rc/img-ir/img-ir-sharp.c |  2 +-
> >  drivers/media/rc/img-ir/img-ir-sony.c  | 11 +++--------
> >  9 files changed, 13 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
> > index 1a0811d..841d9d7 100644
> > --- a/drivers/media/rc/img-ir/img-ir-hw.c
> > +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> > @@ -488,7 +488,7 @@ static int img_ir_set_filter(struct rc_dev *dev, enum rc_filter_type type,
> >  	/* convert scancode filter to raw filter */
> >  	filter.minlen = 0;
> >  	filter.maxlen = ~0;
> > -	ret = hw->decoder->filter(sc_filter, &filter, hw->enabled_protocols);
> > +	ret = hw->decoder->filter(sc_filter, &filter, dev->wakeup_protocol);
> 
> According to patch 1, wakeup_protocol can always be set to
> RC_TYPE_UNKNOWN using the protocol "none", but this function is used for
> the normal filter too. AFAICT that would make it impossible to set a
> normal filter without first setting the (new) wakeup protocol too.
> Technically when type == RC_FILTER_NORMAL, the protocol should be based
> on enabled_protocols, which should be set to a single protocol group.

Yes, this change is wrong. For normal filters it should clearly use
dev->enabled_protocols.

> I'll also note that enforcing that a wakeup protocol is set before
> setting the wakeup filter (in patch 1 which I'm not Cc'd on) is an
> incompatible API change. The old API basically meant that a mask of 0
> disabled the wakeup filter, and there was no wakeup_protocol to set.

The "new" API always ensures that the mask is 0 if no protocol is set,
no wakeup filter can be set while wakeup_protocol is RC_TYPE_UNKNOWN. 
This could be documented more clearly, I'll add something for that.

Howver you point out that the "new" API would require setting a wakeup
protocol first, which was not required before. That is true, but at the
same time, guessing the protocol variant from the scancode is not
reliable either (as is done for Sony and NEC).

> If wakeup filters can be changed to still be writable when wakeup
> protocol is not set, then I suppose this driver could do something like:
> 
> 	if (type == RC_TYPE_NORMAL) {
> 		use hw->enabled_protocols;
> 	} else if (type == RC_TYPE_WAKEUP) {
> 		if (dev->wakeup_protocol == RC_TYPE_UNKNOWN)
> 			use hw->enabled_protocols;
> 		else
> 			use 1 << dev->wakeup_protocol;
> 	}

The problem with this solution is that wakeup_filter can not be set until
a wakeup_protocol is set, so we would still need to set a wakeup_protocol,
so it won't help.

Another solution would be to set the wakeup_protocol automagically whenever
the normal protocol is set, much like enabled_wakeup_protocols is done now.
We would have to pick a variant though.

So that leaves the question open of whether we want to guess the protocol
variant from the scancode for img-ir or if we can live with having to
select this using wakeup_protocols. Having to do this does solve the issue
of the driver guessing the wrong protocol if the higher bits happen to be
0 in the scancode.

Also note that this is an issue for nec and sony only, the other protocols
img-ir supports only have one variant.

> Clearly allowing a wakeup filter with no protocol is not ideal though.

Agreed.

Thanks,
Sean
