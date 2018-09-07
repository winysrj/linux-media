Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:32865 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbeIGND1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 09:03:27 -0400
Received: by mail-ed1-f68.google.com with SMTP id d8-v6so10950731edv.0
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 01:23:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180906084807.GL28160@w540>
References: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org>
 <1534328897-14957-2-git-send-email-jacopo+renesas@jmondi.org>
 <CAMZdPi8gr0p4GogZaj7Lyf1aJF_+xp1gfBfhh7R4S=7eNoR2TQ@mail.gmail.com>
 <20180906074815.GK28160@w540> <CAMZdPi8MTCCNp_Q_WZUm5TnH2U_x9bxO7QLmxaiBvMEAB5ujTw@mail.gmail.com>
 <20180906084807.GL28160@w540>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Fri, 7 Sep 2018 10:22:56 +0200
Message-ID: <CAMZdPi9o5OR2TxdwGw5osH5Duh-FSUnufPB1Ooie3_yDKZ6d8w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] media: ov5640: Re-work MIPI startup sequence
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sam Bobrowicz <sam@elite-embedded.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Fabio Estevam <festevam@gmail.com>, pza@pengutronix.de,
        steve_longerbeam@mentor.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Daniel Mack <daniel@zonque.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 September 2018 at 10:48, jacopo mondi <jacopo@jmondi.org> wrote:
> Hello Loic,
>
> On Thu, Sep 06, 2018 at 10:13:53AM +0200, Loic Poulain wrote:
>> On 6 September 2018 at 09:48, jacopo mondi <jacopo@jmondi.org> wrote:
>> > Hello Loic,
>> >    thanks for looking into this
>> >
>> > On Tue, Sep 04, 2018 at 07:22:50PM +0200, Loic Poulain wrote:
>> >> Hi Jacopo,
>> >>
>> >> > -       ret = ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
>> >> > -                            on ? 0 : BIT(5));
>> >> > -       if (ret)
>> >> > -               return ret;
>> >> > -       ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
>> >> > -                              on ? 0x00 : 0x70);
>> >> > +       /*
>> >> > +        * Enable/disable the MIPI interface
>> >> > +        *
>> >> > +        * 0x300e = on ? 0x45 : 0x40
>> >> > +        * [7:5] = 001  : 2 data lanes mode
>> >>
>> >> Does 2-Lanes work with this config?
>> >> AFAIU, if 2-Lanes is bit 5, value should be 0x25 and 0x20.
>> >>
>> >
>> > Yes, confusing.
>> >
>> > The sensor manual reports
>> > 0x300e[7:5] = 000 one lane mode
>> > 0x300e[7:5] = 001 two lanes mode
>> >
>> > Although this configuration works with 2 lanes, and the application
>> > note I have, with the suggested settings for MIPI CSI-2 2 lanes
>> > reports 0x40 to be the 2 lanes mode...
>> >
>> > I used that one, also because the removed entry from the settings blob
>> > is:
>> > -       {0x300e, 0x45, 0, 0}, {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
>> > +       {0x302e, 0x08, 0, 0}, {0x4300, 0x3f, 0, 0},
>> >
>> > So it was using BIT(6) already.
>>
>> Yes, it was setting BIT(6) from static config and BIT(5) from the
>> ov5640_set_stream_mipi function. In your patch you don't set
>> BIT(5) anymore.
>>
>> So it's not clear to me why it is still working, and the datasheet does
>> not help a lot on this (BIT(6) is for debug modes).
>> FYI I tried with BIT(5) only but it does not work (though I did not
>> investigate a lot).
>
> Thanks. Is your setup using 1 or 2 lanes? (I assume 2...)
>
> Another question, unrelated to this specific issue: was the ov5640
> working with dragonboard before this patch? I'm asking as I've seen
> different behaviors between different platforms, and knowing this
> fixes a widespread one like dragonboard is, would help getting this
> patches in faster :)

I did not test without the patch, will do.
