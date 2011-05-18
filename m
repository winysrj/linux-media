Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43911 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab1ERJKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 05:10:04 -0400
Received: by iyb14 with SMTP id 14so1129124iyb.19
        for <linux-media@vger.kernel.org>; Wed, 18 May 2011 02:10:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105171334.01607.laurent.pinchart@ideasonboard.com>
References: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com>
	<1305624528-5595-2-git-send-email-javier.martin@vista-silicon.com>
	<201105171334.01607.laurent.pinchart@ideasonboard.com>
Date: Wed, 18 May 2011 11:10:03 +0200
Message-ID: <BANLkTinArWj1VsX8_N7Knjyzw8NymQNYkQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mt9p031: Add mt9p031 sensor driver.
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	carlighting@yahoo.co.nz, beagleboard@googlegroups.com,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,
I've already fixed almost every issue you pointed out.
However, I still have got some doubts that I hope you can clarify.

On 17 May 2011 13:33, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> Thanks for the patch.
>
> On Tuesday 17 May 2011 11:28:47 Javier Martin wrote:
>> It has been tested in beagleboard xM, using LI-5M03 module.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>>
>> +
>> +static int mt9p031_power_on(struct mt9p031 *mt9p031)
>> +{
>> +     int ret;
>> +
>> +     if (mt9p031->pdata->set_xclk)
>> +             mt9p031->pdata->set_xclk(&mt9p031->subdev, 54000000);
>> +     /* turn on VDD_IO */
>> +     ret = regulator_enable(mt9p031->reg_2v8);
>> +     if (ret) {
>> +             pr_err("Failed to enable 2.8v regulator: %d\n", ret);
>> +             return -1;
>> +     }
>
>I would enable the regulator first. As a general rule, chips should be powered
>up before their I/Os are actively driven.
>
>You need to restore registers here, otherwise all controls set by the user
>will not be applied to the device.

It's my mistake. This driver uses two regulators: 1,8 and 2,8 V
respectively. 2,8V regulator powers analog part and I/O whereas 1,8V
one powers the core. What I failed to do was keeping 1,8V regulator
always powered on, so that register configuration was not lost, and
power 2,8V regulator on and off as needed since it does not affect
register values. However, I messed it all up.

Ideally I would have to power 1,8V regulator on and off too. However,
as you wisely pointed out, registers should be restored in that case.
How am I supposed to keep track of register values? Are there any
helper functions I can use for that purpose or must I create a custom
register cache? Do you know any driver that uses this technique?

> [snip]
>> +static int mt9p031_set_params(struct i2c_client *client,
>> +                           struct v4l2_rect *rect, u16 xskip, u16 yskip)
>
> set_params should apply the parameters, not change them. They should have
> already been validated by the callers.

"mt9p031_set_params()" function is used by "mt9p031_set_crop()" and
"mt9p031_set_format()", as you have correctly stated, these functions
shouldn' apply parameters but only change them.
I've checked mt9v032 driver and it is as you said. The question is,
where should these parameters get applied then?

>> +static int mt9p031_registered(struct v4l2_subdev *sd)
>> +{
>> +     struct mt9p031 *mt9p031;
>> +     mt9p031 = container_of(sd, struct mt9p031, subdev);
>> +
>> +     mt9p031_power_off(mt9p031);
>
> What's that for ?
>
>> +     return 0;
>> +}

Since "mt9p031_power_off()" and "mt9p031_power_on()" functions
disable/enable the 2,8V regulator which powers I/O, it must be powered
on during probe and after registering, it can be safely powered off.

>
> You have a set_xclk callback to board code, so I assume the chip can be driven
> by one of the OMAP3 ISP XCLK signals. To call back to the OMAP3 ISP from board
> code, you need to get hold of the OMAP3 ISP device pointer. Your next patch
> exports omap3isp_device, but I'm not sure that's the way to go. One option is
>
> struct isp_device *isp = v4l2_dev_to_isp_device(subdev->v4l2_dev);
>
> but that requires the subdev to be registered before the function can be
> called. In that case you would need to move the probe code to the registered
> subdev internal function.
>

Yes, I tried using that function but it didn't work because subdev
hadn't been registeret yet.

> A clean solution is needed in the long run, preferably not involving board
> code at all. It would be nice if the OMAP3 ISP driver could export XCLKA/XCLKB
> as generic clock objects.

So, what should I do in order to submit the driver to mainline?
 Do you want me to move the probe code to registered callback?

Thank you.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
