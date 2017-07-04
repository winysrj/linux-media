Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:60162 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdGDJjy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 05:39:54 -0400
Subject: Re: [PATCH v5 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1498732993.git.joabreu@synopsys.com>
 <52933416f17b8a3408ab94784fa8db56453ff196.1498732993.git.joabreu@synopsys.com>
 <30787ca1-f488-ef29-8997-0a74c70d552f@xs4all.nl>
 <57902dce-e665-8027-1d88-7c447753a5b2@synopsys.com>
 <3a666f71-fb91-5c76-853d-df9de5a9af10@xs4all.nl>
 <749c9b9e-e42b-76ef-36a7-2ea3cbf0ce84@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <e79b8482-342d-3300-21b7-073bbad6df36@cisco.com>
Date: Tue, 4 Jul 2017 11:39:51 +0200
MIME-Version: 1.0
In-Reply-To: <749c9b9e-e42b-76ef-36a7-2ea3cbf0ce84@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/17 11:28, Jose Abreu wrote:
> Hi Hans,
> 
> 
> On 03-07-2017 11:33, Hans Verkuil wrote:
>> On 07/03/2017 11:53 AM, Jose Abreu wrote:
>>> Hi Hans,
>>>
>>>
>>> On 03-07-2017 10:27, Hans Verkuil wrote:
>>>> On 06/29/2017 12:46 PM, Jose Abreu wrote:
>>>>> This is an initial submission for the Synopsys Designware
>>>>> HDMI RX
>>>>> Controller Driver. This driver interacts with a phy driver so
>>>>> that
>>>>> a communication between them is created and a video pipeline is
>>>>> configured.
>>>>>
>>>>> The controller + phy pipeline can then be integrated into a
>>>>> fully
>>>>> featured system that can be able to receive video up to 4k@60Hz
>>>>> with deep color 48bit RGB, depending on the platform. Although,
>>>>> this initial version does not yet handle deep color modes.
>>>>>
>>>>> This driver was implemented as a standard V4L2 subdevice and
>>>>> its
>>>>> main features are:
>>>>>      - Internal state machine that reconfigures phy until the
>>>>>      video is not stable
>>>>>      - JTAG communication with phy
>>>>>      - Inter-module communication with phy driver
>>>>>      - Debug write/read ioctls
>>>>>
>>>>> Some notes:
>>>>>      - RX sense controller (cable connection/disconnection)
>>>>> must
>>>>>      be handled by the platform wrapper as this is not
>>>>> integrated
>>>>>      into the controller RTL
>>>>>      - The same goes for EDID ROM's
>>>>>      - ZCAL calibration is needed only in FPGA platforms, in
>>>>> ASIC
>>>>>      this is not needed
>>>>>      - The state machine is not an ideal solution as it
>>>>> creates a
>>>>>      kthread but it is needed because some sources might not be
>>>>>      very stable at sending the video (i.e. we must react
>>>>>      accordingly).
>>>>>
>>>>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>>>>> Cc: Carlos Palminha <palminha@synopsys.com>
>>>>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>>>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>>>> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
>>>>>
>>>>> Changes from v4:
>>>>>      - Add flag V4L2_SUBDEV_FL_HAS_DEVNODE (Sylwester)
>>>>>      - Remove some comments and change some messages to dev_dbg
>>>>> (Sylwester)
>>>>>      - Use v4l2_async_subnotifier_register() (Sylwester)
>>>>> Changes from v3:
>>>>>      - Use v4l2 async API (Sylwester)
>>>>>      - Do not block waiting for phy
>>>>>      - Do not use busy waiting delays (Sylwester)
>>>>>      - Simplify dw_hdmi_power_on (Sylwester)
>>>>>      - Use clock API (Sylwester)
>>>>>      - Use compatible string (Sylwester)
>>>>>      - Minor fixes (Sylwester)
>>>>> Changes from v2:
>>>>>      - Address review comments from Hans regarding CEC
>>>>>      - Use CEC notifier
>>>>>      - Enable SCDC
>>>>> Changes from v1:
>>>>>      - Add support for CEC
>>>>>      - Correct typo errors
>>>>>      - Correctly detect interlaced video modes
>>>>>      - Correct VIC parsing
>>>>> Changes from RFC:
>>>>>      - Add support for HDCP 1.4
>>>>>      - Fixup HDMI_VIC not being parsed (Hans)
>>>>>      - Send source change signal when powering off (Hans)
>>>>>      - Add a "wait stable delay"
>>>>>      - Detect interlaced video modes (Hans)
>>>>>      - Restrain g/s_register from reading/writing to HDCP regs
>>>>> (Hans)
>>>>> ---
>>>>>    drivers/media/platform/dwc/Kconfig      |   15 +
>>>>>    drivers/media/platform/dwc/Makefile     |    1 +
>>>>>    drivers/media/platform/dwc/dw-hdmi-rx.c | 1824
>>>>> +++++++++++++++++++++++++++++++
>>>>>    drivers/media/platform/dwc/dw-hdmi-rx.h |  441 ++++++++
>>>>>    include/media/dwc/dw-hdmi-rx-pdata.h    |   97 ++
>>>>>    5 files changed, 2378 insertions(+)
>>>>>    create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>>>>>    create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>>>>>    create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
>>>>>
>>>>> diff --git a/drivers/media/platform/dwc/Kconfig
>>>>> b/drivers/media/platform/dwc/Kconfig
>>>>> index 361d38d..3ddccde 100644
>>>>> --- a/drivers/media/platform/dwc/Kconfig
>>>>> +++ b/drivers/media/platform/dwc/Kconfig
>>>>> @@ -6,3 +6,18 @@ config VIDEO_DWC_HDMI_PHY_E405
>>>>>            To compile this driver as a module, choose M here.
>>>>> The module
>>>>>          will be called dw-hdmi-phy-e405.
>>>>> +
>>>>> +config VIDEO_DWC_HDMI_RX
>>>>> +    tristate "Synopsys Designware HDMI Receiver driver"
>>>>> +    depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>>>>> +    help
>>>>> +      Support for Synopsys Designware HDMI RX controller.
>>>>> +
>>>>> +      To compile this driver as a module, choose M here. The
>>>>> module
>>>>> +      will be called dw-hdmi-rx.
>>>>> +
>>>>> +config VIDEO_DWC_HDMI_RX_CEC
>>>>> +    bool
>>>>> +    depends on VIDEO_DWC_HDMI_RX
>>>>> +    select CEC_CORE
>>>>> +    select CEC_NOTIFIER
>>>>> diff --git a/drivers/media/platform/dwc/Makefile
>>>>> b/drivers/media/platform/dwc/Makefile
>>>>> index fc3b62c..cd04ca9 100644
>>>>> --- a/drivers/media/platform/dwc/Makefile
>>>>> +++ b/drivers/media/platform/dwc/Makefile
>>>>> @@ -1 +1,2 @@
>>>>>    obj-$(CONFIG_VIDEO_DWC_HDMI_PHY_E405) += dw-hdmi-phy-e405.o
>>>>> +obj-$(CONFIG_VIDEO_DWC_HDMI_RX) += dw-hdmi-rx.o
>>>>> diff --git a/drivers/media/platform/dwc/dw-hdmi-rx.c
>>>>> b/drivers/media/platform/dwc/dw-hdmi-rx.c
>>>>> new file mode 100644
>>>>> index 0000000..4a7b8fc
>>>>> --- /dev/null
>>>>> +++ b/drivers/media/platform/dwc/dw-hdmi-rx.c
>>>>
>>>> <snip>
>>
>>>>> +static int dw_hdmi_g_register(struct v4l2_subdev *sd,
>>>>> +        struct v4l2_dbg_register *reg)
>>>>> +{
>>>>> +    struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>>>> +
>>>>> +    switch (reg->reg >> 15) {
>>>>> +    case 0: /* Controller core read */
>>>>> +        if (dw_hdmi_is_reserved_register(dw_dev, reg->reg &
>>>>> 0x7fff))
>>>>> +            return -EINVAL;
>>>>
>>>> Is this necessary? Obviously you shouldn't be able to set it,
>>>> but I think it
>>>> should be fine to read it. Up to you, though.
>>>
>>> Actually some of the HDCP 1.4 registers are write only and if
>>> someone tries to read the controller will not respond and will
>>> block the bus. This is no problem for x86, but for some archs it
>>> can block the system entirely.
>>
>> Worth a comment in that case.
> 
> Ok.
> 
>>
>>>>> +static const struct v4l2_subdev_video_ops
>>>>> dw_hdmi_sd_video_ops = {
>>>>> +    .s_routing = dw_hdmi_s_routing,
>>>>> +    .g_input_status = dw_hdmi_g_input_status,
>>>>> +    .g_parm = dw_hdmi_g_parm,
>>>>> +    .g_dv_timings = dw_hdmi_g_dv_timings,
>>>>> +    .query_dv_timings = dw_hdmi_query_dv_timings,
>>>>
>>>> No s_dv_timings???
>>>
>>> Hmm, yeah, I didn't implement it because the callchain and the
>>> player I use just use {get/set}_fmt. s_dv_timings can just
>>> populate the fields and replace them with the detected dv_timings
>>> ? Just like set_fmt does? Because the controller has no scaler.
>>
>> No, s_dv_timings is the function that actually sets
>> dw_dev->timings.
>> After you check that it is valid of course (call
>> v4l2_valid_dv_timings).
>>
>> set_fmt calls get_fmt which returns the information from
>> dw_dev->timings.
>>
>> But it is s_dv_timings that has to set dw_dev->timings.
>>
>> With the current code you can only capture 640x480 (the default
>> timings).
>> Have you ever tested this with any other timings? I don't quite
>> understand
>> how you test.
> 
> I use mpv to test with a wrapper driver that just calls the
> subdev ops and sets up a video dma.
> 
> Ah, I see now. I failed to port the correct callbacks and in the
> upstream version I'm using I only tested with 640x480 ...
> 
> But apart from that this is a capture device without scaling so I
> can not set timings, I can only return them so that applications
> know which format I'm receiving, right? So my s_dv_timings will
> return the same as query_dv_timings ...

Well, to be precise: s_dv_timings just accepts what the application
gives it (as long as it is within the dv_timings capabilities). But
those timings come in practice from a query_dv_timings call from the
application.

The core rule is that receivers cannot randomly change timings since
timings are related to buffer sizes. You do not want the application
to allocate buffers for 640x480 and when the source changes to 1920x1080
have those buffers suddenly overflow.

Instead the app queries the timings, allocates the buffers, start
streaming and when the timings change it will get an event so it can
stop streaming, reallocate buffers, and start the process again.

In other words, the application is in control here.

> 
> <snip>
> 
>>>>> +
>>>>> +    /* V4L2 initialization */
>>>>> +    sd = &dw_dev->sd;
>>>>> +    v4l2_subdev_init(sd, &dw_hdmi_sd_ops);
>>>>> +    strlcpy(sd->name, dev_name(dev), sizeof(sd->name));
>>>>> +    sd->dev = dev;
>>>>> +    sd->internal_ops = &dw_hdmi_internal_ops;
>>>>> +    sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS |
>>>>> V4L2_SUBDEV_FL_HAS_DEVNODE;
>>>>
>>>> You need to add at this control: V4L2_CID_DV_RX_POWER_PRESENT.
>>>> This is a
>>>> read-only control that reports the 5V status. Important for
>>>> applications to have.
>>>
>>> Ok.
>>>
>>>>
>>>> I gather that this IP doesn't handle InfoFrames? If it does,
>>>> then let me know.
>>>
>>> Yes, it handles but I didn't implement the parsing yet (I just
>>> parse the VIC for now).
>>
>> Ah, OK. When you add that, then I strongly recommend that you
>> also add
>> support for the V4L2_CID_DV_RX_RGB_RANGE control, provided this
>> IP can
>> do quantization range conversion. If quantization range
>> conversion is not
>> part of this IP, then just ignore this comment.
> 
> Hmm, I don't think it can. I mean the controller basically just
> outputs what comes from phy in the correct order (it doesn't
> touch the bytes, just reorders them and packs them).

I suspected as much. So just ignore this.

Regards,

	Hans
