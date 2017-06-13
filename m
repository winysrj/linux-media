Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:37615 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752369AbdFMOIU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 10:08:20 -0400
Subject: Re: [RFC PATCH v3 09/11] [media] vimc: Subdevices as modules
To: Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
 <1496458714-16834-1-git-send-email-helen.koike@collabora.com>
 <1496458714-16834-10-git-send-email-helen.koike@collabora.com>
 <a8fce901-ef34-0ebc-e0b9-90b930416965@xs4all.nl>
 <9fa2afbe-890a-7901-8980-5dcc1fbd36a7@collabora.com>
 <eaf57f8b-6ae3-8286-5691-932638d88ca6@xs4all.nl>
 <4cb013f2-fd65-9628-e250-bbf7b9709353@collabora.com>
Cc: jgebben@codeaurora.org, mchehab@osg.samsung.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <398784a7-8bed-4e94-5a05-18428178f0c8@xs4all.nl>
Date: Tue, 13 Jun 2017 16:08:13 +0200
MIME-Version: 1.0
In-Reply-To: <4cb013f2-fd65-9628-e250-bbf7b9709353@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/17 15:23, Helen Koike wrote:
> Hi Hans,
> 
> On 2017-06-13 03:49 AM, Hans Verkuil wrote:
>> On 06/12/2017 10:35 PM, Helen Koike wrote:
>>> Hi Hans,
>>>
>>> Thank you for your review. Please check my comments below
>>>
>>> On 2017-06-12 07:37 AM, Hans Verkuil wrote:
>>>> On 06/03/2017 04:58 AM, Helen Koike wrote:
>>>>> +static struct component_match *vimc_add_subdevs(struct vimc_device
>>>>> *vimc)
>>>>> +{
>>>>> +    struct component_match *match = NULL;
>>>>> +    unsigned int i;
>>>>> +
>>>>> +    for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
>>>>> +        dev_dbg(&vimc->pdev.dev, "new pdev for %s\n",
>>>>> +            vimc->pipe_cfg->ents[i].drv);
>>>>> +
>>>>> +        /*
>>>>> +         * TODO: check if using platform_data is indeed the best
>>>>> way to
>>>>> +         * pass the name to the driver or if we should add the drv
>>>>> name
>>>>> +         * in the platform_device_id table
>>>>> +         */
>>>>
>>>> Didn't you set the drv name in the platform_device_id table already?
>>>
>>> I refer to the name of the entity, there is the name that identifies the
>>> driver as "vimc-sensor" that is set in the platform_device_id table but
>>> there is also the custom name of the entity e.g. "My Sensor A" that I
>>> need to inform to the vimc-sensor driver.
>>
>> Ah, so in the TODO you mean:
>>
>> "the best way to pass the entity name to the driver"
> 
> Yes
> 
>>
>> I got confused there.
> 
> Sorry about that, I'll improve this comment (if we don't decide to 
> remove it)
> 
>>
>> But in that case I still don't get what you mean with "add the drv name
>> in the platform_device_id table". Do you mean "entity name" there as
>> well?
> 
> Yes, it is because there is a member of the platform_device_id table 
> called driver_data and I was wondering if this would be more 
> appropriated then using the platform_data.
> 
> Under Documentation/driver-model/platform.txt it is written:
> "In many cases, the memory and IRQ resources associated with the 
> platform device are not enough to let the device's driver work.  Board 
> setup code
> will often provide additional information using the device's platform_data
> field to hold additional information."
> 
> So I thought that using platform_data to pass the entity's name to the 
> driver would be acceptable as it seems to be a "Board setup code" for vimc

OK, now I understand. I am OK with this, but I would prefer if you made a
proper struct for this:

struct vimc_platform_data {
	char entity_name[32];
};

Then point platform_data to that. Also comment clearly why you do it.

Part of the confusion comes from the fact that this is unusual for MC
devices: they all use the device tree instead of platform_data, so seeing
platform_data being used in something like this is unexpected.

> 
>>
>>>
>>>>
>>>> Using platform_data feels like an abuse to be honest.
>>>
>>> Another option would be to make the vimc-sensor driver to populate the
>>> entity name automatically as "Sensor x", where x could be the entity
>>> number, but I don't think this is a good option.
>>
>> Why not? Well, probably not the entity number, but a simple instance
>> counter would do fine (i.e. Sensor 1, 2, 3...).
> 
> Because I usually use tests scripts that configure the right pad image 
> format to a specific entity's name using media-ctl, I would like an 
> assurance that what identifies the entity doesn't change (that doesn't 
> depend on the order they are inserted), and I thought that applications 
> in userspace might want the same.

Good point!

> 
>>
>> It can be made fancier later with dynamic reconfiguration where you
>> might want to use the first unused instance number.
> 
> We could use configfs for that, but I was wondering what the names of 
> the folders that represent an entity would mean, if the user do
> $ mkdir vimc-sensor-foo
> $ mkdir vimc-sensor-bar
> Then foo and bar would unused names as the entities would be first 
> created under the names "Sensor 1" and "Sensor 2", I think it would be 
> nice if they were created as "Sensor foo" and "Sensor bar".
> 
>>
>>>
>>>>
>>>> Creating these components here makes sense. Wouldn't it also make sense
>>>> to use
>>>> v4l2_async to wait until they have all been bound? It would more closely
>>>> emulate
>>>> standard drivers. Apologies if I misunderstand what is happening here.
>>>
>>> I am using linux/component.h for that, when all devices are present and
>>> all modules are loaded, the component.h system brings up the core by
>>> calling vimc_comp_bind() function, which calls component_bind_all() to
>>> call the binding function of each module, then it finishes registering
>>> the topology.
>>> If any one of the components or module is unload, the component system
>>> takes down the entire topology calling component_unbind_all which calls
>>> the unbind functions from each module.
>>> This makes sure that the media device, subdevices and video device are
>>> only registered in the v4l2 system if all the modules are loaded.
>>>
>>> I wans't familiar with v4l2-async.h, but from a quick look it seems that
>>> it only works with struct v4l2_subdev, but I'll also need for struct
>>> video_device (for the capture node for example).
>>> And also, if a module is missing we would have vimc partially
>>> registered, e.g. the debayer could be registered at /dev/subdevX but the
>>> sensor not yet and the media wouldn't be ready, I am not sure if this is
>>> a problem though.
>>>
>>> Maybe we can use component.h for now, then I can implement
>>> v4l2_async_{un}register_video_device and migrate to v4l2-sync.h latter.
>>> What do you think?
>>
>> That's OK. The v4l2-async mechanism precedes the component API. We should
>> probably investigate moving over to the component API. I seem to remember
>> that it didn't have all the features we needed, but it's a long time ago
>> since someone looked at that and whatever the objections were, they may
>> no longer be true.
> 
> I see, I can try to take a look on this.

Something for later.

So in other words, this looks good but needs better comments and a proper
platform_data struct.

Regards,

	Hans
