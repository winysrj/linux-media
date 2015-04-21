Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35590 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbbDUOue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 10:50:34 -0400
Received: by lbbuc2 with SMTP id uc2so157572172lbb.2
        for <linux-media@vger.kernel.org>; Tue, 21 Apr 2015 07:50:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55365D06.6030602@redhat.com>
References: <1429469565-2695-1-git-send-email-anarsoul@gmail.com> <55365D06.6030602@redhat.com>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Tue, 21 Apr 2015 17:50:13 +0300
Message-ID: <CA+E=qVfo8828M9SV5LoL7bqzy+9Ov41d1LOcDFXCbSo93T2r2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] gspca: sn9c2028: Add support for Genius Videocam Live v2
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Apr 21, 2015 at 5:21 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>> @@ -128,7 +129,7 @@ static int sn9c2028_long_command(struct gspca_dev
>> *gspca_dev, u8 *command)
>>         status = -1;
>>         for (i = 0; i < 256 && status < 2; i++)
>>                 status = sn9c2028_read1(gspca_dev);
>> -       if (status != 2) {
>> +       if (status < 0) {
>>                 pr_err("long command status read error %d\n", status);
>>                 return (status < 0) ? status : -EIO;
>>         }
>
>
> Do you really need this change ? sn9c2028_read1 returns either a negative
> error code, or the byte read from the sn9c2028 chip. This functions wait for
> the sn9c2028 to return a read value of 2. I admit that the check in the for
> vs the check in the error reporting is not chosen well, both should probably
> be != 2. But checking for status < 0 is not good as this does not catch
> a successful read from the chip not returning 2.

For this cam it returns 1 on some commands. Anyway, this value is not
used anywhere later, so I just extended condition.

Regards,
Vasily
