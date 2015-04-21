Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:34708 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbbDUPBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 11:01:12 -0400
Received: by laat2 with SMTP id t2so153306078laa.1
        for <linux-media@vger.kernel.org>; Tue, 21 Apr 2015 08:01:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55365F6F.3040904@redhat.com>
References: <1429469565-2695-1-git-send-email-anarsoul@gmail.com>
 <1429469565-2695-2-git-send-email-anarsoul@gmail.com> <55365F6F.3040904@redhat.com>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Tue, 21 Apr 2015 18:00:50 +0300
Message-ID: <CA+E=qVdxizBpbt7gZ4qBumhzursw0MTeg0aWt3aDC7L3amca4Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] gspca: sn9c2028: Add gain and autogain controls
 Genius Videocam Live v2
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Apr 21, 2015 at 5:32 PM, Hans de Goede <hdegoede@redhat.com> wrote:

>> diff --git a/drivers/media/usb/gspca/sn9c2028.h
>> b/drivers/media/usb/gspca/sn9c2028.h
>> index 8fd1d3e..6f20c0f 100644
>> --- a/drivers/media/usb/gspca/sn9c2028.h
>> +++ b/drivers/media/usb/gspca/sn9c2028.h
>> @@ -21,8 +21,17 @@
>>    *
>>    */
>>
>> -static const unsigned char sn9c2028_sof_marker[5] =
>> -       { 0xff, 0xff, 0x00, 0xc4, 0xc4 };
>> +static const unsigned char sn9c2028_sof_marker[] = {
>> +       0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96,
>> +       0x00,
>> +       0x00, /* seq */
>> +       0x00,
>> +       0x00,
>> +       0x00, /* avg luminance lower 8 bit */
>> +       0x00, /* avg luminance higher 8 bit */
>> +       0x00,
>> +       0x00,
>> +};
>>
>
> This seems wrong, the header is only 12 bytes the extra 2 0x00 bytes you add
> are
> actually part of the compressed data and are parsed by the userspace code,
> please drop them.

OK, I've found average lumimance value in header heuristically,
based on info that it's present in header of sn9c1xx and sn9c201 cams,
and I didn't check actual header length - my fault.

Regards,
Vasily
