Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38294 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752935AbdDDPTo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 11:19:44 -0400
Received: by mail-wm0-f42.google.com with SMTP id t189so31057945wmt.1
        for <linux-media@vger.kernel.org>; Tue, 04 Apr 2017 08:19:43 -0700 (PDT)
Date: Tue, 4 Apr 2017 16:19:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-media@vger.kernel.org, benjamin.gaignard@st.com
Subject: Re: [PATCH] [media] cec: Handle RC capability more elegantly
Message-ID: <20170404151939.bvd252nprj6kjmdu@dell>
References: <20170404144309.31357-1-lee.jones@linaro.org>
 <9fdac3c1-b249-839e-c2bc-f4661994eb3a@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9fdac3c1-b249-839e-c2bc-f4661994eb3a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 04 Apr 2017, Hans Verkuil wrote:

> On 04/04/2017 04:43 PM, Lee Jones wrote:
> > If a user specifies the use of RC as a capability, they should
> > really be enabling RC Core code.  If they do not we WARN() them
> > of this and disable the capability for them.
> > 
> > Once we know RC Core code has not been enabled, we can update
> > the user's capabilities and use them as a term of reference for
> > other RC-only calls.  This is preferable to having ugly #ifery
> > scattered throughout C code.
> > 
> > Most of the functions are actually safe to call, since they
> > sensibly check for a NULL RC pointer before they attempt to
> > deference it.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/media/cec/cec-core.c | 19 +++++++------------
> >  1 file changed, 7 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
> > index cfe414a..51be8d6 100644
> > --- a/drivers/media/cec/cec-core.c
> > +++ b/drivers/media/cec/cec-core.c
> > @@ -208,9 +208,13 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
> >  		return ERR_PTR(-EINVAL);
> >  	if (WARN_ON(!available_las || available_las > CEC_MAX_LOG_ADDRS))
> >  		return ERR_PTR(-EINVAL);
> > +	if (WARN_ON(caps & CEC_CAP_RC && !IS_REACHABLE(CONFIG_RC_CORE)))
> > +		caps &= ~CEC_CAP_RC;
> 
> Don't use WARN_ON, this is not an error of any kind.

Right, this is not an error.

That's why we are warning the user instead of bombing out.

> Neither do you need to add the
> 'caps & CEC_CAP_RC' test. Really, it's just simpler to do what I suggested before
> with an #if.

This does exactly what you asked.

Just to clarify, can you explain to me when asking for RC support, but
not enabling it would ever be a valid configuration?

> > +
> >  	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
> >  	if (!adap)
> >  		return ERR_PTR(-ENOMEM);
> > +
> >  	strlcpy(adap->name, name, sizeof(adap->name));
> >  	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
> >  	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
> > @@ -237,7 +241,6 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
> >  	if (!(caps & CEC_CAP_RC))
> >  		return adap;
> >  
> > -#if IS_REACHABLE(CONFIG_RC_CORE)
> 
> Huh? If CONFIG_RC_CORE is undefined, all these rc_ calls will fail when linking!

I thought I'd tested for that, but it turns out that *my*
CONFIG_RC_CORE=n config was being over-ridden by the build system.

If it will really fail when linking, it sounds like the RC subsystem
is not written properly.  I guess that explains why all these drivers
are riddled with ugly #ifery.

Will fix that too, bear with.

> >  	/* Prepare the RC input device */
> >  	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
> >  	if (!adap->rc) {
> > @@ -264,9 +267,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
> >  	adap->rc->priv = adap;
> >  	adap->rc->map_name = RC_MAP_CEC;
> >  	adap->rc->timeout = MS_TO_NS(100);
> > -#else
> > -	adap->capabilities &= ~CEC_CAP_RC;
> > -#endif
> > +
> >  	return adap;
> >  }
> >  EXPORT_SYMBOL_GPL(cec_allocate_adapter);
> > @@ -285,7 +286,6 @@ int cec_register_adapter(struct cec_adapter *adap,
> >  	adap->owner = parent->driver->owner;
> >  	adap->devnode.dev.parent = parent;
> >  
> > -#if IS_REACHABLE(CONFIG_RC_CORE)
> >  	if (adap->capabilities & CEC_CAP_RC) {
> >  		adap->rc->dev.parent = parent;
> >  		res = rc_register_device(adap->rc);
> > @@ -298,15 +298,13 @@ int cec_register_adapter(struct cec_adapter *adap,
> >  			return res;
> >  		}
> >  	}
> > -#endif
> >  
> >  	res = cec_devnode_register(&adap->devnode, adap->owner);
> >  	if (res) {
> > -#if IS_REACHABLE(CONFIG_RC_CORE)
> >  		/* Note: rc_unregister also calls rc_free */
> >  		rc_unregister_device(adap->rc);
> >  		adap->rc = NULL;
> > -#endif
> > +
> >  		return res;
> >  	}
> >  
> > @@ -337,11 +335,10 @@ void cec_unregister_adapter(struct cec_adapter *adap)
> >  	if (IS_ERR_OR_NULL(adap))
> >  		return;
> >  
> > -#if IS_REACHABLE(CONFIG_RC_CORE)
> >  	/* Note: rc_unregister also calls rc_free */
> >  	rc_unregister_device(adap->rc);
> >  	adap->rc = NULL;
> > -#endif
> > +
> >  	debugfs_remove_recursive(adap->cec_dir);
> >  	cec_devnode_unregister(&adap->devnode);
> >  }
> > @@ -357,9 +354,7 @@ void cec_delete_adapter(struct cec_adapter *adap)
> >  	kthread_stop(adap->kthread);
> >  	if (adap->kthread_config)
> >  		kthread_stop(adap->kthread_config);
> > -#if IS_REACHABLE(CONFIG_RC_CORE)
> >  	rc_free_device(adap->rc);
> > -#endif
> >  	kfree(adap);
> >  }
> >  EXPORT_SYMBOL_GPL(cec_delete_adapter);
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
