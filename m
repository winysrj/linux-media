Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:46517 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752149AbdIKNeW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:34:22 -0400
Subject: Re: [PATCH v10 18/24] v4l: fwnode: Add a helper function to obtain
 device / interger references
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        linux-acpi@vger.kernel.org, mika.westerberg@intel.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-19-sakari.ailus@linux.intel.com>
 <11c951eb-0315-0149-829e-ed73d748e783@xs4all.nl>
 <20170911122820.fkbd2rnaddiestab@valkosipuli.retiisi.org.uk>
 <2e2eba02-39bc-11e1-d9f1-b83a6f580667@xs4all.nl>
 <20170911132710.mcgqn6tbiabzvpqq@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <21d712c2-7608-7153-4421-2c12b90dcb7a@xs4all.nl>
Date: Mon, 11 Sep 2017 15:34:16 +0200
MIME-Version: 1.0
In-Reply-To: <20170911132710.mcgqn6tbiabzvpqq@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2017 03:27 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Sep 11, 2017 at 02:38:23PM +0200, Hans Verkuil wrote:
>> On 09/11/2017 02:28 PM, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> Thanks for the review.
>>>
>>> On Mon, Sep 11, 2017 at 11:38:58AM +0200, Hans Verkuil wrote:
>>>> Typo in subject: interger -> integer
>>>>
>>>> On 09/11/2017 10:00 AM, Sakari Ailus wrote:
>>>>> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
>>>>> the device's own fwnode, 
>>>>
>>>> Sorry, you lost me here. Which device are we talking about?
>>>
>>> The fwnode related a struct device, in other words what dev_fwnode(dev)
>>> gives you. This is either struct device.fwnode or struct
>>> device.of_node.fwnode, depending on which firmware interface was used to
>>> create the device.
>>>
>>> I'll add a note of this.
>>>
>>>>
>>>>> it will follow child fwnodes with the given
>>>>> property -- value pair and return the resulting fwnode.
>>>>
>>>> property-value pair (easier readable that way).
>>>>
>>>> You only describe v4l2_fwnode_reference_parse_int_prop(), not
>>>> v4l2_fwnode_reference_parse_int_props().
>>>
>>> Yes, I think I changed the naming but forgot to update the commit. I'll do
>>> that now.
>>>
>>>>
>>>>>
>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>> ---
>>>>>  drivers/media/v4l2-core/v4l2-fwnode.c | 93 +++++++++++++++++++++++++++++++++++
>>>>>  1 file changed, 93 insertions(+)
>>>>>
>>>>> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>> index 4821c4989119..56eee5bbd3b5 100644
>>>>> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>> @@ -496,6 +496,99 @@ static int v4l2_fwnode_reference_parse(
>>>>>  	return ret;
>>>>>  }
>>>>>  
>>>>> +static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
>>>>> +	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
>>>>> +	const char **props, unsigned int nprops)
>>>>
>>>> Need comments describing what this does.
>>>
>>> Yes. I'll also rename it (get -> read) for consistency with the async
>>> changes.
>>
>> Which async changes? Since the fwnode_handle that's returned is refcounted
>> I wonder if 'get' isn't the right name in this case.
> 
> Right. True. I'll leave that as-is then.
> 
>>
>>>
>>>>
>>>>> +{
>>>>> +	struct fwnode_reference_args fwnode_args;
>>>>> +	unsigned int *args = fwnode_args.args;
>>>>> +	struct fwnode_handle *child;
>>>>> +	int ret;
>>>>> +
>>>>> +	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
>>>>> +						 index, &fwnode_args);
>>>>> +	if (ret)
>>>>> +		return ERR_PTR(ret == -EINVAL ? -ENOENT : ret);
>>>>
>>>> Why map EINVAL to ENOENT? Needs a comment, either here or in the function description.
>>>
>>> fwnode_property_get_reference_args() returns currently a little bit
>>> different error codes in ACPI / DT. This is worth documenting there and
>>> fixing as well.
>>>
>>>>
>>>>> +
>>>>> +	for (fwnode = fwnode_args.fwnode;
>>>>> +	     nprops; nprops--, fwnode = child, props++, args++) {
>>>>
>>>> I think you cram too much in this for-loop: fwnode, nprops, fwnode, props, args...
>>>> It's hard to parse.
>>>
>>> Hmm. I'm not sure if that really helps; the function is just handling each
>>> entry in the array and related array pointers are changed accordingly. The
>>> fwnode = child assignment is there to move to the child node. I.e. what you
>>> need for handling the loop itself.
>>>
>>> I can change this though if you think it really makes a difference for
>>> better.
>>
>> I think so, yes. I noticed you like complex for-loops :-)
> 
> I don't really see a difference. The loop increment will just move at the
> end of the block inside the loop.
> 
>>
>>>
>>>>
>>>> I would make this a 'while (nprops)' and write out all the other assignments,
>>>> increments and decrements.
>>>>
>>>>> +		u32 val;
>>>>> +
>>>>> +		fwnode_for_each_child_node(fwnode, child) {
>>>>> +			if (fwnode_property_read_u32(child, *props, &val))
>>>>> +				continue;
>>>>> +
>>>>> +			if (val == *args)
>>>>> +				break;
>>>>
>>>> I'm lost. This really needs comments and perhaps even an DT or ACPI example
>>>> so you can see what exactly it is we're doing here.
>>>
>>> I'll add comments to the code. A good example will be ACPI documentation
>>> for LEDs, see 17th patch in v9. That will go through the linux-pm tree so
>>> it won't be available in the same tree for a while.
>>
>> Ideally an ACPI and an equivalent DT example would be nice to have, but I might
>> be asking too much. I'm not that familiar with ACPI, so for me a DT example
>> is easier.
> 
> This won't be useful on DT although you could technically use it. In DT you
> can directly refer to any node but on ACPI you can just refer to devices,
> hence this.

So this function will effectively only be used with acpi? That should be
documented. I think that explains some of my confusion since I was trying
to map this code to a device tree, without much success.

> Would you be happy with the leds.txt example? I think it's a good example
> as it's directly related to this.

Yes, that will work.

Regards,

	Hans
