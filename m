Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52698 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750842AbdIKN1O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 09:27:14 -0400
Date: Mon, 11 Sep 2017 16:27:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        linux-acpi@vger.kernel.org, mika.westerberg@intel.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v10 18/24] v4l: fwnode: Add a helper function to obtain
 device / interger references
Message-ID: <20170911132710.mcgqn6tbiabzvpqq@valkosipuli.retiisi.org.uk>
References: <20170911080008.21208-1-sakari.ailus@linux.intel.com>
 <20170911080008.21208-19-sakari.ailus@linux.intel.com>
 <11c951eb-0315-0149-829e-ed73d748e783@xs4all.nl>
 <20170911122820.fkbd2rnaddiestab@valkosipuli.retiisi.org.uk>
 <2e2eba02-39bc-11e1-d9f1-b83a6f580667@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e2eba02-39bc-11e1-d9f1-b83a6f580667@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Sep 11, 2017 at 02:38:23PM +0200, Hans Verkuil wrote:
> On 09/11/2017 02:28 PM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > Thanks for the review.
> > 
> > On Mon, Sep 11, 2017 at 11:38:58AM +0200, Hans Verkuil wrote:
> >> Typo in subject: interger -> integer
> >>
> >> On 09/11/2017 10:00 AM, Sakari Ailus wrote:
> >>> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
> >>> the device's own fwnode, 
> >>
> >> Sorry, you lost me here. Which device are we talking about?
> > 
> > The fwnode related a struct device, in other words what dev_fwnode(dev)
> > gives you. This is either struct device.fwnode or struct
> > device.of_node.fwnode, depending on which firmware interface was used to
> > create the device.
> > 
> > I'll add a note of this.
> > 
> >>
> >>> it will follow child fwnodes with the given
> >>> property -- value pair and return the resulting fwnode.
> >>
> >> property-value pair (easier readable that way).
> >>
> >> You only describe v4l2_fwnode_reference_parse_int_prop(), not
> >> v4l2_fwnode_reference_parse_int_props().
> > 
> > Yes, I think I changed the naming but forgot to update the commit. I'll do
> > that now.
> > 
> >>
> >>>
> >>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>> ---
> >>>  drivers/media/v4l2-core/v4l2-fwnode.c | 93 +++++++++++++++++++++++++++++++++++
> >>>  1 file changed, 93 insertions(+)
> >>>
> >>> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> >>> index 4821c4989119..56eee5bbd3b5 100644
> >>> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> >>> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> >>> @@ -496,6 +496,99 @@ static int v4l2_fwnode_reference_parse(
> >>>  	return ret;
> >>>  }
> >>>  
> >>> +static struct fwnode_handle *v4l2_fwnode_reference_get_int_prop(
> >>> +	struct fwnode_handle *fwnode, const char *prop, unsigned int index,
> >>> +	const char **props, unsigned int nprops)
> >>
> >> Need comments describing what this does.
> > 
> > Yes. I'll also rename it (get -> read) for consistency with the async
> > changes.
> 
> Which async changes? Since the fwnode_handle that's returned is refcounted
> I wonder if 'get' isn't the right name in this case.

Right. True. I'll leave that as-is then.

> 
> > 
> >>
> >>> +{
> >>> +	struct fwnode_reference_args fwnode_args;
> >>> +	unsigned int *args = fwnode_args.args;
> >>> +	struct fwnode_handle *child;
> >>> +	int ret;
> >>> +
> >>> +	ret = fwnode_property_get_reference_args(fwnode, prop, NULL, nprops,
> >>> +						 index, &fwnode_args);
> >>> +	if (ret)
> >>> +		return ERR_PTR(ret == -EINVAL ? -ENOENT : ret);
> >>
> >> Why map EINVAL to ENOENT? Needs a comment, either here or in the function description.
> > 
> > fwnode_property_get_reference_args() returns currently a little bit
> > different error codes in ACPI / DT. This is worth documenting there and
> > fixing as well.
> > 
> >>
> >>> +
> >>> +	for (fwnode = fwnode_args.fwnode;
> >>> +	     nprops; nprops--, fwnode = child, props++, args++) {
> >>
> >> I think you cram too much in this for-loop: fwnode, nprops, fwnode, props, args...
> >> It's hard to parse.
> > 
> > Hmm. I'm not sure if that really helps; the function is just handling each
> > entry in the array and related array pointers are changed accordingly. The
> > fwnode = child assignment is there to move to the child node. I.e. what you
> > need for handling the loop itself.
> > 
> > I can change this though if you think it really makes a difference for
> > better.
> 
> I think so, yes. I noticed you like complex for-loops :-)

I don't really see a difference. The loop increment will just move at the
end of the block inside the loop.

> 
> > 
> >>
> >> I would make this a 'while (nprops)' and write out all the other assignments,
> >> increments and decrements.
> >>
> >>> +		u32 val;
> >>> +
> >>> +		fwnode_for_each_child_node(fwnode, child) {
> >>> +			if (fwnode_property_read_u32(child, *props, &val))
> >>> +				continue;
> >>> +
> >>> +			if (val == *args)
> >>> +				break;
> >>
> >> I'm lost. This really needs comments and perhaps even an DT or ACPI example
> >> so you can see what exactly it is we're doing here.
> > 
> > I'll add comments to the code. A good example will be ACPI documentation
> > for LEDs, see 17th patch in v9. That will go through the linux-pm tree so
> > it won't be available in the same tree for a while.
> 
> Ideally an ACPI and an equivalent DT example would be nice to have, but I might
> be asking too much. I'm not that familiar with ACPI, so for me a DT example
> is easier.

This won't be useful on DT although you could technically use it. In DT you
can directly refer to any node but on ACPI you can just refer to devices,
hence this.

Would you be happy with the leds.txt example? I think it's a good example
as it's directly related to this.

> 
> > 
> >>
> >>> +		}
> >>> +
> >>> +		fwnode_handle_put(fwnode);
> >>> +
> >>> +		if (!child) {
> >>> +			fwnode = ERR_PTR(-ENOENT);
> >>> +			break;
> >>> +		}
> >>> +	}
> >>> +
> >>> +	return fwnode;
> >>> +}
> >>> +
> >>> +static int v4l2_fwnode_reference_parse_int_props(
> >>> +	struct device *dev, struct v4l2_async_notifier *notifier,
> >>> +	const char *prop, const char **props, unsigned int nprops)
> >>
> >> Needs comments describing what this does.
> > 
> > Will add.
> > 
> >>
> >>> +{
> >>> +	struct fwnode_handle *fwnode;
> >>> +	unsigned int index = 0;
> >>> +	int ret;
> >>> +
> >>> +	while (!IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
> >>> +				dev_fwnode(dev), prop, index, props,
> >>> +				nprops)))) {
> >>> +		fwnode_handle_put(fwnode);
> >>> +		index++;
> >>> +	}
> >>> +
> >>> +	if (PTR_ERR(fwnode) != -ENOENT)
> >>> +		return PTR_ERR(fwnode);
> >>
> >> Missing 'if (index == 0)'?
> > 
> > Yes, will add.
> > 
> >>
> >>> +
> >>> +	ret = v4l2_async_notifier_realloc(notifier,
> >>> +					  notifier->num_subdevs + index);
> >>> +	if (ret)
> >>> +		return -ENOMEM;
> >>> +
> >>> +	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
> >>> +					 dev_fwnode(dev), prop, index, props,
> >>> +					 nprops))); ) {
> >>
> >> I'd add 'index++' in this for-loop. It's weird that it is missing.
> > 
> > Agreed, I'll move it there.
> > 
> >>
> >>> +		struct v4l2_async_subdev *asd;
> >>> +
> >>> +		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
> >>> +			ret = -EINVAL;
> >>> +			goto error;
> >>> +		}
> >>> +
> >>> +		asd = kzalloc(sizeof(struct v4l2_async_subdev), GFP_KERNEL);
> >>> +		if (!asd) {
> >>> +			ret = -ENOMEM;
> >>> +			goto error;
> >>> +		}
> >>> +
> >>> +		notifier->subdevs[notifier->num_subdevs] = asd;
> >>> +		asd->match.fwnode.fwnode = fwnode;
> >>> +		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> >>> +		notifier->num_subdevs++;
> >>> +
> >>> +		fwnode_handle_put(fwnode);
> >>> +
> >>> +		index++;
> >>> +	}
> >>> +
> >>> +	return PTR_ERR(fwnode) == -ENOENT ? 0 : PTR_ERR(fwnode);
> >>> +
> >>> +error:
> >>> +	fwnode_handle_put(fwnode);
> >>> +	return ret;
> >>> +}
> >>> +
> >>>  MODULE_LICENSE("GPL");
> >>>  MODULE_AUTHOR("Sakari Ailus <sakari.ailus@linux.intel.com>");
> >>>  MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
> >>>
> > 
> 
> Regards,
> 
> 	Hans

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
