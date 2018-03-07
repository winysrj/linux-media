Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:46339 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbeCGJv1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 04:51:27 -0500
Received: by mail-qt0-f182.google.com with SMTP id m13so1835440qtg.13
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 01:51:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180307081302.h47mjhlkeq72shw7@valkosipuli.retiisi.org.uk>
References: <1520355879-20291-1-git-send-email-hugues.fruchet@st.com> <20180307081302.h47mjhlkeq72shw7@valkosipuli.retiisi.org.uk>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 7 Mar 2018 06:51:26 -0300
Message-ID: <CAOMZO5BEi_dWmerMx5i3UoWU_3G7m3kgUWyGu4LfNMdvWNF+pw@mail.gmail.com>
Subject: Re: [PATCH] media: ov5640: fix get_/set_fmt colorspace related fields
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wed, Mar 7, 2018 at 5:13 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:

>> @@ -2497,16 +2504,22 @@ static int ov5640_probe(struct i2c_client *client,
>>       struct fwnode_handle *endpoint;
>>       struct ov5640_dev *sensor;
>>       int ret;
>> +     struct v4l2_mbus_framefmt *fmt;
>
> This one I'd arrange before ret. The local variable declarations should
> generally look like a Christmas tree but upside down.

It seems Mauro is not happy with reverse Christmas tree ordering:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg127221.html
