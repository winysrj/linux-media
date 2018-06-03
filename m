Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:33088 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751132AbeFCXuX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Jun 2018 19:50:23 -0400
From: "Katsuhiro Suzuki" <suzuki.katsuhiro@socionext.com>
To: "'Masahiro Yamada'" <yamada.masahiro@socionext.com>,
        =?utf-8?B?U3V6dWtpLCBLYXRzdWhpcm8v6Yi05pyoIOWLneWNmg==?=
        <suzuki.katsuhiro@socionext.com>
Cc: "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        <linux-media@vger.kernel.org>,
        "Masami Hiramatsu" <masami.hiramatsu@linaro.org>,
        "Jassi Brar" <jaswinder.singh@linaro.org>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com> <20180530090946.1635-2-suzuki.katsuhiro@socionext.com> <CAK7LNAT3qOrH5PgidVKk73PeL97-VuySnkzSBDWUWqoD8ZwuyQ@mail.gmail.com>
In-Reply-To: <CAK7LNAT3qOrH5PgidVKk73PeL97-VuySnkzSBDWUWqoD8ZwuyQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] media: uniphier: add DT bindings documentation for UniPhier HSC
Date: Mon, 4 Jun 2018 08:50:18 +0900
Message-ID: <005c01d3fb95$a0b016f0$e21044d0$@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: ja
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Yamada-san,

Thank you for your review and comments.
I'll fix this mail and other your replies!

Regards,
--
Katsuhiro Suzuki


> -----Original Message-----
> From: Masahiro Yamada <yamada.masahiro@socionext.com>
> Sent: Saturday, June 2, 2018 6:50 PM
> To: Suzuki, Katsuhiro/鈴木 勝博 <suzuki.katsuhiro@socionext.com>
> Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>;
> linux-media@vger.kernel.org; Masami Hiramatsu <masami.hiramatsu@linaro.org>;
> Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel
> <linux-arm-kernel@lists.infradead.org>; Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH 1/8] media: uniphier: add DT bindings documentation for UniPhier
> HSC
> 
> 2018-05-30 18:09 GMT+09:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>:
> > This patch adds DT binding documentation for UniPhier HSC which is
> > MPEG2-TS input/output and demux subsystem.
> >
> > Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
> > ---
> >  .../bindings/media/uniphier,hsc.txt           | 38 +++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/uniphier,hsc.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/uniphier,hsc.txt
> b/Documentation/devicetree/bindings/media/uniphier,hsc.txt
> > new file mode 100644
> > index 000000000000..4242483b2ecc
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/uniphier,hsc.txt
> > @@ -0,0 +1,38 @@
> > +Socionext UniPhier HSC (High-speed Stream Controller)
> > +
> > +The Socionext UniPhier HSC subsystem consists of MPEG2-TS input/output and
> > +demultiplexer cores in the same register space.
> > +
> > +This interface is support TS serial signals (clock, valid, sync, data) from
> > +external demodulators.
> > +
> > +Required properties:
> > +- compatible      : should be one of the following:
> > +                   "socionext,uniphier-ld11-hsc"
> > +                   "socionext,uniphier-ld20-hsc"
> > +- reg             : offset and length of the register set for the device.
> > +- interrupts      : should contain DMA and TSI error interrupt.
> > +- pinctrl-names   : should be "default".
> > +- pinctrl-0       : defined TS serial signal pins for external demodulators.
> > +- clock-names     : should include following entries:
> 
> 
> "the following entries:"
> 
> 
> 
> > +                    "hsc", "stdmac"
> > +- clocks          : a list of phandle, should contain an entry for each
> > +                    entry in clock-names.
> > +- reset-names     : should include following entries:
> 
> 
> Ditto.
> 
> 
> 
> > +                    "hsc", "stdmac"
> > +- resets          : a list of phandle, should contain an entry for each
> > +                    entry in reset-names.
> > +
> > +Example:
> > +       hsc {
> > +               compatible = "socionext,uniphier-ld20-hsc";
> > +               reg = <0x5c000000 0x100000>;
> > +               interrupts = <0 100 4>, <0 101 4>;
> > +               pinctrl-names = "default";
> > +               pinctrl-0 = <&pinctrl_hscin2_s>,
> > +                           <&pinctrl_hscin3_s>;
> > +               clock-names = "stdmac", "hsc";
> > +               clocks = <&sys_clk 8>, <&sys_clk 9>;
> > +               reset-names = "stdmac", "hsc";
> > +               resets = <&sys_rst 8>, <&sys_rst 9>;
> > +       };
> > --
> > 2.17.0
> >
> 
> 
> 
> --
> Best Regards
> Masahiro Yamada
