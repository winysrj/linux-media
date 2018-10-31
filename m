Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f173.google.com ([209.85.214.173]:35527 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbeKAGwy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 02:52:54 -0400
Received: by mail-pl1-f173.google.com with SMTP id n4-v6so7346054plp.2
        for <linux-media@vger.kernel.org>; Wed, 31 Oct 2018 14:52:59 -0700 (PDT)
Subject: Re: i.MX6: can't capture on MIPI-CSI2 with DS90UB954
To: Jean-Michel Hautbois <jhautbois@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        kieran.bingham@ideasonboard.com
References: <CAL8zT=g1dquRZC=ZNO97nYjoX47JrZAUVrwJ+xVcR6LcmwY22g@mail.gmail.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b368e66b-eafa-1c3e-f75d-a57ccb6cc125@gmail.com>
Date: Wed, 31 Oct 2018 14:52:55 -0700
MIME-Version: 1.0
In-Reply-To: <CAL8zT=g1dquRZC=ZNO97nYjoX47JrZAUVrwJ+xVcR6LcmwY22g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

We've done some work with another FPD-Link de-serializer (ds90ux940) and 
IIRC we had some trouble figuring out how to coax the lanes into LP-11 
state. But on the ds90ux940 it can be done by setting bit 7 in the CSI 
Enable Port registers (offsets 0x13 and 0x14). But the "imx6-mipi-csi2: 
clock lane timeout" message is something else and indicates the 
de-serializer is not activating the clock lane during its s_stream(ON) 
subdev call.

Hope that helps,
Steve


On 10/30/18 9:41 AM, Jean-Michel Hautbois wrote:
> Hi there,
>
> I am using the i.MX6D from Digi (connect core 6 sbc) with a mailine
> kernel (well, 4.14 right now) and have an issue with mipi-csi2
> capture.
> First I will give brief explanation of my setup, and then I will
> detail the issue.
> I have a camera sensor (OV2732, but could be any other sensor)
> connected on a DS90UB953 FPD-Link III serializer.
> Then a coax cable propagates the signal to a DS90UB954 FPD-Link III
> deserializer.
>
> The DS90UB954 has the ability to work in a pattern generation mode,
> and I will use it for the rest of the discussion.
> It is an I²C device, and I have written a basic driver (for the moment
> ;)) in order to make it visible on the imx6-mipi-csi2 bus as a camera
> sensor.
> I can give an access to the driver if necessary.
>
> I then program the MC pipeline :
> media-ctl -l "'ds90ub954 2-0034':0 -> 'imx6-mipi-csi2':0[1]" -v
> media-ctl -l "'imx6-mipi-csi2':1 -> 'ipu1_csi0_mux':0[1]" -v
> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]" -v
> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> media-ctl -V "'ds90ub954 2-0034':0 [fmt:RGB888_1X24/1280x720 field:none]"
> media-ctl -V "'imx6-mipi-csi2':1 [fmt:RGB888_1X24/1280x720 field:none]"
> media-ctl -V "'ipu1_csi0_mux':2 [fmt:RGB888_1X24/1280x720 field:none]"
> media-ctl -V "'ipu1_csi0':2 [fmt:RGB888_1X24/1280x720 field:none]"
>
> Everything works fine, all nodes are correctly configured, and the
> DS90UB954 is normaly sending data on 2 lanes, with VC-ID=0.
> The pattern is 1280x720@30 RGB888.
>
> Then, I start a Gstreamer pipeline (I tried with v4l2-ctl and have the
> same issue though) :
> GST_DEBUG="v4l2:5" gst-launch-1.0 v4l2src device=/dev/video4 !
> video/x-raw, width=1280, height=720, format=RGB ! fakesink
>
> And... well, I had to use this patch
> https://lkml.org/lkml/2017/3/11/270 in order to go further, but I am
> finishing into :
> [  164.077302] imx-ipuv3-csi imx-ipuv3-csi.0: stream ON
> [  164.097955] imx-ipuv3-csi imx-ipuv3-csi.0: FI=33333 usec
> [  165.129424] ipu1_csi0: EOF timeout
> [  165.142395] imx-ipuv3-csi imx-ipuv3-csi.0: stream OFF
> [  166.169299] ipu1_csi0: wait last EOF timeout
>
> Sounds like a recurrent issue on this ML :).
> I can think of several things which could explain this, but I tried a
> lot and am a bit stuck.
> The clock is set to 800MHz on DS90UB954 side.
> => Should CSI2_PHY_TST_CTRL1 be 0x32 ? 0x12 ? or 0x4a (ie 400MHz) ?
> I think I have tried all but still the same issue.
>
> Maybe this could be a hint, when booting, the first stream-on leads to:
>   imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200 => just a warning now
>   imx6-mipi-csi2: clock lane timeout, phy_state = 0x00000230
> The next one leads to the EOF timeout.
>
> Here is the dts part BTW :
> &i2c3 {
>      status = "okay";
>
>      ds90ub954: camera@34 {
>          compatible = "ti,ds90ub954";
>          status = "okay";
>          reg = <0x34>;
>          clocks = <&clks IMX6QDL_CLK_CKO>;
>          clock-names = "xclk";
>          port {
>              #address-cells = <1>;
>              #size-cells = <0>;
>
>              ds90ub954_out0: endpoint {
>                  remote-endpoint = <&mipi_csi2_in>;
>                  clock-lanes = <0>;
>                  data-lanes = <1 2>;
>              };
>          };
>      };
> };
>
> &mipi_csi {
>      status = "okay";
>
>      port@0 {
>          reg = <0>;
>
>          mipi_csi2_in: endpoint {
>              remote-endpoint = <&ds90ub954_out0>;
>              clock-lanes = <0>;
>              data-lanes = <1 2>;
>          };
>      };
> };
>
>
> If ayone has a suggestion...
> Thanks a lot !
>
> Regards,
> JM
