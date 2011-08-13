Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50875 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1HMTHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 15:07:11 -0400
Received: by vws1 with SMTP id 1so3170388vws.19
        for <linux-media@vger.kernel.org>; Sat, 13 Aug 2011 12:07:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPueXH4QysAb=hsA12TQHe7Uumb0gOCBzkNkyExVGept8pa2+w@mail.gmail.com>
References: <CAOO8FEfvJWvxDxL5VnXwsWRgKSMsEq8w3zc9K1M=TjypU431Ww@mail.gmail.com>
	<CAPueXH4QysAb=hsA12TQHe7Uumb0gOCBzkNkyExVGept8pa2+w@mail.gmail.com>
Date: Sun, 14 Aug 2011 00:37:10 +0530
Message-ID: <CAOO8FEcJZkyawy0acpQndsZCmw9mBNMCMEd3s6o05CrRXy-rNQ@mail.gmail.com>
Subject: Re: size of raw bayer data
From: Veda N <veda74@gmail.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 13, 2011 at 11:56 PM, Paulo Assis <pj.assis@gmail.com> wrote:
> Hi,
>
> 2011/8/13 Veda N <veda74@gmail.com>:
>> what should be the size of a raw bayer data from the driver.
>>
>> for 640x480 = i get 640x480x2.
>
> Is this in bytes?
>
>>
>> Shouldnt i get more? It shoule be more than yuv422/rgb565
>>
>
> No, that depends on the pixel size, so for 8 bit pixel you should get
> 640x480 bytes, for 12 bit you should get 640x480x3/2 and so on.
>
> 640x480x2 is equivalent to a 16 bit pixel, this is a bit unusual I
> think, the most common is 8 bit pixel, what device/driver are you
> using ?

If it is V4L2_PIX_FMT_SGRBG10 - it is 10 bits/color.
If it is V4L2_PIX_FMT_SGRBG8 -   it is 8 bits/color

Shouldnt it be more? raw data is supposed to be large in size when
compared to processed data pixel size.


>
>
> Regards,
> Paulo
>
>> --
>> Regards,
>> S. N. Veda
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
Regards,
S. N. Veda
