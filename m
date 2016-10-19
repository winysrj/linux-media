Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:36866 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbcJSTZZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 15:25:25 -0400
Subject: Re: [PATCH v2 08/21] [media] imx: Add i.MX IPUv3 capture driver
To: Jack Mitchell <ml@embed.me.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <1476466481-24030-9-git-send-email-p.zabel@pengutronix.de>
 <a5a06050-f6e7-2031-4b14-312f085c5644@embed.me.uk>
 <1476706359.2488.13.camel@pengutronix.de>
 <fe21681b-0b92-c983-b14a-daf6504a9000@embed.me.uk>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
From: Marek Vasut <marex@denx.de>
Message-ID: <9550fc48-8bbd-181a-c6d5-5403c7088ac0@denx.de>
Date: Wed, 19 Oct 2016 21:25:16 +0200
MIME-Version: 1.0
In-Reply-To: <fe21681b-0b92-c983-b14a-daf6504a9000@embed.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/19/2016 06:22 PM, Jack Mitchell wrote:
> Hi Philipp,
> 
> On 17/10/16 13:12, Philipp Zabel wrote:
>> Hi Jack,
>>
>> Am Montag, den 17.10.2016, 12:32 +0100 schrieb Jack Mitchell:
>>> Hi Philipp,
>>>
>>> I'm looking at how I would enable a parallel greyscale camera using this
>>> set of drivers and am a little bit confused. Do you have an example
>>> somewhere of a devicetree with an input node.
>>
>> In your board device tree it should look somewhat like this:
>>
>> &i2c1 {
>>     sensor@48 {
>>         compatible = "aptina,mt9v032m";
>>         /* ... */
>>
>>         port {
>>             cam_out: endpoint {
>>                 remote-endpoint = <&csi_in>;
>>             }
>>         };
>>     };
>> };
>>
>> /*
>>  * This is the input port node corresponding to the 'CSI0' pad group,
>>  * not necessarily the CSI0 port of IPU1 or IPU2. On i.MX6Q it's port@1
>>  * of the mipi_ipu1_mux, on i.MX6DL it's port@4 of the ipu_csi0_mux,
>>  * the csi0 label is added in patch 13/21.
>>  */
>> &csi0 {
>>     #address-cells = <1>;
>>     #size-cells = <0>;
>>
>>     csi_in: endpoint@0 {
>>         bus-width = <8>;
>>         data-shift = <12>;
>>         hsync-active = <1>;
>>         vsync-active = <1>;
>>         pclk-sample = <1>;
>>         remote-endpoint = <&cam_out>;
>>     };
>> };
>>
>>>  I also have a further note below:
>> [...]
>>>> +    if (raw && priv->smfc) {
>>>
> 
> Thank you, I think I have something which is kind of right.
> 
> (Apologies in advance for the formatting)
> 
> diff --git a/arch/arm/boot/dts/imx6q-sabrelite.dts
> b/arch/arm/boot/dts/imx6q-sabrelite.dts
> index 66d10d8..90e6b92 100644
> --- a/arch/arm/boot/dts/imx6q-sabrelite.dts
> +++ b/arch/arm/boot/dts/imx6q-sabrelite.dts
> @@ -52,3 +52,62 @@
>  &sata {
>      status = "okay";
>  };
> +
> +&i2c2 {
> +    sensor@10 {
> +        compatible = "onsemi,ar0135";
> +        reg = <0x10>;
> +
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&pinctrl_ar0135>;
> +
> +        reset-gpio = <&gpio1 6 GPIO_ACTIVE_HIGH>;
> +
> +        clocks = <&clks IMX6QDL_CLK_CKO2>;
> +        clock-names = "xclk";
> +
> +        xclk = <24000000>;
> +
> +        port {
> +            parallel_camera_output: endpoint {
> +                remote-endpoint = <&csi_in_from_parallel_camera>;
> +            };
> +        };
> +    };
> +};
> +
> +&csi0 {
> +    csi_in_from_parallel_camera: endpoint@0 {
> +        bus-width = <8>;
> +        data-shift = <12>;
> +        hsync-active = <1>;
> +        vsync-active = <1>;
> +        pclk-sample = <1>;
> +        remote-endpoint = <&parallel_camera_output>;
> +    };
> +};
> +
> +&iomuxc {
> +
> +        imx6q-sabrelite {
> +
> +        pinctrl_ar0135: ar0135grp {
> +            fsl,pins = <
> +                MX6QDL_PAD_GPIO_6__GPIO1_IO06   0x80000000
> +                MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12    0x80000000
> +                MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13    0x80000000
> +                MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14    0x80000000
> +                MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15    0x80000000
> +                MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16    0x80000000
> +                MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17    0x80000000
> +                MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18    0x80000000
> +                MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19    0x80000000
> +                MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK   0x80000000
> +                MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC      0x80000000
> +                MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC     0x80000000
> +                MX6QDL_PAD_CSI0_DATA_EN__IPU1_CSI0_DATA_EN 0x80000000
> +            >;
> +        };
> +    };
> +};
> 
> 
> However, I can't seem to link the entities together properly, am I
> missing something obvious?
> 
> root@vicon:~# media-ctl -p
> Media controller API version 0.1.0
> 
> Media device information
> ------------------------
> driver          imx-media
> model           i.MX IPUv3
> serial
> bus info
> hw revision     0x0
> driver version  0.0.0
> 
> Device topology
> - entity 1: IPU0 CSI0 (2 pads, 1 link)
>             type V4L2 subdev subtype Unknown flags 0
>     pad0: Sink
>     pad1: Source
>         -> "imx-ipuv3-capture.0":0 [ENABLED]
> 
> - entity 4: imx-ipuv3-capture.0 (1 pad, 1 link)
>             type Node subtype V4L flags 0
>             device node name /dev/video0
>     pad0: Sink
>         <- "IPU0 CSI0":1 [ENABLED]
> 
> - entity 10: IPU0 CSI1 (2 pads, 1 link)
>              type V4L2 subdev subtype Unknown flags 0
>     pad0: Sink
>     pad1: Source
>         -> "imx-ipuv3-capture.1":0 [ENABLED]
> 
> - entity 13: imx-ipuv3-capture.1 (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video1
>     pad0: Sink
>         <- "IPU0 CSI1":1 [ENABLED]
> 
> - entity 19: IPU1 CSI0 (2 pads, 1 link)
>              type V4L2 subdev subtype Unknown flags 0
>     pad0: Sink
>     pad1: Source
>         -> "imx-ipuv3-capture.0":0 [ENABLED]
> 
> - entity 22: imx-ipuv3-capture.0 (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video2
>     pad0: Sink
>         <- "IPU1 CSI0":1 [ENABLED]
> 
> - entity 28: IPU1 CSI1 (2 pads, 1 link)
>              type V4L2 subdev subtype Unknown flags 0
>     pad0: Sink
>     pad1: Source
>         -> "imx-ipuv3-capture.1":0 [ENABLED]
> 
> - entity 31: imx-ipuv3-capture.1 (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video3
>     pad0: Sink
>         <- "IPU1 CSI1":1 [ENABLED]
> 
> - entity 37: mipi_ipu1_mux (3 pads, 0 link)
>              type V4L2 subdev subtype Unknown flags 0
>     pad0: Sink
>     pad1: Sink
>     pad2: Source
> 
> - entity 41: mipi_ipu2_mux (3 pads, 0 link)
>              type V4L2 subdev subtype Unknown flags 0
>     pad0: Sink
>     pad1: Sink
>     pad2: Source
> 
> - entity 45: ar0135 1-0010 (1 pad, 0 link)
>              type V4L2 subdev subtype Unknown flags 0
>     pad0: Source
> 
> 
> 
> 
> root@imx6:~# media-ctl -v --links '"ar01351-0010":0->"mipi_ipu1_mux":0[1]'
> 
> Opening media device /dev/media0
> Enumerating entities
> Found 11 entities
> Enumerating pads and links
> No link between "ar0135 1-0010":0 and "mipi_ipu1_mux":0
> media_parse_setup_link: Unable to parse link
> 
>  "ar0135 1-0010":0->"mipi_ipu1_mux":0[1]
>                                      ^
> Unable to parse link: Invalid argument (22)
> 
> If you have something in the works with a camera example then just tell
> me to be patient and I'll wait for a v3 ;)

Check whether you have something along these lines in your camera driver
in the probe() function:

        priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
        priv->subdev.dev = &client->dev;
        priv->pad.flags = MEDIA_PAD_FL_SOURCE;

        ret = media_entity_init(&priv->subdev.entity, 1, &priv->pad, 0);
        if (ret < 0) {
                v4l2_clk_put(priv->clk);
                return ret;
        }

        ret = v4l2_async_register_subdev(&priv->subdev);
        if (ret < 0) {
                v4l2_clk_put(priv->clk);
                return ret;
        }

-- 
Best regards,
Marek Vasut
