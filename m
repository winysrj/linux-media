Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33303 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753579AbdGXRNI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 13:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <20170724094158.GA22320@bigcity.dyn.berto.se>
References: <CAPD8ABUMQgL88WdTHLsVuGRqJR46TJuJ4jHzPm7bgdBJp9k_sw@mail.gmail.com>
 <20170724094158.GA22320@bigcity.dyn.berto.se>
From: Naman Jain <nsahula.photo.sharing@gmail.com>
Date: Mon, 24 Jul 2017 22:43:06 +0530
Message-ID: <CAPD8ABWD7wqQiYLKiX4AV88Wzjcsc8aH6GgybWiawcAufiQx-g@mail.gmail.com>
Subject: Re: adv7281m and rcar-vin problem
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 24, 2017 at 3:11 PM, Niklas S=C3=B6derlund
<niklas.soderlund@ragnatech.se> wrote:
> Hi Naman,
>
> On 2017-07-24 14:30:52 +0530, Naman Jain wrote:
>> i am using renesas soc with video decoder adv7281m
>> i have done thr device tree configuration by following dt bindings
>> i am getting timeout of reading the phy clock lane, after i start stream=
ing
>> and nothing is displayed on the screen
>> kindly help me in configuration
>
> To be able to try and help you I would need a lot more information. For
> starters:
>
> - Which kernel version are you using?
>
> - How dose the device tree nodes for VIN and ADV7281m look like?
>
> --
> Regards,
> Niklas S=C3=B6derlund

Hi Niklas,

I am using kernel version  - 4.9

following is the device tree configuration :

&i2c6 {
status =3D "okay";
clock-frequency =3D <400000>;
adv7281m@21{
                   compatible =3D "adi,adv7281-m";
                   reg =3D <0x20>;
                   interrupt-parent =3D <&gpio6>;
                   interrupts =3D <4 IRQ_TYPE_LEVEL_LOW>
                   adv7281m_out: endpoint {
                                clock-lanes =3D <0>;
                                data-lanes =3D <1>;
                                remote-endpoint =3D <&csi20_in>;
                                 };
               };

}

&csi20 {
  status =3D "okay";
  ports {
         #address-cells =3D <1>;
         #size-cells =3D <0>;

         port@0 {
                        reg =3D <0>;
                        csi20_in: endpoint {
                                                   clock-lanes =3D <0>;
                                                   data-lanes =3D <1>;
                                                    virtual-channel-number=
=3D<0>;
                                                   remote-endpoint =3D
<&adv7281m_out>;
                                            };
                       };
            };
};

&vin0 {
status =3D "okay";
};

&vin1 {
status =3D "okay";
};

&vin2 {
status =3D "okay";
};

&vin3 {
status =3D "okay";
};

&vin4 {
status =3D "okay";
};

&vin5 {
status =3D "okay";
};

&vin6 {
status =3D "okay";
};

&vin7 {
status =3D "okay";
};
