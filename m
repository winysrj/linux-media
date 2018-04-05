Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f177.google.com ([74.125.82.177]:39267 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbeDEOYP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 10:24:15 -0400
Received: by mail-ot0-f177.google.com with SMTP id a14-v6so9203343otf.6
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 07:24:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5DKPaBwHEtr2DbOWfx7VU-5j9PKS6iCzpbx8B+Fwf2Wiw@mail.gmail.com>
References: <CAPQseg3c+jVBRv7nu9BZXFi2V+afrDUq+YR-0jEDGevgwa-NWw@mail.gmail.com>
 <CAOMZO5DKPaBwHEtr2DbOWfx7VU-5j9PKS6iCzpbx8B+Fwf2Wiw@mail.gmail.com>
From: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>
Date: Thu, 5 Apr 2018 16:24:14 +0200
Message-ID: <CAPQseg0g-64dPGoCFopiNJZPf9qjvdETOz=U-dLS_D0y+HrNHA@mail.gmail.com>
Subject: Re: IMX6 Media dev node not created
To: Fabio Estevam <festevam@gmail.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

Thanks for your reply.

On Thu, Apr 5, 2018 at 3:31 PM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Ibtsam,
>
> [Adding Steve and Philipp in case they can provide some suggestions]
>
> On Thu, Apr 5, 2018 at 9:30 AM, Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com> wrote:
>> Greetings everyone,
>>
>> I'm running Linux 4.14.31 on an IMX6 QuadPlus based Phytec board
>> (PCM-058). I have connected an mt9p031 sensor to ipu1_csi0. The
>> problem is that I am not seeing the /dev/media0 node.
>
> Can you share your dts?
>

Certainly. The dts provided by the board manufacturer was meant to
work with their own kernel, I tried to modify it to work with the
mainline kernel.

The sensor related nodes are:

&i2c1 {
    pinctrl-names = "default";
    pinctrl-0 = <&pinctrl_i2c1>;
    clock-frequency = <100000>;
    status = "okay";

    mt9p031_0: cam0@48 {
        compatible = "aptina,mt9p031";
        reg = <0x48>;
        status = "okay";
        vdd-supply = <&reg_cam2v8>;
        vdd_io-supply = <&reg_cam2v8>;
        vaa-supply = <&reg_cam2v8>;

        clocks = <&sensor_camclk>;

        port {
            mt9p031_ep0: endpoint {
                input-clock-frequency = <27000000>;
                pixel-clock-frequency = <54000000>;
                pclk-sample = <1>;
                remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
            };
        };
    };

    mt9p031_1: cam1@5d {
        compatible = "aptina,mt9p031";
        reg = <0x5d>;
        status = "okay";
        vdd-supply = <&reg_cam2v8>;
        vdd_io-supply = <&reg_cam2v8>;
        vaa-supply = <&reg_cam2v8>;

        clocks = <&sensor_camclk>;

        port {
            mt9p031_ep1: endpoint {
                input-clock-frequency = <27000000>;
                pixel-clock-frequency = <54000000>;
                bus-width = <12>;
                pclk-sample = <1>;
                remote-endpoint = <&ipu2_csi1_mux_from_parallel_sensor>;
            };
        };
    };
};


And the IPU related stuff:

&ipu1_csi0_from_ipu1_csi0_mux {
    bus-width = <8>;
    data-shift = <12>; /* Lines 19:12 used */
    hsync-active = <1>;
    vsync-active = <1>;
};

&ipu1_csi0_mux_from_parallel_sensor {
    remote-endpoint = <&mt9p031_ep0>;
};

&ipu1_csi0 {
    pinctrl-names = "default";
    pinctrl-0 = <
        &pinctrl_sensor_cam0_data
        &pinctrl_sensor_cam0_ctrl
    >;
};

&ipu2_csi1_from_ipu2_csi1_mux {
    bus-width = <8>;
    data-shift = <12>; /* Lines 19:12 used */
    hsync-active = <1>;
    vsync-active = <1>;
};

&ipu2_csi1_mux_from_parallel_sensor {
    remote-endpoint = <&mt9p031_ep1>;
};

&ipu2_csi1 {
    pinctrl-names = "default";
    pinctrl-0 = <
        &pinctrl_sensor_cam1_data
        &pinctrl_sensor_cam1_ctrl
    >;
};


>> I have already read the fix mentioned in a previous discussion:
>>
>> https://www.spinics.net/lists/linux-media/msg121965.html
>>
>> and that does not seem to be the problem in my case as I do get the
>> "ipu1_csi0_mux" registered. Running a grep on dmesg I get:
>>
>> [    3.235383] imx-media: Registered subdev ipu1_vdic
>> [    3.241134] imx-media: Registered subdev ipu2_vdic
>> [    3.246830] imx-media: Registered subdev ipu1_ic_prp
>> [    3.252115] imx-media: Registered subdev ipu1_ic_prpenc
>> [    3.266991] imx-media: Registered subdev ipu1_ic_prpvf
>> [    3.280228] imx-media: Registered subdev ipu2_ic_prp
>> [    3.285580] imx-media: Registered subdev ipu2_ic_prpenc
>> [    3.299335] imx-media: Registered subdev ipu2_ic_prpvf
>> [    3.350034] imx-media: Registered subdev ipu1_csi0
>> [    3.363017] imx-media: Registered subdev ipu1_csi1
>> [    3.375523] imx-media: Registered subdev ipu2_csi0
>> [    3.388615] imx-media: Registered subdev ipu2_csi1
>> [    3.560351] imx-media: Registered subdev ipu1_csi0_mux
>> [    3.566151] imx-media: Registered subdev ipu2_csi1_mux
>> [   10.525497] imx-media: Registered subdev mt9p031 0-0048
>> [   10.530816] imx-media capture-subsystem: Entity type for entity
>> mt9p031 0-0048 was not initialized!
>> [   10.569201] mt9p031 0-0048: MT9P031 detected at address 0x48
>> [   10.582895] imx-media: Registered subdev mt9p031 0-005d
>> [   10.588335] imx-media capture-subsystem: Entity type for entity
>> mt9p031 0-005d was not initialized!
>> [   10.618795] mt9p031 0-005d: MT9P031 not detected, wrong version 0xfffffffa
>
> Why do you have the camera in two I2C addresses: 0x48 and 0x5d?
>

I intend to use two cameras simultaneously. In my current setup
however only one camera is physically connected.


>> Also my config does appear to have the required options activated;
>> running "zcat /proc/config.gz | egrep 'VIDEO_MUX|MUX_MMIO|VIDEO_IMX'"
>> I get:
>>
>> # CONFIG_MDIO_BUS_MUX_MMIOREG is not set
>> CONFIG_VIDEO_MUX=y
>> CONFIG_VIDEO_IMX_VDOA=m
>> CONFIG_VIDEO_IMX_MEDIA=y
>> CONFIG_VIDEO_IMX_CSI=y
>> CONFIG_MUX_MMIO=y
>>
>> I would really appreciate if anyone could help me trying to find out
>> what went wrong and why the /dev/media0 node is not showing up.
>>
>> Many thanks and best regards,
>> Ibtsam Haq
