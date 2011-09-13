Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46119 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab1IMIU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 04:20:28 -0400
Received: by qyk7 with SMTP id 7so180406qyk.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 01:20:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109130926020.17902@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-3-git-send-email-scott.jiang.linux@gmail.com>
	<Pine.LNX.4.64.1109130926020.17902@axis700.grange>
Date: Tue, 13 Sep 2011 16:20:28 +0800
Message-ID: <CAHG8p1AJgPiE7VixBAKkwvcEfXyQP=62XhEG+ZdKSvCkwdocBA@mail.gmail.com>
Subject: Re: [PATCH 3/4] v4l2: add vs6624 sensor driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> +#define VGA_WIDTH       640
>> +#define VGA_HEIGHT      480
>> +#define QVGA_WIDTH      320
>> +#define QVGA_HEIGHT     240
>> +#define QQVGA_WIDTH     160
>> +#define QQVGA_HEIGHT    120
>> +#define CIF_WIDTH       352
>> +#define CIF_HEIGHT      288
>> +#define QCIF_WIDTH      176
>> +#define QCIF_HEIGHT     144
>> +#define QQCIF_WIDTH     88
>> +#define QQCIF_HEIGHT    72
>
> ...Can anyone put these in a central header, please? really, please?;-)
>
if already exists in some common file, please tell me

>
> I'm sure many other reviewers will also ask you to replace numerical
> register addresses with symbolic names, since it looks like a sufficiently
> detailed documentation is available to you.
>
sorry, I can't find these names in the datasheet I downloaded from st website.

>
>> +     0x200d, 0x3c,           /* Damper PeakGain Output MSB */
>
> Actually, some of these registers are already defined in your header:
>
> +#define VS6624_PEAK_MIN_OUT_G_MSB     0x200D /* minimum damper output for gain MSB */
>
> so, please, just use those names here and add defines for missing registers
>
I can't find many register names in datasheet. so I treat it as a
binary firmware patch.

>> +     ret = gpio_request(*ce, "VS6624 Chip Enable");
>> +     if (ret) {
>> +             v4l_err(client, "failed to request GPIO %d\n", *ce);
>> +             return ret;
>> +     }
>> +     gpio_direction_output(*ce, 1);
>> +     /* wait 100ms before any further i2c writes are performed */
>> +     mdelay(100);
>
> Logically, it could be a good idea to toggle chip-enable in your
> v4l2_subdev_core_ops::s_power() method, but if you really have to wait for
> 100ms before accessing the chip...
yes, I found if I don't wait a long time, the i2c operation will fail

>
>> +
>> +     vs6624_writeregs(sd, vs6624_p1);
>> +     vs6624_write(sd, VS6624_MICRO_EN, 0x2);
>> +     vs6624_write(sd, VS6624_DIO_EN, 0x1);
>> +     mdelay(10);
>> +     vs6624_writeregs(sd, vs6624_p2);
>> +
>> +     /* make sure the sensor is vs6624 */
>> +     device_id = vs6624_read(sd, VS6624_DEV_ID_MSB) << 8
>> +                     | vs6624_read(sd, VS6624_DEV_ID_LSB);
>
> Wow... this is like saying - sorry, guys, the chip, we just killed by
> writing random rubbish to it wasn't a vs6624;-) I mean, are ID registers
> really unreadable before writing defaults to registers?
>
I remember I put this before writing registers at the first version
but it failed...
Perhaps I should remove the id check, it looks strange

Scott
