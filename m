Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:58169 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750952AbdISKKX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 06:10:23 -0400
Subject: Re: [PATCH v13 05/25] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-6-sakari.ailus@linux.intel.com>
 <a17ab793-b859-f04a-2dff-d8f6a314e9bf@xs4all.nl>
 <20170919082015.vt6olgirnvmpcrpa@paasikivi.fi.intel.com>
 <af99e12c-6fb8-a633-eec2-c1eb9d82226a@xs4all.nl>
 <20170919100048.7jut3benh2vbb32q@paasikivi.fi.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0e18e159-51cc-1473-86c9-ffb9ee4212a8@xs4all.nl>
Date: Tue, 19 Sep 2017 12:10:18 +0200
MIME-Version: 1.0
In-Reply-To: <20170919100048.7jut3benh2vbb32q@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/17 12:00, Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, Sep 19, 2017 at 10:40:14AM +0200, Hans Verkuil wrote:
>> On 09/19/2017 10:20 AM, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> Thank you for the review.
>>>
>>> On Tue, Sep 19, 2017 at 10:03:27AM +0200, Hans Verkuil wrote:
>>>> On 09/15/2017 04:17 PM, Sakari Ailus wrote:
> ...
>>>>> +static int __v4l2_async_notifier_parse_fwnode_endpoints(
>>>>> +	struct device *dev, struct v4l2_async_notifier *notifier,
>>>>> +	size_t asd_struct_size, unsigned int port, bool has_port,
>>>>> +	int (*parse_endpoint)(struct device *dev,
>>>>> +			    struct v4l2_fwnode_endpoint *vep,
>>>>> +			    struct v4l2_async_subdev *asd))
>>>>> +{
>>>>> +	struct fwnode_handle *fwnode = NULL;
>>>>> +	unsigned int max_subdevs = notifier->max_subdevs;
>>>>> +	int ret;
>>>>> +
>>>>> +	if (WARN_ON(asd_struct_size < sizeof(struct v4l2_async_subdev)))
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
>>>>> +				     dev_fwnode(dev), fwnode)); ) {
>>>>
>>>> You can replace this by:
>>>>
>>>> 	while ((fwnode = fwnode_graph_get_next_endpoint(dev_fwnode(dev), fwnode))) {
>>>>
>>>>> +		if (!fwnode_device_is_available(
>>>>> +			    fwnode_graph_get_port_parent(fwnode)))
>>>>> +			continue;
>>>>> +
>>>>> +		if (has_port) {
>>>>> +			struct fwnode_endpoint ep;
>>>>> +
>>>>> +			ret = fwnode_graph_parse_endpoint(fwnode, &ep);
>>>>> +			if (ret) {
>>>>> +				fwnode_handle_put(fwnode);
>>>>> +				return ret;
>>>>> +			}
>>>>> +
>>>>> +			if (ep.port != port)
>>>>> +				continue;
>>>>> +		}
>>>>> +		max_subdevs++;
>>>>> +	}
>>>>> +
>>>>> +	/* No subdevs to add? Return here. */
>>>>> +	if (max_subdevs == notifier->max_subdevs)
>>>>> +		return 0;
>>>>> +
>>>>> +	ret = v4l2_async_notifier_realloc(notifier, max_subdevs);
>>>>> +	if (ret)
>>>>> +		return ret;
>>>>> +
>>>>> +	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
>>>>> +				     dev_fwnode(dev), fwnode)); ) {
>>>>
>>>> Same here: this can be a 'while'.
>>>
>>> The fwnode = NULL assignment still needs to be done. A for loop has a
>>> natural initialiser for the loop, I think it's cleaner than using while
>>> here.
>>
>> After the previous while fwnode is NULL again (since that's when the while
>> stops).
>>
>>>
>>> The macro would be implemented this way as well.
>>>
>>> For the loop above this one, I'd use for for consistency: it's the same
>>> loop after all.
>>>
>>> This reminds me --- I'll send the patch for the macro.
>>
>> If this is going to be replaced by a macro, then disregard my comment.
> 
> Yes. I just sent that to linux-acpi (as well as devicetree and to you).
> 
> ...
> 
>>>>> +/**
>>>>> + * v4l2_async_notifier_parse_fwnode_endpoints - Parse V4L2 fwnode endpoints in a
>>>>> + *						device node
>>>>> + * @dev: the device the endpoints of which are to be parsed
>>>>> + * @notifier: notifier for @dev
>>>>> + * @asd_struct_size: size of the driver's async sub-device struct, including
>>>>> + *		     sizeof(struct v4l2_async_subdev). The &struct
>>>>> + *		     v4l2_async_subdev shall be the first member of
>>>>> + *		     the driver's async sub-device struct, i.e. both
>>>>> + *		     begin at the same memory address.
>>>>> + * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
>>>>> + *		    endpoint. Optional.
>>>>> + *		    Return: %0 on success
>>>>> + *			    %-ENOTCONN if the endpoint is to be skipped but this
>>>>> + *				       should not be considered as an error
>>>>> + *			    %-EINVAL if the endpoint configuration is invalid
>>>>> + *
>>>>> + * Parse the fwnode endpoints of the @dev device and populate the async sub-
>>>>> + * devices array of the notifier. The @parse_endpoint callback function is
>>>>> + * called for each endpoint with the corresponding async sub-device pointer to
>>>>> + * let the caller initialize the driver-specific part of the async sub-device
>>>>> + * structure.
>>>>> + *
>>>>> + * The notifier memory shall be zeroed before this function is called on the
>>>>> + * notifier.
>>>>> + *
>>>>> + * This function may not be called on a registered notifier and may be called on
>>>>> + * a notifier only once.
>>>>> + *
>>>>> + * Do not change the notifier's subdevs array, take references to the subdevs
>>>>> + * array itself or change the notifier's num_subdevs field. This is because this
>>>>> + * function allocates and reallocates the subdevs array based on parsing
>>>>> + * endpoints.
>>>>> + *
>>>>> + * The @struct v4l2_fwnode_endpoint passed to the callback function
>>>>> + * @parse_endpoint is released once the function is finished. If there is a need
>>>>> + * to retain that configuration, the user needs to allocate memory for it.
>>>>> + *
>>>>> + * Any notifier populated using this function must be released with a call to
>>>>> + * v4l2_async_notifier_release() after it has been unregistered and the async
>>>>> + * sub-devices are no longer in use, even if the function returned an error.
>>>>> + *
>>>>> + * Return: %0 on success, including when no async sub-devices are found
>>>>> + *	   %-ENOMEM if memory allocation failed
>>>>> + *	   %-EINVAL if graph or endpoint parsing failed
>>>>> + *	   Other error codes as returned by @parse_endpoint
>>>>> + */
>>>>> +int v4l2_async_notifier_parse_fwnode_endpoints(
>>>>> +	struct device *dev, struct v4l2_async_notifier *notifier,
>>>>> +	size_t asd_struct_size,
>>>>> +	int (*parse_endpoint)(struct device *dev,
>>>>> +			      struct v4l2_fwnode_endpoint *vep,
>>>>> +			      struct v4l2_async_subdev *asd));
>>>>> +
>>>>> +/**
>>>>> + * v4l2_async_notifier_parse_fwnode_endpoints_by_port - Parse V4L2 fwnode
>>>>> + *							endpoints of a port in a
>>>>> + *							device node
>>>>> + * @dev: the device the endpoints of which are to be parsed
>>>>> + * @notifier: notifier for @dev
>>>>> + * @asd_struct_size: size of the driver's async sub-device struct, including
>>>>> + *		     sizeof(struct v4l2_async_subdev). The &struct
>>>>> + *		     v4l2_async_subdev shall be the first member of
>>>>> + *		     the driver's async sub-device struct, i.e. both
>>>>> + *		     begin at the same memory address.
>>>>> + * @port: port number where endpoints are to be parsed
>>>>> + * @parse_endpoint: Driver's callback function called on each V4L2 fwnode
>>>>> + *		    endpoint. Optional.
>>>>> + *		    Return: %0 on success
>>>>> + *			    %-ENOTCONN if the endpoint is to be skipped but this
>>>>> + *				       should not be considered as an error
>>>>> + *			    %-EINVAL if the endpoint configuration is invalid
>>>>> + *
>>>>> + * This function is just like @v4l2_async_notifier_parse_fwnode_endpoints with
>>>>> + * the exception that it only parses endpoints in a given port. This is useful
>>>>> + * on devices that have both sinks and sources: the async sub-devices connected
>>>>
>>>> on -> for
>>>>
>>>>> + * to sources have already been set up by another driver (on capture devices).
>>>>
>>>> on -> for
>>>
>>> Agreed on both.
>>>
>>>>
>>>> So if I understand this correctly for devices with both sinks and sources you use
>>>> this function to just parse the sink ports. And you have to give explicit port
>>>> numbers since you can't tell from parsing the device tree if a port is a sink or
>>>> source port, right? Only the driver knows this.
>>>
>>> Correct. The graph data structure in DT isn't directed, so this is only
>>> known by the driver.
>>
>> I think this should be clarified.
>>
>> I wonder if there is any way around it. I don't have time to dig into this, but
>> isn't it possible to tell that the source ports are already configured?
> 
> Well, this is essentially what the documentation is attempting to convey.
> :-)
> 
> I can add this / change the existing wording, if you think it could help.

Yes please. The documentation is just missing the little fact that the DT can't
tell the difference between a sink and source port, hence the driver has to be
explicit about which ports to parse in a case like this.

Regards,

	Hans
