Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:56776 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751292AbdJSGwb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 02:52:31 -0400
Subject: Re: [PATCH v15.1 24/32] v4l: fwnode: Add a helper function to obtain
 device / integer references
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
References: <20171004215051.13385-25-sakari.ailus@linux.intel.com>
 <20171018135656.13549-1-sakari.ailus@linux.intel.com>
 <20171018153225.i7ahk7fa3fullhur@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ffc57dfd-e798-d532-e029-dc91989e285c@xs4all.nl>
Date: Thu, 19 Oct 2017 08:52:22 +0200
MIME-Version: 1.0
In-Reply-To: <20171018153225.i7ahk7fa3fullhur@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2017 05:32 PM, Sakari Ailus wrote:
> On Wed, Oct 18, 2017 at 04:56:56PM +0300, Sakari Ailus wrote:
>> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
>> the device's own fwnode, it will follow child fwnodes with the given
>> property-value pair and return the resulting fwnode.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>> since v15:
>>
>> - Use a graph example instead of a LED one; this way nprops will be 2.
>>
>>  drivers/media/v4l2-core/v4l2-fwnode.c | 252 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 252 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
>> index edd2e8d983a1..989a6f8a09fa 100644
>> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
>> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
>> @@ -578,6 +578,258 @@ static int v4l2_fwnode_reference_parse(
>>  	return ret;
>>  }
>>  
>> +/*
>> + * v4l2_fwnode_reference_get_int_prop - parse a reference with integer
>> + *					arguments
>> + * @fwnode: fwnode to read @prop from
>> + * @notifier: notifier for @dev
>> + * @prop: the name of the property
>> + * @index: the index of the reference to get
>> + * @props: the array of integer property names
>> + * @nprops: the number of integer property names in @nprops
>> + *
>> + * First find an fwnode referred to by the reference at @index in @prop.
>> + *
>> + * Then under that fwnode, @nprops times, for each property in @props,
>> + * iteratively follow child nodes starting from fwnode such that they have the
>> + * property in @props array at the index of the child node distance from the
>> + * root node and the value of that property matching with the integer argument
>> + * of the reference, at the same index.
>> + *
>> + * The child fwnode reched at the end of the iteration is then returned to the
>> + * caller.
> 
> An alternative to these three paragraphs could be:
> 
> First obtain an fwnode, with integer arguments, referred to by the reference
> at @index in @prop. These shall be referred as "remote fwnode" and "remote
> fwnode arguments".
> 
> Under the remote fwnode, perform the following steps iteratively @nprops
> times. Let the number of iteration be "i", starting from 0.
> 
> 1. Designate the remote fwnode as the "current fwnode".
> 
> 2. Begin iterating child fwnodes under the current fwnode.
> 
> 3. Find next child fwnode under the current fwnode. If no node is found,
>    return NULL.
> 
> 4. From the child fwnode, read 32-bit unsigned integer property named as
>    the i'th element in @props array.
> 
> 5. Compare the value of that integer property with the i'th element in the
>    remote fwnode argument array. If the values do not match, go to (3).
> 
> 6. Increment i by one. If i matches with @nprops, return the child fwnode.
> 
> 7. Designate the child fwnode as the current fwnode and continue from (2).

This is definitely a better text.

However, this describes the mechanics of the function, not what its purpose
actually is.

The core reason for this is that you cannot refer to just any node in ACPI.
So to refer to an endpoint (easy in DT) you need to refer to a device, then
provide a list of (property name, property value) tuples where each tuple
uniquely identifies a child node. The first tuple identifies a child directly
underneath the device fwnode, the next tuple identifies a child node underneath
the fwnode identified by the previous tuple, etc. until you reached the fwnode
you need.

Does this make sense?

> 
>> + *
>> + * An example with a graph, as defined in Documentation/acpi/dsd/graph.txt:
>> + *
>> + *	Scope (\_SB.PCI0.I2C2)
>> + *	{
>> + *		Device (CAM0)
>> + *		{
>> + *			Name (_DSD, Package () {
>> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> + *				Package () {
>> + *					Package () {
>> + *						"compatible",
>> + *						Package () { "nokia,smia" }
>> + *					},
>> + *				},
>> + *				ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
>> + *				Package () {
>> + *					Package () { "port0", "PRT0" },
>> + *				}
>> + *			})
>> + *			Name (PRT0, Package() {
>> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> + *				Package () {
>> + *					Package () { "port", 0 },
>> + *				},
>> + *				ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
>> + *				Package () {
>> + *					Package () { "endpoint0", "EP00" },
>> + *				}
>> + *			})
>> + *			Name (EP00, Package() {
>> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> + *				Package () {
>> + *					Package () { "endpoint", 0 },
>> + *					Package () {
>> + *						"remote-endpoint",
>> + *						Package() {
>> + *							\_SB.PCI0.ISP, 4, 0
>> + *						}
>> + *					},
>> + *				}
>> + *			})
>> + *		}
>> + *	}
>> + *
>> + *	Scope (\_SB.PCI0)
>> + *	{
>> + *		Device (ISP)
>> + *		{
>> + *			Name (_DSD, Package () {
>> + *				ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
>> + *				Package () {
>> + *					Package () { "port4", "PRT4" },
>> + *				}
>> + *			})
>> + *
>> + *			Name (PRT4, Package() {
>> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> + *				Package () {
>> + *					Package () { "port", 4 },
>> + *				},
>> + *				ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
>> + *				Package () {
>> + *					Package () { "endpoint0", "EP40" },
>> + *				}
>> + *			})
>> + *
>> + *			Name (EP40, Package() {
>> + *				ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>> + *				Package () {
>> + *					Package () { "endpoint", 0 },
>> + *					Package () {
>> + *						"remote-endpoint",
>> + *						Package () {
>> + *							\_SB.PCI0.I2C2.CAM0,
>> + *							0, 0
>> + *						}
>> + *					},
>> + *				}
>> + *			})
>> + *		}
>> + *	}

Please provide the equivalent DT structure as well. A large part of the
problem was lack of ACPI syntax understanding on my side.

>> + *
>> + * From the EP40 node under ISP device, you could parse the graph remote
>> + * endpoint using v4l2_fwnode_reference_get_int_prop with these arguments:
>> + *
>> + *  @fwnode: fwnode referring to EP40 under ISP.
>> + *  @prop: "remote-endpoint"
>> + *  @index: 0
>> + *  @props: "port", "endpoint"
>> + *  @nprops: 2
>> + *
>> + * And you'd get back fwnode referring to EP00 under CAM0.
>> + *
>> + * The same works the other way around: if you use EP00 under CAM0 as the
>> + * fwnode, you'll get fwnode referring to EP40 under ISP.
>> + *
>> + * Return: 0 on success
>> + *	   -ENOENT if no entries (or the property itself) were found
>> + *	   -EINVAL if property parsing otherwise failed
>> + *	   -ENOMEM if memory allocation failed
>> + */
>> +static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
>> +	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
>> +	const char **props, unsigned int nprops)
>> +{
>> +	struct fwnode_reference_args fwnode_args;
>> +	unsigned int *args = fwnode_args.args;
>> +	struct fwnode_handle *child;
>> +	int ret;
>> +
>> +	/*
>> +	 * Obtain remote fwnode as well as the integer arguments.
>> +	 *
>> +	 * Note that right now both -ENODATA and -ENOENT may signal
>> +	 * out-of-bounds access. Return -ENOENT in that case.
>> +	 */
>> +	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
>> +						 index, &fwnode_args);
>> +	if (ret)
>> +		return ERR_PTR(ret == -ENODATA ? -ENOENT : ret);
>> +
>> +	/*
>> +	 * Find a node in the tree under the referred fwnode corresponding to
>> +	 * the integer arguments.
>> +	 */
>> +	fwnode = fwnode_args.fwnode;
>> +	while (nprops--) {
>> +		u32 val;
>> +
>> +		/* Loop over all child nodes under fwnode. */
>> +		fwnode_for_each_child_node(fwnode, child) {
>> +			if (fwnode_property_read_u32(child, *props, &val))
>> +				continue;
>> +
>> +			/* Found property, see if its value matches. */
>> +			if (val == *args)
>> +				break;
>> +		}
>> +
>> +		fwnode_handle_put(fwnode);
>> +
>> +		/* No property found; return an error here. */
>> +		if (!child) {
>> +			fwnode = ERR_PTR(-ENOENT);
>> +			break;
>> +		}
>> +
>> +		props++;
>> +		args++;
>> +		fwnode = child;
>> +	}
>> +
>> +	return fwnode;
>> +}
>> +
>> +/*
>> + * v4l2_fwnode_reference_parse_int_props - parse references for async sub-devices
>> + * @dev: struct device pointer
>> + * @notifier: notifier for @dev
>> + * @prop: the name of the property
>> + * @props: the array of integer property names
>> + * @nprops: the number of integer properties
>> + *
>> + * Use v4l2_fwnode_reference_get_int_prop to find fwnodes through reference in
>> + * property @prop with integer arguments with child nodes matching in properties
>> + * @props. Then, set up V4L2 async sub-devices for those fwnodes in the notifier
>> + * accordingly.
>> + *
>> + * While it is technically possible to use this function on DT, it is only
>> + * meaningful on ACPI. On Device tree you can refer to any node in the tree but
>> + * on ACPI the references are limited to devices.
>> + *
>> + * Return: 0 on success
>> + *	   -ENOENT if no entries (or the property itself) were found
>> + *	   -EINVAL if property parsing otherwisefailed
>> + *	   -ENOMEM if memory allocation failed
>> + */
>> +static int v4l2_fwnode_reference_parse_int_props(
>> +	struct device *dev, struct v4l2_async_notifier *notifier,
>> +	const char *prop, const char **props, unsigned int nprops)
>> +{
>> +	struct fwnode_handle *fwnode;
>> +	unsigned int index;
>> +	int ret;
>> +
>> +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
>> +					 dev_fwnode(dev), prop, index, props,
>> +					 nprops))); index++)
>> +		fwnode_handle_put(fwnode);
>> +
>> +	/*
>> +	 * Note that right now both -ENODATA and -ENOENT may signal
>> +	 * out-of-bounds access. Return the error in cases other than that.
>> +	 */
>> +	if (PTR_ERR(fwnode) != -ENOENT && PTR_ERR(fwnode) != -ENODATA)
>> +		return PTR_ERR(fwnode);
>> +
>> +	ret = v4l2_async_notifier_realloc(notifier,
>> +					  notifier->num_subdevs + index);
>> +	if (ret)
>> +		return -ENOMEM;
>> +
>> +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
>> +					 dev_fwnode(dev), prop, index, props,
>> +					 nprops))); index++) {
>> +		struct v4l2_async_subdev *asd;
>> +
>> +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
>> +			ret = -EINVAL;
>> +			goto error;
>> +		}
>> +
>> +		asd = kzalloc(sizeof(struct v4l2_async_subdev), GFP_KERNEL);
>> +		if (!asd) {
>> +			ret = -ENOMEM;
>> +			goto error;
>> +		}
>> +
>> +		notifier->subdevs[notifier->num_subdevs] = asd;
>> +		asd->match.fwnode.fwnode = fwnode;
>> +		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
>> +		notifier->num_subdevs++;
>> +	}
>> +
>> +	return PTR_ERR(fwnode) == -ENOENT ? 0 : PTR_ERR(fwnode);
>> +
>> +error:
>> +	fwnode_handle_put(fwnode);
>> +	return ret;
>> +}
>> +
>>  MODULE_LICENSE("GPL");
>>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
>>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
>> -- 
>> 2.11.0
>>
> 

Regards,

	Hans
