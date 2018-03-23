Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:46950 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752494AbeCWLoO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:44:14 -0400
Received: by mail-ua0-f181.google.com with SMTP id d1so7549318ual.13
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2018 04:44:13 -0700 (PDT)
Received: from mail-ua0-f169.google.com (mail-ua0-f169.google.com. [209.85.217.169])
        by smtp.gmail.com with ESMTPSA id y22sm1999826uag.24.2018.03.23.04.44.11
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Mar 2018 04:44:11 -0700 (PDT)
Received: by mail-ua0-f169.google.com with SMTP id l21so2117948uak.1
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2018 04:44:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521218319-14972-1-git-send-email-andy.yeh@intel.com>
References: <1521218319-14972-1-git-send-email-andy.yeh@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 23 Mar 2018 20:43:50 +0900
Message-ID: <CAAFQd5Cbn1sqRWq6A6xYthkHtFjHaa64URDiKDMXOpDPr1r5EA@mail.gmail.com>
Subject: Re: [PATCH v9.1] media: imx258: Add imx258 camera sensor driver
To: Andy Yeh <andy.yeh@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Some issues found when reviewing cherry pick of this patch to Chrome
OS kernel. Please see inline.

On Sat, Mar 17, 2018 at 1:38 AM, Andy Yeh <andy.yeh@intel.com> wrote:

[snip]

> +       case V4L2_CID_VBLANK:
> +               /*
> +                * Auto Frame Length Line Control is enabled by default.
> +                * Not need control Vblank Register.
> +                */

What is the meaning of this control then? Should it be read-only?

> +               break;
> +       default:
> +               dev_info(&client->dev,
> +                        "ctrl(id:0x%x,val:0x%x) is not handled\n",
> +                        ctrl->id, ctrl->val);
> +               ret = -EINVAL;
> +               break;
> +       }
> +
> +       pm_runtime_put(&client->dev);
> +
> +       return ret;
> +

[snip]

> +       v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx258_ctrl_ops,
> +                               V4L2_CID_TEST_PATTERN,
> +                               ARRAY_SIZE(imx258_test_pattern_menu) - 1,
> +                               0, 0, imx258_test_pattern_menu);

There is no code for handling this control in imx258_s_ctrl(). It's
not a correct behavior to register a control, which isn't handled by
the driver. Please either implement the control completely or remove
it.

> +
> +       if (ctrl_hdlr->error) {
> +                               ret = ctrl_hdlr->error;
> +                               dev_err(&client->dev, "%s control init failed (%d)\n",
> +                               __func__, ret);
> +                               goto error;

Something strange happening here with indentation.

Best regards,
Tomasz
