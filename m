Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54692 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754592AbdDDP53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 11:57:29 -0400
Subject: Re: [PATCH] [media] cec: Handle RC capability more elegantly
To: Lee Jones <lee.jones@linaro.org>
References: <20170404144309.31357-1-lee.jones@linaro.org>
 <9fdac3c1-b249-839e-c2bc-f4661994eb3a@xs4all.nl>
 <20170404151939.bvd252nprj6kjmdu@dell>
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-media@vger.kernel.org, benjamin.gaignard@st.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bbe09764-a675-ae2d-88d3-7a415ae4d9c5@xs4all.nl>
Date: Tue, 4 Apr 2017 17:57:22 +0200
MIME-Version: 1.0
In-Reply-To: <20170404151939.bvd252nprj6kjmdu@dell>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/04/2017 05:19 PM, Lee Jones wrote:
> On Tue, 04 Apr 2017, Hans Verkuil wrote:
> 
>> On 04/04/2017 04:43 PM, Lee Jones wrote:
>>> If a user specifies the use of RC as a capability, they should
>>> really be enabling RC Core code.  If they do not we WARN() them
>>> of this and disable the capability for them.
>>>
>>> Once we know RC Core code has not been enabled, we can update
>>> the user's capabilities and use them as a term of reference for
>>> other RC-only calls.  This is preferable to having ugly #ifery
>>> scattered throughout C code.
>>>
>>> Most of the functions are actually safe to call, since they
>>> sensibly check for a NULL RC pointer before they attempt to
>>> deference it.
>>>
>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>> ---
>>>  drivers/media/cec/cec-core.c | 19 +++++++------------
>>>  1 file changed, 7 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
>>> index cfe414a..51be8d6 100644
>>> --- a/drivers/media/cec/cec-core.c
>>> +++ b/drivers/media/cec/cec-core.c
>>> @@ -208,9 +208,13 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
>>>  		return ERR_PTR(-EINVAL);
>>>  	if (WARN_ON(!available_las || available_las > CEC_MAX_LOG_ADDRS))
>>>  		return ERR_PTR(-EINVAL);
>>> +	if (WARN_ON(caps & CEC_CAP_RC && !IS_REACHABLE(CONFIG_RC_CORE)))
>>> +		caps &= ~CEC_CAP_RC;
>>
>> Don't use WARN_ON, this is not an error of any kind.
> 
> Right, this is not an error.
> 
> That's why we are warning the user instead of bombing out.
> 
>> Neither do you need to add the
>> 'caps & CEC_CAP_RC' test. Really, it's just simpler to do what I suggested before
>> with an #if.
> 
> This does exactly what you asked.
> 
> Just to clarify, can you explain to me when asking for RC support, but
> not enabling it would ever be a valid configuration?

Drivers can decide not to enable RC support. This is more likely to happen with
out-of-tree drivers or when you patch the driver for an embedded system. Using
the RC subsystem for CEC remote control may not be what you want, especially
in an embedded system. Not all CEC RC messages can be handled by the rc subsystem,
and you may not want to have them end up in the rc subsystem at all.

So I decided to make this a capability that drivers have to explicitly set when
they create the CEC adapter. Of course, if they set it (and all in-tree drivers
do set it) but the whole subsystem is not enabled, then that's not an error, nor
a warning. Instead we simply drop that capability silently here.

In the future I might decide to change this (e.g. have it as a CEC config option),
but I'd like to wait and see how this works out.

> 
>>> +
>>>  	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
>>>  	if (!adap)
>>>  		return ERR_PTR(-ENOMEM);
>>> +
>>>  	strlcpy(adap->name, name, sizeof(adap->name));
>>>  	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
>>>  	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
>>> @@ -237,7 +241,6 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
>>>  	if (!(caps & CEC_CAP_RC))
>>>  		return adap;
>>>  
>>> -#if IS_REACHABLE(CONFIG_RC_CORE)
>>
>> Huh? If CONFIG_RC_CORE is undefined, all these rc_ calls will fail when linking!
> 
> I thought I'd tested for that, but it turns out that *my*
> CONFIG_RC_CORE=n config was being over-ridden by the build system.
> 
> If it will really fail when linking, it sounds like the RC subsystem
> is not written properly.  I guess that explains why all these drivers
> are riddled with ugly #ifery.

The rc subsystem doesn't provide you with empty stubs for these functions
in the header if RC_CORE isn't defined.

> 
> Will fix that too, bear with.

Please just keep this patch simple. Just clean up the confusing control flow.

Anything else can be done afterwards.

	Hans

> 
>>>  	/* Prepare the RC input device */
>>>  	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
>>>  	if (!adap->rc) {
>>> @@ -264,9 +267,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
>>>  	adap->rc->priv = adap;
>>>  	adap->rc->map_name = RC_MAP_CEC;
>>>  	adap->rc->timeout = MS_TO_NS(100);
>>> -#else
>>> -	adap->capabilities &= ~CEC_CAP_RC;
>>> -#endif
>>> +
>>>  	return adap;
>>>  }
>>>  EXPORT_SYMBOL_GPL(cec_allocate_adapter);
>>> @@ -285,7 +286,6 @@ int cec_register_adapter(struct cec_adapter *adap,
>>>  	adap->owner = parent->driver->owner;
>>>  	adap->devnode.dev.parent = parent;
>>>  
>>> -#if IS_REACHABLE(CONFIG_RC_CORE)
>>>  	if (adap->capabilities & CEC_CAP_RC) {
>>>  		adap->rc->dev.parent = parent;
>>>  		res = rc_register_device(adap->rc);
>>> @@ -298,15 +298,13 @@ int cec_register_adapter(struct cec_adapter *adap,
>>>  			return res;
>>>  		}
>>>  	}
>>> -#endif
>>>  
>>>  	res = cec_devnode_register(&adap->devnode, adap->owner);
>>>  	if (res) {
>>> -#if IS_REACHABLE(CONFIG_RC_CORE)
>>>  		/* Note: rc_unregister also calls rc_free */
>>>  		rc_unregister_device(adap->rc);
>>>  		adap->rc = NULL;
>>> -#endif
>>> +
>>>  		return res;
>>>  	}
>>>  
>>> @@ -337,11 +335,10 @@ void cec_unregister_adapter(struct cec_adapter *adap)
>>>  	if (IS_ERR_OR_NULL(adap))
>>>  		return;
>>>  
>>> -#if IS_REACHABLE(CONFIG_RC_CORE)
>>>  	/* Note: rc_unregister also calls rc_free */
>>>  	rc_unregister_device(adap->rc);
>>>  	adap->rc = NULL;
>>> -#endif
>>> +
>>>  	debugfs_remove_recursive(adap->cec_dir);
>>>  	cec_devnode_unregister(&adap->devnode);
>>>  }
>>> @@ -357,9 +354,7 @@ void cec_delete_adapter(struct cec_adapter *adap)
>>>  	kthread_stop(adap->kthread);
>>>  	if (adap->kthread_config)
>>>  		kthread_stop(adap->kthread_config);
>>> -#if IS_REACHABLE(CONFIG_RC_CORE)
>>>  	rc_free_device(adap->rc);
>>> -#endif
>>>  	kfree(adap);
>>>  }
>>>  EXPORT_SYMBOL_GPL(cec_delete_adapter);
>>>
>>
> 
