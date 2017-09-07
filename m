Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:34527 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754606AbdIGMEC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 08:04:02 -0400
Subject: Re: [PATCH v8 06/21] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, laurent.pinchart@ideasonboard.com,
        devicetree@vger.kernel.org, pavel@ucw.cz, sre@kernel.org
References: <20170905130553.1332-1-sakari.ailus@linux.intel.com>
 <20170905130553.1332-7-sakari.ailus@linux.intel.com>
 <dd3a2e55-8de0-c30e-04a7-cb26b519689c@xs4all.nl>
 <20170907073446.ajxsscekwrbfbtgk@valkosipuli.retiisi.org.uk>
 <85733523-7f6b-4aaf-55ca-e60e76719874@xs4all.nl>
 <20170907095850.m7mlag3tofwbj2jc@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8123f8c5-9045-2a22-c97f-09d36e504e2e@xs4all.nl>
Date: Thu, 7 Sep 2017 14:03:57 +0200
MIME-Version: 1.0
In-Reply-To: <20170907095850.m7mlag3tofwbj2jc@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/07/17 11:58, Sakari Ailus wrote:
> Hi Hans,
> 
> On Thu, Sep 07, 2017 at 10:51:21AM +0200, Hans Verkuil wrote:
>> On 09/07/17 09:34, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Wed, Sep 06, 2017 at 09:41:40AM +0200, Hans Verkuil wrote:
>>>> On 09/05/2017 03:05 PM, Sakari Ailus wrote:
>>>>> The current practice is that drivers iterate over their endpoints and
>>>>> parse each endpoint separately. This is very similar in a number of
>>>>> drivers, implement a generic function for the job. Driver specific matters
>>>>> can be taken into account in the driver specific callback.
>>>>>
>>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>>> ---
>>>>>  drivers/media/v4l2-core/v4l2-async.c  |  19 +++++
>>>>>  drivers/media/v4l2-core/v4l2-fwnode.c | 140 ++++++++++++++++++++++++++++++++++
>>>>>  include/media/v4l2-async.h            |  24 +++++-
>>>>>  include/media/v4l2-fwnode.h           |  53 +++++++++++++
>>>>>  4 files changed, 234 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
>>>>> index 3d81ff6a496f..7bd595c4094a 100644
>>>>> --- a/drivers/media/v4l2-core/v4l2-async.c
>>>>> +++ b/drivers/media/v4l2-core/v4l2-async.c
>>>>> @@ -22,6 +22,7 @@
>>>>>  
>>>>>  #include <media/v4l2-async.h>
>>>>>  #include <media/v4l2-device.h>
>>>>> +#include <media/v4l2-fwnode.h>
>>>>>  #include <media/v4l2-subdev.h>
>>>>>  
>>>>>  static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>>>>> @@ -224,6 +225,24 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
>>>>>  }
>>>>>  EXPORT_SYMBOL(v4l2_async_notifier_unregister);
>>>>>  
>>>>> +void v4l2_async_notifier_release(struct v4l2_async_notifier *notifier)
>>>>> +{
>>>>> +	unsigned int i;
>>>>> +
>>>>> +	if (!notifier->max_subdevs)
>>>>> +		return;
>>>>> +
>>>>> +	for (i = 0; i < notifier->num_subdevs; i++)
>>>>> +		kfree(notifier->subdevs[i]);
>>>>> +
>>>>> +	notifier->max_subdevs = 0;
>>>>> +	notifier->num_subdevs = 0;
>>>>> +
>>>>> +	kvfree(notifier->subdevs);
>>>>> +	notifier->subdevs = NULL;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(v4l2_async_notifier_release);
>>>>> +
>>>>>  int v4l2_async_register_subdev(struct v4l2_subdev *sd)
>>>>>  {
>>>>>  	struct v4l2_async_notifier *notifier;
>>>>> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>> index 706f9e7b90f1..e6932d7d47b6 100644
>>>>> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>> @@ -19,6 +19,7 @@
>>>>>   */
>>>>>  #include <linux/acpi.h>
>>>>>  #include <linux/kernel.h>
>>>>> +#include <linux/mm.h>
>>>>>  #include <linux/module.h>
>>>>>  #include <linux/of.h>
>>>>>  #include <linux/property.h>
>>>>> @@ -26,6 +27,7 @@
>>>>>  #include <linux/string.h>
>>>>>  #include <linux/types.h>
>>>>>  
>>>>> +#include <media/v4l2-async.h>
>>>>>  #include <media/v4l2-fwnode.h>
>>>>>  
>>>>>  enum v4l2_fwnode_bus_type {
>>>>> @@ -313,6 +315,144 @@ void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
>>>>>  }
>>>>>  EXPORT_SYMBOL_GPL(v4l2_fwnode_put_link);
>>>>>  
>>>>> +static int v4l2_async_notifier_realloc(struct v4l2_async_notifier *notifier,
>>>>> +				       unsigned int max_subdevs)
>>>>> +{
>>>>> +	struct v4l2_async_subdev **subdevs;
>>>>> +
>>>>> +	if (max_subdevs <= notifier->max_subdevs)
>>>>> +		return 0;
>>>>> +
>>>>> +	subdevs = kvmalloc_array(
>>>>> +		max_subdevs, sizeof(*notifier->subdevs),
>>>>> +		GFP_KERNEL | __GFP_ZERO);
>>>>> +	if (!subdevs)
>>>>> +		return -ENOMEM;
>>>>> +
>>>>> +	if (notifier->subdevs) {
>>>>> +		memcpy(subdevs, notifier->subdevs,
>>>>> +		       sizeof(*subdevs) * notifier->num_subdevs);
>>>>> +
>>>>> +		kvfree(notifier->subdevs);
>>>>> +	}
>>>>> +
>>>>> +	notifier->subdevs = subdevs;
>>>>> +	notifier->max_subdevs = max_subdevs;
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>> +static int v4l2_async_notifier_fwnode_parse_endpoint(
>>>>> +	struct device *dev, struct v4l2_async_notifier *notifier,
>>>>> +	struct fwnode_handle *endpoint, unsigned int asd_struct_size,
>>>>> +	int (*parse_endpoint)(struct device *dev,
>>>>> +			    struct v4l2_fwnode_endpoint *vep,
>>>>> +			    struct v4l2_async_subdev *asd))
>>>>> +{
>>>>> +	struct v4l2_async_subdev *asd;
>>>>> +	struct v4l2_fwnode_endpoint *vep;
>>>>> +	struct fwnode_endpoint ep;
>>>>> +	int ret = 0;
>>>>> +
>>>>> +	asd = kzalloc(asd_struct_size, GFP_KERNEL);
>>>>> +	if (!asd)
>>>>> +		return -ENOMEM;
>>>>> +
>>>>> +	asd->match.fwnode.fwnode =
>>>>> +		fwnode_graph_get_remote_port_parent(endpoint);
>>>>> +	if (!asd->match.fwnode.fwnode) {
>>>>> +		dev_warn(dev, "bad remote port parent\n");
>>>>> +		ret = -EINVAL;
>>>>> +		goto out_err;
>>>>> +	}
>>>>> +
>>>>> +	/* Ignore endpoints the parsing of which failed. */
>>>>> +	vep = v4l2_fwnode_endpoint_alloc_parse(endpoint);
>>>>> +	if (IS_ERR(vep)) {
>>>>> +		ret = PTR_ERR(vep);
>>>>> +		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
>>>>> +			 ret);
>>>>> +		goto out_err;
>>>>> +	}
>>>>> +
>>>>> +	ep = vep->base;
>>>>> +
>>>>> +	ret = parse_endpoint ? parse_endpoint(dev, vep, asd) : 0;
>>>>> +	v4l2_fwnode_endpoint_free(vep);
>>>>> +	if (ret == -ENOTCONN) {
>>>>> +		dev_dbg(dev, "ignoring endpoint %u,%u\n", ep.port, ep.id);
>>>>> +		kfree(asd);
>>>>
>>>> Shouldn't there be a call to fwnode_handle_put()?
>>>
>>> Actually no. But your hunch is right in the sense that I think there are
>>> issues. The fwnode_endpoint (as of_endpoint) contains the fwnode which is
>>> referenced, but no reference is taken here. One couldn't be released either
>>> later on, as the fwnode field is const.
>>>
>>> I guess this is almost fine as long as the fwnode field is used for pointer
>>> comparison and nothing else but you can never be sure what drivers actually
>>> do.
>>>
>>> This actually should be addressed for both OF and fwnode but it's mostly
>>> independent of this patchset. Luckily there are not *that* many users of
>>> this. The V4L2 fwnode interface that allocates and releases endpoints makes
>>> this quite a bit easier actually.
>>
>> I think a comment or two here would be helpful. If I tripped over this, so
>> will others.
> 
> Reading the code again, I noticed I didn't read far enough the last time.
> While v4l2_fwnode_endpoint_alloc_parse() won't take a reference,
> fwnode_graph_get_remote_port_parent() does. That reference indeed isn't
> released right now.
> 
> It shouldn't be too hard to do that properly in
> v4l2_async_notifier_release(). I guess I'll do just that actually. By that
> time, there are no users left anymore.
> 
> Good catch.
> 
>>
>>>
>>>>
>>>>> +		return 0;
>>>>> +	} else if (ret < 0) {
>>>>> +		dev_warn(dev, "driver could not parse endpoint %u,%u (%d)\n",
>>>>> +			 ep.port, ep.id, ret);
>>>>> +		goto out_err;
>>>>> +	}
>>>>
>>>> I think this would be better and it avoids the need for the ep local variable:
>>>>
>>>> 	ret = parse_endpoint ? parse_endpoint(dev, vep, asd) : 0;
>>>> 	if (ret == -ENOTCONN)
>>>> 		dev_dbg(dev, "ignoring endpoint %u,%u\n", vep->base.port, vep->base.id);
>>>> 	else if (ret < 0)
>>>> 		dev_warn(dev, "driver could not parse endpoint %u,%u (%d)\n",
>>>> 			 vep->base.port, vep->base.id, ret);
>>>> 	v4l2_fwnode_endpoint_free(vep);
>>>> 	if (ret < 0)
>>>> 		goto out_err;
>>>>
>>>> And the 'return ret;' below would become:
>>>>
>>>> 	return ret == -ENOTCONN ? 0 : ret;
>>>
>>> Looks good to me, I'll use it.
>>>
>>>>
>>>>> +
>>>>> +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
>>>>> +	notifier->subdevs[notifier->num_subdevs] = asd;
>>>>> +	notifier->num_subdevs++;
>>>>> +
>>>>> +	return 0;
>>>>> +
>>>>> +out_err:
>>>>> +	fwnode_handle_put(asd->match.fwnode.fwnode);
>>
>> Just a reminder: this put() should now check if ret != -ENOTCONN.
> 
> Should it? Even if ret == -ENOTCONN, the reference is there and needs to be
> released as the endpoint is not used (just as in the case of an error).

Well, in the previous reply you mentioned that the put wasn't necessary, hence
my comment. Since it is now needed again you can ignore this.

Regards,

	Hans

> 
>>
>>>>> +	kfree(asd);
>>>>> +
>>>>> +	return ret;
>>>>> +}
