Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61273 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1FDU1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 16:27:18 -0400
Received: by pzk9 with SMTP id 9so1289372pzk.19
        for <linux-media@vger.kernel.org>; Sat, 04 Jun 2011 13:27:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DE9EB0E.8070207@redhat.com>
References: <BANLkTikCgTWA92P2Qw4hqyvmQFRZm7+Aog@mail.gmail.com>
	<4DE9EB0E.8070207@redhat.com>
Date: Sat, 4 Jun 2011 17:27:17 -0300
Message-ID: <BANLkTindTPo+E5AQ9zydftWOyyK=CT4WDg@mail.gmail.com>
Subject: Re: [PATCH] Increase max exposure value to 255 from 26.
From: =?ISO-8859-1?Q?Marco_Diego_Aur=E9lio_Mesquita?=
	<marcodiegomesquita@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I think there maybe some different versions of the chip. Whenever I
get a webcam with a pac207, it has the problem described here:
http://ubuntuforums.org/archive/index.php/t-1553690.html

2011/6/4 Hans de Goede <hdegoede@redhat.com>:
> Hi,
>
> Interesting. I'll go and test this with my 6 or so pac207 cameras,
> but first I need to wait till this evening as atm it is too
> light to test high exposure settings :)
>
> Regards,
>
> Hans
>
>
> On 06/04/2011 09:38 AM, Marco Diego Aurélio Mesquita wrote:
>>
>> The inline patch increases maximum exposure value from 26 to 255. It
>> has been tested and works well. Without the patch the captured image
>> is too dark and can't be improved too much.
>>
>> Please CC answers as I'm not subscribed to the list.
>>
>>
>> Signed-off-by: Marco Diego Aurélio Mesquita<marcodiegomesquita@gmail.com>
>> ---
>>  drivers/media/video/gspca/pac207.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/video/gspca/pac207.c
>> b/drivers/media/video/gspca/pac207.c
>> index 892b454..6a2fb26 100644
>> --- a/drivers/media/video/gspca/pac207.c
>> +++ b/drivers/media/video/gspca/pac207.c
>> @@ -39,7 +39,7 @@ MODULE_LICENSE("GPL");
>>  #define PAC207_BRIGHTNESS_DEFAULT     46
>>
>>  #define PAC207_EXPOSURE_MIN           3
>> -#define PAC207_EXPOSURE_MAX            26
>> +#define PAC207_EXPOSURE_MAX            255
>>  #define PAC207_EXPOSURE_DEFAULT               5 /* power on default: 3 */
>>  #define PAC207_EXPOSURE_KNEE          8 /* 4 = 30 fps, 11 = 8, 15 = 6 */
>>
>
