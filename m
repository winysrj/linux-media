Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34675 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdGPEXD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 00:23:03 -0400
MIME-Version: 1.0
In-Reply-To: <2238838.k7NpPUxaC0@avalon>
References: <1500101920-24039-1-git-send-email-jacob-chen@iotwrt.com>
 <1500101920-24039-6-git-send-email-jacob-chen@iotwrt.com> <2238838.k7NpPUxaC0@avalon>
From: Jacob Chen <jacobchen110@gmail.com>
Date: Sun, 16 Jul 2017 12:23:02 +0800
Message-ID: <CAFLEztRwuzkAn_QrgRNv_yrNixuicfr99PEpR2SDyRROqe=b7w@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] ARM: dts: rockchip: enable RGA for rk3288 devices
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        robh+dt@kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        laurent.pinchart+renesas@ideasonboard.com,
        Hans Verkuil <hans.verkuil@cisco.com>, s.nawrocki@samsung.com,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

2017-07-15 17:16 GMT+08:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Jacob,
>
> Thank you for the patch.
>
> On Saturday 15 Jul 2017 14:58:39 Jacob Chen wrote:
>> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
>> ---
>>  arch/arm/boot/dts/rk3288-evb.dtsi                 | 4 ++++
>>  arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi | 4 ++++
>>  arch/arm/boot/dts/rk3288-firefly.dtsi             | 4 ++++
>>  arch/arm/boot/dts/rk3288-miqi.dts                 | 4 ++++
>>  arch/arm/boot/dts/rk3288-popmetal.dts             | 4 ++++
>>  arch/arm/boot/dts/rk3288-tinker.dts               | 4 ++++
>
> Some boards are missing from this list (Fennec, Phycore, ...) What criteria
> have you used to decide on which ones to enable the RGA ? That should be
> explained in the commit message.
>

Ok.

I just enable the boards i have tested, because i can't make sure it
won't break the other board
because of clocks or power-domains.

>>  6 files changed, 24 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi
>> b/arch/arm/boot/dts/rk3288-evb.dtsi index 4905760..ec12162 100644
>> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
>> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
>> @@ -379,6 +379,10 @@
>>       };
>>  };
>>
>> +&rga {
>> +     status = "okay";
>> +};
>> +
>>  &usbphy {
>>       status = "okay";
>>  };
>> diff --git a/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi
>> b/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi index 8134966..fffa92e2
>> 100644
>> --- a/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi
>> +++ b/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi
>> @@ -283,6 +283,10 @@
>>       };
>>  };
>>
>> +&rga {
>> +     status = "okay";
>> +};
>> +
>>  &tsadc {
>>       rockchip,hw-tshut-mode = <0>;
>>       rockchip,hw-tshut-polarity = <0>;
>> diff --git a/arch/arm/boot/dts/rk3288-firefly.dtsi
>> b/arch/arm/boot/dts/rk3288-firefly.dtsi index f520589..74a6ce5 100644
>> --- a/arch/arm/boot/dts/rk3288-firefly.dtsi
>> +++ b/arch/arm/boot/dts/rk3288-firefly.dtsi
>> @@ -500,6 +500,10 @@
>>       };
>>  };
>>
>> +&rga {
>> +     status = "okay";
>> +};
>> +
>>  &saradc {
>>       vref-supply = <&vcc_18>;
>>       status = "okay";
>> diff --git a/arch/arm/boot/dts/rk3288-miqi.dts
>> b/arch/arm/boot/dts/rk3288-miqi.dts index 21326f3..dc5e6bd 100644
>> --- a/arch/arm/boot/dts/rk3288-miqi.dts
>> +++ b/arch/arm/boot/dts/rk3288-miqi.dts
>> @@ -401,6 +401,10 @@
>>       };
>>  };
>>
>> +&rga {
>> +     status = "okay";
>> +};
>> +
>>  &saradc {
>>       vref-supply = <&vcc_18>;
>>       status = "okay";
>> diff --git a/arch/arm/boot/dts/rk3288-popmetal.dts
>> b/arch/arm/boot/dts/rk3288-popmetal.dts index aa1f9ec..362e5aa 100644
>> --- a/arch/arm/boot/dts/rk3288-popmetal.dts
>> +++ b/arch/arm/boot/dts/rk3288-popmetal.dts
>> @@ -490,6 +490,10 @@
>>       };
>>  };
>>
>> +&rga {
>> +     status = "okay";
>> +};
>> +
>>  &tsadc {
>>       rockchip,hw-tshut-mode = <0>;
>>       rockchip,hw-tshut-polarity = <0>;
>> diff --git a/arch/arm/boot/dts/rk3288-tinker.dts
>> b/arch/arm/boot/dts/rk3288-tinker.dts index 525b0e5..1a8c149 100644
>> --- a/arch/arm/boot/dts/rk3288-tinker.dts
>> +++ b/arch/arm/boot/dts/rk3288-tinker.dts
>> @@ -460,6 +460,10 @@
>>       status = "okay";
>>  };
>>
>> +&rga {
>> +     status = "okay";
>> +};
>> +
>>  &saradc {
>>       vref-supply = <&vcc18_ldo1>;
>>       status ="okay";
>
> --
> Regards,
>
> Laurent Pinchart
>
