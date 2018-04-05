Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33116 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeDEHd5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 03:33:57 -0400
MIME-Version: 1.0
In-Reply-To: <2180075.m4Wkig6IL5@avalon>
References: <20180212230132.5402-1-niklas.soderlund+renesas@ragnatech.se>
 <20180212230132.5402-3-niklas.soderlund+renesas@ragnatech.se>
 <20180329113039.4v5whquyrtgf5yaa@flea> <2180075.m4Wkig6IL5@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Apr 2018 09:33:55 +0200
Message-ID: <CAMuHMdXoprxZNP6KuYjcYW5EYjzAAFqNn6orK24pv7k_fO+i4A@mail.gmail.com>
Subject: Re: [PATCH v13 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Fukawa <tomoharu.fukawa.eb@renesas.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 4, 2018 at 5:26 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Thursday, 29 March 2018 14:30:39 EEST Maxime Ripard wrote:
>> On Tue, Feb 13, 2018 at 12:01:32AM +0100, Niklas S=C3=B6derlund wrote:
>> > +   switch (priv->lanes) {
>> > +   case 1:
>> > +           phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
>> > +           break;
>> > +   case 2:
>> > +           phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_1 | PHYCNT_ENA=
BLE_0;
>> > +           break;
>> > +   case 4:
>> > +           phycnt =3D PHYCNT_ENABLECLK | PHYCNT_ENABLE_3 | PHYCNT_ENA=
BLE_2 |
>> > +                   PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
>> > +           break;
>> > +   default:
>> > +           return -EINVAL;
>> > +   }
>>
>> I guess you could have a simpler construct here using this:
>>
>> phycnt =3D PHYCNT_ENABLECLK;
>>
>> switch (priv->lanes) {
>> case 4:
>>       phycnt |=3D PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2;
>> case 2:
>>       phycnt |=3D PHYCNT_ENABLE_1;
>> case 1:
>>       phycnt |=3D PHYCNT_ENABLE_0;
>>       break;
>>
>> default:
>>       return -EINVAL;
>> }
>>
>> But that's really up to you.
>
> Wouldn't Niklas' version generate simpler code as it uses direct assignme=
nts ?

Alternatively, you could check for a valid number of lanes, and use knowled=
ge
about the internal lane bits:

    phycnt =3D PHYCNT_ENABLECLK;
    phycnt |=3D (1 << priv->lanes) - 1;

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
