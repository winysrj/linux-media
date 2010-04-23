Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40898 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab0DWCU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 22:20:56 -0400
Received: by gyg13 with SMTP id 13so4864769gyg.19
        for <linux-media@vger.kernel.org>; Thu, 22 Apr 2010 19:20:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BD0B32B.8060505@redhat.com>
References: <x2m6e8e83e21004062310ia0eef09fgf97bcfafcdf25737@mail.gmail.com>
	 <4BD0B32B.8060505@redhat.com>
Date: Fri, 23 Apr 2010 10:20:50 +0800
Message-ID: <i2k6e8e83e21004221920q3f687324z8d8aba7ca26978ad@mail.gmail.com>
Subject: Re: Help needed in understanding v4l2_device_call_all
From: Bee Hock Goh <beehock@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Thanks.

Previously, I have done some limited test and it seem that
xc2028_signal seem to be getting the correct registered value for the
detected a signal locked.

Since I am now able to get video working(though somewhat limited since
it still crashed if i change channel from mythtv), i will be spending
more time to look getting a lock on the signal.


Is line 139,140,155,156 needed? Its slowing down the loading of
firmware and it working for me with the additional register setting.

 138 if (addr == dev->tuner_addr << 1) {
139 tm6000_set_reg(dev, 0x32, 0,0);
140 tm6000_set_reg(dev, 0x33, 0,0);
141 }
142 if (i2c_debug >= 2)
143 for (byte = 0; byte < msgs[i].len; byte++)
144 printk(" %02x", msgs[i].buf[byte]);
145 } else {
146 /* write bytes */
147 if (i2c_debug >= 2)
148 for (byte = 0; byte < msgs[i].len; byte++)
149 printk(" %02x", msgs[i].buf[byte]);
150 rc = tm6000_i2c_send_regs(dev, addr, msgs[i].buf[0],
151 msgs[i].buf + 1, msgs[i].len - 1);
152
153 if (addr == dev->tuner_addr << 1) {
154 tm6000_set_reg(dev, 0x32, 0,0);
155 tm6000_set_reg(dev, 0x33, 0,0);


On Fri, Apr 23, 2010 at 4:35 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Bee Hock Goh wrote:
>> Hi,
>>
>> I am trying to understand how the subdev function are triggered when I
>> use v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner,t) on
>> tm600-video.
>
> It calls tuner-core.c code, with g_tuner command. tuner-core
> checks what's the used tuner and, in the case of tm6000, calls the corresponding
> function at tuner-xc2028. This is implemented on tuner_g_tuner() function.
>
> The function basically does some sanity checks, and some common tuner code, but
> the actual implementation is handled by some callbacks that the driver needs to
> define (get_afc, get_status, is_stereo, has_signal). In general, drivers use
> get_status for it:
>                fe_tuner_ops->get_status(&t->fe, &tuner_status);
>
>
> You will find a good example of how to implement such code at tuner-simple
> simple_get_status() function.
>
> In the case of tuner-xc2028, we never found a way for it to properly report the
> status of the tuner lock. That's why this function is not implemented on the driver.
>
>> How am i able to link the callback from the tuner_xc2028 function?
>
> The callback is used by tuner-xc2028 when it detects the need of changing the
> firmware (or when the firmware is not loaded yet, or when you select a standard
> that it is not supported by the current firmware).
>
> Basically, xc2028 driver will use the callback that was set previously via:
>
>        v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config, &xc2028_cfg);
>
>
>>
>> Please help me to understand or directly me to any documentation that
>> I can read up?
>>
>> thanks,
>>  Hock.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
>
> Cheers,
> Mauro
>
