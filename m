Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:53956 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752279AbdIMJ2t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 05:28:49 -0400
Subject: Re: [PATCH v12 18/26] v4l: fwnode: Add a helper function for parsing
 generic references
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
 <20170912134200.19556-19-sakari.ailus@linux.intel.com>
 <020b9c86-dd73-3516-4a0e-827db9680b55@xs4all.nl>
 <20170913092430.cbdgerkhiuxakbxv@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c85397c3-19f2-90be-4c5e-6214ca1294b8@xs4all.nl>
Date: Wed, 13 Sep 2017 11:28:44 +0200
MIME-Version: 1.0
In-Reply-To: <20170913092430.cbdgerkhiuxakbxv@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/17 11:24, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the review!
> 
> On Wed, Sep 13, 2017 at 09:27:34AM +0200, Hans Verkuil wrote:
>> On 09/12/2017 03:41 PM, Sakari Ailus wrote:
>>> Add function v4l2_fwnode_reference_count() for counting external
>>
>> ???? There is no function v4l2_fwnode_reference_count()?!
> 
> It got removed during the revisions but the commit message was not changed
> accordingly, I do that now.
> 
>>
>>> references and v4l2_fwnode_reference_parse() for parsing them as async
>>> sub-devices.
>>>
>>> This can be done on e.g. flash or lens async sub-devices that are not part
>>> of but are associated with a sensor.
>>>
>>> struct v4l2_async_notifier.max_subdevs field is added to contain the
>>> maximum number of sub-devices in a notifier to reflect the memory
>>> allocated for the subdevs array.
>>
>> You forgot to remove this outdated paragraph.
> 
> Oops. Removed it now.
> 
>>
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-fwnode.c | 69 +++++++++++++++++++++++++++++++++++
>>>  1 file changed, 69 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
>>> index 44ee35f6aad5..a32473f95be1 100644
>>> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
>>> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
>>> @@ -498,6 +498,75 @@ int v4l2_async_notifier_parse_fwnode_endpoints_by_port(
>>>  }
>>>  EXPORT_SYMBOL_GPL(v4l2_async_notifier_parse_fwnode_endpoints_by_port);
>>>  
>>> +/*
>>> + * v4l2_fwnode_reference_parse - parse references for async sub-devices
>>> + * @dev: the device node the properties of which are parsed for references
>>> + * @notifier: the async notifier where the async subdevs will be added
>>> + * @prop: the name of the property
>>> + *
>>> + * Return: 0 on success
>>> + *	   -ENOENT if no entries were found
>>> + *	   -ENOMEM if memory allocation failed
>>> + *	   -EINVAL if property parsing failed
>>> + */
>>> +static int v4l2_fwnode_reference_parse(
>>> +	struct device *dev, struct v4l2_async_notifier *notifier,
>>> +	const char *prop)
>>> +{
>>> +	struct fwnode_reference_args args;
>>> +	unsigned int index;
>>> +	int ret;
>>> +
>>> +	for (index = 0;
>>> +	     !(ret = fwnode_property_get_reference_args(
>>> +		       dev_fwnode(dev), prop, NULL, 0, index, &args));
>>> +	     index++)
>>> +		fwnode_handle_put(args.fwnode);
>>> +
>>> +	if (!index)
>>> +		return -ENOENT;
>>> +
>>> +	/*
>>> +	 * To-do: handle -ENODATA when "device property: Align return
>>> +	 * codes of acpi_fwnode_get_reference_with_args" is merged.
>>> +	 */
>>> +	if (ret != -ENOENT && ret != -ENODATA)
>>
>> So while that patch referenced in the To-do above is not merged yet,
>> what does fwnode_property_get_reference_args return? ENOENT or ENODATA?
>> Or ENOENT now and ENODATA later? Or vice versa?
>>
>> I can't tell based on that information whether this code is correct or not.
>>
>> The comment needs to explain this a bit better.
> 
> I'll add this:
> 
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index a32473f95be1..74fcc3ba9ebd 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -529,6 +529,9 @@ static int v4l2_fwnode_reference_parse(
>  	/*
>  	 * To-do: handle -ENODATA when "device property: Align return
>  	 * codes of acpi_fwnode_get_reference_with_args" is merged.

So after this patch referred to in the To-do is applied it will only
return ENODATA?

In that case, change 'handle' to 'handle only'.

> +	 * Right now, both -ENODATA and -ENOENT signal the end of
> +	 * references where only a single error code should be used
> +	 * for the purpose.
>  	 */
>  	if (ret != -ENOENT && ret != -ENODATA)
>  		return ret;
> 

Regards,

	Hans
