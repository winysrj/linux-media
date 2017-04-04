Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34918 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754262AbdDDPhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 11:37:18 -0400
Date: Tue, 4 Apr 2017 16:36:59 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, benjamin.gaignard@st.com,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-kernel@vger.kernel.org, hans.verkuil@cisco.com,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] cec: Handle RC capability more elegantly
Message-ID: <20170404153659.GC7909@n2100.armlinux.org.uk>
References: <20170404144309.31357-1-lee.jones@linaro.org>
 <9fdac3c1-b249-839e-c2bc-f4661994eb3a@xs4all.nl>
 <20170404151939.bvd252nprj6kjmdu@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170404151939.bvd252nprj6kjmdu@dell>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 04, 2017 at 04:19:39PM +0100, Lee Jones wrote:
> On Tue, 04 Apr 2017, Hans Verkuil wrote:
> 
> > On 04/04/2017 04:43 PM, Lee Jones wrote:
> > > If a user specifies the use of RC as a capability, they should
> > > really be enabling RC Core code.  If they do not we WARN() them
> > > of this and disable the capability for them.
> > > 
> > > Once we know RC Core code has not been enabled, we can update
> > > the user's capabilities and use them as a term of reference for
> > > other RC-only calls.  This is preferable to having ugly #ifery
> > > scattered throughout C code.
> > > 
> > > Most of the functions are actually safe to call, since they
> > > sensibly check for a NULL RC pointer before they attempt to
> > > deference it.
> > > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/media/cec/cec-core.c | 19 +++++++------------
> > >  1 file changed, 7 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
> > > index cfe414a..51be8d6 100644
> > > --- a/drivers/media/cec/cec-core.c
> > > +++ b/drivers/media/cec/cec-core.c
> > > @@ -208,9 +208,13 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
> > >  		return ERR_PTR(-EINVAL);
> > >  	if (WARN_ON(!available_las || available_las > CEC_MAX_LOG_ADDRS))
> > >  		return ERR_PTR(-EINVAL);
> > > +	if (WARN_ON(caps & CEC_CAP_RC && !IS_REACHABLE(CONFIG_RC_CORE)))
> > > +		caps &= ~CEC_CAP_RC;
> > 
> > Don't use WARN_ON, this is not an error of any kind.
> 
> Right, this is not an error.
> 
> That's why we are warning the user instead of bombing out.

Please print warning using pr_warn() or dev_warn().  Using WARN_ON()
because something is not configured is _really_ not nice behaviour.
Consider how useful a stack trace is to the user for this situation -
it's completely meaningless.

A message that prompts the user to enable RC_CORE would make more sense,
and be much more informative to the user.  Maybe something like this:

+	if (caps & CEC_CAP_RC && !IS_REACHABLE(CONFIG_RC_CORE)) {
+		pr_warn("CEC: driver %pf requests RC, please enable CONFIG_RC_CORE\n",
+			__builtin_return_address(0));
+		caps &= ~CEC_CAP_RC;
+	}

It could be much more informative by using dev_warn() if we had the
'struct device' passed in to this function, and then we wouldn't need
to use __builtin_return_address().

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
