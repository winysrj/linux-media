Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:38691 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751675AbeDKEib (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 00:38:31 -0400
Received: by mail-vk0-f67.google.com with SMTP id b16so306180vka.5
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2018 21:38:30 -0700 (PDT)
Received: from mail-ua0-f169.google.com (mail-ua0-f169.google.com. [209.85.217.169])
        by smtp.gmail.com with ESMTPSA id 7sm137622uap.0.2018.04.10.21.38.28
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Apr 2018 21:38:29 -0700 (PDT)
Received: by mail-ua0-f169.google.com with SMTP id c3so325027uae.2
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2018 21:38:28 -0700 (PDT)
MIME-Version: 1.0
References: <1523375324-27856-1-git-send-email-andy.yeh@intel.com> <1523375324-27856-3-git-send-email-andy.yeh@intel.com>
In-Reply-To: <1523375324-27856-3-git-send-email-andy.yeh@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 11 Apr 2018 04:38:17 +0000
Message-ID: <CAAFQd5ApQdHCFAmA1PjUOcDGa6VMbc=JJA1mLa8WH2PJJGD17g@mail.gmail.com>
Subject: Re: [RESEND PATCH v7 2/2] media: dw9807: Add dw9807 vcm driver
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        devicetree@vger.kernel.org, jacopo@jmondi.org,
        Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy, Alan,

On Wed, Apr 11, 2018 at 12:41 AM Andy Yeh <andy.yeh@intel.com> wrote:

> From: Alan Chiang <alanx.chiang@intel.com>

> DW9807 is a 10 bit DAC from Dongwoon, designed for linear
> control of voice coil motor.

> This driver creates a V4L2 subdevice and
> provides control to set the desired focus.

Please see my comments inline.

[snip]
> +static int dw9807_i2c_check(struct i2c_client *client)
> +{
> +       const char status_addr = DW9807_STATUS_ADDR;
> +       char status_result;
> +       int ret;
> +
> +       ret = i2c_master_send(client, (const char *)&status_addr,
> +               sizeof(status_addr));

Why is this cast needed? status_addr is const char already, so
&status_addr, should be const char *.

> +       if (ret < 0) {
> +               dev_err(&client->dev, "I2C write STATUS address fail ret
= %d\n",
> +                       ret);
> +               return ret;
> +       }
> +
> +       ret = i2c_master_recv(client, (char *)&status_result,

Shouldn't need this cast.

> +               sizeof(status_result));
> +       if (ret != sizeof(status_result)) {
> +               dev_err(&client->dev, "I2C read STATUS value fail
ret=%d\n",
> +                       ret);
> +               return ret;
> +       }
> +
> +       return status_result;
> +}
> +
> +static int dw9807_set_dac(struct i2c_client *client, u16 data)
> +{
> +       const char tx_data[3] = {
> +               DW9807_MSB_ADDR, ((data >> 8) & 0x03), (data & 0xff)
> +       };
> +       int ret, retry = 0;
> +
> +       /*
> +        * According to the datasheet, need to check the bus status
before we
> +        * write VCM position. This ensure that we really write the value
> +        * into the register
> +        */
> +       while ((ret = dw9807_i2c_check(client)) != 0) {
> +               if (ret < 0)
> +                       return ret;
> +
> +               if (MAX_RETRY == ++retry) {
> +                       dev_err(&client->dev,
> +                               "Cannot do the write operation because
VCM is busy\n");
> +                       return -EIO;
> +               }
> +               usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US +
10);
> +       }

One could use readx_poll_timeout() here:

int val;

ret = readx_poll_timeout(dw9807_i2c_check, client, val, !val,
                          DW9807_CTRL_DELAY_US,
                          MAX_RETRY * DW9807_CTRL_DELAY_US);

if (ret) {
         dev_err(&client->dev,
                 "Cannot do the write operation because VCM is busy\n");
         return -EIO;
}

> +
> +       /* Write VCM position to registers */
> +       ret = i2c_master_send(client, tx_data, sizeof(tx_data));
> +       if (ret != sizeof(tx_data)) {
> +               if (ret < 0) {
> +                       dev_err(&client->dev,
> +                               "I2C write MSB fail ret=%d\n", ret);
> +                       return ret;
> +               } else {

I believe this can't happen, both by looking at implementation of
i2c_master_send() and existing drivers checking only for (ret < 0).

> +                       dev_err(&client->dev, "I2C write MSB fail,
transmission size is not equal the size expected\n");
> +                       return -EIO;
> +               }
> +       }
> +
> +       return 0;
> +}
[snip]
> +static const struct of_device_id dw9807_of_table[] = {
> +       { .compatible = "dongwoon,dw9807" },
> +       { { 0 } }

It looks like we may need other changes, so I'd go with

{ /* sentinel */ },

here. That's (+/- the comment) what other drivers use normally.

Best regards,
Tomasz
