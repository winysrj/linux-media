Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38289 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbdHVSpn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 14:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <20170726083838.GC22320@bigcity.dyn.berto.se>
References: <CAPD8ABUMQgL88WdTHLsVuGRqJR46TJuJ4jHzPm7bgdBJp9k_sw@mail.gmail.com>
 <20170724094158.GA22320@bigcity.dyn.berto.se> <CAPD8ABWD7wqQiYLKiX4AV88Wzjcsc8aH6GgybWiawcAufiQx-g@mail.gmail.com>
 <20170726083838.GC22320@bigcity.dyn.berto.se>
From: Naman Jain <nsahula.photo.sharing@gmail.com>
Date: Wed, 23 Aug 2017 00:15:41 +0530
Message-ID: <CAPD8ABVUzPg9C+HT7OBVAFBUY5qH9EnnpfTvCJ70VCsxmPobMQ@mail.gmail.com>
Subject: Re: adv7281m and rcar-vin problem
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

adv7281m driver powers up the CSI transmitter in s_power(), which is
called before setting up of D-PHY layer of R-Car CSI-2 Receiver.
I shifted the part of code which enables CSI transmitter in adv7281m
(Low Power state to High Speed state) to s_stream() -

if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
           if (on) {
                        adv7180_csi_write(state, 0xDE, 0x02);
                        adv7180_csi_write(state, 0xD2, 0xF7);
                        adv7180_csi_write(state, 0xD8, 0x65);
                        adv7180_csi_write(state, 0xE0, 0x09);
                        adv7180_csi_write(state, 0x2C, 0x00);
                           if (state->field =3D=3D V4L2_FIELD_NONE)
                                   adv7180_csi_write(state, 0x1D, 0x80);
                        adv7180_csi_write(state, 0x00, 0x00);
                     } else {
                        adv7180_csi_write(state, 0x00, 0x80);
                      }
}

After this change, i am not getting timeout of reading the phy clock
lane and capture starts but nothing is displayed on the screen.

On Wed, Jul 26, 2017 at 2:08 PM, Niklas S=C3=B6derlund
<niklas.soderlund@ragnatech.se> wrote:
> Hi Naman,
>
> On 2017-07-24 22:43:06 +0530, Naman Jain wrote:
>> On Mon, Jul 24, 2017 at 3:11 PM, Niklas S=C3=B6derlund
>> <niklas.soderlund@ragnatech.se> wrote:
>> > Hi Naman,
>> >
>> > On 2017-07-24 14:30:52 +0530, Naman Jain wrote:
>> >> i am using renesas soc with video decoder adv7281m
>> >> i have done thr device tree configuration by following dt bindings
>> >> i am getting timeout of reading the phy clock lane, after i start str=
eaming
>> >> and nothing is displayed on the screen
>> >> kindly help me in configuration
>> >
>> > To be able to try and help you I would need a lot more information. Fo=
r
>> > starters:
>> >
>> > - Which kernel version are you using?
>> >
>> > - How dose the device tree nodes for VIN and ADV7281m look like?
>> >
>> > --
>> > Regards,
>> > Niklas S=C3=B6derlund
>>
>> Hi Niklas,
>>
>> I am using kernel version  - 4.9
>
> The VIN driver which supports CSI-2 and the R-Car CSI-2 driver is not a
> part of the upstream kernel yet, and the latest patches with contains
> the most fixes are based on newer kernels then v4.9. So I assume you are
> using a BSP of some sort, if possible could you tell me which one?
>
> If you want to try with later increments of the VIN and CSI-2 patches
> please see:
>
> http://elinux.org/R-Car/Tests:rcar-vin
>
>

Soc version is rcar-h3 (r8a7795).
Can tell me dependency patches required?

>>
>> following is the device tree configuration :
>>
>> &i2c6 {
>> status =3D "okay";
>> clock-frequency =3D <400000>;
>> adv7281m@21{
>>                    compatible =3D "adi,adv7281-m";
>>                    reg =3D <0x20>;
>>                    interrupt-parent =3D <&gpio6>;
>>                    interrupts =3D <4 IRQ_TYPE_LEVEL_LOW>
>>                    adv7281m_out: endpoint {
>>                                 clock-lanes =3D <0>;
>>                                 data-lanes =3D <1>;
>>                                 remote-endpoint =3D <&csi20_in>;
>>                                  };
>>                };
>>
>> }
>>
>> &csi20 {
>>   status =3D "okay";
>>   ports {
>>          #address-cells =3D <1>;
>>          #size-cells =3D <0>;
>>
>>          port@0 {
>>                         reg =3D <0>;
>>                         csi20_in: endpoint {
>>                                                    clock-lanes =3D <0>;
>>                                                    data-lanes =3D <1>;
>>                                                     virtual-channel-numb=
er=3D<0>;
>
> This is interesting for me, I have not worked with any driver for the
> R-Car CSI-2 driver which understands the virtual-channel-number
> property.
>
>>                                                    remote-endpoint =3D
>> <&adv7281m_out>;
>>                                             };
>>                        };
>>             };
>> };
>>
>> &vin0 {
>> status =3D "okay";
>> };
>>
>> &vin1 {
>> status =3D "okay";
>> };
>>
>> &vin2 {
>> status =3D "okay";
>> };
>>
>> &vin3 {
>> status =3D "okay";
>> };
>>
>> &vin4 {
>> status =3D "okay";
>> };
>>
>> &vin5 {
>> status =3D "okay";
>> };
>>
>> &vin6 {
>> status =3D "okay";
>> };
>>
>> &vin7 {
>> status =3D "okay";
>> };
>
> --
> Regards,
> Niklas S=C3=B6derlund
