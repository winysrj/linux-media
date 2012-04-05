Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65226 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab2DEKRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 06:17:51 -0400
Received: by yhmm54 with SMTP id m54so596321yhm.19
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2012 03:17:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPueXH61Kc0ufek_6Ni+Vq=9GQWZfLBtmrBW9r7Ns4ef8GOz8g@mail.gmail.com>
References: <CAK2bqVJT-AvRS9NYhRbpiZRHEVpUHUMxmHTW9OaS1+TYbsaVog@mail.gmail.com>
 <CAPueXH61Kc0ufek_6Ni+Vq=9GQWZfLBtmrBW9r7Ns4ef8GOz8g@mail.gmail.com>
From: Paulo Assis <pj.assis@gmail.com>
Date: Thu, 5 Apr 2012 11:17:30 +0100
Message-ID: <CAPueXH6bZm-PNiKQ7YyrryWJvQAqGU9V3Fq=Mk6rR8o9CAXuWA@mail.gmail.com>
Subject: Re: UVC video output problem with 3.3.1 kernel
To: Chris Rankin <rankincj@googlemail.com>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
>From what you describe I would say that during conversion a YUYV (2
bytes per pixel) size (be it a buffer or loop iterations) is being
used for RGB3 (3 bytes per pixel), so you only get 2/3 of the picture.
Does this happen in any resolution ?

Regards,
Paulo

2012/4/5 Paulo Assis <pj.assis@gmail.com>:
> Hi,
> BGR3, RGB3, YU12 and YV12 are provided through libv4l, the original
> unconverted stream format provided through uvcvideo driver is YUYV, if
> this is fine then this is probably an issue with libv4l.
>
> Regards,
> Paulo
>
> 2012/4/5 Chris Rankin <rankincj@googlemail.com>:
>> Hi,
>>
>> I have a UVC video device, which lsusb describes as:
>>
>> 046d:0992 Logitech, Inc. QuickCam Communicate Deluxe
>>
>> With the 3.3.1 kernel, the bottom 3rd of the video window displayed by
>> guvcview is completely black. This happens whenever I select either
>> BGR3 or RGB3 as the video output format. However, YUYV, YU12 and YV12
>> all display fine.
>>
>> Does anyone else see this, please?
>> Thanks,
>> Chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
