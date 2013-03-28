Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52804 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3C1I3b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 04:29:31 -0400
Received: by mail-vc0-f174.google.com with SMTP id hx10so7378333vcb.33
        for <linux-media@vger.kernel.org>; Thu, 28 Mar 2013 01:29:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3061473.pZdeCOpV7t@avalon>
References: <1358546444-30265-1-git-send-email-scott.jiang.linux@gmail.com>
	<3061473.pZdeCOpV7t@avalon>
Date: Thu, 28 Mar 2013 16:29:30 +0800
Message-ID: <CAHG8p1CP8nSjVFeus17wDfiSgq1qTMDDvAJtJODmt5OxL3zj=A@mail.gmail.com>
Subject: Re: [PATCH RFC] [media] add Aptina mt9m114 HD digital image sensor driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> This driver support parallel data output mode and
>> QVGA/VGA/WVGA/720P resolution. You can select YCbCr and RGB565
>> output format.
>
> What host bridge do you use this driver with ?
>
I only tested with blackfin.

>
>> + */
>
> [snip]
>
>> +struct mt9m114_reg {
>> +     u16 reg;
>> +     u32 val;
>> +     int width;
>> +};
>> +
>> +enum {
>> +     MT9M114_QVGA,
>> +     MT9M114_VGA,
>> +     MT9M114_WVGA,
>> +     MT9M114_720P,
>> +};
>
> This is the part I don't like. Instead of hardcoding 4 different resolutions
> and using large register address/value tables, you should compute the register
> values from the image size requested by the user.
>
In fact we get this table with the Aptina development tool. So we only support
fixed resolutions. If we compute each register value, it only makes
the code more complex.
