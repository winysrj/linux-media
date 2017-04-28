Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52691 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030532AbdD1AAx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 20:00:53 -0400
Subject: Re: [PATCH 1/5] v4l2-subdev: Provide a port mapping for asynchronous
 subdevs
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
 <1493317564-18026-2-git-send-email-kbingham@kernel.org>
 <20170427214346.GB7456@valkosipuli.retiisi.org.uk>
 <d6295abe-5f04-5896-a582-e79d65f0a2ad@ideasonboard.com>
 <20170427224940.GC7456@valkosipuli.retiisi.org.uk>
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <74b2997d-cada-a486-737d-fc21f34a9570@ideasonboard.com>
Date: Fri, 28 Apr 2017 01:00:46 +0100
MIME-Version: 1.0
In-Reply-To: <20170427224940.GC7456@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/04/17 23:49, Sakari Ailus wrote:
> Hi Kieran,
> 
> On Thu, Apr 27, 2017 at 11:13:50PM +0100, Kieran Bingham wrote:
>> Hi Sakari,
>>
>> Thanks for taking a look
> 
> Sure! :-)
> 
>>
>> On 27/04/17 22:43, Sakari Ailus wrote:
>>> Hi Kieran,
>>>
>>> Could I ask you to rebase your patches on top of my V4L2 fwnode patches
>>> here?
>>>
>>> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>
>>>
>>> It depends on the fwnode graph patches, merged here:
>>>
>>> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi-merge>
>>>
>>> I expect the fwnode graph patches in v4.12 so we'll have them in media-tree
>>> master soon.
>>>
>>> (I'm pushing these branches right now, it may take a while until it's really
>>> there.)
>>
>> Sure, I'll merge those into my base.
>>
>>> On Thu, Apr 27, 2017 at 07:26:00PM +0100, Kieran Bingham wrote:
>>>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>>
>>>> Devices such as the the ADV748x support multiple parallel stream routes
>>>> through a single chip. This leads towards needing to provide multiple
>>>> distinct entities and subdevs from a single device-tree node.
>>>>
>>>> To distinguish these separate outputs, the device-tree binding must
>>>> specify each endpoint link with a unique (to the device) non-zero port
>>>> number.
>>>>
>>>> This number allows async subdev registrations to identify the correct
>>>> subdevice to bind and link.
>>>>
>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>> ---
>>>>  drivers/media/v4l2-core/v4l2-async.c  | 7 +++++++
>>>>  drivers/media/v4l2-core/v4l2-subdev.c | 1 +
>>>>  include/media/v4l2-async.h            | 1 +
>>>>  include/media/v4l2-subdev.h           | 2 ++
>>>>  4 files changed, 11 insertions(+)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
>>>> index 1815e54e8a38..875e6ce646ec 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-async.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-async.c
>>>> @@ -42,6 +42,13 @@ static bool match_devname(struct v4l2_subdev *sd,
>>>>  
>>>>  static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
>>>>  {
>>>> +	/*
>>>> +	 * If set, we must match the device tree port, with the subdev port.
>>>> +	 * This is a fast match, so do this first
>>>> +	 */
>>>> +	if (sd->port && sd->port != asd->match.of.port)
>>>
>>> Zero is an entirely valid value for a port. I think it'd be good not to
>>> depend on non-zero port values for port matching.
>>
>> Well then that pretty much dashes my chances on not parsing the DT in the ADV
>> driver.
> 
> Hmm. I guess there's no really a way to avoid it. But we could make it
> easier 
> 
>>
>>
>>
>>>> +		return -1;
>>>
>>> Any particular reason to return -1 from a function with bool return type?
>>
>> Ahem, I clearly can't read ;-)
>> I think my mindset was thinking strcmp or something...
> 
> But -1 is perfectly valid. If you wanted to make it look really interesting,
> you could return -!false and still have exactly the same functionality. ;-)

I'll consider -!false a recommendation for my next patch :D



>>>> +
>>>>  	return !of_node_cmp(of_node_full_name(sd->of_node),
>>>>  			    of_node_full_name(asd->match.of.node));
>>>>  }
>>>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>>>> index da78497ae5ed..67f816f90ac3 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>>>> @@ -607,6 +607,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>>>>  	sd->flags = 0;
>>>>  	sd->name[0] = '\0';
>>>>  	sd->grp_id = 0;
>>>> +	sd->port = 0;
>>>>  	sd->dev_priv = NULL;
>>>>  	sd->host_priv = NULL;
>>>>  #if defined(CONFIG_MEDIA_CONTROLLER)
>>>> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
>>>> index 5b501309b6a7..2988960613ec 100644
>>>> --- a/include/media/v4l2-async.h
>>>> +++ b/include/media/v4l2-async.h
>>>> @@ -56,6 +56,7 @@ struct v4l2_async_subdev {
>>>>  	union {
>>>>  		struct {
>>>>  			const struct device_node *node;
>>>> +			u32 port;
>>>
>>> What if instead of storing the device's OF node, you'd store the port node
>>> and used that for matching?
>>>
>>> Would that also solve the problem or do I miss something?
>>
>> Actually - I was 'trying' to prevent having to parse the DT in the adv748x
>> driver if I didn't need to.
>>
>> Once I have to parse the DT, then yes, I think storing the endpoint node is
>> probably the best thing to compare against.
>>
>> And actually - you might have just solved my open question in the cover letter ...
>>
>> I had got stuck in my mindset that if I were to use the endpoint 'leaf' node as
>> a comparator - that it would be 'instead' of the root node.
>>
>> But actually - it could just be root-node + leaf-node to compare, which then
>> allows us the fallback of comparing just the root nodes if the leaf isn't set.
>>
>> I'll respin with this either tomorrow or early next week.
> 
> Endpoints are indeed another option.
> 
> Is there something that would prevent switching from device node matching to
> port / endpoint matching altogether? I don't think the driver changes should
> be difficult to make.
> 
> Supporting different options there will be painful as it will likely require
> help from the driver to implement both --- separately.

Ok - so a bit of pain either way...

IMO - 'endpoint' matching is 'more correct' as then we are tying the subdev with
precisely the object that it is linking to.

It looks like there are 11 users of v4l2_async_notifier_register(), so yes,
hopefully it might not actually be so much effort to go through and adapt each
to match to the endpoint of_node instead!

I'll have a go at this and see how far I get down the rabbit hole.

>>>>  		} of;
>>>>  		struct {
>>>>  			const char *name;
>>>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>>>> index 0ab1c5df6fac..1c1731b491e5 100644
>>>> --- a/include/media/v4l2-subdev.h
>>>> +++ b/include/media/v4l2-subdev.h
>>>> @@ -782,6 +782,7 @@ struct v4l2_subdev_platform_data {
>>>>   * @ctrl_handler: The control handler of this subdev. May be NULL.
>>>>   * @name: Name of the sub-device. Please notice that the name must be unique.
>>>>   * @grp_id: can be used to group similar subdevs. Value is driver-specific
>>>> + * @port: driver-specific value to bind multiple subdevs with a single DT node.
>>>>   * @dev_priv: pointer to private data
>>>>   * @host_priv: pointer to private data used by the device where the subdev
>>>>   *	is attached.
>>>> @@ -814,6 +815,7 @@ struct v4l2_subdev {
>>>>  	struct v4l2_ctrl_handler *ctrl_handler;
>>>>  	char name[V4L2_SUBDEV_NAME_SIZE];
>>>>  	u32 grp_id;
>>>> +	u32 port;
>>>>  	void *dev_priv;
>>>>  	void *host_priv;
>>>>  	struct video_device *devnode;
>>>
> 
