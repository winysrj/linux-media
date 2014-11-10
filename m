Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:45095 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaKJHxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 02:53:40 -0500
Received: by mail-lb0-f176.google.com with SMTP id 10so5424896lbg.35
        for <linux-media@vger.kernel.org>; Sun, 09 Nov 2014 23:53:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141109111200.6fb604c8@recife.lan>
References: <CAL+AA1ntfVxkaHhY8qNciBkHRw0SXOAzBJgV+A9Y7oYtbD38mQ@mail.gmail.com>
	<CALF0-+VpPttePKF-VTLJ5Y29_EZtSz96PwN9av1SOkkc414CRA@mail.gmail.com>
	<CAL+AA1nUAgOYUeWxrgeHiWaDSkHvh0yXuwA-gjdUomn-s_HVyA@mail.gmail.com>
	<CALF0-+WuVtk3SpwCNfJB88jvgXEujVPmT9ute6Ohdhi=0VsOSw@mail.gmail.com>
	<20141109111200.6fb604c8@recife.lan>
Date: Mon, 10 Nov 2014 10:53:38 +0300
Message-ID: <CAL+AA1kQSrOCSxUPkSFa8xxpkCRJUj+46-RCwVhUrUc6Jduv9A@mail.gmail.com>
Subject: Re: STK1160 Sharpness
From: =?UTF-8?B?0JHQsNGA0YIg0JPQvtC/0L3QuNC6?= <bart.gopnik@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Mike Thomas <rmthomas@sciolus.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-11-09 16:12 GMT+03:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> (thread reordered, to be bottom-posting)
>
> Em Sat, 8 Nov 2014 19:12:59 -0300
> Ezequiel Garcia <elezegarcia@gmail.com> escreveu:
>
>> >>> I have 05e1:0408 USB ID STK1160 chip GM7113 (SAA7113 clone) video
>> >>> processor device.
>> >>>
>> >>> Is there way to control for sharpness improvement via STK1160 driver?
>> >>> SAA7113 Data Sheet says that control for sharpness via I2C-bus
>> >>> subaddress 09H. Brightness, saturation, contrast, hue, etc. work
>> >>> perfectly.
>
> First of all, GM7113 is not identical to saa7113. We had to add some
> code there for the gm7113 to properly work, as the saa7113 settings
> doesn't work there.

(Where) can I find the the full list of the (key) differences between
SAA7113 and GM7113?

> So, even if the saa7113 datasheet shows a way to set sharpness, it
> is possible that such setting would be different on gm7113.
>
>> >>> Is it implemented control for sharpness in the diver?
>
> No. The only controls currently implemented there are:
>
> drivers/media/i2c/saa7115.c:    case V4L2_CID_CHROMA_AGC:
> drivers/media/i2c/saa7115.c:    case V4L2_CID_BRIGHTNESS:
> drivers/media/i2c/saa7115.c:    case V4L2_CID_CONTRAST:
> drivers/media/i2c/saa7115.c:    case V4L2_CID_SATURATION:
> drivers/media/i2c/saa7115.c:    case V4L2_CID_HUE:
> drivers/media/i2c/saa7115.c:    case V4L2_CID_CHROMA_AGC:
>
>> >>> Or at least, is it possible to implement it?
>
> Sure, and it shouldn't be hard to do it. It is just a matter
> of adding a new case at saa711x_s_ctrl to handle the sharpness,
> but see below.

If it is not hard to do it, can anybody please implement it?
Unfortunately, I'm not very good with system drivers programming.

I'm interesting only in sharpness control because the image quality
(sharpness) during capture using CVBS input is bad (on my EasyCap
device). If I use S-Video input, the quality (sharpness) is better. It
is important to implement it, because the sharpness control
implemented in hardware (not in software, post-processing filtering).
Control of other parameters like gamma are also don't work, but I'm
not sure that gamma control is hardware (not software) implemented
(I'm not found any info about gamma in saa7113 datasheet).

>
>> >>>
>> >>> Thanks in advance!
>
>> Hi Барт,
>>
>> If at all possible, remember to avoid top-posting, because it makes
>> the discussion harder to follow.
>>
>> On Sat, Nov 8, 2014 at 1:42 PM, Барт Гопник <bart.gopnik@gmail.com> wrote:
>> > Looks like the problem is not in the v4l. The sharpness controlled for
>> > my webcam is perfectly, but I can't conrol sharpness for my EasyCap
>> > STK1160 device and I think the problem is in STK1160 driver. I
>> > carefully looked through all the source codes of the driver and found
>> > no references of sharpness. I can control brightness, saturation,
>> > etc., but I can't control sharpness. Why do you advise me asking this
>> > question on the video4linux mailing list? Do you think they can help?
>> >
>>
>> Sure, they can help. I've just Cced the list.
>>
>> The video4linux mailing list is the place to ask this question,
>> because it supports *all* the media drivers (not only v4l core). Any driver
>> in drivers/media, including saa7115 and stk1160 drivers, are supported there.
>>
>> On the other side, this has nothing to do with the stk1160 driver,
>> which is only in
>> charge of the STK1160 chip (the USB chipset). You are looking at the
>> video decoder's
>> datasheet, so this must be implemented in the driver.
>
> Yes. You need to first add support to saa7115 driver for the sharpness
> control. This should be a patch at saa711x_s_ctrl case, like:
>
>         case V4L2_CID_SHARPNESS:
>                 saa711x_write(sd, SOME_REGISTER_NAME_HERE, ctrl->val);
>                 break;
>
>
> Then, at stk1160, you need to add support for the control framework.
>
> Then the control framework need to know what controls should be exposed
> to userspace, with something like (looking at em28xx driver):
>                 v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
>                                   V4L2_CID_SHARPNESS,
>                                   0, 0x0f, 1, SHARPNESS_DEFAULT);
>
> in order to expose the sharpness control.
>
> A function callback is also needed there, in order to call the saa7115
> implementation.
>
>>
>> Regarding your question, subaddress 09h seems to be used in the saa7115 driver
>> (grep 09_LUMA) but I'm not sure how it works.
>
> See item 8.4 at:
>         http://www.nxp.com/documents/data_sheet/SAA7113H.pdf
>
> Not sure what would be the proper way to implement it in a way that
> the sharpness will be controlled by just one value, as we can't
> simply write the data directly into register 9, as there are
> actually 6 different values controlled by the register, including
> one to enable/disable sharpness adjustments.
>
> Perhaps it should be mapped via more than one control.
>
> Regards,
> Mauro
