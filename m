Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f51.google.com ([209.85.221.51]:35908 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbeJaBeR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 21:34:17 -0400
Received: by mail-wr1-f51.google.com with SMTP id y16so13352082wrw.3
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 09:40:04 -0700 (PDT)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Tue, 30 Oct 2018 17:41:06 +0100
Message-ID: <CAL8zT=g1dquRZC=ZNO97nYjoX47JrZAUVrwJ+xVcR6LcmwY22g@mail.gmail.com>
Subject: i.MX6: can't capture on MIPI-CSI2 with DS90UB954
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        kieran.bingham@ideasonboard.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I am using the i.MX6D from Digi (connect core 6 sbc) with a mailine
kernel (well, 4.14 right now) and have an issue with mipi-csi2
capture.
First I will give brief explanation of my setup, and then I will
detail the issue.
I have a camera sensor (OV2732, but could be any other sensor)
connected on a DS90UB953 FPD-Link III serializer.
Then a coax cable propagates the signal to a DS90UB954 FPD-Link III
deserializer.

The DS90UB954 has the ability to work in a pattern generation mode,
and I will use it for the rest of the discussion.
It is an I=C2=B2C device, and I have written a basic driver (for the moment
;)) in order to make it visible on the imx6-mipi-csi2 bus as a camera
sensor.
I can give an access to the driver if necessary.

I then program the MC pipeline :
media-ctl -l "'ds90ub954 2-0034':0 -> 'imx6-mipi-csi2':0[1]" -v
media-ctl -l "'imx6-mipi-csi2':1 -> 'ipu1_csi0_mux':0[1]" -v
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]" -v
media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
media-ctl -V "'ds90ub954 2-0034':0 [fmt:RGB888_1X24/1280x720 field:none]"
media-ctl -V "'imx6-mipi-csi2':1 [fmt:RGB888_1X24/1280x720 field:none]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:RGB888_1X24/1280x720 field:none]"
media-ctl -V "'ipu1_csi0':2 [fmt:RGB888_1X24/1280x720 field:none]"

Everything works fine, all nodes are correctly configured, and the
DS90UB954 is normaly sending data on 2 lanes, with VC-ID=3D0.
The pattern is 1280x720@30 RGB888.

Then, I start a Gstreamer pipeline (I tried with v4l2-ctl and have the
same issue though) :
GST_DEBUG=3D"v4l2:5" gst-launch-1.0 v4l2src device=3D/dev/video4 !
video/x-raw, width=3D1280, height=3D720, format=3DRGB ! fakesink

And... well, I had to use this patch
https://lkml.org/lkml/2017/3/11/270 in order to go further, but I am
finishing into :
[  164.077302] imx-ipuv3-csi imx-ipuv3-csi.0: stream ON
[  164.097955] imx-ipuv3-csi imx-ipuv3-csi.0: FI=3D33333 usec
[  165.129424] ipu1_csi0: EOF timeout
[  165.142395] imx-ipuv3-csi imx-ipuv3-csi.0: stream OFF
[  166.169299] ipu1_csi0: wait last EOF timeout

Sounds like a recurrent issue on this ML :).
I can think of several things which could explain this, but I tried a
lot and am a bit stuck.
The clock is set to 800MHz on DS90UB954 side.
=3D> Should CSI2_PHY_TST_CTRL1 be 0x32 ? 0x12 ? or 0x4a (ie 400MHz) ?
I think I have tried all but still the same issue.

Maybe this could be a hint, when booting, the first stream-on leads to:
 imx6-mipi-csi2: LP-11 timeout, phy_state =3D 0x00000200 =3D> just a warnin=
g now
 imx6-mipi-csi2: clock lane timeout, phy_state =3D 0x00000230
The next one leads to the EOF timeout.

Here is the dts part BTW :
&i2c3 {
    status =3D "okay";

    ds90ub954: camera@34 {
        compatible =3D "ti,ds90ub954";
        status =3D "okay";
        reg =3D <0x34>;
        clocks =3D <&clks IMX6QDL_CLK_CKO>;
        clock-names =3D "xclk";
        port {
            #address-cells =3D <1>;
            #size-cells =3D <0>;

            ds90ub954_out0: endpoint {
                remote-endpoint =3D <&mipi_csi2_in>;
                clock-lanes =3D <0>;
                data-lanes =3D <1 2>;
            };
        };
    };
};

&mipi_csi {
    status =3D "okay";

    port@0 {
        reg =3D <0>;

        mipi_csi2_in: endpoint {
            remote-endpoint =3D <&ds90ub954_out0>;
            clock-lanes =3D <0>;
            data-lanes =3D <1 2>;
        };
    };
};


If ayone has a suggestion...
Thanks a lot !

Regards,
JM
