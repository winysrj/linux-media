Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35713 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbdK3THB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 14:07:01 -0500
Received: by mail-oi0-f47.google.com with SMTP id 184so5556121oii.2
        for <linux-media@vger.kernel.org>; Thu, 30 Nov 2017 11:07:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1511975472-26659-3-git-send-email-hugues.fruchet@st.com>
References: <1511975472-26659-1-git-send-email-hugues.fruchet@st.com> <1511975472-26659-3-git-send-email-hugues.fruchet@st.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 30 Nov 2017 17:07:00 -0200
Message-ID: <CAOMZO5CUeHhju95KrOmNL7Q7kMjCO5JQdLkvXfBHsdEyOS1AGA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] media: ov5640: check chip id
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Wed, Nov 29, 2017 at 3:11 PM, Hugues Fruchet <hugues.fruchet@st.com> wrote:

>  /* read exposure, in number of line periods */
>  static int ov5640_get_exposure(struct ov5640_dev *sensor)
>  {
> @@ -1562,6 +1586,10 @@ static int ov5640_set_power(struct ov5640_dev *sensor, bool on)
>                 ov5640_reset(sensor);
>                 ov5640_power(sensor, true);
>
> +               ret = ov5640_check_chip_id(sensor);
> +               if (ret)
> +                       goto power_off;

Wouldn't it make more sense to add this check in ov5640_probe()
function instead?
