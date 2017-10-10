Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:42740 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755272AbdJJNIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 09:08:02 -0400
Subject: Re: [PATCH v14 20/28] v4l: fwnode: Add a helper function to obtain
 device / integer references
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-21-sakari.ailus@linux.intel.com>
 <fbd2f71d-aa6d-08ef-1723-132864bde27b@xs4all.nl>
 <20170926113029.eh5i4sp6we6lvgow@paasikivi.fi.intel.com>
 <4363f544-d1ec-68e4-1edf-9a16b3cdb1ea@xs4all.nl>
 <20171010112710.noq6a4ktjqzt5u22@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d8a48273-7a19-0f83-4a4d-8058b7a59e0e@xs4all.nl>
Date: Tue, 10 Oct 2017 15:07:29 +0200
MIME-Version: 1.0
In-Reply-To: <20171010112710.noq6a4ktjqzt5u22@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/10/2017 01:27 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Oct 09, 2017 at 02:06:55PM +0200, Hans Verkuil wrote:
>> Hi Sakari,
>>
>> My reply here is also valid for v15.
>>
>> On 26/09/17 13:30, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> Thanks for the review.
>>>
>>> On Tue, Sep 26, 2017 at 10:47:40AM +0200, Hans Verkuil wrote:
>>>> On 26/09/17 00:25, Sakari Ailus wrote:
>>>>> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
>>>>> the device's own fwnode, it will follow child fwnodes with the given
>>>>> property-value pair and return the resulting fwnode.
>>>>>
>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>> ---
>>>>>  drivers/media/v4l2-core/v4l2-fwnode.c | 201 ++++++++++++++++++++++++++++++++++
>>>>>  1 file changed, 201 insertions(+)
>>>>>
>>>>> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>> index f739dfd16cf7..f93049c361e4 100644
>>>>> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>> @@ -578,6 +578,207 @@ static int v4l2_fwnode_reference_parse(
>>>>>  	return ret;
>>>>>  }
>>>>>  
>>>>> +/*
>>>>> + * v4l2_fwnode_reference_get_int_prop - parse a reference with integer
>>>>> + *					arguments
>>>>> + * @dev: struct device pointer
>>>>> + * @notifier: notifier for @dev
>>>>> + * @prop: the name of the property
>>>>> + * @index: the index of the reference to get
>>>>> + * @props: the array of integer property names
>>>>> + * @nprops: the number of integer property names in @nprops
>>>>> + *
>>>>> + * Find fwnodes referred to by a property @prop, then under that
>>>>> + * iteratively, @nprops times, follow each child node which has a
>>>>> + * property in @props array at a given child index the value of which
>>>>> + * matches the integer argument at an index.
>>>>
>>>> "at an index". Still makes no sense to me. Which index?
>>>
>>> How about this:
>>>
>>> First find an fwnode referred to by the reference at @index in @prop.
>>>
>>> Then under that fwnode, @nprops times, for each property in @props,
>>> iteratively follow child nodes starting from fwnode such that they have the
>>> property in @props array at the index of the child node distance from the
>>
>> distance? You mean 'instance'?
> 
> No. It's a tree structure: this is the distance between a node in the tree
> and the root node (i.e. device's fwnode).
> 
>>
>>> root node and the value of that property matching with the integer argument of
>>> the reference, at the same index.
>>
>> You've completely lost me. About halfway through this sentence my brain crashed :-)
> 
> :-D
> 
> Did keeping distance have any effect?

No :-)

"the index of the child node distance from the root node": I have absolutely
no idea how to interpret that.

> 
>>
>>>
>>>>
>>>>> + *
>>>>> + * For example, if this function was called with arguments and values
>>>>> + * @dev corresponding to device "SEN", @prop == "flash-leds", @index
>>>>> + * == 1, @props == { "led" }, @nprops == 1, with the ASL snippet below
>>>>> + * it would return the node marked with THISONE. The @dev argument in
>>>>> + * the ASL below.
>>>>
>>>> I know I asked for this before, but can you change the example to one where
>>>> nprops = 2? I think that will help understanding this.
>>>
>>> I could do that but then the example no longer corresponds to any actual
>>> case that exists at the moment. LED nodes will use a single integer
>>> argument and lens-focus nodes none.
>>
>> So? The example is here to understand the code and it doesn't have to be
>> related to actual hardware for a mainlined driver.
> 
> This isn't about hardware, the definitions being parsed currently aren't
> specific to any single piece of hardware. I could add an example which does
> not exist, that's certainly possible. But I fail to see how it'd help
> while the contrary could well be the case.

It helps to relate the code (and the comments for that matter) to what is in
the ACPI. In fact, if you can make such an example, then I can see if I can
come up with a better description.

Regards,

	Hans

> 
>>
>> If you really don't want to do this here, then put the example in the commit
>> log. I don't see any reason why you can't put it here, though.
>>
>> I think that once I see an 'nprops = 2' example I can rephrase that
>> brain-crash sentence for you...
>>
>> BTW, where are the ACPI 'bindings' defined anyway? For DT they are in the
>> bindings directory, but where does ACPI define such things? Just curious.
> 
> As the fwnode interface can be used to access information in both ACPI and
> DT, there is an incentive to maintain the interfaces effectively the same.
> In other words where the interfaces are the same, there is no need to
> define bindings for ACPI as such. Where there are differences the bindings
> are defined in Documentation/acpi/dsd .
> 
> The so far only technical reason to that is related to the same is that
> ACPI can only refer to device nodes (i.e. nodes that correspond to struct
> devices), not sub-nodes under them.
> 
