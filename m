Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36193 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbeITOed (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 10:34:33 -0400
Received: by mail-yb1-f195.google.com with SMTP id 5-v6so3603905ybf.3
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2018 01:52:09 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id s63-v6sm6220582ywd.63.2018.09.20.01.52.07
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Sep 2018 01:52:07 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id 14-v6so3450337ywe.2
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2018 01:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com>
In-Reply-To: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 20 Sep 2018 17:51:55 +0900
Message-ID: <CAAFQd5D=ze1nSCXwUxOm58+oiWNwuZDS5PvuR+xtNH0=YhA7NQ@mail.gmail.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
To: ping-chung.chen@intel.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        sylwester.nawrocki@gmail.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[+Laurent and Sylwester]

On Wed, Aug 8, 2018 at 4:08 PM Ping-chung Chen
<ping-chung.chen@intel.com> wrote:
[snip]
> +
> +/* Digital gain control */
> +#define IMX208_REG_GR_DIGITAL_GAIN     0x020e
> +#define IMX208_REG_R_DIGITAL_GAIN      0x0210
> +#define IMX208_REG_B_DIGITAL_GAIN      0x0212
> +#define IMX208_REG_GB_DIGITAL_GAIN     0x0214
> +#define IMX208_DGTL_GAIN_MIN           0
> +#define IMX208_DGTL_GAIN_MAX           4096
> +#define IMX208_DGTL_GAIN_DEFAULT       0x100
> +#define IMX208_DGTL_GAIN_STEP           1
> +
[snip]
> +/* Initialize control handlers */
> +static int imx208_init_controls(struct imx208 *imx208)
> +{
[snip]
> +       v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
> +                         IMX208_DGTL_GAIN_MIN, IMX208_DGTL_GAIN_MAX,
> +                         IMX208_DGTL_GAIN_STEP,
> +                         IMX208_DGTL_GAIN_DEFAULT);

We have a problem here. The sensor supports only a discrete range of
values here - {1, 2, 4, 8, 16} (multiplied by 256, since the value is
fixed point). This makes it possible for the userspace to set values
that are not allowed by the sensor specification and also leaves no
way to enumerate the supported values.

I can see two solutions here:

1) Define the control range from 0 to 4 and treat it as an exponent of
2, so that the value for the sensor becomes (1 << val) * 256.
(Suggested by Sakari offline.)

This approach has the problem of losing the original unit (and scale)
of the value.

2) Use an integer menu control, which reports only the supported
discrete values - {1, 2, 4, 8, 16}.

With this approach, userspace can enumerate the real gain values, but
we would either need to introduce a new control (e.g.
V4L2_CID_DIGITAL_GAIN_DISCRETE) or abuse the specification and
register V4L2_CID_DIGITAL_GAIN as an integer menu.

Any opinions or better ideas?

Best regards,
Tomasz
