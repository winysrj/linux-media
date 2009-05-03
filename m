Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:5674 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZECHvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 May 2009 03:51:45 -0400
Received: by fg-out-1718.google.com with SMTP id d23so294300fga.17
        for <linux-media@vger.kernel.org>; Sun, 03 May 2009 00:51:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905021804.17908.hverkuil@xs4all.nl>
References: <c70ff3ad0904300535i6c5855f2g3bd404398a41d17f@mail.gmail.com>
	 <200905021804.17908.hverkuil@xs4all.nl>
Date: Sun, 3 May 2009 10:51:42 +0300
Message-ID: <c70ff3ad0905030051l62dc2030o4adfb8ecd334b598@mail.gmail.com>
Subject: Re: cafe driver need to initialize the chip->ident
From: saeed bishara <saeed.bishara@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tested it, fixed my problem, thanks.

saeed

On Sat, May 2, 2009 at 7:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thursday 30 April 2009 14:35:58 saeed bishara wrote:
>> Hi,
>>     The cafe_cam_init declares un-initialized v4l2_dbg_chip_ident
>> structure, then it uses the chip.ident to test if the sensor is known.
>>     but, this field is never initialized and it my get random value,
>> then later it used by the v4l2_chip_ident_i2c_client function.
>>     I think this is bug and it must be fixed by initializing the ident
>> field with zero.
>>    I'm using kernel 2.6.29.1
>> saeed
>
> Thanks! This is indeed wrong and I'll fix it. I think it is sufficient to
> apply this patch:
>
> --- cafe_ccic.c.orig    2009-05-02 17:57:08.000000000 +0200
> +++ cafe_ccic.c 2009-05-02 17:57:37.000000000 +0200
> @@ -868,6 +868,7 @@
>        ret = __cafe_cam_reset(cam);
>        if (ret)
>                goto out;
> +       chip.ident = V4L2_IDENT_NONE;
>        chip.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
>        chip.match.addr = cam->sensor->addr;
>        ret = __cafe_cam_cmd(cam, VIDIOC_DBG_G_CHIP_IDENT, &chip);
>
> Can you confirm this? If it works, then I'll merge this patch and see if I
> can get it into the 2.6.29 stable series.
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>
