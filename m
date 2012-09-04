Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53144 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2IDGPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2012 02:15:10 -0400
Message-ID: <50459C3B.9060201@ti.com>
Date: Tue, 4 Sep 2012 11:44:19 +0530
From: Manjunath Hadli <manjunath.hadli@ti.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	<linux-doc@vger.kernel.org>, Rob Landley <rob@landley.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com> <20120802000756.GM26642@valkosipuli.retiisi.org.uk> <502331F8.3050503@ti.com> <20120816162318.GZ29636@valkosipuli.retiisi.org.uk> <50349ED2.4050209@ti.com> <20120901172530.GA6757@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120901172530.GA6757@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 01 September 2012 10:55 PM, Sakari Ailus wrote:
> Hi Manju,
> 
> My apologies for the delayed answer.
> 
> On Wed, Aug 22, 2012 at 02:26:50PM +0530, Manjunath Hadli wrote:
>> On Thursday 16 August 2012 09:53 PM, Sakari Ailus wrote:
>>> On Thu, Aug 09, 2012 at 09:13:52AM +0530, Manjunath Hadli wrote:
>>>> On Thursday 02 August 2012 05:37 AM, Sakari Ailus wrote:
>>>>> Hi Manju,
>>>>>
>>>>> Thanks for the patch.
>>>>>
>>>>> Please make sure these patches reach linux-media next time. If they do
>>>>> not,
>>>>> it severely limits the number of potential reviewers. I don't know
>>>>> why, but
>>>>> the original patch isn't on linux-media even if the list was cc'd.
>>>>>
>>>>> Dropping linux-kernel from cc.
>>>>>
>>>>> Manjunath Hadli wrote:
>>>>>> Add documentation on the Davinci VPFE driver. Document the subdevs,
>>>>>> and private IOTCLs the driver implements
>>>>>>
>>>>>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>>>>>> ---
>>>>>>   Documentation/video4linux/davinci-vpfe-mc.txt |  263
>>>>>> +++++++++++++++++++++++++
>>>>>>   1 files changed, 263 insertions(+), 0 deletions(-)
>>>>>>   create mode 100644 Documentation/video4linux/davinci-vpfe-mc.txt
>>>>>>
>>>>>> diff --git a/Documentation/video4linux/davinci-vpfe-mc.txt
>>>>>> b/Documentation/video4linux/davinci-vpfe-mc.txt
>>>>>> new file mode 100644
>>>>>> index 0000000..968194f
>>>>>> --- /dev/null
>>>>>> +++ b/Documentation/video4linux/davinci-vpfe-mc.txt
>>>>>> @@ -0,0 +1,263 @@
>>>>>> +Davinci Video processing Front End (VPFE) driver
>>>>>> +
>>>>>> +Copyright (C) 2012 Texas Instruments Inc
>>>>>> +
>>>>>> +Contacts: Manjunath Hadli <manjunath.hadli@ti.com>
>>>>>> +
>>>>>> +Introduction
>>>>>> +============
>>>>>> +
>>>>>> +This file documents the Texas Instruments Davinci Video processing
>>>>>> Front End
>>>>>> +(VPFE) driver located under drivers/media/video/davinci. The
>>>>>> original driver
>>>>>> +exists for Davinci VPFE, which is now being changed to Media Controller
>>>>>> +Framework.
>>>>>> +
>>>>>> +Currently the driver has been successfully used on the following
>>>>>> version of Davinci:
>>>>>> +
>>>>>> +    DM365/DM368
>>>>>> +
>>>>>> +The driver implements V4L2, Media controller and v4l2_subdev
>>>>>> interfaces.
>>>>>> +Sensor, lens and flash drivers using the v4l2_subdev interface in
>>>>>> the kernel
>>>>>> +are supported.
>>>>>> +
>>>>>> +
>>>>>> +Split to subdevs
>>>>>> +================
>>>>>> +
>>>>>> +The Davinic VPFE is split into V4L2 subdevs, each of the blocks
>>>>>> inside the VPFE
>>>>>> +having one subdev to represent it. Each of the subdevs provide a
>>>>>> V4L2 subdev
>>>>>> +interface to userspace.
>>>>>> +
>>>>>> +    DAVINCI CCDC
>>>>>> +    DAVINCI PREVIEWER
>>>>>> +    DAVINCI RESIZER
>>>>>> +    DAVINCI AEW
>>>>>> +    DAVINCI AF
>>>>>> +
>>>>>> +Each possible link in the VPFE is modeled by a link in the Media
>>>>>> controller
>>>>>> +interface. For an example program see [1].
>>>>>> +
>>>>>> +
>>>>>> +Private IOCTLs
>>>>>> +==============
>>>>>> +
>>>>>> +The Davinci Video processing Front End (VPFE) driver supports
>>>>>> standard V4L2
>>>>>> +IOCTLs and controls where possible and practical. Much of the
>>>>>> functions provided
>>>>>> +by the VPFE, however, does not fall under the standard IOCTLs.
>>>>>> +
>>>>>> +In general, there is a private ioctl for configuring each of the blocks
>>>>>> +containing hardware-dependent functions.
>>>>>> +
>>>>>> +The following private IOCTLs are supported:
>>>>>> +
>>>>>> +1: IOCTL: PREV_S_PARAM/PREV_G_PARAM
>>>>>> +Description:
>>>>>> +    Sets/Gets the parameters required by the previewer module
>>>>>> +Parameter:
>>>>>> +    /**
>>>>>> +     * struct prev_module_param- structure to configure preview modules
>>>>>> +     * @version: Version of the preview module
>>>>>> +     * @len: Length of the module config structure
>>>>>> +     * @module_id: Module id
>>>>>> +     * @param: pointer to module config parameter.
>>>>>> +     */
>>>>>> +    struct prev_module_param {
>>>>>> +        char version[IMP_MAX_NAME_SIZE];
>>>>>> +        unsigned short len;
>>>>>> +        unsigned short module_id;
>>>>>> +        void *param;
>>>>>> +    };
>>>>>
>>>>> In addition to what Laurent commented on this, could the version
>>>>> information be passed in struct media_entity_desc instead?
>>>> I plan to leave out the version.
>>>>>
>>>>> As a general comment, it's a bad idea to design an API that allows
>>>>> passing
>>>>> blobs, especially when the expected size of the blobs isn't known. That
>>>>> really equals to asking for trouble.
>>>>>
>>>>> That said, I know this is an area where complete documentation is acarce,
>>>>> but I think that at least the memory layout of the current blob pointers
>>>>> should be visible in the struct definitions whenever possible. See
>>>>> e.g. the
>>>>> OMAP 3 ISP driver.
>>>> I have proposed using a union of structures instead of the void  blob. 
>>>> I also saw the OMAP implementation, and they are pointers (but not void). 
>>>> To me the union approach looks better as it keeps the architecture
>>>> intact and does not necessitate an
>>>> explicit copy_from_user. Which of these ways do you suggest?
>>>
>>> I would suggest to use the approach taken in the OMAP 3 ISP driver as it has
>>> one obvious advantage over the union of pointers: it makes it possible to
>>> perform atomic changes to the configuration.
>>>
>>> However, changes to configuration done through controls and the private
>>> IOCTL can never be atomic as they're done using a different IOCTL. This is
>>> something that will require some work at the API level in the future.
>>>
>>> I'm fine with both union of struct pointers or a struct of struct pointers
>>> (as in the OMAP 3 ISP driver). Laurent?
>>>
>> What I meant was using a union of structures and not strct pointers.
>> That way there would be no need to have a copy_from_user in the
>> driver.Hovewer ,I am open to either methods.So We will go ahead with the
>> OMAP way for now.
> 
> Agreed. An obvious issue with the approach of having an union of structures
> (not pointers) is that you end up copying a lot more memory (the maximum
> size of all of the configurations) every time between user and kernel
> spaces.
> 
OK.
>>>>>
>>>>>> +2: IOCTL: PREV_S_CONFIG/PREV_G_CONFIG
>>>>>> +Description:
>>>>>> +    Sets/Gets the configuration required by the previewer channel
>>>>>> +Parameter:
>>>>>> +    /**
>>>>>> +     * struct prev_channel_config - structure for configuring the
>>>>>> previewer channel
>>>>>> +     * @len: Length of the user configuration
>>>>>> +     * @config: pointer to either single shot config or continuous
>>>>>> +     */
>>>>>> +    struct prev_channel_config {
>>>>>> +        unsigned short len;
>>>>>> +        void *config;
>>>>>> +    };
>>>>>> +
>>>>>> +3: IOCTL: PREV_ENUM_CAP
>>>>>> +Description:
>>>>>> +    Queries the modules available in the image processor for preview
>>>>>> the
>>>>>> +    input image.
>>>>>> +Parameter:
>>>>>> +    /**
>>>>>> +     * struct prev_cap - structure to enumerate capabilities of
>>>>>> previewer
>>>>>> +     * @index: application use this to iterate over the available
>>>>>> modules
>>>>>> +     * @version: version of the preview module
>>>>>> +     * @module_id: module id
>>>>>> +     * @control: control operation allowed in continuous mode? 1 -
>>>>>> allowed, 0 - not allowed
>>>>>> +     * @path: path on which the module is sitting
>>>>>> +     * @module_name: module name
>>>>>> +     */
>>>>>> +    struct prev_cap {
>>>>>> +        unsigned short index;
>>>>>> +        char version[IMP_MAX_NAME_SIZE];
>>>>>> +        unsigned short module_id;
>>>>>
>>>>> Huh? How many sub-modules do the preview modules have in different DM
>>>>> series
>>>>> chips, and which ones have the same?
>>>>>
>>>>> The user still has to know quite lot about the hardware; I'd give the
>>>>> responsibility of knowing the hardware to the user also here --- the user
>>>>> has to know this exactly anyway.
>>>> I am going to remove this IOCTL as agreed. Will keep only a SET and a
>>>> GET IOTCL.
>>>
>>> PREV_[GS]_CONFIG or something else? That's also a blob passing IOCTL.
>>>
>>
>> We will implement this is a similar way as above. Will probably merge
>> with the above to make it a single blob IOCTL.
> 
> I'm not comfortable with the idea of a blob IOCTL. As the kernel driver will
> even parse the data, is there a single valid reason not to specify the
> memory layout of the data as well, and thus enforce the proper use of the
> interface?
I guess you meant blob = void *. No I will not have a void pointer but
an actual struct pointer from the user space. I think that is what you
wanted.

> 
>>>>>> +        char control;
>>>>>> +        enum imp_data_paths path;
>>>>>> +        char module_name[IMP_MAX_NAME_SIZE];
>>>>>> +    };
>>>>>> +
>>>>>> +4: IOCTL: RSZ_S_CONFIG/RSZ_G_CONFIG
>>>>>> +Description:
>>>>>> +    Sets/Gets the configuration required by the resizer channel
>>>>>> +Parameter:
>>>>>> +    /**
>>>>>> +     * struct rsz_channel_config - structure for configuring the
>>>>>> resizer channel
>>>>>> +     * @chain: chain this resizer at the previewer output
>>>>>> +     * @len: length of the user configuration
>>>>>> +     * @config: pointer to either single shot config or continuous
>>>>>> +     */
>>>>>> +    struct rsz_channel_config {
>>>>>> +        unsigned char chain;
>>>>>
>>>>> How many resizers do you have? Wouldn't the Media controller link
>>>>> configuration be the right way to configure this?
>>>> Yes. The Media controller links the entities to act as single shot or
>>>> continuous.
>>>> The above variable can be removed. There are two resizers.
>>>
>>> If you have two independent resizer blocks then you should represent them as
>>> two subdevs. The reason is that the scaling factor is configured using the
>>> COMPOSE target on the sink pad, making the scaling factor specific to the
>>> subdev.
>>>
>> Oh! in that sense it is more of a single resizer which a lot of common
>> hardware blocks and has a facility that we can enable the second output.
>> Most of registers are common as well. I think it is much better to keep
>> it the way it is. The scaling factor is not taken as an explicit
>> parameter but managed using the w and h of sources and sinks.
> 
> That would be against the V4L2 spec. It's explicitly defined that the source
> compose rectangle defines the output size of the scaler.
> 
> <URL:http://hverkuil.home.xs4all.nl/spec/media.html#pad-level-formats>
> 
> The reason for the source width and height not being used for the purpose is
> that it'd be impossible to specify cropping after scaling in the same
> subdev.
There is no cropping here. I am using the pad's mbus_framefmt  structure
to determine the scaling. It is according to the v4L2 scheme of things,
and could not see any discrepancy.  How else did you like it to be
implemented? As I stated before, if you see problems in Resizer 2, i am
willing to drop the feature. Let me know your view.
> 
> I'll reply to the rest later on.
> 
> Kind regards,
> 

Thanks and Regards,
-Manju
