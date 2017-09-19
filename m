Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8898 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbdISIpj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 04:45:39 -0400
Date: Tue, 19 Sep 2017 11:45:34 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v13 18/25] v4l: fwnode: Add a helper function to obtain
 device / integer references
Message-ID: <20170919084534.ivgmrlmgywdwuhoa@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-19-sakari.ailus@linux.intel.com>
 <ee1252cf-3396-9bed-443f-56e3c2d621e5@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee1252cf-3396-9bed-443f-56e3c2d621e5@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Tue, Sep 19, 2017 at 10:31:41AM +0200, Hans Verkuil wrote:
> Hi Sakari,
> 
> I'm slowly starting to understand this. The example helped a lot. But I still have
> some questions, see below.
> 
> On 09/15/2017 04:17 PM, Sakari Ailus wrote:
> > v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
> > the device's own fwnode, it will follow child fwnodes with the given
> > property-value pair and return the resulting fwnode.
> 
> I think both the subject, commit log, function comment and function name should
> reflect the fact that this function is for an ACPI reference.
> 
> It's only called for ACPI (from patch 19):
> 
> +		if (props[i].props && is_acpi_node(dev_fwnode(dev)))
> +			ret = v4l2_fwnode_reference_parse_int_props(
> 
> So renaming it to v4l2_fwnode_acpi_reference_parse_int_props or something similar
> would clarify this fact.

I don't think we'll see many like this one. I presume we won't use it on DT
albeit there are no direct references to ACPI in the code itself.

How about v4l2_fwnode_parse_acpi_reference (+ "s" for the one below)?

> 
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-fwnode.c | 201 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 201 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> > index 65e84ea1cc35..968a345a288f 100644
> > --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> > +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> > @@ -567,6 +567,207 @@ static int v4l2_fwnode_reference_parse(
> >  	return ret;
> >  }
> >  
> > +/*
> > + * v4l2_fwnode_reference_get_int_prop - parse a reference with integer
> > + *					arguments
> > + * @dev: struct device pointer
> > + * @notifier: notifier for @dev
> > + * @prop: the name of the property
> > + * @index: the index of the reference to get
> > + * @props: the array of integer property names
> > + * @nprops: the number of integer property names in @nprops
> 
> You mean 'in @props'?

Yes, I'll fix that.

> 
> One thing that is not clear to me is when you would use an nprops value > 1.
> What's the use-case for that? It only makes sense (I think) if you would have
> property names that are all aliases of one another.

There may be several flash LEDs related to a sensor. That's the use case,
for instance.

> 
> > + *
> > + * Find fwnodes referred to by a property @prop, then under that
> > + * iteratively, @nprops times, follow each child node which has a
> > + * property in @props array at a given child index the value of which
> > + * matches the integer argument at an index.
> > + *
> > + * For example, if this function was called with arguments and values
> > + * @dev corresponding to device "SEN", @prop == "flash-leds", @index
> > + * == 1, @props == { "led" }, @nprops == 1, with the ASL snippet below
> > + * it would return the node marked with THISONE. The @dev argument in
> > + * the ASL below.
> 
> That last sentence about the @dev seems incomplete. I'm not sure what is
> meant by it.

I think it was meant to convey some information but it got added to the
previous sentence. I'll remove it.

> 
> > + *
> > + *	Device (LED)
> > + *	{
> > + *		Name (_DSD, Package () {
> > + *			ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> > + *			Package () {
> > + *				Package () { "led0", "LED0" },
> > + *				Package () { "led1", "LED1" },
> > + *			}
> > + *		})
> > + *		Name (LED0, Package () {
> > + *			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > + *			Package () {
> > + *				Package () { "led", 0 },
> > + *			}
> > + *		})
> > + *		Name (LED1, Package () {
> > + *			// THISONE
> > + *			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > + *			Package () {
> > + *				Package () { "led", 1 },
> > + *			}
> > + *		})
> > + *	}
> > + *
> > + *	Device (SEN)
> > + *	{
> > + *		Name (_DSD, Package () {
> > + *			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > + *			Package () {
> > + *				Package () {
> > + *					"flash-leds",
> > + *					Package () { ^LED, 0, ^LED, 1 },
> > + *				}
> > + *			}
> > + *		})
> > + *	}
> > + *
> > + * where
> > + *
> > + *	LED	LED driver device
> > + *	LED0	First LED
> > + *	LED1	Second LED
> > + *	SEN	Camera sensor device (or another device the LED is
> > + *		related to)
> > + *
> > + * Return: 0 on success
> > + *	   -ENOENT if no entries (or the property itself) were found
> > + *	   -EINVAL if property parsing otherwise failed
> > + *	   -ENOMEM if memory allocation failed
> > + */
> > +static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
> > +	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
> > +	const char **props, unsigned int nprops)
> > +{
> > +	struct fwnode_reference_args fwnode_args;
> > +	unsigned int *args = fwnode_args.args;
> > +	struct fwnode_handle *child;
> > +	int ret;
> > +
> > +	/*
> > +	 * Obtain remote fwnode as well as the integer arguments.
> > +	 *
> > +	 * Note that right now both -ENODATA and -ENOENT may signal
> > +	 * out-of-bounds access. Return -ENOENT in that case.
> > +	 */
> > +	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
> > +						 index, &fwnode_args);
> > +	if (ret)
> > +		return ERR_PTR(ret == -ENODATA ? -ENOENT : ret);
> > +
> > +	/*
> > +	 * Find a node in the tree under the referred fwnode corresponding the
> > +	 * integer arguments.
> > +	 */
> > +	fwnode = fwnode_args.fwnode;
> 
> So given the example above, fwnode would point to the LED device?
> 
> If correct, then mention that in the comment.

It could be a LED driver device, but it could be something else as well.
Like a lens VCM, depending on the property being parsed. That's why I
didn't put it in the comments. But this is a device node, not a
hierarchical data extension node, for instance. That's what I think I
should add.

> 
> > +	while (nprops--) {
> > +		u32 val;
> > +
> > +		/* Loop over all child nodes under fwnode. */
> 
> And here you check if the LED device has child nodes that have a *props
> property with a value matching the index.
> 
> So given the example above it is looking for a child with property "led"
> and value 1.
> 
> It's useful if that is mentioned in the comment as well.

But should I? This isn't specific to LEDs.

> 
> > +		fwnode_for_each_child_node(fwnode, child) {
> > +			if (fwnode_property_read_u32(child, *props, &val))
> > +				continue;
> > +
> > +			/* Found property, see if its value matches. */
> > +			if (val == *args)
> > +				break;
> > +		}
> > +
> > +		fwnode_handle_put(fwnode);
> > +
> > +		/* No property found; return an error here. */
> > +		if (!child) {
> > +			fwnode = ERR_PTR(-ENOENT);
> > +			break;
> > +		}
> > +
> > +		props++;
> > +		args++;
> > +		fwnode = child;
> > +	}
> > +
> > +	return fwnode;
> > +}
> > +
> > +/*
> > + * v4l2_fwnode_reference_parse_int_props - parse references for async sub-devices
> > + * @dev: struct device pointer
> > + * @notifier: notifier for @dev
> > + * @prop: the name of the property
> > + * @props: the array of integer property names
> > + * @nprops: the number of integer properties
> > + *
> > + * Use v4l2_fwnode_reference_get_int_prop to find fwnodes through reference in
> > + * property @prop with integer arguments with child nodes matching in properties
> > + * @props. Then, set up V4L2 async sub-devices for those fwnodes in the notifier
> > + * accordingly.
> > + *
> > + * While it is technically possible to use this function on DT, it is only
> > + * meaningful on ACPI. On Device tree you can refer to any node in the tree but
> > + * on ACPI the references are limited to devices.
> > + *
> > + * Return: 0 on success
> > + *	   -ENOENT if no entries (or the property itself) were found
> > + *	   -EINVAL if property parsing otherwisefailed
> > + *	   -ENOMEM if memory allocation failed
> > + */
> > +static int v4l2_fwnode_reference_parse_int_props(
> > +	struct device *dev, struct v4l2_async_notifier *notifier,
> > +	const char *prop, const char **props, unsigned int nprops)
> > +{
> > +	struct fwnode_handle *fwnode;
> > +	unsigned int index;
> > +	int ret;
> > +
> > +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
> > +					 dev_fwnode(dev), prop, index, props,
> > +					 nprops))); index++)
> > +		fwnode_handle_put(fwnode);
> > +
> > +	/*
> > +	 * Note that right now both -ENODATA and -ENOENT may signal
> > +	 * out-of-bounds access. Return the error in cases other than that.
> > +	 */
> > +	if (PTR_ERR(fwnode) != -ENOENT && PTR_ERR(fwnode) != -ENODATA)
> > +		return PTR_ERR(fwnode);
> > +
> > +	ret = v4l2_async_notifier_realloc(notifier,
> > +					  notifier->num_subdevs + index);
> > +	if (ret)
> > +		return -ENOMEM;
> > +
> > +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
> > +					 dev_fwnode(dev), prop, index, props,
> > +					 nprops))); index++) {
> > +		struct v4l2_async_subdev *asd;
> > +
> > +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
> > +			ret = -EINVAL;
> > +			goto error;
> > +		}
> > +
> > +		asd = kzalloc(sizeof(struct v4l2_async_subdev), GFP_KERNEL);
> > +		if (!asd) {
> > +			ret = -ENOMEM;
> > +			goto error;
> > +		}
> > +
> > +		notifier->subdevs[notifier->num_subdevs] = asd;
> > +		asd->match.fwnode.fwnode = fwnode;
> > +		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> > +		notifier->num_subdevs++;
> > +	}
> > +
> > +	return PTR_ERR(fwnode) == -ENOENT ? 0 : PTR_ERR(fwnode);
> > +
> > +error:
> > +	fwnode_handle_put(fwnode);
> > +	return ret;
> > +}
> > +
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
> >  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
