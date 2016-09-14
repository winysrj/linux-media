Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32842 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756249AbcINNRd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 09:17:33 -0400
Received: by mail-oi0-f41.google.com with SMTP id r126so20440476oib.0
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 06:17:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <16e7882f-2975-281a-eb6e-f27c3ca76fa2@xs4all.nl>
References: <1473852249-15960-1-git-send-email-benjamin.gaignard@linaro.org>
 <1473852249-15960-3-git-send-email-benjamin.gaignard@linaro.org> <16e7882f-2975-281a-eb6e-f27c3ca76fa2@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Wed, 14 Sep 2016 15:17:31 +0200
Message-ID: <CA+M3ks6AO0VzQQfSstpQj1phhZcq5JOFLZxJEFCOKKEOzWuBoQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] add stih-cec driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: hans.verkuil@cisco.com,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed and tested, thanks.

I will wait for any others comments before send a v3.

Regards,
Benjamin

2016-09-14 14:58 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Benjamin,
>
> Just one comment:
>
> On 09/14/2016 01:24 PM, Benjamin Gaignard wrote:
>> This patch implement CEC driver for stih4xx platform.
>> Driver compliance has been test with cec-ctl and
>> cec-compliance tools.
>>
>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>> ---
>>  drivers/staging/media/Kconfig           |   2 +
>>  drivers/staging/media/Makefile          |   1 +
>>  drivers/staging/media/st-cec/Kconfig    |   8 +
>>  drivers/staging/media/st-cec/Makefile   |   1 +
>>  drivers/staging/media/st-cec/stih-cec.c | 382 +++++++++++++++++++++++++=
+++++++
>>  5 files changed, 394 insertions(+)
>>  create mode 100644 drivers/staging/media/st-cec/Kconfig
>>  create mode 100644 drivers/staging/media/st-cec/Makefile
>>  create mode 100644 drivers/staging/media/st-cec/stih-cec.c
>>
>
> <snip>
>
>> +static void stih_rx_done(struct stih_cec *cec, u32 status)
>> +{
>> +     struct cec_msg *msg =3D &cec->rx_msg;
>
> You can just say:
>
>         struct cec_msg msg =3D {};
>
> and drop rx_msg.
>
>> +     u8 i;
>> +
>> +     if (status & CEC_RX_ERROR_MIN)
>> +             return;
>> +
>> +     if (status & CEC_RX_ERROR_MAX)
>> +             return;
>> +
>> +     memset(msg, 0x00, sizeof(*msg));
>> +     msg->len =3D readl(cec->regs + CEC_DATA_ARRAY_STATUS) & 0x1f;
>> +
>> +     if (!msg-len)
>> +             return;
>> +
>> +     if (msg->len > 16)
>> +             msg->len =3D 16;
>> +
>> +     for (i =3D 0; i < msg->len; i++)
>> +             msg->msg[i] =3D readl(cec->regs + CEC_RX_DATA_BASE + i);
>> +
>> +     cec_received_msg(cec->adap, msg);
>
> cec_received_msg will copy the contents, so it is OK if it is gone after
> this call.
>
>> +}
>
> Regards,
>
>         Hans



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
