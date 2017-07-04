Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:36070 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751631AbdGDJ2e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 05:28:34 -0400
Subject: Re: [PATCH v5 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1498732993.git.joabreu@synopsys.com>
 <52933416f17b8a3408ab94784fa8db56453ff196.1498732993.git.joabreu@synopsys.com>
 <30787ca1-f488-ef29-8997-0a74c70d552f@xs4all.nl>
 <57902dce-e665-8027-1d88-7c447753a5b2@synopsys.com>
 <3a666f71-fb91-5c76-853d-df9de5a9af10@xs4all.nl>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sylwester Nawrocki" <snawrocki@kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <749c9b9e-e42b-76ef-36a7-2ea3cbf0ce84@synopsys.com>
Date: Tue, 4 Jul 2017 10:28:27 +0100
MIME-Version: 1.0
In-Reply-To: <3a666f71-fb91-5c76-853d-df9de5a9af10@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 03-07-2017 11:33, Hans Verkuil wrote:
> On 07/03/2017 11:53 AM, Jose Abreu wrote:
>> Hi Hans,
>>
>>
>> On 03-07-2017 10:27, Hans Verkuil wrote:
>>> On 06/29/2017 12:46 PM, Jose Abreu wrote:
>>>> This is an initial submission for the Synopsys Designware
>>>> HDMI RX
>>>> Controller Driver. This driver interacts with a phy driver so
>>>> that
>>>> a communication between them is created and a video pipeline is
>>>> configured.
>>>>
>>>> The controller + phy pipeline can then be integrated into a
>>>> fully
>>>> featured system that can be able to receive video up to 4k@60Hz
>>>> with deep color 48bit RGB, depending on the platform. Although,
>>>> this initial version does not yet handle deep color modes.
>>>>
>>>> This driver was implemented as a standard V4L2 subdevice and
>>>> its
>>>> main features are:
>>>>      - Internal state machine that reconfigures phy until the
>>>>      video is not stable
>>>>      - JTAG communication with phy
>>>>      - Inter-module communication with phy driver
>>>>      - Debug write/read ioctls
>>>>
>>>> Some notes:
>>>>      - RX sense controller (cable connection/disconnection)
>>>> must
>>>>      be handled by the platform wrapper as this is not
>>>> integrated
>>>>      into the controller RTL
>>>>      - The same goes for EDID ROM's
>>>>      - ZCAL calibration is needed only in FPGA platforms, in
>>>> ASIC
>>>>      this is not needed
>>>>      - The state machine is not an ideal solution as it
>>>> creates a
>>>>      kthread but it is needed because some sources might not be
>>>>      very stable at sending the video (i.e. we must react
>>>>      accordingly).
>>>>
>>>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>>>> Cc: Carlos Palminha <palminha@synopsys.com>
>>>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>>> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
>>>>
>>>> Changes from v4:
>>>>      - Add flag V4L2_SUBDEV_FL_HAS_DEVNODE (Sylwester)
>>>>      - Remove some comments and change some messages to dev_dbg
>>>> (Sylwester)
>>>>      - Use v4l2_async_subnotifier_register() (Sylwester)
>>>> Changes from v3:
>>>>      - Use v4l2 async API (Sylwester)
>>>>      - Do not block waiting for phy
>>>>      - Do not use busy waiting delays (Sylwester)
>>>>      - Simplify dw_hdmi_power_on (Sylwester)
>>>>      - Use clock API (Sylwester)
>>>>      - Use compatible string (Sylwester)
>>>>      - Minor fixes (Sylwester)
>>>> Changes from v2:
>>>>      - Address review comments from Hans regarding CEC
>>>>      - Use CEC notifier
>>>>      - Enable SCDC
>>>> Changes from v1:
>>>>      - Add support for CEC
>>>>      - Correct typo errors
>>>>      - Correctly detect interlaced video modes
>>>>      - Correct VIC parsing
>>>> Changes from RFC:
>>>>      - Add support for HDCP 1.4
>>>>      - Fixup HDMI_VIC not being parsed (Hans)
>>>>      - Send source change signal when powering off (Hans)
>>>>      - Add a "wait stable delay"
>>>>      - Detect interlaced video modes (Hans)
>>>>      - Restrain g/s_register from reading/writing to HDCP regs
>>>> (Hans)
>>>> ---
>>>>    drivers/media/platform/dwc/Kconfig      |   15 +
>>>>    drivers/media/platform/dwc/Makefile     |    1 +
>>>>    drivers/media/platform/dwc/dw-hdmi-rx.c | 1824
>>>> +++++++++++++++++++++++++++++++
>>>>    drivers/media/platform/dwc/dw-hdmi-rx.h |  441 ++++++++
>>>>    include/media/dwc/dw-hdmi-rx-pdata.h    |   97 ++
>>>>    5 files changed, 2378 insertions(+)
>>>>    create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>>>>    create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>>>>    create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
>>>>
>>>> diff --git a/drivers/media/platform/dwc/Kconfig
>>>> b/drivers/media/platform/dwc/Kconfig
>>>> index 361d38d..3ddccde 100644
>>>> --- a/drivers/media/platform/dwc/Kconfig
>>>> +++ b/drivers/media/platform/dwc/Kconfig
>>>> @@ -6,3 +6,18 @@ config VIDEO_DWC_HDMI_PHY_E405
>>>>            To compile this driver as a module, choose M here.
>>>> The module
>>>>          will be called dw-hdmi-phy-e405.
>>>> +
>>>> +config VIDEO_DWC_HDMI_RX
>>>> +    tristate "Synopsys Designware HDMI Receiver driver"
>>>> +    depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>>>> +    help
>>>> +      Support for Synopsys Designware HDMI RX controller.
>>>> +
>>>> +      To compile this driver as a module, choose M here. The
>>>> module
>>>> +      will be called dw-hdmi-rx.
>>>> +
>>>> +config VIDEO_DWC_HDMI_RX_CEC
>>>> +    bool
>>>> +    depends on VIDEO_DWC_HDMI_RX
>>>> +    select CEC_CORE
>>>> +    select CEC_NOTIFIER
>>>> diff --git a/drivers/media/platform/dwc/Makefile
>>>> b/drivers/media/platform/dwc/Makefile
>>>> index fc3b62c..cd04ca9 100644
>>>> --- a/drivers/media/platform/dwc/Makefile
>>>> +++ b/drivers/media/platform/dwc/Makefile
>>>> @@ -1 +1,2 @@
>>>>    obj-$(CONFIG_VIDEO_DWC_HDMI_PHY_E405) += dw-hdmi-phy-e405.o
>>>> +obj-$(CONFIG_VIDEO_DWC_HDMI_RX) += dw-hdmi-rx.o
>>>> diff --git a/drivers/media/platform/dwc/dw-hdmi-rx.c
>>>> b/drivers/media/platform/dwc/dw-hdmi-rx.c
>>>> new file mode 100644
>>>> index 0000000..4a7b8fc
>>>> --- /dev/null
>>>> +++ b/drivers/media/platform/dwc/dw-hdmi-rx.c
>>>
>>> <snip>
>
>>>> +static int dw_hdmi_g_register(struct v4l2_subdev *sd,
>>>> +        struct v4l2_dbg_register *reg)
>>>> +{
>>>> +    struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>>> +
>>>> +    switch (reg->reg >> 15) {
>>>> +    case 0: /* Controller core read */
>>>> +        if (dw_hdmi_is_reserved_register(dw_dev, reg->reg &
>>>> 0x7fff))
>>>> +            return -EINVAL;
>>>
>>> Is this necessary? Obviously you shouldn't be able to set it,
>>> but I think it
>>> should be fine to read it. Up to you, though.
>>
>> Actually some of the HDCP 1.4 registers are write only and if
>> someone tries to read the controller will not respond and will
>> block the bus. This is no problem for x86, but for some archs it
>> can block the system entirely.
>
> Worth a comment in that case.

Ok.

>
>>>> +static const struct v4l2_subdev_video_ops
>>>> dw_hdmi_sd_video_ops = {
>>>> +    .s_routing = dw_hdmi_s_routing,
>>>> +    .g_input_status = dw_hdmi_g_input_status,
>>>> +    .g_parm = dw_hdmi_g_parm,
>>>> +    .g_dv_timings = dw_hdmi_g_dv_timings,
>>>> +    .query_dv_timings = dw_hdmi_query_dv_timings,
>>>
>>> No s_dv_timings???
>>
>> Hmm, yeah, I didn't implement it because the callchain and the
>> player I use just use {get/set}_fmt. s_dv_timings can just
>> populate the fields and replace them with the detected dv_timings
>> ? Just like set_fmt does? Because the controller has no scaler.
>
> No, s_dv_timings is the function that actually sets
> dw_dev->timings.
> After you check that it is valid of course (call
> v4l2_valid_dv_timings).
>
> set_fmt calls get_fmt which returns the information from
> dw_dev->timings.
>
> But it is s_dv_timings that has to set dw_dev->timings.
>
> With the current code you can only capture 640x480 (the default
> timings).
> Have you ever tested this with any other timings? I don't quite
> understand
> how you test.

I use mpv to test with a wrapper driver that just calls the
subdev ops and sets up a video dma.

Ah, I see now. I failed to port the correct callbacks and in the
upstream version I'm using I only tested with 640x480 ...

But apart from that this is a capture device without scaling so I
can not set timings, I can only return them so that applications
know which format I'm receiving, right? So my s_dv_timings will
return the same as query_dv_timings ...

<snip>

>>>> +
>>>> +    /* V4L2 initialization */
>>>> +    sd = &dw_dev->sd;
>>>> +    v4l2_subdev_init(sd, &dw_hdmi_sd_ops);
>>>> +    strlcpy(sd->name, dev_name(dev), sizeof(sd->name));
>>>> +    sd->dev = dev;
>>>> +    sd->internal_ops = &dw_hdmi_internal_ops;
>>>> +    sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS |
>>>> V4L2_SUBDEV_FL_HAS_DEVNODE;
>>>
>>> You need to add at this control: V4L2_CID_DV_RX_POWER_PRESENT.
>>> This is a
>>> read-only control that reports the 5V status. Important for
>>> applications to have.
>>
>> Ok.
>>
>>>
>>> I gather that this IP doesn't handle InfoFrames? If it does,
>>> then let me know.
>>
>> Yes, it handles but I didn't implement the parsing yet (I just
>> parse the VIC for now).
>
> Ah, OK. When you add that, then I strongly recommend that you
> also add
> support for the V4L2_CID_DV_RX_RGB_RANGE control, provided this
> IP can
> do quantization range conversion. If quantization range
> conversion is not
> part of this IP, then just ignore this comment.

Hmm, I don't think it can. I mean the controller basically just
outputs what comes from phy in the correct order (it doesn't
touch the bytes, just reorders them and packs them).

<snip>

>>>
>>>> + *
>>>> + * @bksv: BKSV value for HDCP 1.4 engine (40 bits).
>>>> + *
>>>> + * @keys: Keys value for HDCP 1.4 engine (80 * 56 bits).
>>>> + *
>>>> + * @keys_valid: Must be set to true if the keys in this
>>>> structure are valid
>>>> + * and can be used by the HDMI receiver controller.
>>>> + */
>>>> +struct dw_hdmi_hdcp14_key {
>>>> +    u32 seed;
>>>> +    u32 bksv[DW_HDMI_HDCP14_BKSV_SIZE];
>>>> +    u32 keys[DW_HDMI_HDCP14_KEYS_SIZE];
>>>> +    bool keys_valid;
>>>> +};
>>>> +
>>>> +/**
>>>> + * struct dw_hdmi_rx_pdata - Platform Data configuration for
>>>> HDMI receiver.
>>>> + *
>>>> + * @hdcp14_keys: Keys for HDCP 1.4 engine. See
>>>> @dw_hdmi_hdcp14_key.
>>>
>>> Was this for debugging only? These are the Device Private Keys
>>> you're talking about?
>>>
>>> If this is indeed the case, then this doesn't belong here. You
>>> should never rely on
>>> software to set these keys. It should be fused in the hardware,
>>> or read from an
>>> encrypted eeprom or something like that. None of this
>>> (including the bksv) should
>>> be settable from the driver. You can read the bksv since that's
>>> public.
>>>
>>> This can't be in a kernel driver, nor can it be set or read
>>> through the s_register API.
>>>
>>> Instead there should be a big fat disclaimer that how you
>>> program these keys is up to
>>> the hardware designer and that it should be in accordance to
>>> the HDCP requirements.
>>>
>>> I would drop this completely from the pdata. My recommendation
>>> would be to not include
>>> HDCP support at all for this first version. Add it in follow-up
>>> patches which include
>>> a new V4L2 API for handling HDCP. This needs to be handled
>>> carefully.
>>
>> Yes, in real HW these keys will not be handled this way. I'm
>> using a prototyping system so its easier to debug. I will remove
>> this entirely and drop HDCP 1.4 support for now.
>>
>> Hmm, I'm seeing the configuration flow for keys written in HW and
>> it actually just needs a seed (for encrypted keys, for decrypted
>> ones it just doesn't need anything). Shall I drop the support or
>> change the code? I've no way to test this right now though...
>
> Drop the support. I don't want to mix this in with the other
> code. HDCP
> support should be done in a separate patch series once this is
> merged.
> That way I can give it the attention it deserves.

Ok.

Best regards,
Jose Miguel Abreu

>
> Regards,
>
>     Hans
>
>>
>> Best regards,
>> Jose Miguel Abreu
>>
>>>
>>>> + *
>>>> + * @dw_5v_status: 5v status callback. Shall return the status
>>>> of the given
>>>> + * input, i.e. shall be true if a cable is connected to the
>>>> specified input.
>>>> + *
>>>> + * @dw_5v_clear: 5v clear callback. Shall clear the interrupt
>>>> associated with
>>>> + * the 5v sense controller.
>>>> + *
>>>> + * @dw_5v_arg: Argument to be used with the 5v sense
>>>> callbacks.
>>>> + *
>>>> + * @dw_zcal_reset: Impedance calibration reset callback.
>>>> Shall be called when
>>>> + * the impedance calibration needs to be restarted. This is
>>>> used by phy driver
>>>> + * only.
>>>> + *
>>>> + * @dw_zcal_done: Impendace calibration status callback.
>>>> Shall return true if
>>>
>>> Typo: Impendace -> Impedance
>>>
>>>> + * the impedance calibration procedure has ended. This is
>>>> used by phy driver
>>>> + * only.
>>>> + *
>>>> + * @dw_zcal_arg: Argument to be used with the ZCAL
>>>> calibration callbacks.
>>>> + */
>>>> +struct dw_hdmi_rx_pdata {
>>>> +    /* Controller configuration */
>>>> +    struct dw_hdmi_hdcp14_key hdcp14_keys;
>>>> +    /* 5V sense interface */
>>>> +    bool (*dw_5v_status)(void __iomem *regs, int input);
>>>> +    void (*dw_5v_clear)(void __iomem *regs);
>>>> +    void __iomem *dw_5v_arg;
>>>> +    /* Zcal interface */
>>>> +    void (*dw_zcal_reset)(void __iomem *regs);
>>>> +    bool (*dw_zcal_done)(void __iomem *regs);
>>>> +    void __iomem *dw_zcal_arg;
>>>> +};
>>>> +
>>>> +#endif /* __DW_HDMI_RX_PDATA_H__ */
>>>>
>>>
>>> Regards,
>>>
>>>      Hans
>>
>
