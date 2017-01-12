Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:33124 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdALVNO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 16:13:14 -0500
Received: by mail-it0-f53.google.com with SMTP id d9so5602442itc.0
        for <linux-media@vger.kernel.org>; Thu, 12 Jan 2017 13:13:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <afe51f5f-03dd-4092-9ec0-297afb1453c7@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <CAJ+vNU2zU++Xam_UpDPfmSQhauhhS3_z8L-+ww6o-D9brWhiwA@mail.gmail.com> <afe51f5f-03dd-4092-9ec0-297afb1453c7@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 12 Jan 2017 13:13:12 -0800
Message-ID: <CAJ+vNU3ymeA9d+cJ44Wm_zX17EMkd__w6vB_xyagxzBAYNJbZQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
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

On Wed, Jan 11, 2017 at 7:22 PM, Steve Longerbeam
<steve_longerbeam@mentor.com> wrote:
> Hi Tim,
>
>
> On 01/11/2017 03:14 PM, Tim Harvey wrote:
>>
>>
>> <snip>
>>
>> Hi Steve,
>>
>> I took a stab at testing this today on a gw51xx which has an adv7180
>> hooked up as follows:
>> - i2c3@0x20
>> - 8bit data bus from DAT12 to DAT19, HSYNC, VSYNC, PIXCLK on CSI0 pads
>> (CSI0_IPU1)
>> - PWRDWN# on MX6QDL_PAD_CSI0_DATA_EN__GPIO5_IO20
>> - IRQ# on MX6QDL_PAD_CSI0_DAT5__GPIO5_IO23
>> - all three analog inputs available to off-board connector
>>
>> My patch to the imx6qdl-gw51xx dtsi is:
>
>
> As long as you used the patch to imx6qdl-sabreauto.dtsti that adds
> the adv7180 support as a guide, you should be ok here.

yes - fairly straightforward

>
>> <snip>
>>
>>
>>
>> On an IMX6Q I'm getting the following when the adv7180 module loads:
>> [   12.862477] adv7180 2-0020: chip found @ 0x20 (21a8000.i2c)
>> [   12.907767] imx-media: Registered subdev adv7180 2-0020
>> [   12.907793] imx-media soc:media@0: Entity type for entity adv7180
>> 2-0020 was not initialized!
>> [   12.907867] imx-media: imx_media_create_link: adv7180 2-0020:0 ->
>> ipu1_csi0_mux:1
>>
>> Is the warning that adv7180 was not initialized expected and or an issue?
>
>
> Yeah it's still a bug in the adv7180 driver, needs fixing.
>

ok - ignoring

>>
>> Now that your driver is hooking into the current media framework, I'm
>> not at all clear on how to link and configure the media entities.
>
>
> It's all documented at Documentation/media/v4l-drivers/imx.rst.
> Follow the SabreAuto pipeline setup example.
>

ah yes... it helps to read your patches! You did a great job on the
documentation.

Regarding the The ipu1_csi0_mux/ipu2_csi1_mux entities which have 1
source and 2 sinks (which makes sense for a mux) how do you know which
sink pad you should use (in your adv7180 example you use the 2nd sink
pad vs the first)?

As my hardware is the same as the SabreAuto except that my adv7180 is
on i2c-2@0x20 I follow your example from
Documentation/media/v4l-drivers/imx.rst:

# Setup links
media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":1[1]'
media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
media-ctl -l '"ipu1_csi0":1 -> "ipu1_smfc0":0[1]'
media-ctl -l '"ipu1_smfc0":1 -> "ipu1_ic_prpvf":0[1]'
media-ctl -l '"ipu1_ic_prpvf":1 -> "camif0":0[1]'
media-ctl -l '"camif0":1 -> "camif0 devnode":0[1]'

# Configure pads
media-ctl -V "\"adv7180 2-0020\":0 [fmt:UYVY2X8/720x480]"
media-ctl -V "\"ipu1_csi0_mux\":1 [fmt:UYVY2X8/720x480]"
media-ctl -V "\"ipu1_csi0_mux\":2 [fmt:UYVY2X8/720x480]"
media-ctl -V "\"ipu1_csi0\":0 [fmt:UYVY2X8/720x480]"
media-ctl -V "\"ipu1_csi0\":1 [fmt:UYVY2X8/720x480]"
media-ctl -V "\"ipu1_smfc0\":0 [fmt:UYVY2X8/720x480]"
media-ctl -V "\"ipu1_smfc0\":1 [fmt:UYVY2X8/720x480]"
media-ctl -V "\"ipu1_ic_prpvf\":0 [fmt:UYVY2X8/720x480]"
# pad field types for camif can be any format prpvf supports
export outputfmt="UYVY2X8/720x480"
media-ctl -V "\"ipu1_ic_prpvf\":1 [fmt:$outputfmt]"
media-ctl -V "\"camif0\":0 [fmt:$outputfmt]"
media-ctl -V "\"camif0\":1 [fmt:$outputfmt]"

# select AIN1
v4l2-ctl -d0 -i0
Video input set to 0 (ADV7180 Composite on Ain1: ok)
v4l2-ctl -d0 --set-fmt-video=width=720,height=480,pixelformat=UYVY
# capture a single raw frame
v4l2-ctl -d0 --stream-mmap --stream-to=/x.raw --stream-count=1
[ 2092.056394] camif0: pipeline_set_stream failed with -32
VIDIOC_STREAMON: failed: Broken pipe

Enabling debug in drivers/media/media-entity.c I see:
[   38.870087] imx-media soc:media@0: link validation failed for
"ipu1_smfc0":1 -> "ipu1_ic_prpvf":0, error -32

Looking at ipu1_smfc0 and ipu1_ic_prpvf with media-ctl I see:
- entity 12: ipu1_ic_prpvf (2 pads, 8 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev3
        pad0: Sink
                [fmt:UYVY2X8/720x480 field:alternate]
                <- "ipu1_csi0":1 []
                <- "ipu1_csi1":1 []
                <- "ipu1_smfc0":1 [ENABLED]
                <- "ipu1_smfc1":1 []
        pad1: Source
                [fmt:UYVY2X8/720x480 field:none]
                -> "camif0":0 [ENABLED]
                -> "camif1":0 []
                -> "ipu1_ic_pp0":0 []
                -> "ipu1_ic_pp1":0 []

- entity 45: ipu1_smfc0 (2 pads, 5 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev14
        pad0: Sink
                [fmt:UYVY2X8/720x480]
                <- "ipu1_csi0":1 [ENABLED]
        pad1: Source
                [fmt:UYVY2X8/720x480]
                -> "ipu1_ic_prpvf":0 [ENABLED]
                -> "ipu1_ic_pp0":0 []
                -> "camif0":0 []
                -> "camif1":0 []

Any ideas what is going wrong here? Seems like its perhaps a field
type mismatch. Is my outputfmt incorrect perhaps? I likely have
misunderstood the pad type comments in your documentation.

>
>
>> <snip>
>>
>>
>>
>> Additionally I've found that on an IMX6S/IMX6DL we crash while
>> registering the media-ic subdev's:
<snip>
>
> Yep, I only have quad boards here so I haven't gotten around to
> testing on S/DL.
>
> But it looks like I forgot to clear out the csi subdev pointer array before
> passing it to imx_media_of_parse(). I think that might explain the OOPS
> above. Try this patch:
>
> diff --git a/drivers/staging/media/imx/imx-media-dev.c
> b/drivers/staging/media/imx/imx-media-dev.c
> index 357654d..0cf2d61 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -379,7 +379,7 @@ static int imx_media_probe(struct platform_device *pdev)
>  {
>         struct device *dev = &pdev->dev;
>         struct device_node *node = dev->of_node;
> -       struct imx_media_subdev *csi[4];
> +       struct imx_media_subdev *csi[4] = {0};
>         struct imx_media_dev *imxmd;
>         int ret;
>

This does resolves the crash on S/DL.

I do notice that the ipu1_csi*_mux entities on the S/DL have 3 more
sink pads compared to the D/Q which is from the additional ports
defined in the GPR nodes you add for mipi_vc1/vc2/vc3. Are there
really 3 more MIPI virtual channels on the S/DL vs the D/Q?

I get the same results on the S/DL as I do on D/Q as long as I adjust
the links to compensate for these additional sinks:
media-ctl -l '"adv7180 2-0020":0 -> "ipu1_csi0_mux":4[1]'  # pad4
media-ctl -l '"ipu1_csi0_mux":5 -> "ipu1_csi0":0[1]' # pad5
...

This means link configuration must differ depending on S/DL vs D/Q
which is a bummer but I suppose this is the harsh reality as for
boards that use the EIM pads for IPU's they also will be using IPU2
for IMX6D/Q and IPU1 for IMX6S/DL.

Tim
