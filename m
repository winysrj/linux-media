Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33813 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752663AbdHVTJ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 15:09:57 -0400
Received: by mail-lf0-f48.google.com with SMTP id g77so51210235lfg.1
        for <linux-media@vger.kernel.org>; Tue, 22 Aug 2017 12:09:56 -0700 (PDT)
Date: Tue, 22 Aug 2017 21:09:54 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Naman Jain <nsahula.photo.sharing@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: adv7281m and rcar-vin problem
Message-ID: <20170822190953.GE14873@bigcity.dyn.berto.se>
References: <CAPD8ABUMQgL88WdTHLsVuGRqJR46TJuJ4jHzPm7bgdBJp9k_sw@mail.gmail.com>
 <20170724094158.GA22320@bigcity.dyn.berto.se>
 <CAPD8ABWD7wqQiYLKiX4AV88Wzjcsc8aH6GgybWiawcAufiQx-g@mail.gmail.com>
 <20170726083838.GC22320@bigcity.dyn.berto.se>
 <CAPD8ABVUzPg9C+HT7OBVAFBUY5qH9EnnpfTvCJ70VCsxmPobMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPD8ABVUzPg9C+HT7OBVAFBUY5qH9EnnpfTvCJ70VCsxmPobMQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Naman,

On 2017-08-23 00:15:41 +0530, Naman Jain wrote:
> Hi Niklas,
> 
> adv7281m driver powers up the CSI transmitter in s_power(), which is
> called before setting up of D-PHY layer of R-Car CSI-2 Receiver.
> I shifted the part of code which enables CSI transmitter in adv7281m
> (Low Power state to High Speed state) to s_stream() -
> 
> if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
>            if (on) {
>                         adv7180_csi_write(state, 0xDE, 0x02);
>                         adv7180_csi_write(state, 0xD2, 0xF7);
>                         adv7180_csi_write(state, 0xD8, 0x65);
>                         adv7180_csi_write(state, 0xE0, 0x09);
>                         adv7180_csi_write(state, 0x2C, 0x00);
>                            if (state->field == V4L2_FIELD_NONE)
>                                    adv7180_csi_write(state, 0x1D, 0x80);
>                         adv7180_csi_write(state, 0x00, 0x00);
>                      } else {
>                         adv7180_csi_write(state, 0x00, 0x80);
>                       }
> }
> 
> After this change, i am not getting timeout of reading the phy clock
> lane and capture starts but nothing is displayed on the screen.

I know nothing about the adv7281m driver, but if you define DEBUG in the 
rcar-vin and rcar-csi2 drivers it will provide you with a lot more 
information about how they behave and maybe it can help you in your 
troubleshooting. If you enable this and send me a console log of what 
happens when you try to start a stream I can try and help you.

> 
> On Wed, Jul 26, 2017 at 2:08 PM, Niklas Söderlund
> <niklas.soderlund@ragnatech.se> wrote:
> > Hi Naman,
> >
> > On 2017-07-24 22:43:06 +0530, Naman Jain wrote:
> >> On Mon, Jul 24, 2017 at 3:11 PM, Niklas Söderlund
> >> <niklas.soderlund@ragnatech.se> wrote:
> >> > Hi Naman,
> >> >
> >> > On 2017-07-24 14:30:52 +0530, Naman Jain wrote:
> >> >> i am using renesas soc with video decoder adv7281m
> >> >> i have done thr device tree configuration by following dt bindings
> >> >> i am getting timeout of reading the phy clock lane, after i start streaming
> >> >> and nothing is displayed on the screen
> >> >> kindly help me in configuration
> >> >
> >> > To be able to try and help you I would need a lot more information. For
> >> > starters:
> >> >
> >> > - Which kernel version are you using?
> >> >
> >> > - How dose the device tree nodes for VIN and ADV7281m look like?
> >> >
> >> > --
> >> > Regards,
> >> > Niklas Söderlund
> >>
> >> Hi Niklas,
> >>
> >> I am using kernel version  - 4.9
> >
> > The VIN driver which supports CSI-2 and the R-Car CSI-2 driver is not a
> > part of the upstream kernel yet, and the latest patches with contains
> > the most fixes are based on newer kernels then v4.9. So I assume you are
> > using a BSP of some sort, if possible could you tell me which one?
> >
> > If you want to try with later increments of the VIN and CSI-2 patches
> > please see:
> >
> > http://elinux.org/R-Car/Tests:rcar-vin
> >
> >
> 
> Soc version is rcar-h3 (r8a7795).
> Can tell me dependency patches required?

The dependencies are documented in the wiki page mentioned above, you 
can also use the latest renesas-drivers master branch

git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git

> 
> >>
> >> following is the device tree configuration :
> >>
> >> &i2c6 {
> >> status = "okay";
> >> clock-frequency = <400000>;
> >> adv7281m@21{
> >>                    compatible = "adi,adv7281-m";
> >>                    reg = <0x20>;
> >>                    interrupt-parent = <&gpio6>;
> >>                    interrupts = <4 IRQ_TYPE_LEVEL_LOW>
> >>                    adv7281m_out: endpoint {
> >>                                 clock-lanes = <0>;
> >>                                 data-lanes = <1>;
> >>                                 remote-endpoint = <&csi20_in>;
> >>                                  };
> >>                };
> >>
> >> }
> >>
> >> &csi20 {
> >>   status = "okay";
> >>   ports {
> >>          #address-cells = <1>;
> >>          #size-cells = <0>;
> >>
> >>          port@0 {
> >>                         reg = <0>;
> >>                         csi20_in: endpoint {
> >>                                                    clock-lanes = <0>;
> >>                                                    data-lanes = <1>;
> >>                                                     virtual-channel-number=<0>;
> >
> > This is interesting for me, I have not worked with any driver for the
> > R-Car CSI-2 driver which understands the virtual-channel-number
> > property.
> >
> >>                                                    remote-endpoint =
> >> <&adv7281m_out>;
> >>                                             };
> >>                        };
> >>             };
> >> };
> >>
> >> &vin0 {
> >> status = "okay";
> >> };
> >>
> >> &vin1 {
> >> status = "okay";
> >> };
> >>
> >> &vin2 {
> >> status = "okay";
> >> };
> >>
> >> &vin3 {
> >> status = "okay";
> >> };
> >>
> >> &vin4 {
> >> status = "okay";
> >> };
> >>
> >> &vin5 {
> >> status = "okay";
> >> };
> >>
> >> &vin6 {
> >> status = "okay";
> >> };
> >>
> >> &vin7 {
> >> status = "okay";
> >> };
> >
> > --
> > Regards,
> > Niklas Söderlund

-- 
Regards,
Niklas Söderlund
