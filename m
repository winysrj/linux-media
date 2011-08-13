Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48902 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1HMS03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 14:26:29 -0400
Received: by qwk3 with SMTP id 3so1978121qwk.19
        for <linux-media@vger.kernel.org>; Sat, 13 Aug 2011 11:26:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOO8FEfvJWvxDxL5VnXwsWRgKSMsEq8w3zc9K1M=TjypU431Ww@mail.gmail.com>
References: <CAOO8FEfvJWvxDxL5VnXwsWRgKSMsEq8w3zc9K1M=TjypU431Ww@mail.gmail.com>
From: Paulo Assis <pj.assis@gmail.com>
Date: Sat, 13 Aug 2011 19:26:07 +0100
Message-ID: <CAPueXH4QysAb=hsA12TQHe7Uumb0gOCBzkNkyExVGept8pa2+w@mail.gmail.com>
Subject: Re: size of raw bayer data
To: Veda N <veda74@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2011/8/13 Veda N <veda74@gmail.com>:
> what should be the size of a raw bayer data from the driver.
>
> for 640x480 = i get 640x480x2.

Is this in bytes?

>
> Shouldnt i get more? It shoule be more than yuv422/rgb565
>

No, that depends on the pixel size, so for 8 bit pixel you should get
640x480 bytes, for 12 bit you should get 640x480x3/2 and so on.

640x480x2 is equivalent to a 16 bit pixel, this is a bit unusual I
think, the most common is 8 bit pixel, what device/driver are you
using ?


Regards,
Paulo

> --
> Regards,
> S. N. Veda
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
