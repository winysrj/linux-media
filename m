Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38250 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756623Ab2CZVXU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 17:23:20 -0400
Message-ID: <4F70DE45.1000002@iki.fi>
Date: Tue, 27 Mar 2012 00:23:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] omap3isp: preview: Shorten shadow update delay
References: <1332772951-19108-1-git-send-email-laurent.pinchart@ideasonboard.com> <1332772951-19108-4-git-send-email-laurent.pinchart@ideasonboard.com> <20120326162323.GE913@valkosipuli.localdomain> <1968166.nyWDzh5zcN@avalon>
In-Reply-To: <1968166.nyWDzh5zcN@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> On Monday 26 March 2012 19:23:23 Sakari Ailus wrote:
>> On Mon, Mar 26, 2012 at 04:42:31PM +0200, Laurent Pinchart wrote:
>>> When applications modify preview engine parameters, the new values are
>>> applied to the hardware by the preview engine interrupt handler during
>>> vertical blanking. If the parameters are being changed when the
>>> interrupt handler is called, it just delays applying the parameters
>>> until the next frame.
>>>
>>> If an application modifies the parameters for every frame, and the
>>> preview engine interrupt is triggerred synchronously, the parameters are
>>> never applied to the hardware.
>>>
>>> Fix this by storing new parameters in a shadow copy, and replace the
>>> active parameters with the shadow values atomically.
>
> [snip]
>
>>> @@-886,20 +896,24@@ static int preview_config(struct isp_prev_device*prev,
>>>   			  struct omap3isp_prev_update_config *cfg)
>>>   {
>>>   	struct prev_params *params;
>>> +	struct prev_params *shadow;
>>>   	struct preview_update *attr;
>>> +	unsigned long flags;
>>>   	int i, bit, rval = 0;
>>>
>>> -	params =&prev->params;
>>>   	if (cfg->update == 0)
>>>   		return 0;
>>>
>>> -	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
>>> -		unsigned long flags;
>>> +	params = kmalloc(sizeof(*params), GFP_KERNEL);
>>> +	if (params == NULL)
>>> +		return -ENOMEM;
>>>
>>> -		spin_lock_irqsave(&prev->lock, flags);
>>> -		prev->shadow_update = 1;
>>> -		spin_unlock_irqrestore(&prev->lock, flags);
>>> -	}
>>> +	spin_lock_irqsave(&prev->params.lock, flags);
>>> +	memcpy(params, prev->params.shadow ? : prev->params.active,
>>> +	       sizeof(*params));
>>> +	spin_unlock_irqrestore(&prev->params.lock, flags);
>>> +
>>> +	params->update = 0;
>>>
>>>   	for (i = 0; i<  ARRAY_SIZE(update_attrs); i++) {
>>>   	
>>>   		attr =&update_attrs[i];
>>
>> I think it's partly a matter of taste but --- would you think it'd make
>> sense to allocate the another configuration structure statically? I didn't
>> check the actual size of the configuration but it seems to be pretty big.
>> Handling allocation failures in applications is a nuisance, but also
>> allocating such largish chunks to just to be on the safe side doesn't sound
>> very appealing either.
>
> I'd like that better as well, but then we'll run into the same issue that this
> patch tries to fix. I'll try to find a better solution.
>
>> Say, if you're capturing a photo and you allocation fails here. Should you
>> just retry it a few times, or fail immediately? Random allocation failures
>> are not unforeseen even on systems with plenty of memory. Not that it should
>> work this way I guess...
>>
>> Have you checked what's the size of this struct btw.?
>
> It's big. Around 16k if I'm not mistaken.

As this is only 16 kiB, I'd go with a static allocation.

In the long run such allocations should be done dynamically when the 
first user accesses the device. I guess this isn't the only struct of 
its kind so likely more than 16 kiB would be gained by making the 
allocation depend on actual users.

We could also use vmalloc() instead --- this memory doesn't have to be 
physically contiguous. It would "fix" in-ioctl allocation but on the 
expense on larger (I suppose) allocation time, so I still wouldn't do it 
on every ioctl.

Albeit I feel it wouldn't be much of a job. One function call to preview 
code in both isp_get() / isp_put() mostly plus a bit of error handling, 
instead of omap3isp_preview_init() / omap3isp_preview_cleanup()?

Still, I'm fine with introducing dynamic allocation later on.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
