Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr40083.outbound.protection.outlook.com ([40.107.4.83]:14064
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751555AbdBJJvE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 04:51:04 -0500
From: Thomas Axelsson <Thomas.Axelsson@cybercom.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Device Tree formatting for multiple virtual channels in ti-vpe/cal
 driver?
Date: Fri, 10 Feb 2017 09:34:46 +0000
Message-ID: <DB5PR0701MB1909024C800EFCDE9AD9C4A588440@DB5PR0701MB1909.eurprd07.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a TI AM571x CPU, and I'm trying to add support for multiple MIPI CSI=
-2=20
virtual channels per PHY (port) to the ti-vpe/cal.c driver (CAMSS/CAL perip=
heral, =20
ch. 8 in Datasheet [1]). This CPU can have more contexts (virtual channels)=
 per PHY=20
than what it has DMA handlers. Each PHY may have up to 8 contexts, and ther=
e are 2=20
PHYs, but there are only 8 DMA channels in total. It is not required to use=
 DMA to=20
receive data from the context.
=20
Since it will be very useful to specify which contexts will use DMA and whi=
ch will=20
not, the proper place to do this seems to be the device tree.
=20
This becomes rather messy though, since it needs to be specified in the dev=
ice tree=20
node pointed to by the remote-endpoint field - yet, it's decided by the cap=
abilities=20
of the master component (in this case the CAL), so the remote-endpoint is a=
 weird=20
place to put it.
=20
I have made an example [2] using the Device Tree example in=20
Documentation/devicetree/bindings/media/ti-cal.txt (my own comments).
In the ar0330_1 endpoint, I have:
* Put multiple virtual channels in "reg", as in=20
  Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt,
* Added "dma-write" for specifying which virtual channels should get writte=
n=20
  directly to memory through DMA,
* Added "vip" just to show that a Virtual Channel can go somewhere else tha=
n=20
  through DMA write.
* Added "pix-proc" to show that pixel processing might be applied to some o=
f the=20
  Virtual Channels.
=20
What is your advice on how to properly move forward with adding support lik=
e this?

Thank you in advance.

Best regards,
Thomas Axelsson
=20

[1] http://www.ti.com/lit/gpn/am5716
=20
[2]
--------------------------------------------------
cal: cal@4845b000 {
    compatible =3D "ti,dra72-cal";
    ti,hwmods =3D "cal";
=20
    /* snip */
=20
    ports {
        #address-cells =3D <1>;
        #size-cells =3D <0>;
        csi2_0: port@0 {
            reg =3D <0>;                         /* PHY index, must match p=
ort index */
            status =3D "okay";                   /* Enable */
            endpoint {
                slave-mode;
                remote-endpoint =3D <&ar0330_1>;
            };
        };
        csi2_1: port@1 {
            reg =3D <1>;                         /* PHY Index */
        };
    };
};
=20
i2c5: i2c@4807c000 {
    ar0330@10 {
        compatible =3D "ti,ar0330";
        reg =3D <0x10>;
        port {
            #address-cells =3D <1>;
            #size-cells =3D <0>;
            ar0330_1: endpoint {
                reg =3D <0 1 2>;                 /* Virtual Channels */
                dma-write =3D <0 2>;             /* Virtual Channels that w=
ill use=20
                                                  Write DMA */
                vip =3D <1>;                     /* Virtual Channel to send=
 on to=20
                                                  Video Input Port */
                pix-proc =3D <2>;                /* Virtual channels to app=
ly pixel
                                                  processing on */
                clock-lanes =3D <1>;             /* Clock lane indices */
                data-lanes =3D <0 2 3 4>;        /* Data lane indices */
                remote-endpoint =3D <&csi2_0>;
            };
        };
    };
};
--------------------------------------------------
