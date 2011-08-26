Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41199 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1HZPDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 11:03:00 -0400
Received: by ywf7 with SMTP id 7so2886724ywf.19
        for <linux-media@vger.kernel.org>; Fri, 26 Aug 2011 08:02:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E577AE3.5020304@mlbassoc.com>
References: <CA+2YH7tJjssZs6-tQibHGYZw_t0xdu9d0PJBKkMaXn79=VFJ8g@mail.gmail.com>
	<4E577AE3.5020304@mlbassoc.com>
Date: Fri, 26 Aug 2011 17:02:59 +0200
Message-ID: <CA+2YH7ucxV9ywh96C2ehfrUi+_5v8eT94aNK+v03rYVvTPvyiA@mail.gmail.com>
Subject: Re: omap3isp and tvp5150 hangs
From: Enrico <ebutera@users.berlios.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 26, 2011 at 12:52 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2011-08-26 04:42, Enrico wrote:
>>
>> Hi,
>>
>> i need some help to debug a kernel hang on an igep board (+ expansion)
>>  when using omap3-isp and tvp5150 video capture. Kernel version is
>> mainline 3.0.1


> I found that this driver is not compatible with the [new] v4l2_subdev setup.
> In particular, it does not define any "pads" and the call to
> media_entity_create_link()
> in omap3isp/isp.c:1803 fires a BUG_ON() for this condition.

So basically what is needed is to implement pad functions and do
something like this:

static struct v4l2_subdev_pad_ops mt9v032_subdev_pad_ops = {
        .enum_mbus_code = mt9v032_enum_mbus_code,
        .enum_frame_size = mt9v032_enum_frame_size,
        .get_fmt = mt9v032_get_format,
        .set_fmt = mt9v032_set_format,
        .get_crop = mt9v032_get_crop,
        .set_crop = mt9v032_set_crop,
};

and add media init/cleanup functions? Can someone confirm this? Is
someone already working on this?

Enrico
