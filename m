Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:40018 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753936AbeEOQkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 12:40:49 -0400
MIME-Version: 1.0
In-Reply-To: <568980a1-9c22-ccdb-de43-ba88cdce4ecd@xs4all.nl>
References: <1526395342-15481-1-git-send-email-narmstrong@baylibre.com>
 <1526395342-15481-5-git-send-email-narmstrong@baylibre.com> <568980a1-9c22-ccdb-de43-ba88cdce4ecd@xs4all.nl>
From: Enric Balletbo Serra <eballetbo@gmail.com>
Date: Tue, 15 May 2018 18:40:48 +0200
Message-ID: <CAFqH_52nkk=ATeNoOdhmfAioD30sbg_kyAxr259bydLj9Z6xJg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] mfd: cros_ec_dev: Add CEC sub-device registration
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        David Airlie <airlied@linux.ie>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lee Jones <lee.jones@linaro.org>,
        Olof Johansson <olof@lixom.net>, seanpaul@google.com,
        sadolfsson@google.com, intel-gfx@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Fabien Parent <fparent@baylibre.com>, felixe@google.com,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        Benson Leung <bleung@google.com>, darekm@google.com,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

I suspect that this patch will conflict with some patches that will be
queued for 4.18 that also introduces new devices, well, for now I
don't see these merged in the Lee's tree.

Based on some reviews I got when I send a patch to this file ...

2018-05-15 17:29 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 05/15/2018 04:42 PM, Neil Armstrong wrote:
>> The EC can expose a CEC bus, thus add the cros-ec-cec MFD sub-device
>> when the CEC feature bit is present.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>
> For what it is worth (not an MFD expert):
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> Thanks!
>
>         Hans
>
>> ---
>>  drivers/mfd/cros_ec_dev.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
>> index eafd06f..57064ec 100644
>> --- a/drivers/mfd/cros_ec_dev.c
>> +++ b/drivers/mfd/cros_ec_dev.c
>> @@ -383,6 +383,18 @@ static void cros_ec_sensors_register(struct cros_ec_dev *ec)
>>       kfree(msg);
>>  }
>>
>> +static void cros_ec_cec_register(struct cros_ec_dev *ec)
>> +{
>> +     int ret;
>> +     struct mfd_cell cec_cell = {
>> +             .name = "cros-ec-cec",
>> +     };
>> +
>> +     ret = mfd_add_devices(ec->dev, 0, &cec_cell, 1, NULL, 0, NULL);
>> +     if (ret)
>> +             dev_err(ec->dev, "failed to add EC CEC\n");
>> +}
>> +

Do not create a single function to only call mfd_add_devices, instead
do the following on top:

static const struct mfd_cell cros_ec_cec_cells[] = {
        { .name = "cros-ec-cec" }
};


>>  static int ec_device_probe(struct platform_device *pdev)
>>  {
>>       int retval = -ENOMEM;
>> @@ -422,6 +434,10 @@ static int ec_device_probe(struct platform_device *pdev)
>>       if (cros_ec_check_features(ec, EC_FEATURE_MOTION_SENSE))
>>               cros_ec_sensors_register(ec);
>>
>> +     /* check whether this EC handles CEC. */
>> +     if (cros_ec_check_features(ec, EC_FEATURE_CEC))
>> +             cros_ec_cec_register(ec);
>> +

and use PLATFORM_DEVID_AUTO and the ARRAY_SIZE macro, something like this.

/* Check whether this EC instance handles CEC */
if (cros_ec_check_features(ec, EC_FEATURE_CEC)) {
        retval = mfd_add_devices(ec->dev, PLATFORM_DEVID_AUTO,
                                                  cros_ec_cec_cells,
                                                  ARRAY_SIZE(cros_ec_cec_cells),
                                                  NULL, 0, NULL);
        if (retval)
                dev_err(ec->dev, "failed to add cros-ec-cec device: %d\n",
                             retval);
}

Best regards,
  Enric

>>       /* Take control of the lightbar from the EC. */
>>       lb_manual_suspend_ctrl(ec, 1);
>>
>>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
