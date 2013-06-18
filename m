Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:43225 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3FREvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 00:51:22 -0400
Received: by mail-vc0-f175.google.com with SMTP id hr11so2619252vcb.34
        for <linux-media@vger.kernel.org>; Mon, 17 Jun 2013 21:51:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <002a01ce6b69$512943c0$f37bcb40$%debski@samsung.com>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
	<1370870586-24141-4-git-send-email-arun.kk@samsung.com>
	<002a01ce6b69$512943c0$f37bcb40$%debski@samsung.com>
Date: Tue, 18 Jun 2013 10:21:21 +0530
Message-ID: <CALt3h7-mNkOJoGbyNsBR0Z2mYKXD58EwqOezeY+7xpx7G0-vHQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] [media] s5p-mfc: Core support for MFC v7
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Thank you for the review.


>>  #define IS_MFCV6(dev)                (dev->variant->version >= 0x60 ? 1 :
> 0)
>> +#define IS_MFCV7(dev)                (dev->variant->version >= 0x70 ? 1 :
> 0)
>
> According to this, MFC v7 is also detected as MFC v6. Was this intended?

Yes this was intentional as most of v7 will be reusing the v6 code and
only minor
changes are there w.r.t firmware interface.


> I think that it would be much better to use this in code:
>         if (IS_MFCV6(dev) || IS_MFCV7(dev))
> And change the define to detect only single MFC revision:
>         #define IS_MFCV6(dev)           (dev->variant->version >= 0x60 &&
> dev->variant->version < 0x70)
>

I kept it like that since the macro IS_MFCV6() is used quite frequently
in the driver. Also if MFCv8 comes which is again similar to v6 (not
sure about this),
then it will add another OR condition to this check.

> Other possibility I see is to change the name of the check. Although
> IS_MFCV6_OR_NEWER(dev) seems too long :)
>

How about making it IS_MFCV6_PLUS()?

Regards
Arun
