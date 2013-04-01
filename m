Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:35736 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab3DAJdE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 05:33:04 -0400
Received: by mail-ve0-f180.google.com with SMTP id c13so2269155vea.25
        for <linux-media@vger.kernel.org>; Mon, 01 Apr 2013 02:33:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1691028.0qtxercLZ8@avalon>
References: <1358546444-30265-1-git-send-email-scott.jiang.linux@gmail.com>
	<3061473.pZdeCOpV7t@avalon>
	<CAHG8p1CP8nSjVFeus17wDfiSgq1qTMDDvAJtJODmt5OxL3zj=A@mail.gmail.com>
	<1691028.0qtxercLZ8@avalon>
Date: Mon, 1 Apr 2013 17:33:02 +0800
Message-ID: <CAHG8p1CpeF3BGyVB1pT+brOB+1o1MmuEZuAk+mvDhY_wPYynLA@mail.gmail.com>
Subject: Re: [PATCH RFC] [media] add Aptina mt9m114 HD digital image sensor driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

>> >
>> >> +struct mt9m114_reg {
>> >> +     u16 reg;
>> >> +     u32 val;
>> >> +     int width;
>> >> +};
>> >> +
>> >> +enum {
>> >> +     MT9M114_QVGA,
>> >> +     MT9M114_VGA,
>> >> +     MT9M114_WVGA,
>> >> +     MT9M114_720P,
>> >> +};
>> >
>> > This is the part I don't like. Instead of hardcoding 4 different
>> > resolutions and using large register address/value tables, you should
>> > compute the register values from the image size requested by the user.
>>
>> In fact we get this table with the Aptina development tool. So we only
>> support fixed resolutions. If we compute each register value, it only makes
>> the code more complex.
>
> But it also makes the code more useful, as the user won't be limited to the 4
> resolutions above.
>
The problem is Aptina datasheet doesn't tell us how to calculate these values.
We only have some register presets.
