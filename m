Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47422 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751714AbdIMKEx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 06:04:53 -0400
Date: Wed, 13 Sep 2017 13:04:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v12 19/26] v4l: fwnode: Add a helper function to obtain
 device / interger references
Message-ID: <20170913100449.7pgg6pdglo3b43ml@valkosipuli.retiisi.org.uk>
References: <20170912134200.19556-1-sakari.ailus@linux.intel.com>
 <20170912134200.19556-20-sakari.ailus@linux.intel.com>
 <f92245da-0823-c95e-2208-b038f1bbb869@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f92245da-0823-c95e-2208-b038f1bbb869@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Sep 13, 2017 at 09:57:52AM +0200, Hans Verkuil wrote:
> The subject still has the 'interger' typo.
> 
> On 09/12/2017 03:41 PM, Sakari Ailus wrote:
> > v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
> > the device's own fwnode, it will follow child fwnodes with the given
> > property -- value pair and return the resulting fwnode.
> 
> As suggested before: 'property-value' is easier to read than ' -- '.

Oops. I must have missed some of your comments while making changes.
Apologies for that.

> 
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-fwnode.c | 145 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 145 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> > index a32473f95be1..a07599a8f647 100644
> > --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> > +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> > @@ -567,6 +567,151 @@ static int v4l2_fwnode_reference_parse(
> >  	return ret;
> >  }
> >  
> > +/*
> > + * v4l2_fwnode_reference_get_int_prop - parse a reference with integer
> > + *					arguments
> > + * @dev: struct device pointer
> > + * @notifier: notifier for @dev
> > + * @prop: the name of the property
> 
> @index is not documented.

Fixed.

> 
> > + * @props: the array of integer property names
> > + * @nprops: the number of integer properties
> 
> properties -> property names in @props

Fixed.

> 
> > + *
> > + * Find fwnodes referred to by a property @prop, then under that iteratively
> > + * follow each child node which has a property the value matches the integer
> 
> "the value" -> "whose value" or "with a value that"
> 
> At least, I think that's what you mean here.
> 
> How is @props/@nprops used?
> 
> > + * argument at an index.
> 
> I assume this should be "the @index"?

Um, no. This is the index to the @props array. I'll clarify the
documentation for this function.

> 
> > + *
> > + * Return: 0 on success
> > + *	   -ENOENT if no entries (or the property itself) were found
> > + *	   -EINVAL if property parsing otherwisefailed
> 
> Missing space before "failed"

Fixed.

> 
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
> > +	 * To-do: handle -ENODATA when "device property: Align return
> > +	 * codes of acpi_fwnode_get_reference_with_args" is merged.
> > +	 */
> > +	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
> > +						 index, &fwnode_args);
> > +	if (ret)
> > +		return ERR_PTR(ret == -ENODATA ? -ENOENT : ret);
> > +
> > +	/*
> > +	 * Find a node in the tree under the referred fwnode corresponding the
> 
> the -> to the

Fixed.

> 
> > +	 * integer arguments.
> > +	 */
> > +	fwnode = fwnode_args.fwnode;
> > +	while (nprops) {
> 
> This can be 'while (nprops--) {'.

Changed.

> 
> > +		u32 val;
> > +
> > +		/* Loop over all child nodes under fwnode. */
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
> > +		nprops--;
> > +	}
> > +
> > +	return fwnode;
> > +}
> 
> You really need to add an ACPI example as comment for this source code.

I can copy the relevant portions of the LED flash example, and remove them
once the example is merged to mainline. That example really doesn't belong
here though.

> 
> I still don't understand the code. I know you pointed me to an example,
> but I can't remember/find what it was. Either copy the example here or
> point to the file containing the example (copying is best IMHO).

:-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
