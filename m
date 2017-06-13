Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34310 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751834AbdFMJi5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 05:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <c80cbe50-047e-3e54-94ac-5d4fa2a8c6e4@ideasonboard.com>
References: <cover.d0545e32d322ca1b939fa2918694173629e680eb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <865b71d4fcf6ce407a94a10d5dcb06944ddb6dcb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <CAMuHMdXarryPs6Fq1ZxorztbqD15W3+0UYnHVQs4pNNVtV=XNw@mail.gmail.com> <c80cbe50-047e-3e54-94ac-5d4fa2a8c6e4@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 13 Jun 2017 11:38:54 +0200
Message-ID: <CAMuHMdXtpnJcNLeG_TGHzsJve_JV2_oo+P4DbK0q6hbNcBh7ag@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] media: i2c: adv748x: add adv748x driver
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tue, Jun 13, 2017 at 11:32 AM, Kieran Bingham
<kieran.bingham+renesas@ideasonboard.com> wrote:
> On 13/06/17 10:24, Geert Uytterhoeven wrote:
>> On Tue, Jun 13, 2017 at 2:35 AM, Kieran Bingham <kbingham@kernel.org> wr=
ote:
>>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>
>>> Provide support for the ADV7481 and ADV7482.
>>>
>>> The driver is modelled with 4 subdevices to allow simultaneous streamin=
g
>>> from the AFE (Analog front end) and HDMI inputs though two CSI TX
>>> entities.
>>>
>>> The HDMI entity is linked to the TXA CSI bus, whilst the AFE is linked
>>> to the TXB CSI bus.
>>>
>>> The driver is based on a prototype by Koji Matsuoka in the Renesas BSP,
>>> and an earlier rework by Niklas S=C3=B6derlund.
>>>
>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>>> --- /dev/null
>>> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
>>
>>> +static int adv748x_hdmi_set_pixelrate(struct adv748x_hdmi *hdmi)
>>> +{
>>> +       struct v4l2_subdev *tx;
>>> +       struct v4l2_dv_timings timings;
>>> +       struct v4l2_bt_timings *bt =3D &timings.bt;
>>> +       unsigned int fps;
>>> +
>>> +       tx =3D adv748x_get_remote_sd(&hdmi->pads[ADV748X_HDMI_SOURCE]);
>>> +       if (!tx)
>>> +               return -ENOLINK;
>>> +
>>> +       adv748x_hdmi_query_dv_timings(&hdmi->sd, &timings);
>>> +
>>> +       fps =3D DIV_ROUND_CLOSEST(bt->pixelclock,
>>> +                               V4L2_DV_BT_FRAME_WIDTH(bt) *
>>> +                               V4L2_DV_BT_FRAME_HEIGHT(bt));
>>
>> On arm32:
>>
>>     drivers/built-in.o: In function `adv748x_hdmi_set_pixelrate':
>>     :(.text+0x1b8b1c): undefined reference to `__aeabi_uldivmod'
>>
>> v4l2_bt_timings.pixelclock is u64, so you should use DIV_ROUND_CLOSEST_U=
LL()
>> instead.
>
> Aha, thanks.
>
> /me ponders why I didn't get spammed from the bot-builders about this?

-EBUSY?

> Fix applied locally ready for v5.
>
> Would you like the remote updated for renesas-drivers or will you patch l=
ocally?

I'll patch it locally just to avoid receiving more spam from the builders s=
oon
(we don't use adv748x on arm32 boards).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
