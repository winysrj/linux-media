Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:36639 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932833AbdDEJLd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 05:11:33 -0400
Received: by mail-wr0-f170.google.com with SMTP id w11so4966625wrc.3
        for <linux-media@vger.kernel.org>; Wed, 05 Apr 2017 02:11:32 -0700 (PDT)
Date: Wed, 5 Apr 2017 10:11:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, benjamin.gaignard@st.com,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-kernel@vger.kernel.org, hans.verkuil@cisco.com,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] cec: Handle RC capability more elegantly
Message-ID: <20170405091129.fcxblw3ydqilxrlg@dell>
References: <20170404144309.31357-1-lee.jones@linaro.org>
 <9fdac3c1-b249-839e-c2bc-f4661994eb3a@xs4all.nl>
 <20170404151939.bvd252nprj6kjmdu@dell>
 <20170404153659.GC7909@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170404153659.GC7909@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 04 Apr 2017, Russell King - ARM Linux wrote:

> On Tue, Apr 04, 2017 at 04:19:39PM +0100, Lee Jones wrote:
> > On Tue, 04 Apr 2017, Hans Verkuil wrote:
> > 
> > > On 04/04/2017 04:43 PM, Lee Jones wrote:
> > > > If a user specifies the use of RC as a capability, they should
> > > > really be enabling RC Core code.  If they do not we WARN() them
> > > > of this and disable the capability for them.
> > > > 
> > > > Once we know RC Core code has not been enabled, we can update
> > > > the user's capabilities and use them as a term of reference for
> > > > other RC-only calls.  This is preferable to having ugly #ifery
> > > > scattered throughout C code.
> > > > 
> > > > Most of the functions are actually safe to call, since they
> > > > sensibly check for a NULL RC pointer before they attempt to
> > > > deference it.
> > > > 
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/media/cec/cec-core.c | 19 +++++++------------
> > > >  1 file changed, 7 insertions(+), 12 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
> > > > index cfe414a..51be8d6 100644
> > > > --- a/drivers/media/cec/cec-core.c
> > > > +++ b/drivers/media/cec/cec-core.c
> > > > @@ -208,9 +208,13 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
> > > >  		return ERR_PTR(-EINVAL);
> > > >  	if (WARN_ON(!available_las || available_las > CEC_MAX_LOG_ADDRS))
> > > >  		return ERR_PTR(-EINVAL);
> > > > +	if (WARN_ON(caps & CEC_CAP_RC && !IS_REACHABLE(CONFIG_RC_CORE)))
> > > > +		caps &= ~CEC_CAP_RC;
> > > 
> > > Don't use WARN_ON, this is not an error of any kind.
> > 
> > Right, this is not an error.
> > 
> > That's why we are warning the user instead of bombing out.
> 
> Please print warning using pr_warn() or dev_warn().  Using WARN_ON()
> because something is not configured is _really_ not nice behaviour.
> Consider how useful a stack trace is to the user for this situation -
> it's completely meaningless.
> 
> A message that prompts the user to enable RC_CORE would make more sense,
> and be much more informative to the user.  Maybe something like this:
> 
> +	if (caps & CEC_CAP_RC && !IS_REACHABLE(CONFIG_RC_CORE)) {
> +		pr_warn("CEC: driver %pf requests RC, please enable CONFIG_RC_CORE\n",
> +			__builtin_return_address(0));
> +		caps &= ~CEC_CAP_RC;
> +	}
> 
> It could be much more informative by using dev_warn() if we had the
> 'struct device' passed in to this function, and then we wouldn't need
> to use __builtin_return_address().

Understood.

I *would* fix, but Hans has made it pretty clear that this is not the
way he wants to go.  I still think a warning is the correct solution,
but for some reason we are to support out-of-tree drivers which might
be doing weird stuff.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
