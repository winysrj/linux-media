Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35150 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932707AbcI3NBB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 09:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <1951325.PMIbTHqE2x@avalon>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com>
 <20160916130935.21292-3-ulrich.hecht+renesas@gmail.com> <1951325.PMIbTHqE2x@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 30 Sep 2016 15:00:59 +0200
Message-ID: <CAMuHMdV3ZSfMeyCv3j8F3rUeT48nQc-03L5iDXYF-=wT7Ek2nw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: dts: gose: add HDMI input
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 30, 2016 at 2:40 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> --- a/arch/arm/boot/dts/r8a7793-gose.dts
>> +++ b/arch/arm/boot/dts/r8a7793-gose.dts
>> @@ -374,6 +374,11 @@
>>               groups = "audio_clk_a";
>>               function = "audio_clk";
>>       };
>> +
>> +     vin0_pins: vin0 {
>> +             groups = "vin0_data24", "vin0_sync", "vin0_clkenb",
> "vin0_clk";
>> +             function = "vin0";
>> +     };
>>  };
>>
>>  &ether {
>> @@ -531,6 +536,21 @@
>>               };
>>       };
>>
>> +     hdmi-in@4c {
>> +             compatible = "adi,adv7612";
>> +             reg = <0x4c>;
>> +             interrupt-parent = <&gpio1>;
>> +             interrupts = <20 IRQ_TYPE_LEVEL_LOW>;
>
> Isn't the interrupt signal connected to GP4_2 ?

No idea about Gose, but on Koelsch it is (hence koelsch DTS is wrong??)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
