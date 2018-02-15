Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45212 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946054AbeBORnk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 12:43:40 -0500
Received: by mail-wr0-f195.google.com with SMTP id q16so466049wrf.12
        for <linux-media@vger.kernel.org>; Thu, 15 Feb 2018 09:43:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <10f08dfb-cc23-a9e3-7439-95955661cb77@xs4all.nl>
References: <1518712767-21928-1-git-send-email-tharvey@gateworks.com>
 <1518712767-21928-7-git-send-email-tharvey@gateworks.com> <10f08dfb-cc23-a9e3-7439-95955661cb77@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 15 Feb 2018 09:43:38 -0800
Message-ID: <CAJ+vNU1ZZnrMJgmOA+XBRjnV0WE8uyc4OSJvdKyZ_eooWGLqRA@mail.gmail.com>
Subject: Re: [PATCH v12 6/8] media: i2c: Add TDA1997x HDMI receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 15, 2018 at 9:16 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 15/02/18 17:39, Tim Harvey wrote:
>> Add support for the TDA1997x HDMI receivers.
>>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>> ---
>> v12:
>>  - fix coccinelle warnings
>
> Did you post the right version? I still see the owner being set and the
> other kbuild warning ('note: in expansion of macro 'v4l_dbg'') is also
> still there.
>
> Note that the last one also shows these errors:
>
> drivers/media/i2c/tda1997x.c:387:5-8: WARNING: Unsigned expression compared with zero: val < 0
> drivers/media/i2c/tda1997x.c:391:5-8: WARNING: Unsigned expression compared with zero: val < 0
> drivers/media/i2c/tda1997x.c:404:5-8: WARNING: Unsigned expression compared with zero: val < 0
> drivers/media/i2c/tda1997x.c:408:5-8: WARNING: Unsigned expression compared with zero: val < 0
> drivers/media/i2c/tda1997x.c:412:5-8: WARNING: Unsigned expression compared with zero: val < 0
> drivers/media/i2c/tda1997x.c:427:6-9: WARNING: Unsigned expression compared with zero: val < 0
>
> This is indeed wrong.
>
> Regards,
>
>         Hans

oh geez... no I goofed that up. I'll send a v13 now.

Tim
