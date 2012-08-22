Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:57989 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab2HVI5p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 04:57:45 -0400
Message-ID: <50349ED2.4050209@ti.com>
Date: Wed, 22 Aug 2012 14:26:50 +0530
From: Manjunath Hadli <manjunath.hadli@ti.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	<linux-doc@vger.kernel.org>, Rob Landley <rob@landley.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com> <20120802000756.GM26642@valkosipuli.retiisi.org.uk> <502331F8.3050503@ti.com> <20120816162318.GZ29636@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120816162318.GZ29636@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 16 August 2012 09:53 PM, Sakari Ailus wrote:
> Hi Manju,
> 
> On Thu, Aug 09, 2012 at 09:13:52AM +0530, Manjunath Hadli wrote:
>> Hi Sakari,
>>  
>>  Thank you for the comments.
> 
> Thanks for the graphs!
> 
>> On Thursday 02 August 2012 05:37 AM, Sakari Ailus wrote:
>>> Hi Manju,
>>>
>>> Thanks for the patch.
>>>
>>> Please make sure these patches reach linux-media next time. If they do
>>> not,
>>> it severely limits the number of potential reviewers. I don't know
>>> why, but
>>> the original patch isn't on linux-media even if the list was cc'd.
>>>
>>> Dropping linux-kernel from cc.
>>>
>>> Manjunath Hadli wrote:
>>>> Add documentation on the Davinci VPFE driver. Document the subdevs,
>>>> and private IOTCLs the driver implements
>>>>
>>>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>>>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>>>> ---
>>>>   Documentation/video4linux/davinci-vpfe-mc.txt |  263
>>>> +++++++++++++++++++++++++
>>>>   1 files changed, 263 insertions(+), 0 deletions(-)
>>>>   create mode 100644 Documentation/video4linux/davinci-vpfe-mc.txt
>>>>
>>>> diff --git a/Documentation/video4linux/davinci-vpfe-mc.txt
>>>> b/Documentation/video4linux/davinci-vpfe-mc.txt
>>>> new file mode 100644
>>>> index 0000000..968194f
>>>> --- /dev/null
>>>> +++ b/Documentation/video4linux/davinci-vpfe-mc.txt
>>>> @@ -0,0 +1,263 @@
>>>> +Davinci Video processing Front End (VPFE) driver
>>>> +
>>>> +Copyright (C) 2012 Texas Instruments Inc
>>>> +
>>>> +Contacts: Manjunath Hadli <manjunath.hadli@ti.com>
>>>> +
>>>> +Introduction
>>>> +============
>>>> +
>>>> +This file documents the Texas Instruments Davinci Video processing
>>>> Front End
>>>> +(VPFE) driver located under drivers/media/video/davinci. The
>>>> original driver
>>>> +exists for Davinci VPFE, which is now being changed to Media Controller
>>>> +Framework.
>>>> +
>>>> +Currently the driver has been successfully used on the following
>>>> version of Davinci:
>>>> +
>>>> +    DM365/DM368
>>>> +
>>>> +The driver implements V4L2, Media controller and v4l2_subdev
>>>> interfaces.
>>>> +Sensor, lens and flash drivers using the v4l2_subdev interface in
>>>> the kernel
>>>> +are supported.
>>>> +
>>>> +
>>>> +Split to subdevs
>>>> +================
>>>> +
>>>> +The Davinic VPFE is split into V4L2 subdevs, each of the blocks
>>>> inside the VPFE
>>>> +having one subdev to represent it. Each of the subdevs provide a
>>>> V4L2 subdev
>>>> +interface to userspace.
>>>> +
>>>> +    DAVINCI CCDC
>>>> +    DAVINCI PREVIEWER
>>>> +    DAVINCI RESIZER
>>>> +    DAVINCI AEW
>>>> +    DAVINCI AF
>>>> +
>>>> +Each possible link in the VPFE is modeled by a link in the Media
>>>> controller
>>>> +interface. For an example program see [1].
>>>> +
>>>> +
>>>> +Private IOCTLs
>>>> +==============
>>>> +
>>>> +The Davinci Video processing Front End (VPFE) driver supports
>>>> standard V4L2
>>>> +IOCTLs and controls where possible and practical. Much of the
>>>> functions provided
>>>> +by the VPFE, however, does not fall under the standard IOCTLs.
>>>> +
>>>> +In general, there is a private ioctl for configuring each of the blocks
>>>> +containing hardware-dependent functions.
>>>> +
>>>> +The following private IOCTLs are supported:
>>>> +
>>>> +1: IOCTL: PREV_S_PARAM/PREV_G_PARAM
>>>> +Description:
>>>> +    Sets/Gets the parameters required by the previewer module
>>>> +Parameter:
>>>> +    /**
>>>> +     * struct prev_module_param- structure to configure preview modules
>>>> +     * @version: Version of the preview module
>>>> +     * @len: Length of the module config structure
>>>> +     * @module_id: Module id
>>>> +     * @param: pointer to module config parameter.
>>>> +     */
>>>> +    struct prev_module_param {
>>>> +        char version[IMP_MAX_NAME_SIZE];
>>>> +        unsigned short len;
>>>> +        unsigned short module_id;
>>>> +        void *param;
>>>> +    };
>>>
>>> In addition to what Laurent commented on this, could the version
>>> information be passed in struct media_entity_desc instead?
>> I plan to leave out the version.
>>>
>>> As a general comment, it's a bad idea to design an API that allows
>>> passing
>>> blobs, especially when the expected size of the blobs isn't known. That
>>> really equals to asking for trouble.
>>>
>>> That said, I know this is an area where complete documentation is acarce,
>>> but I think that at least the memory layout of the current blob pointers
>>> should be visible in the struct definitions whenever possible. See
>>> e.g. the
>>> OMAP 3 ISP driver.
>> I have proposed using a union of structures instead of the void  blob. 
>> I also saw the OMAP implementation, and they are pointers (but not void). 
>> To me the union approach looks better as it keeps the architecture
>> intact and does not necessitate an
>> explicit copy_from_user. Which of these ways do you suggest?
> 
> I would suggest to use the approach taken in the OMAP 3 ISP driver as it has
> one obvious advantage over the union of pointers: it makes it possible to
> perform atomic changes to the configuration.
> 
> However, changes to configuration done through controls and the private
> IOCTL can never be atomic as they're done using a different IOCTL. This is
> something that will require some work at the API level in the future.
> 
> I'm fine with both union of struct pointers or a struct of struct pointers
> (as in the OMAP 3 ISP driver). Laurent?
> 
What I meant was using a union of structures and not strct pointers.
That way there would be no need to have a copy_from_user in the
driver.Hovewer ,I am open to either methods.So We will go ahead with the
OMAP way for now.
>>>
>>>> +2: IOCTL: PREV_S_CONFIG/PREV_G_CONFIG
>>>> +Description:
>>>> +    Sets/Gets the configuration required by the previewer channel
>>>> +Parameter:
>>>> +    /**
>>>> +     * struct prev_channel_config - structure for configuring the
>>>> previewer channel
>>>> +     * @len: Length of the user configuration
>>>> +     * @config: pointer to either single shot config or continuous
>>>> +     */
>>>> +    struct prev_channel_config {
>>>> +        unsigned short len;
>>>> +        void *config;
>>>> +    };
>>>> +
>>>> +3: IOCTL: PREV_ENUM_CAP
>>>> +Description:
>>>> +    Queries the modules available in the image processor for preview
>>>> the
>>>> +    input image.
>>>> +Parameter:
>>>> +    /**
>>>> +     * struct prev_cap - structure to enumerate capabilities of
>>>> previewer
>>>> +     * @index: application use this to iterate over the available
>>>> modules
>>>> +     * @version: version of the preview module
>>>> +     * @module_id: module id
>>>> +     * @control: control operation allowed in continuous mode? 1 -
>>>> allowed, 0 - not allowed
>>>> +     * @path: path on which the module is sitting
>>>> +     * @module_name: module name
>>>> +     */
>>>> +    struct prev_cap {
>>>> +        unsigned short index;
>>>> +        char version[IMP_MAX_NAME_SIZE];
>>>> +        unsigned short module_id;
>>>
>>> Huh? How many sub-modules do the preview modules have in different DM
>>> series
>>> chips, and which ones have the same?
>>>
>>> The user still has to know quite lot about the hardware; I'd give the
>>> responsibility of knowing the hardware to the user also here --- the user
>>> has to know this exactly anyway.
>> I am going to remove this IOCTL as agreed. Will keep only a SET and a
>> GET IOTCL.
> 
> PREV_[GS]_CONFIG or something else? That's also a blob passing IOCTL.
> 

We will implement this is a similar way as above. Will probably merge
with the above to make it a single blob IOCTL.

>>>> +        char control;
>>>> +        enum imp_data_paths path;
>>>> +        char module_name[IMP_MAX_NAME_SIZE];
>>>> +    };
>>>> +
>>>> +4: IOCTL: RSZ_S_CONFIG/RSZ_G_CONFIG
>>>> +Description:
>>>> +    Sets/Gets the configuration required by the resizer channel
>>>> +Parameter:
>>>> +    /**
>>>> +     * struct rsz_channel_config - structure for configuring the
>>>> resizer channel
>>>> +     * @chain: chain this resizer at the previewer output
>>>> +     * @len: length of the user configuration
>>>> +     * @config: pointer to either single shot config or continuous
>>>> +     */
>>>> +    struct rsz_channel_config {
>>>> +        unsigned char chain;
>>>
>>> How many resizers do you have? Wouldn't the Media controller link
>>> configuration be the right way to configure this?
>> Yes. The Media controller links the entities to act as single shot or
>> continuous.
>> The above variable can be removed. There are two resizers.
> 
> If you have two independent resizer blocks then you should represent them as
> two subdevs. The reason is that the scaling factor is configured using the
> COMPOSE target on the sink pad, making the scaling factor specific to the
> subdev.
> 
Oh! in that sense it is more of a single resizer which a lot of common
hardware blocks and has a facility that we can enable the second output.
Most of registers are common as well. I think it is much better to keep
it the way it is. The scaling factor is not taken as an explicit
parameter but managed using the w and h of sources and sinks.
>>> A media-ctl --print-dot graph on the device layout would be
>>> appreciated if
>>> the driver is in a state where it can be easily produced.
>> Sure will send it.
>>>
>>>> +        unsigned short len;
>>>> +        void *config;
>>>> +    };
>>>> +
>>>> +5: IOCTL: VPFE_CMD_S_CCDC_RAW_PARAMS/VPFE_CMD_G_CCDC_RAW_PARAMS
>>>> +Description:
>>>> +    Sets/Gets the CCDC parameter
>>>> +Parameter:
>>>> +    /**
>>>> +     * struct ccdc_config_params_raw - structure for configuring
>>>> ccdc params
>>>> +     * @linearize: linearization parameters for image sensor data input
>>>> +     * @df_csc: data formatter or CSC
>>>> +     * @dfc: defect Pixel Correction (DFC) configuration
>>>> +     * @bclamp: Black/Digital Clamp configuration
>>>> +     * @gain_offset: Gain, offset adjustments
>>>> +     * @culling: Culling
>>>> +     * @pred: predictor for DPCM compression
>>>> +     * @horz_offset: horizontal offset for Gain/LSC/DFC
>>>> +     * @vert_offset: vertical offset for Gain/LSC/DFC
>>>> +     * @col_pat_field0: color pattern for field 0
>>>> +     * @col_pat_field1: color pattern for field 1
>>>> +     * @data_size: data size from 8 to 16 bits
>>>> +     * @data_shift: data shift applied before storing to SDRAM
>>>> +     * @test_pat_gen: enable input test pattern generation
>>>> +     */
>>>> +    struct ccdc_config_params_raw {
>>>> +        struct ccdc_linearize linearize;
>>>> +        struct ccdc_df_csc df_csc;
>>>> +        struct ccdc_dfc dfc;
>>>> +        struct ccdc_black_clamp bclamp;
>>>> +        struct ccdc_gain_offsets_adj gain_offset;
>>>> +        struct ccdc_cul culling;
>>>> +        enum ccdc_dpcm_predictor pred;
>>>> +        unsigned short horz_offset;
>>>> +        unsigned short vert_offset;
>>>> +        struct ccdc_col_pat col_pat_field0;
>>>> +        struct ccdc_col_pat col_pat_field1;
>>>> +        enum ccdc_data_size data_size;
>>>> +        enum ccdc_datasft data_shift;
>>>> +        unsigned char test_pat_gen;
>>>
>>> Are the struct definitions available somewhere? I bet more than the test
>>> pattern Laurent suggested might be implementable as controls. The dpcm
>>> predictor, for example.
>> I will check on the DPSM test pattern. The definitions are available
>> at:http://davinci-linux-open-source.1494791.n2.nabble.com/RESEND-RFC-PATCH-v4-00-15-RFC-for-Media-Controller-capture-driver-for-DM365-td7003648.html
> 
> Thanks!
> 
> I think the DPCM predictor should be made a control in the image processing
> controls class. The test pattern would fit there as well I think.
> 
> <URL:http://hverkuil.home.xs4all.nl/spec/media.html#image-process-controls>
> 
>>>
>>>> +    };
>>>> +
>>>> +6: IOCTL: AF_S_PARAM/AF_G_PARAM
>>>> +Description:
>>>> +    AF_S_PARAM performs the hardware setup and sets the parameter for
>>>> +    AF engine.AF_G_PARAM gets the parameter setup in AF engine
>>>> +Parameter:
>>>> +    /**
>>>> +     * struct af_configuration - struct to configure parameters of
>>>> AF engine
>>>> +     * @alaw_enable: ALAW status
>>>> +     * @fv_sel: focus value selection
>>>> +     * @hmf_config: HMF configurations
>>>> +     * @rgb_pos: RGB Positions. Only applicable with AF_HFV_ONLY
>>>> selection
>>>> +     * @iir_config: IIR filter configurations
>>>> +     * @fir_config: FIR filter configuration
>>>> +     * @paxel_config: Paxel parameters
>>>> +     * @mode: accumulator mode
>>>> +     */
>>>> +    struct af_configuration {
>>>> +        enum af_enable_flag alaw_enable;
>>>
>>> What does alaw_enable do? Is it set by the user?
>> This will be removed. We will take it from mbus format.
> 
> Ok.
> 
>>> It'd be nice to see what's behind these enums and structs.
>> Please see the above link.
>>>
>>>> +        enum af_focus_val_sel fv_sel;
>>>> +        struct af_hmf hmf_config;
>>>> +        enum rgbpos rgb_pos;
> 
>                           ^
> This information is available in the media bus format.
> 
>>>> +        struct af_iir iir_config;
>>>> +        struct af_fir fir_config;
>>>> +        struct af_paxel paxel_config;
>>>> +        enum af_mode mode;
>>>> +    };
>>>> +
>>>> +7: IOCTL: AF_GET_STAT
>>>> +Description:
>>>> +    Copy the entire statistics located in application buffer
>>>> +    to user space from the AF engine
>>>> +Parameter:
>>>> +    /**
>>>> +     * struct af_statdata - structure to get statistics from AF engine
>>>> +     * @buffer: pointer to buffer
>>>> +     * @buf_length: length of buffer
>>>> +     */
>>>> +    struct af_statdata {
>>>> +        void *buffer;
>>>> +        int buf_length;
>>>> +    };
>>>
>>> I think the proper way to pass statistics to the user space has been
>>> discussed for years, but AFAIR --- please correct if I'm mistaken --- the
>>> agreement was to implement statistics as video buffer queue. It is, after
>>> all, very similar to regular image data in how it's handled by the
>>> hardware
>>> and when it's needed by the user and even some of the statistics can
>>> be even
>>> considered images themselves.
>> Depending on which statistics we are talking about, the data size might
>> vary, and
>> in general much saller than a image that it is based on. I am not sure
>> if we need a 
>> full fledged buffer exchange mechanism to exchange statistics data.
>> Anyway, can you
>> point me to the discussion?
> 
> The data size varies according to the configuration which isn't unexpected.
> The video buffers, such as the non-video buffers, just need to be large
> enough to hold the biggest statistics the user intends to capture --- just
> as for images.
> 
> I can't find a discussion now --- it might have been a real verbal
> discussion. :-) There are numerous benefits both in kernel and user space:
> videobuf2 gives you the buffer handling; enabling and disabling works
> through enabling or disabling the link between the statistics subdev and the
> video node, and you get the standard user space API as well. For instance,
> you only need to configure the statistics engine using a private IOCTL after
> which you can use yavta to capture statistics (for testing). The OMAP 3 ISP
> driver either copies the statistics data or used to use the buffers one by
> one independently of whether the user was still accessing them. That's a lot
> of complexity both in kernel and user space which can be almost completely
> avoided by just using videobuf2.
Right now our priority is to have at least the base driver into the
mainline and add features quickly after that as we have done sufficient
numbers of changes and do not want to get stuck in a loop between
framework advancements vs our changes. With that in mind, we will drop
the support for statistics, and add it later with videobuf2.
> 
> Hans, Laurent: could you ack this?
> 
>>> So, this should be done using video buffers instead. I know the OMAP 3
>>> ISP
>>> doesn't, but at the time of the implementation this was seen otherwise.
>>> You'll save a lot of trouble by using video buffers since you won't
>>> need to
>>> implement the same functionality that already exists in videobuf2 for the
>>> statistics.
>> Is there any driver which uses video buffers for statistics data 
>> exchange using video buffers? If so can you point me to it? If it is a
>> quickie, I lan to make the changes. Else I will plan to get this driver
>> into the mainline without AF/AEW and add patches later.
> 
> Currently no. At the time the OMAP 3 ISP driver was written, the rough
> concensus was on using private IOCTLs. We had to have one driver to
> implement statistics passing using private IOCTLs to find that's a bad idea.
> :-) That's definitely my opinion on that.
OK.
> 
>>>
>>>> +8: IOCTL: AEW_S_PARAM/AEW_G_PARAM
>>>> +Description:
>>>> +    AEW_S_PARAM performs the hardware setup and sets the parameter for
>>>> +    AEW engine.AEW_G_PARAM gets the parameter setup in AEW engine
>>>> +Parameter:
>>>> +    /**
>>>> +     * struct aew_configuration -  struct to configure parameters of
>>>> AEW engine
>>>> +     * @alaw_enable: A-law status
>>>> +     * @format: AE/AWB output format
>>>> +     * @sum_shift: AW/AWB right shift value for sum of pixels
>>>> +     * @saturation_limit: Saturation Limit
>>>> +     * @hmf_config: HMF configurations
>>>> +     * @window_config: Window for AEW Engine
>>>> +     * @blackwindow_config: Black Window
>>>> +     */
>>>> +    struct aew_configuration {
>>>> +        enum aew_enable_flag alaw_enable;
>>>> +        enum aew_output_format out_format;
>>>> +        char sum_shift;
>>>> +        int saturation_limit;
>>>> +        struct aew_hmf hmf_config;
>>>> +        struct aew_window window_config;
>>>> +        struct aew_black_window blackwindow_config;
>>>> +    };
>>>> +
>>>> +9: IOCTL: AEW_GET_STAT
>>>> +Description:
>>>> +    Copy the entire statistics located in application buffer
>>>> +    to user space from the AEW engine
>>>> +Parameter:
>>>> +    /**
>>>> +     * struct aew_statdata - structure to get statistics from AEW
>>>> engine
>>>> +     * @buffer: pointer to buffer
>>>> +     * @buf_length: length of buffer
>>>> +     */
>>>> +    struct aew_statdata {
>>>> +        void *buffer;
>>>> +        int buf_length;
>>>> +    };
>>>
>>> Same as for AF.
>>>
>>>> +
>>>> +
>>>> +Technical reference manuals (TRMs) and other documentation
>>>> +==========================================================
>>>> +
>>>> +Davinci DM365 TRM:
>>>> +<URL:http://www.ti.com/lit/ds/sprs457e/sprs457e.pdf>
>>>> +Referenced MARCH 2009-REVISED JUNE 2011
>>>> +
>>>> +Davinci DM368 TRM:
>>>> +<URL:http://www.ti.com/lit/ds/sprs668c/sprs668c.pdf>
>>>> +Referenced APRIL 2010-REVISED JUNE 2011
>>>> +
>>>> +Davinci Video Processing Front End (VPFE) DM36x
>>>> +<URL:http://www.ti.com/lit/ug/sprufg8c/sprufg8c.pdf>
>>>> +
>>>> +
>>>> +References
>>>> +==========
>>>> +
>>>> +[1] http://git.ideasonboard.org/?p=media-ctl.git;a=summary
>>>>
> 
> Cheers,
> 
With the above changes, I will float another version of the document,
and hopefully we will have your ACK on that. :)


Thanks and Regards,
-Manju
