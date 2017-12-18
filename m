Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38213 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936469AbdLRWVm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 17:21:42 -0500
Received: by mail-wm0-f45.google.com with SMTP id 64so560072wme.3
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 14:21:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5BUyF_E3aQByD2=4CxB-+DP189QAXMUA=AgOnq99wzmRg@mail.gmail.com>
References: <1510253136-14153-1-git-send-email-tharvey@gateworks.com>
 <1510253136-14153-4-git-send-email-tharvey@gateworks.com> <CAOMZO5BUyF_E3aQByD2=4CxB-+DP189QAXMUA=AgOnq99wzmRg@mail.gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 18 Dec 2017 14:21:40 -0800
Message-ID: <CAJ+vNU2F-3t9CqO8daeTWBarxepB7ZJKvj3LQR-nLEkspK+6nw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 3/5] media: i2c: Add TDA1997x HDMI receiver driver
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Shawn Guo <shawnguo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 16, 2017 at 11:32 AM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Tim,
>
> On Thu, Nov 9, 2017 at 4:45 PM, Tim Harvey <tharvey@gateworks.com> wrote:
>
>> +static int tda1997x_set_power(struct tda1997x_state *state, bool on)
>> +{
>> +       int ret = 0;
>> +
>> +       if (on) {
>> +               ret = regulator_bulk_enable(TDA1997X_NUM_SUPPLIES,
>> +                                            state->supplies);
>> +               msleep(300);
>
> Didn't you miss a 'return ret' here?
>
> Otherwise regulator_bulk_disable() will always be called below.
>

Fabio,

Yes thanks for catching that. I'll fix in the next revision.

Tim
