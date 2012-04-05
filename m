Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2DEKEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 06:04:01 -0400
Received: by iagz16 with SMTP id z16so1557316iag.19
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2012 03:04:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK2bqVJT-AvRS9NYhRbpiZRHEVpUHUMxmHTW9OaS1+TYbsaVog@mail.gmail.com>
References: <CAK2bqVJT-AvRS9NYhRbpiZRHEVpUHUMxmHTW9OaS1+TYbsaVog@mail.gmail.com>
From: Paulo Assis <pj.assis@gmail.com>
Date: Thu, 5 Apr 2012 11:03:40 +0100
Message-ID: <CAPueXH61Kc0ufek_6Ni+Vq=9GQWZfLBtmrBW9r7Ns4ef8GOz8g@mail.gmail.com>
Subject: Re: UVC video output problem with 3.3.1 kernel
To: Chris Rankin <rankincj@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
BGR3, RGB3, YU12 and YV12 are provided through libv4l, the original
unconverted stream format provided through uvcvideo driver is YUYV, if
this is fine then this is probably an issue with libv4l.

Regards,
Paulo

2012/4/5 Chris Rankin <rankincj@googlemail.com>:
> Hi,
>
> I have a UVC video device, which lsusb describes as:
>
> 046d:0992 Logitech, Inc. QuickCam Communicate Deluxe
>
> With the 3.3.1 kernel, the bottom 3rd of the video window displayed by
> guvcview is completely black. This happens whenever I select either
> BGR3 or RGB3 as the video output format. However, YUYV, YU12 and YV12
> all display fine.
>
> Does anyone else see this, please?
> Thanks,
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
