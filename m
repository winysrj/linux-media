Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab2CGUx0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 15:53:26 -0500
Message-ID: <4F57CAB9.3050604@redhat.com>
Date: Wed, 07 Mar 2012 17:53:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
CC: gregkh <gregkh@linuxfoundation.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: A second easycap driver implementation
References: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com> <4F572611.50607@redhat.com> <CALF0-+V5kTMXZ+Nfy4yqOSgyMwBYmjGH4EfFbqjju+d3GdsvSA@mail.gmail.com> <20120307154311.GB14836@kroah.com> <4F578E65.4070409@redhat.com> <CALF0-+W5HwFFnp96sK=agjc07V_GuizrD6k+Eu9b7sQXOW=Ngw@mail.gmail.com> <4F579815.2060207@redhat.com> <CALF0-+VnoMRoaTKeyD6bE8kP3qccun5keyiJRnM3Vg0sAecaQw@mail.gmail.com>
In-Reply-To: <CALF0-+VnoMRoaTKeyD6bE8kP3qccun5keyiJRnM3Vg0sAecaQw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-03-2012 17:39, Ezequiel García escreveu:
> Hi Mauro,
> 
>>
>> em28xx is a good reference.
>>
> 
> I'm looking at it.
> In fact, I have a first question: why there is a limit to the number of devices
> the driver support? I found the same idea in easycap original
> implementation, but I
> can't understand why do we have to limit in such a way.
> 
>         /* Check to see next free device and mark as used */
>         do {
>                 nr = find_first_zero_bit(&em28xx_devused, EM28XX_MAXBOARDS);
>                 if (nr >= EM28XX_MAXBOARDS) {
>                         /* No free device slots */
>                         printk(DRIVER_NAME ": Supports only %i em28xx
> boards.\n",
>                                         EM28XX_MAXBOARDS);
>                         retval = -ENOMEM;
>                         goto err_no_slot;
>                 }
>         } while (test_and_set_bit(nr, &em28xx_devused));

There are several reasons for that, including a few historical ones. One of them 
is that the number of reserved v4l char devices is limited (well, V4L core
now supports dynamic allocation). Another one is a few modprobe arrays for em28xx.

Anyway, an USB 2.0 bus only supports one  uncompressed video stream.

> 
> 
>>
>> It is not clear, from the easycap code, where the I2C address
>> is stored:
>>
>> int write_saa(struct usb_device *p, u16 reg0, u16 set0)
>> {
>>        if (!p)
>>                return -ENODEV;
>>        SET(p, 0x200, 0x00);
>>        SET(p, 0x204, reg0);
>>        SET(p, 0x205, set0);
>>        SET(p, 0x200, 0x01);
>>        return wait_i2c(p);
>> }
> 
> I think i2c_address it is near registers 0x200/0x204, which gets
> initialised at setup_stk().
> I'll have a closer look.

Ok.

> 
> Thanks for your comments,
> Ezequiel.

