Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:36492 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdAMVEz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 16:04:55 -0500
Received: by mail-it0-f47.google.com with SMTP id c7so40767556itd.1
        for <linux-media@vger.kernel.org>; Fri, 13 Jan 2017 13:04:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f956170a-38d9-ce97-51df-e88f59e4ac17@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <CAJ+vNU2zU++Xam_UpDPfmSQhauhhS3_z8L-+ww6o-D9brWhiwA@mail.gmail.com>
 <afe51f5f-03dd-4092-9ec0-297afb1453c7@mentor.com> <CAJ+vNU3ymeA9d+cJ44Wm_zX17EMkd__w6vB_xyagxzBAYNJbZQ@mail.gmail.com>
 <f956170a-38d9-ce97-51df-e88f59e4ac17@gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Fri, 13 Jan 2017 13:04:53 -0800
Message-ID: <CAJ+vNU1=UusZD0WQvrfXxfND0w2gEn+-QO1zN+apyYPc0+nOwA@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 12, 2017 at 2:32 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Hi Tim,
>
>
> On 01/12/2017 01:13 PM, Tim Harvey wrote:
>>
>>
>>>> Now that your driver is hooking into the current media framework, I'm
>>>> not at all clear on how to link and configure the media entities.
>>>
>>>
>>> It's all documented at Documentation/media/v4l-drivers/imx.rst.
>>> Follow the SabreAuto pipeline setup example.
>>>
>> ah yes... it helps to read your patches! You did a great job on the
>> documentation.
>>
>> Regarding the The ipu1_csi0_mux/ipu2_csi1_mux entities which have 1
>> source and 2 sinks (which makes sense for a mux) how do you know which
>> sink pad you should use (in your adv7180 example you use the 2nd sink
>> pad vs the first)?
>
>
> The adv7180 can only go to the parallel input pad (ipu1_csi0_mux:1
> on quad). The other input pads select from the mipi csi-2 receiver virtual
> channels.

right - my question was how does the user know which pad is which. I
see that the imx6q.dtsi makes it clear that port0 (sink1) is the mipi
port and port1 is the parallel port (sink2). Do you know how a user
would determine this from runtime information (maybe something via
media-ctl or /sys/class/media that I haven't yet found) or perhaps
this is to be taken care of by documentation or referring to the dts?

>
> Have you generated a dot graph? It makes it much easier to
> visualize:
>
> # media-ctl --print-dot > graph.dot
>
> then on your host:
>
> % dot -Tpng graph.dot > graph.png
>

Yes - that makes it much easier to understand the possible links.

I notice 'media-ctl --print-topology' shows link and pad type fields,
but 'media-ctl --print-dot' does not include the pad type field (maybe
newer versions do or will in the future)

Do you know how one goes about determining the possible format types
possible for each pad?

>
>
>>
>> As my hardware is the same as the SabreAuto except that my adv7180 is
>> on i2c-2@0x20 I follow your example from
>> Documentation/media/v4l-drivers/imx.rst:
>>
>> # Setup links
>> media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":1[1]'
>> media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
>> media-ctl -l '"ipu1_csi0":1 -> "ipu1_smfc0":0[1]'
>> media-ctl -l '"ipu1_smfc0":1 -> "ipu1_ic_prpvf":0[1]'
>> media-ctl -l '"ipu1_ic_prpvf":1 -> "camif0":0[1]'
>> media-ctl -l '"camif0":1 -> "camif0 devnode":0[1]'
>>
>> # Configure pads
>> media-ctl -V "\"adv7180 2-0020\":0 [fmt:UYVY2X8/720x480]"
>> media-ctl -V "\"ipu1_csi0_mux\":1 [fmt:UYVY2X8/720x480]"
>> media-ctl -V "\"ipu1_csi0_mux\":2 [fmt:UYVY2X8/720x480]"
>> media-ctl -V "\"ipu1_csi0\":0 [fmt:UYVY2X8/720x480]"
>> media-ctl -V "\"ipu1_csi0\":1 [fmt:UYVY2X8/720x480]"
>> media-ctl -V "\"ipu1_smfc0\":0 [fmt:UYVY2X8/720x480]"
>> media-ctl -V "\"ipu1_smfc0\":1 [fmt:UYVY2X8/720x480]"
>> media-ctl -V "\"ipu1_ic_prpvf\":0 [fmt:UYVY2X8/720x480]"
>> # pad field types for camif can be any format prpvf supports
>> export outputfmt="UYVY2X8/720x480"
>> media-ctl -V "\"ipu1_ic_prpvf\":1 [fmt:$outputfmt]"
>> media-ctl -V "\"camif0\":0 [fmt:$outputfmt]"
>> media-ctl -V "\"camif0\":1 [fmt:$outputfmt]"
>>
>> # select AIN1
>> v4l2-ctl -d0 -i0
>> Video input set to 0 (ADV7180 Composite on Ain1: ok)
>> v4l2-ctl -d0 --set-fmt-video=width=720,height=480,pixelformat=UYVY
>> # capture a single raw frame
>> v4l2-ctl -d0 --stream-mmap --stream-to=/x.raw --stream-count=1
>> [ 2092.056394] camif0: pipeline_set_stream failed with -32
>> VIDIOC_STREAMON: failed: Broken pipe
>>
>> Enabling debug in drivers/media/media-entity.c I see:
>> [   38.870087] imx-media soc:media@0: link validation failed for
>> "ipu1_smfc0":1 -> "ipu1_ic_prpvf":0, error -32
>>
>> Looking at ipu1_smfc0 and ipu1_ic_prpvf with media-ctl I see:
>> - entity 12: ipu1_ic_prpvf (2 pads, 8 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev3
>>          pad0: Sink
>>                  [fmt:UYVY2X8/720x480 field:alternate]
>>                  <- "ipu1_csi0":1 []
>>                  <- "ipu1_csi1":1 []
>>                  <- "ipu1_smfc0":1 [ENABLED]
>>                  <- "ipu1_smfc1":1 []
>>          pad1: Source
>>                  [fmt:UYVY2X8/720x480 field:none]
>>                  -> "camif0":0 [ENABLED]
>>                  -> "camif1":0 []
>>                  -> "ipu1_ic_pp0":0 []
>>                  -> "ipu1_ic_pp1":0 []
>>
>> - entity 45: ipu1_smfc0 (2 pads, 5 links)
>>               type V4L2 subdev subtype Unknown flags 0
>>               device node name /dev/v4l-subdev14
>>          pad0: Sink
>>                  [fmt:UYVY2X8/720x480]
>>                  <- "ipu1_csi0":1 [ENABLED]
>>          pad1: Source
>>                  [fmt:UYVY2X8/720x480]
>>                  -> "ipu1_ic_prpvf":0 [ENABLED]
>>                  -> "ipu1_ic_pp0":0 []
>>                  -> "camif0":0 []
>>                  -> "camif1":0 []
>>
>> Any ideas what is going wrong here? Seems like its perhaps a field
>> type mismatch.
>
>
> Yes, exactly, you'll need to set the field types on every pad in your
> pipeline.
>
>>   Is my outputfmt incorrect perhaps? I likely have
>> misunderstood the pad type comments in your documentation.
>
>
> Attached is an update doc (from branch imx-media-staging-md-v7 on my fork).
> I recently upgraded my v4l-utils package and media-ctl now supports
> specifying
> the field type in the pad format strings. If you don't have the latest
> v4l-utils, it's
> fairly straightforward to cross-build.
>

Your updated imx.rst makes it very clear - I was misunderstanding the
pervious version and comments as it skipped setting the pad field
types.

The v4l-utils-1.10 from Ubuntu 16.04 allows setting field types with
the links so I didn't need to build a newer one and this did resolve
my issue.

>>
>>>
>>>> <snip>
>>>>
>>>>
>>>>
>>>> Additionally I've found that on an IMX6S/IMX6DL we crash while
>>>> registering the media-ic subdev's:
>>
>> <snip>
>>>
>>> Yep, I only have quad boards here so I haven't gotten around to
>>> testing on S/DL.
>>>
>>> But it looks like I forgot to clear out the csi subdev pointer array
>>> before
>>> passing it to imx_media_of_parse(). I think that might explain the OOPS
>>> above. Try this patch:
>>>
>>> diff --git a/drivers/staging/media/imx/imx-media-dev.c
>>> b/drivers/staging/media/imx/imx-media-dev.c
>>> index 357654d..0cf2d61 100644
>>> --- a/drivers/staging/media/imx/imx-media-dev.c
>>> +++ b/drivers/staging/media/imx/imx-media-dev.c
>>> @@ -379,7 +379,7 @@ static int imx_media_probe(struct platform_device
>>> *pdev)
>>>   {
>>>          struct device *dev = &pdev->dev;
>>>          struct device_node *node = dev->of_node;
>>> -       struct imx_media_subdev *csi[4];
>>> +       struct imx_media_subdev *csi[4] = {0};
>>>          struct imx_media_dev *imxmd;
>>>          int ret;
>>>
>> This does resolves the crash on S/DL.
>
>

I now have dts patches ready for the following which have an on-board
ADV7180 SD capture on:
arch/arm/boot/dts/imx6dl-gw52xx.dts
arch/arm/boot/dts/imx6dl-gw53xx.dts
arch/arm/boot/dts/imx6dl-gw54xx.dts
arch/arm/boot/dts/imx6q-gw52xx.dts
arch/arm/boot/dts/imx6q-gw53xx.dts
arch/arm/boot/dts/imx6q-gw54xx.dts
arch/arm/boot/dts/imx6qdl-gw51xx.dtsi
arch/arm/boot/dts/imx6qdl-gw553x.dtsi

So for the above which I've tested with the 'sensor -> ipu_csi_mux ->
ipu_csi -> ipu_smfc -> ipu_ic_prpvf -> camif' pipeline
Tested-by: Tim Harvey <tharvey@gateworks.com>

Thanks for all your continued effort on these drivers!

Tim
