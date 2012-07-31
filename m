Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46259 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687Ab2GaHqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 03:46:22 -0400
Message-ID: <50178D17.8030504@ti.com>
Date: Tue, 31 Jul 2012 13:15:27 +0530
From: Manju <manjunath.hadli@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Rob Landley <rob@landley.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com> <6523233.d6sC4kbUpR@avalon> <E99FAA59F8D8D34D8A118DD37F7C8F753E941A7E@DBDE01.ent.ti.com> <1461029.ufNJEg1MSf@avalon>
In-Reply-To: <1461029.ufNJEg1MSf@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Friday 27 July 2012 04:19 PM, Laurent Pinchart wrote:
> Hi Manjunath,
>
> On Friday 27 July 2012 05:49:24 Hadli, Manjunath wrote:
>> On Thu, Jul 26, 2012 at 05:55:31, Laurent Pinchart wrote:
>>> On Tuesday 17 July 2012 10:43:54 Hadli, Manjunath wrote:
>>>> On Sun, Jul 15, 2012 at 18:16:25, Laurent Pinchart wrote:
>>>>> On Wednesday 11 July 2012 21:09:26 Manjunath Hadli wrote:
>>>>>> Add documentation on the Davinci VPFE driver. Document the subdevs,
>>>>>> and private IOTCLs the driver implements
>>>>>>
>>>>>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>>> [snip]
>>>
>>>>>> +Private IOCTLs
>>>>>> +==============
>>>>>> +
>>>>>> +The Davinci Video processing Front End (VPFE) driver supports
>>>>>> standard V4L2
>>>>>> +IOCTLs and controls where possible and practical. Much of the
>>>>>> functions provided
>>>>>> +by the VPFE, however, does not fall under the standard IOCTLs.
>>>>>> +
>>>>>> +In general, there is a private ioctl for configuring each of the
>>>>>> blocks
>>>>>> +containing hardware-dependent functions.
>>>>>> +
>>>>>> +The following private IOCTLs are supported:
>>>>>> +
>>>>>> +1: IOCTL: PREV_S_PARAM/PREV_G_PARAM
>>>>>> +Description:
>>>>>> +	Sets/Gets the parameters required by the previewer module
>>>>>> +Parameter:
>>>>>> +	/**
>>>>>> +	 * struct prev_module_param- structure to configure preview
>>>>>> modules
>>>>>> +	 * @version: Version of the preview module
>>>>> Who is responsible for filling this field, the application or the
>>>>> driver ?
>>>> The application is responsible for filling this info. He would enumerate
>>>> the capabilities first and  set them using S_PARAM/G_PARAM.
>>> And what's the point of the application setting the version field ? How
>>> does the driver use it ?
>> The version may not be required. Will remove it.
>>
>>>>>> +	 * @len: Length of the module config structure
>>>>>> +	 * @module_id: Module id
>>>>>> +	 * @param: pointer to module config parameter.
>>>>> What is module_id for ? What does param point to ?
>>>> There are a lot of tiny modules in the previewer/resizer which are
>>>> enumerated as individual modules. The param points to the parameter set
>>>> that the module expects to be set.
>>> Why don't you implement something similar to
>>> VPFE_CMD_S_CCDC_RAW_PARAMS/VPFE_CMD_G_CCDC_RAW_PARAMS instead ?
>> I feel if we implement direct IOCTLS there might be many of them. To make
>> sure than independent of the number of internal modules present, having the
>> same IOCTL used for all modules is a good idea.
> You can set several parameters using a single ioctl, much like
> VPFE_CMD_S_CCDC_RAW_PARAMS does. You don't need one ioctl per parameter.
>
> PREV_ENUM_CAP, PREV_[GS]_PARAM and PREV_[GS]_CONFIG are essentially
> reinventing V4L2 controls, and I don't think that's a good idea.
Ok. I looked into this, and found that the structure needed to pass
all the parameters is going to be huge. just to avoid a big structure
from the user space, I propose:

Having a union of structures and a parameter identifying the structure.

In that way, we will remove the enumeration and all the other
things except for a SET and GET, much like the CCDC_RAW_PARAMS
like you suggested. So essentially we will have only 2 IOCTLS for setting
  the private params/configs and remove the rest.  I hope that was your
point and this proposal will solve it?

>
>>>>>> +	 */
>>>>>> +	struct prev_module_param {
>>>>>> +		char version[IMP_MAX_NAME_SIZE];
>>>>> Is there a need to express the version as a string instead of an
>>>>> integer ?
>>>> It could be integer. It is generally a fixed point num, and easy to read
>>>> it as a string than an integer. Can I keep it as a string?
>>> Let's first decide whether a version field is needed at all :-)
>> Will remove.
>>
>>>>>> +		unsigned short len;
>>>>>> +		unsigned short module_id;
>>>>>> +		void *param;
>>>>>> +	};
>>>>>> +
>>>>>> +2: IOCTL: PREV_S_CONFIG/PREV_G_CONFIG
>>>>>> +Description:
>>>>>> +	Sets/Gets the configuration required by the previewer channel
>>>>>> +Parameter:
>>>>>> +	/**
>>>>>> +	 * struct prev_channel_config - structure for configuring the
>>>>>> previewer
>>>>>> channel
>>>>>> +	 * @len: Length of the user configuration
>>>>>> +	 * @config: pointer to either single shot config or continuous
>>>>>> +	 */
>>>>>> +	struct prev_channel_config {
>>>>>> +		unsigned short len;
>>>>>> +		void *config;
>>>>>> +	};
>>>>> What's the difference between parameters and configuration ? What does
>>>>> config point to ?
>>>> Config is setting which is required for a subdev to function based on
>>>> what it is set for (single shot/continuous.) common to all platforms.
>>>> Parameters are the settings for individual small sub-ips which might be
>>>> slightly different from one platform to another. Config points to
>>>> prev_single_shot_config or  prev_continuous_config currently defined in
>>>> linux/dm3656ipipe.h. I think we will move it to a common location.
>>> Why don't you implement something similar to
>>> VPFE_CMD_S_CCDC_RAW_PARAMS/VPFE_CMD_G_CCDC_RAW_PARAMS here as well (same
>>> for the resizer configuration ioctls) ?
>> Ditto.
>>
>>>>>> +
>>>>>> +3: IOCTL: PREV_ENUM_CAP
>>>>>> +Description:
>>>>>> +	Queries the modules available in the image processor for preview
>>>>>> the
>>>>>> +	input image.
>>>>>> +Parameter:
>>>>>> +	/**
>>>>>> +	 * struct prev_cap - structure to enumerate capabilities of
>>>>>> previewer
>>>>>> +	 * @index: application use this to iterate over the available
>>>>>> modules
>>>>>> +	 * @version: version of the preview module
>>>>>> +	 * @module_id: module id
>>>>>> +	 * @control: control operation allowed in continuous mode? 1 -
>>>>>> allowed, 0
>>>>>> - not allowed
>>>>>> +	 * @path: path on which the module is sitting
>>>>>> +	 * @module_name: module name
>>>>>> +	 */
>>>>>> +	struct prev_cap {
>>>>>> +		unsigned short index;
>>>>>> +		char version[IMP_MAX_NAME_SIZE];
>>>>>> +		unsigned short module_id;
>>>>>> +		char control;
>>>>>> +		enum imp_data_paths path;
>>>>>> +		char module_name[IMP_MAX_NAME_SIZE];
>>>>>> +	};
>>>>> Enumerating internal modules is exactly what the MC API was designed
>>>>> for.
>>>>> Why do you reimplement that using private ioctls ?
>>>> The number of these sub-Ips are quite a few in DM365 and Dm355, having a
>>>> lot of them In a way that may be bewildering to the end-user to be able
>>>> to connect them quickly and properly. But overall, these are nothing
>>>> but exposed subips of what we call as CCDC,Previewer  and Resizer.It
>>>> Made a lot of logical sense to keep it that way, give a default
>>>> configuration for everything, and if at all the user wants the fine
>>>> grain config control, be able to give (mainly for the configurations-
>>>> not so much for connections). In most of the cases the param IOTCLs are
>>>> only used for fine-tuning the image and not expected to be used as a
>>>> regular flow of a normal application. I do not think there could be any
>>>> justification for making all these nitty gritty which keep changing for
>>>> each IPs as part of regular V4L2 IOCTLs. In future, if there is a common
>>>> theme that emerges, we could definitely relook into this.
>>> I totally agree with you on this, the tiny sub-blocks should not be
>>> exposed as through the MC API. However, I would go one step further : I
>>> wouldn't expose them through a private ioctl either. What would a
>>> userspace application do with this information that it couldn't do with
>>> just the entity name and its revision number ?
>> Not exposing the full functionality might not be an option. The driver gets
>> used by different kinds of users. Some might want to use only the basic
>> features, but many would like to have the full control in terms of setting
>> all the parameters. Since IPIPE is so much about tuning, not having a fine
>> grain control on its parameters is not an option.
> My point wasn't that you shouldn't expose all device features, but that you
> don't need userspace to be able to dynamically enumerate the content of the
> entity. Applications need to use your private ioctls so they know what
> hardware they deal with. Knowing the entity name (and possibly revision)
> should be enough.
ditto.
>
>>> [snip]
>>>
>>>>>> +5: IOCTL: VPFE_CMD_S_CCDC_RAW_PARAMS/VPFE_CMD_G_CCDC_RAW_PARAMS
>>>>>> +Description:
>>>>>> +	Sets/Gets the CCDC parameter
>>>>>> +Parameter:
>>>>>> +	/**
>>>>>> +	 * struct ccdc_config_params_raw - structure for configuring
> ccdc
>>>>>> params
>>>>>> +	 * @linearize: linearization parameters for image sensor data
>>>>>> input
>>>>>> +	 * @df_csc: data formatter or CSC
>>>>>> +	 * @dfc: defect Pixel Correction (DFC) configuration
>>>>>> +	 * @bclamp: Black/Digital Clamp configuration
>>>>>> +	 * @gain_offset: Gain, offset adjustments
>>>>> Can't you use subdev V4L2 controls for gains ?
>>>> In that case only gain has to be taken out as a generic IOCTL. Since
>>>> that is is The parameter which could be taken out of this big structure
>>> That's correct.
>>>
>>>>>> +	 * @culling: Culling
>>>>>> +	 * @pred: predictor for DPCM compression
>>>>>> +	 * @horz_offset: horizontal offset for Gain/LSC/DFC
>>>>>> +	 * @vert_offset: vertical offset for Gain/LSC/DFC
>>>>>> +	 * @col_pat_field0: color pattern for field 0
>>>>>> +	 * @col_pat_field1: color pattern for field 1
>>>>> Shouldn't color patterns be computed automatically by the driver based
>>>>> on
>>>>> the media bus pixel code ?
>>>> OK.
>>>>
>>>>>> +	 * @data_size: data size from 8 to 16 bits
>>>>>> +	 * @data_shift: data shift applied before storing to SDRAM
>>>>> Ditto, this should probably be computed automatically.
>>>> Do you want to define new MBUS formats for these?
>>> The media bus format contains information about the data width, so I think
>>> those fields are redundant.
>> The specific fields here have the control of specifying the datawidth from 9
>> bits to 16 bits. Did you want us to implement media bus format for all
>> these variations?
> If you have hardware that can generate data in a given width, it needs a media
> bus format, yes. Just don't add media bus formats for widths that are not
> implemented in any hardware.
Sure. Like we agreed,  will send a separate patch for this.
>
>> Just to make sure we do not get held up, I will send a separate patch on
>> mediabus formats for these variations for review. In the mean time, we will
>> go ahead with this.
>>
>>>>>> +	 * @test_pat_gen: enable input test pattern generation
>>>>> You could use a subdev V4L2 control for that.
>>>> Ok.
>>>>
>>>>>> +	 */
>>>>>> +	struct ccdc_config_params_raw {
>>>>>> +		struct ccdc_linearize linearize;
>>>>>> +		struct ccdc_df_csc df_csc;
>>>>>> +		struct ccdc_dfc dfc;
>>>>>> +		struct ccdc_black_clamp bclamp;
>>>>>> +		struct ccdc_gain_offsets_adj gain_offset;
>>>>>> +		struct ccdc_cul culling;
>>>>>> +		enum ccdc_dpcm_predictor pred;
>>>>>> +		unsigned short horz_offset;
>>>>>> +		unsigned short vert_offset;
>>>>>> +		struct ccdc_col_pat col_pat_field0;
>>>>>> +		struct ccdc_col_pat col_pat_field1;
>>>>>> +		enum ccdc_data_size data_size;
>>>>>> +		enum ccdc_datasft data_shift;
>>>>>> +		unsigned char test_pat_gen;
>>>>>> +	};
>>>>>> +
>>> [snip]
>>>
>>>>>> +7: IOCTL: AF_GET_STAT
>>>>>> +Description:
>>>>>> +	Copy the entire statistics located in application buffer
>>>>>> +	to user space from the AF engine
>>>>>> +Parameter:
>>>>>> +	/**
>>>>>> +	 * struct af_statdata - structure to get statistics from AF
> engine
>>>>>> +	 * @buffer: pointer to buffer
>>>>>> +	 * @buf_length: length of buffer
>>>>>> +	 */
>>>>>> +	struct af_statdata {
>>>>>> +		void *buffer;
>>>>>> +		int buf_length;
>>>>>> +	};
>>>>> The OMAP3 ISP driver also needs to export statistics data to
>>>>> userspace. We should design a common API here.
>>>>   
>>>>   Sure we can take it up sometime later.
>>> [snip]
>>>
>>>>>> +9: IOCTL: AEW_GET_STAT
>>>>>> +Description:
>>>>>> +	Copy the entire statistics located in application buffer
>>>>>> +	to user space from the AEW engine
>>>>>> +Parameter:
>>>>>> +	/**
>>>>>> +	 * struct aew_statdata - structure to get statistics from AEW
>>>>>> engine
>>>>>> +	 * @buffer: pointer to buffer
>>>>>> +	 * @buf_length: length of buffer
>>>>>> +	 */
>>>>>> +	struct aew_statdata {
>>>>>> +		void *buffer;
>>>>>> +		int buf_length;
>>>>>> +	};
>>>>> Same comment as for AF_GET_STAT.
>>>> Yes, we can discuss about it to make it common. I would prefer we get
>>>> this driver in and make amends when you are doing it for OMAP.
>>> OK, but then please start a discussion on the mailing list about this
>>> topic (CC'ing David Cohen as he might be interested).
>> I will. Let us get the current driver in. In the meantime I will do some
>> analysis and send an RFC.
> OK.
>
>> If possible, I would request for your ACK on this patch and driver.
> I can't ack this before we solve the PREV_ENUM_CAP, PREV_[GS]_PARAM and
> PREV_[GS]_CONFIG issue.
>
Thanks and Regards,
-Manju
