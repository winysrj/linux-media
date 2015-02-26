Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33302 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbbBZSdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 13:33:06 -0500
Received: by wghb13 with SMTP id b13so13648985wgh.0
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2015 10:33:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54EF652E.1020509@metafoo.de>
References: <1424974769-27095-1-git-send-email-prabhakar.csengg@gmail.com> <54EF652E.1020509@metafoo.de>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 26 Feb 2015 18:32:34 +0000
Message-ID: <CA+V-a8sCaY+p_vdCLj9H=LekEZa+38n==1OXCBsBdcMSqUTfEg@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: adv7180: unregister the subdev in remove callback
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

On Thu, Feb 26, 2015 at 6:25 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 02/26/2015 07:19 PM, Lad Prabhakar wrote:
>>
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> this patch makes sure we unregister the subdev by calling
>> v4l2_device_unregister_subdev() on remove callback.
>
>
> This was just removed a while ago, see commit 632f2b0db9da ("[media]
> adv7180: Remove duplicate unregister call")[1].
>
Sorry for the noise, I missed the path
v4l2_async_unregister_subdev --> v4l2_async_cleanup -->
v4l2_device_unregister_subdev()

Cheers,
--Prabhakar Lad
