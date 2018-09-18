Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42523 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbeIRPV3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 11:21:29 -0400
Received: by mail-yb1-f196.google.com with SMTP id 13-v6so528586ybn.9
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 02:49:39 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id j132-v6sm685380ywg.46.2018.09.18.02.49.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Sep 2018 02:49:38 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id d9-v6so522644ybr.12
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 02:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <1537163872-14567-1-git-send-email-bingbu.cao@intel.com>
In-Reply-To: <1537163872-14567-1-git-send-email-bingbu.cao@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 18 Sep 2018 18:49:26 +0900
Message-ID: <CAAFQd5Dp8kp6fi8bXr6jODO0Cr4Kqu5L0eSXudsrOkHK6cKdjg@mail.gmail.com>
Subject: Re: [PATCH v5] media: add imx319 camera sensor driver
To: Cao Bing Bu <bingbu.cao@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        bingbu.cao@linux.intel.com,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bingbu,

On Mon, Sep 17, 2018 at 2:53 PM <bingbu.cao@intel.com> wrote:
>
> From: Bingbu Cao <bingbu.cao@intel.com>
>
> Add a v4l2 sub-device driver for the Sony imx319 image sensor.
> This is a camera sensor using the i2c bus for control and the
> csi-2 bus for data.

Please see my comments inline. Also, I'd appreciate being CCed on
related work in the future.

[snip]
> +
> +static const char * const imx319_test_pattern_menu[] = {
> +       "Disabled",
> +       "100% color bars",
> +       "Solid color",
> +       "Fade to gray color bars",
> +       "PN9"
> +};
> +
> +static const int imx319_test_pattern_val[] = {
> +       IMX319_TEST_PATTERN_DISABLED,
> +       IMX319_TEST_PATTERN_COLOR_BARS,
> +       IMX319_TEST_PATTERN_SOLID_COLOR,
> +       IMX319_TEST_PATTERN_GRAY_COLOR_BARS,
> +       IMX319_TEST_PATTERN_PN9,
> +};

This array is not needed. All the entries are equal to corresponding
indices, i.e. the array is equivalent to { 0, 1, 2, 3, 4 }. We can use
ctrl->val directly.
[snip]

> +/* Write a list of registers */
> +static int imx319_write_regs(struct imx319 *imx319,
> +                             const struct imx319_reg *regs, u32 len)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx319->sd);
> +       int ret;
> +       u32 i;
> +
> +       for (i = 0; i < len; i++) {
> +               ret = imx319_write_reg(imx319, regs[i].address, 1, regs[i].val);
> +               if (ret) {
> +                       dev_err_ratelimited(&client->dev,
> +

Hmm, the message is clipped here. Let me see if it's something with my
email client...

Best regards,
Tomasz
