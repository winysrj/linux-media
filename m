Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54412 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751621AbdJIMG6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 08:06:58 -0400
Subject: Re: [PATCH v14 20/28] v4l: fwnode: Add a helper function to obtain
 device / integer references
To: Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20170925222540.371-1-sakari.ailus@linux.intel.com>
 <20170925222540.371-21-sakari.ailus@linux.intel.com>
 <fbd2f71d-aa6d-08ef-1723-132864bde27b@xs4all.nl>
 <20170926113029.eh5i4sp6we6lvgow@paasikivi.fi.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4363f544-d1ec-68e4-1edf-9a16b3cdb1ea@xs4all.nl>
Date: Mon, 9 Oct 2017 14:06:55 +0200
MIME-Version: 1.0
In-Reply-To: <20170926113029.eh5i4sp6we6lvgow@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

My reply here is also valid for v15.

On 26/09/17 13:30, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the review.
> 
> On Tue, Sep 26, 2017 at 10:47:40AM +0200, Hans Verkuil wrote:
>> On 26/09/17 00:25, Sakari Ailus wrote:
>>> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
>>> the device's own fwnode, it will follow child fwnodes with the given
>>> property-value pair and return the resulting fwnode.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-fwnode.c | 201 ++++++++++++++++++++++++++++++++++
>>>  1 file changed, 201 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
>>> index f739dfd16cf7..f93049c361e4 100644
>>> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
>>> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
>>> @@ -578,6 +578,207 @@ static int v4l2_fwnode_reference_parse(
>>>  	return ret;
>>>  }
>>>  
>>> +/*
>>> + * v4l2_fwnode_reference_get_int_prop - parse a reference with integer
>>> + *					arguments
>>> + * @dev: struct device pointer
>>> + * @notifier: notifier for @dev
>>> + * @prop: the name of the property
>>> + * @index: the index of the reference to get
>>> + * @props: the array of integer property names
>>> + * @nprops: the number of integer property names in @nprops
>>> + *
>>> + * Find fwnodes referred to by a property @prop, then under that
>>> + * iteratively, @nprops times, follow each child node which has a
>>> + * property in @props array at a given child index the value of which
>>> + * matches the integer argument at an index.
>>
>> "at an index". Still makes no sense to me. Which index?
> 
> How about this:
> 
> First find an fwnode referred to by the reference at @index in @prop.
> 
> Then under that fwnode, @nprops times, for each property in @props,
> iteratively follow child nodes starting from fwnode such that they have the
> property in @props array at the index of the child node distance from the

distance? You mean 'instance'?

> root node and the value of that property matching with the integer argument of
> the reference, at the same index.

You've completely lost me. About halfway through this sentence my brain crashed :-)

> 
>>
>>> + *
>>> + * For example, if this function was called with arguments and values
>>> + * @dev corresponding to device "SEN", @prop == "flash-leds", @index
>>> + * == 1, @props == { "led" }, @nprops == 1, with the ASL snippet below
>>> + * it would return the node marked with THISONE. The @dev argument in
>>> + * the ASL below.
>>
>> I know I asked for this before, but can you change the example to one where
>> nprops = 2? I think that will help understanding this.
> 
> I could do that but then the example no longer corresponds to any actual
> case that exists at the moment. LED nodes will use a single integer
> argument and lens-focus nodes none.

So? The example is here to understand the code and it doesn't have to be
related to actual hardware for a mainlined driver.

If you really don't want to do this here, then put the example in the commit
log. I don't see any reason why you can't put it here, though.

I think that once I see an 'nprops = 2' example I can rephrase that
brain-crash sentence for you...

BTW, where are the ACPI 'bindings' defined anyway? For DT they are in the
bindings directory, but where does ACPI define such things? Just curious.

Regards,

	Hans

> 
>>
>>> + *
>>> + *	Device (LED)
>>> + *	{
>>> + *		Name (_DSD, Package () {
>>> + *			ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
>>> + *			Package () {
>>> + *				Package () { "led0", "LED0" },
>>> + *				Package () { "led1", "LED1" },
>>> + *			}
>>> + *		})
>>> + *		Name (LED0, Package () {
>>> + *			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>>> + *			Package () {
>>> + *				Package () { "led", 0 },
>>> + *			}
>>> + *		})
>>> + *		Name (LED1, Package () {
>>> + *			// THISONE
>>> + *			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>>> + *			Package () {
>>> + *				Package () { "led", 1 },
>>> + *			}
>>> + *		})
>>> + *	}
>>> + *
>>> + *	Device (SEN)
>>> + *	{
>>> + *		Name (_DSD, Package () {
>>> + *			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>>> + *			Package () {
>>> + *				Package () {
>>> + *					"flash-leds",
>>> + *					Package () { ^LED, 0, ^LED, 1 },
>>> + *				}
>>> + *			}
>>> + *		})
>>> + *	}
>>> + *
>>> + * where
>>> + *
>>> + *	LED	LED driver device
>>> + *	LED0	First LED
>>> + *	LED1	Second LED
>>> + *	SEN	Camera sensor device (or another device the LED is
>>> + *		related to)
>>> + *
>>> + * Return: 0 on success
>>> + *	   -ENOENT if no entries (or the property itself) were found
>>> + *	   -EINVAL if property parsing otherwise failed
>>> + *	   -ENOMEM if memory allocation failed
>>> + */
>>> +static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
>>> +	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
>>> +	const char **props, unsigned int nprops)
>>> +{
>>> +	struct fwnode_reference_args fwnode_args;
>>> +	unsigned int *args = fwnode_args.args;
>>> +	struct fwnode_handle *child;
>>> +	int ret;
>>> +
>>> +	/*
>>> +	 * Obtain remote fwnode as well as the integer arguments.
>>> +	 *
>>> +	 * Note that right now both -ENODATA and -ENOENT may signal
>>> +	 * out-of-bounds access. Return -ENOENT in that case.
>>> +	 */
>>> +	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
>>> +						 index, &fwnode_args);
>>> +	if (ret)
>>> +		return ERR_PTR(ret == -ENODATA ? -ENOENT : ret);
>>> +
>>> +	/*
>>> +	 * Find a node in the tree under the referred fwnode corresponding the
>>
>> corresponding -> corresponding to
> 
> Fixed.
> 
>>
>>> +	 * integer arguments.
>>> +	 */
>>> +	fwnode = fwnode_args.fwnode;
>>> +	while (nprops--) {
>>> +		u32 val;
>>> +
>>> +		/* Loop over all child nodes under fwnode. */
>>> +		fwnode_for_each_child_node(fwnode, child) {
>>> +			if (fwnode_property_read_u32(child, *props, &val))
>>> +				continue;
>>> +
>>> +			/* Found property, see if its value matches. */
>>> +			if (val == *args)
>>> +				break;
>>> +		}
>>> +
>>> +		fwnode_handle_put(fwnode);
>>> +
>>> +		/* No property found; return an error here. */
>>> +		if (!child) {
>>> +			fwnode = ERR_PTR(-ENOENT);
>>> +			break;
>>> +		}
>>> +
>>> +		props++;
>>> +		args++;
>>> +		fwnode = child;
>>> +	}
>>> +
>>> +	return fwnode;
>>> +}
>>> +
>>> +/*
>>> + * v4l2_fwnode_reference_parse_int_props - parse references for async sub-devices
>>> + * @dev: struct device pointer
>>> + * @notifier: notifier for @dev
>>> + * @prop: the name of the property
>>> + * @props: the array of integer property names
>>> + * @nprops: the number of integer properties
>>> + *
>>> + * Use v4l2_fwnode_reference_get_int_prop to find fwnodes through reference in
>>> + * property @prop with integer arguments with child nodes matching in properties
>>> + * @props. Then, set up V4L2 async sub-devices for those fwnodes in the notifier
>>> + * accordingly.
>>> + *
>>> + * While it is technically possible to use this function on DT, it is only
>>> + * meaningful on ACPI. On Device tree you can refer to any node in the tree but
>>> + * on ACPI the references are limited to devices.
>>> + *
>>> + * Return: 0 on success
>>> + *	   -ENOENT if no entries (or the property itself) were found
>>> + *	   -EINVAL if property parsing otherwisefailed
>>> + *	   -ENOMEM if memory allocation failed
>>> + */
>>> +static int v4l2_fwnode_reference_parse_int_props(
>>> +	struct device *dev, struct v4l2_async_notifier *notifier,
>>> +	const char *prop, const char **props, unsigned int nprops)
>>> +{
>>> +	struct fwnode_handle *fwnode;
>>> +	unsigned int index;
>>> +	int ret;
>>> +
>>> +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
>>> +					 dev_fwnode(dev), prop, index, props,
>>> +					 nprops))); index++)
>>> +		fwnode_handle_put(fwnode);
>>> +
>>> +	/*
>>> +	 * Note that right now both -ENODATA and -ENOENT may signal
>>> +	 * out-of-bounds access. Return the error in cases other than that.
>>> +	 */
>>> +	if (PTR_ERR(fwnode) != -ENOENT && PTR_ERR(fwnode) != -ENODATA)
>>> +		return PTR_ERR(fwnode);
>>> +
>>> +	ret = v4l2_async_notifier_realloc(notifier,
>>> +					  notifier->num_subdevs + index);
>>> +	if (ret)
>>> +		return -ENOMEM;
>>> +
>>> +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
>>> +					 dev_fwnode(dev), prop, index, props,
>>> +					 nprops))); index++) {
>>> +		struct v4l2_async_subdev *asd;
>>> +
>>> +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
>>> +			ret = -EINVAL;
>>> +			goto error;
>>> +		}
>>> +
>>> +		asd = kzalloc(sizeof(struct v4l2_async_subdev), GFP_KERNEL);
>>> +		if (!asd) {
>>> +			ret = -ENOMEM;
>>> +			goto error;
>>> +		}
>>> +
>>> +		notifier->subdevs[notifier->num_subdevs] = asd;
>>> +		asd->match.fwnode.fwnode = fwnode;
>>> +		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
>>> +		notifier->num_subdevs++;
>>> +	}
>>> +
>>> +	return PTR_ERR(fwnode) == -ENOENT ? 0 : PTR_ERR(fwnode);
>>> +
>>> +error:
>>> +	fwnode_handle_put(fwnode);
>>> +	return ret;
>>> +}
>>> +
>>>  MODULE_LICENSE("GPL");
>>>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>>>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
>>>
>>
>> Regards,
>>
>> 	Hans
> 
