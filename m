Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64246 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1DTQJJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2011 12:09:09 -0400
Received: by qyk7 with SMTP id 7so2339031qyk.19
        for <linux-media@vger.kernel.org>; Wed, 20 Apr 2011 09:09:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimccZM=ipUUhEBNM+pPhAvQgn=AbQ@mail.gmail.com>
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com>
	<201103292241.51237.laurent.pinchart@ideasonboard.com>
	<AANLkTikjDOsx6-A75A510k_BY0bF9qmTKKBw_YVyJgBF@mail.gmail.com>
	<201103301532.16635.laurent.pinchart@ideasonboard.com>
	<BANLkTimccZM=ipUUhEBNM+pPhAvQgn=AbQ@mail.gmail.com>
Date: Wed, 20 Apr 2011 18:09:08 +0200
Message-ID: <BANLkTincCWWHc83tx0Li2NXuTOAv86O8_Q@mail.gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?Lo=C3=AFc_Akue?= <akue.loic@gmail.com>,
	=?UTF-8?Q?Enric_Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On Wed, Apr 20, 2011 at 5:25 PM, Raffaele Recalcati
<lamiaposta71@gmail.com> wrote:
> Hi Laurent,
>
> On Wed, Mar 30, 2011 at 3:32 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Loïc,
>>
>> On Wednesday 30 March 2011 13:05:08 Loïc Akue wrote:
>>> Hi Laurent,
>>>
>>> > The OMAP3 ISP should support interleaving interlaced frames, but that's
>>> > not implemented in the driver. You will need to at least implement
>>> > interlaced frames support in the CCDC module to report field identifiers
>>> > to userspace.
>>>
>>> Are you saying that the OMAP ISP could be configured to provide some full
>>> field frames on the CCDC output? I'm looking at the ISP's TRM but I can't
>>> find anything interesting.
>>
>> Look at the "Line-Output Control" section in the OMAP3 TRM (SWPU177B, page
>> 1201).
>>
>>> Or is it the job of the user space application to recompose the image with
>>> the interleaved frames?
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> I'm using tvp5151 in DaVinci with the drivers/media/video/tvp5150.c
> driver with little modification to enhance v4l2 interface.
> It works.
> Now I'm moving to dm3730 and I see that evm dm3730 uses tvp514x-int.c
> from Arago tree, that is really different from tvp514x.c .
> I'm trying to understand if I need to create a tvp5150-int.c using the
> call v4l2_int_device_register instead of v4l2_i2c_subdev_init.
> The drivers/media/video/omap34xxcam.c driver calls
> v4l2_int_device_register and so it needs v4l2_int_device_register.
>
> Maybe you have done some modifications to
> drivers/media/video/tvp5150.c that I could merge with mines ?

I stop boring you with this item.
I have seen in linuxtv tree the omap3isp directory.
At the moment I think not to move from 2.6.32 to latest linuxtv
kernel, but I keep in mind
this possibility.

Regards,
Raffaele
