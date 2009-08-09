Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:58482 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbZHILN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Aug 2009 07:13:59 -0400
Received: by qw-out-2122.google.com with SMTP id 8so966885qwh.37
        for <linux-media@vger.kernel.org>; Sun, 09 Aug 2009 04:14:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908091044.11020.hverkuil@xs4all.nl>
References: <5e9665e10908090057n25103147s8b048bb0eb1d2d5b@mail.gmail.com>
	<4A7E86DF.1070901@gmail.com> <200908091044.11020.hverkuil@xs4all.nl>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Sun, 9 Aug 2009 20:13:40 +0900
Message-ID: <5e9665e10908090413n39d960b0n1a327cf41274e8e4@mail.gmail.com>
Subject: Re: About some sensor drivers in mc5602 gspca driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	v4l2_linux <linux-media@vger.kernel.org>, moinejf@free.fr,
	=?UTF-8?B?64+Z7IiY?= <dongsoo45.kim@samsung.com>,
	=?UTF-8?B?7ZiV7KSA?= <riverful.kim@samsung.com>,
	=?UTF-8?B?6rK966+8?= <kyungmin.park@samsung.com>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/8/9 Hans Verkuil <hverkuil@xs4all.nl>:
> On Sunday 09 August 2009 10:20:47 Erik Andrén wrote:
>>
>> Dongsoo, Nathaniel Kim wrote:
>> > Hello,
>> >
>> > It has been years I've working on linux multimedia drivers, but what a
>> > shame I found that there were already sensor drivers that I've already
>> > implemented. Precisely speaking, soc camera devices from Samsung named
>> > s5k4aa* and s5k83a* were already in Linux kernel and even seems to
>> > have been there for years.
>> > But a thing that I'm curious is those drivers are totally mc602 and
>> > gspca oriented. So some users who are intending to use those samsung
>> > camera devices but not using gspca and mc5602 H/W have to figure out
>> > another way.
>> > As you know, the s5k* camera devices are actually ISP devices which
>> > are made in SoC device and can be used independently with any kind of
>> > ITU or MIPI supporting host devices.
>> > However, I see that gspca and mc5602 have their own driver structure
>> > so it seems to be tough to split out the sensor drivers from them.
>> > So, how should we coordinate our drivers if a new s5k* driver is
>> > getting adopted in the Linux kernel? different version of s5k* drivers
>> > in gspca and subdev or gspca also is able to use subdev drivers?
>> > I am very willing to contribute several drivers for s5k* soc camera
>> > isp devices and in the middle of researching to prepare for
>> > contribution those s5k* drivers popped up.
>> > Please let me know whether it is arrangeable or not.
>> > Cheers,
>> >
>>
>> Hi Nathaniel,
>> The sensor sharing question pops up now and then and I'm sure that
>> if you search the mailing list archive you can find several threads
>> discussing this.
>> IIRC the main problem is that in an usb webcam consisting of a
>> sensor and an usb bridge. The sensor is often configured in a very
>> specific way tied to the particular usb bridge. It is also common
>> that much of the initialization is reverse engineered and that we
>> may have little or no understanding what we're actually doing.
>> (Often just mimicing a windows webcam driver).
>> I think the conclusion reached now is that it's not worth the effort
>> considering that the sensors usually don't need that much setup to
>> get working. Of course this may need to be reevaluated from time to
>> time. If someone could device a clever solution I would be all for
>> trying to create some kind of driver sharing.
>
> Basically any gspca driver that can set registers in the i2c device
> (as opposed to only replaying USB commands) can be modified so the i2c
> part can be split off into a regular sub-device driver. I've discussed
> this in the past with Hans de Goede and that is definitely the way to go.
>
>> In the gspca-m5602-s5k* case everything is reverse-engineered, as I
>> don't possess any datasheets of the ALi m5602 nor the s5k83a,
>> s5k4aa. I would be much happy if you Samsung folks would be able to
>> provide with me with datasheets for the s5k* sensors.
>
> Looking at the code I'd say that it should be possible to implement an
> i2c_adapter in m5602_core.c, and when that's in place the various sensor
> drivers can be gradually split off into generic subdev drivers. Which is
> of course ever so much easier if the datasheets are available :-)
>
> For this particular bridge driver I strongly suggest that this approach
> is taken since there are already duplicate sensor drivers here (mt9m111).
>
> Regards,
>
>        Hans
>

Hi Hans,

I didn't know that there already have been a discussion. I'll google
about that thread and go through.
And thanks to your mail, I could find that there already existing
duplicated drivers. I'll take that as a reference.
BTW, I was strongly appealing my boss to let me attend the
linuxplumber conf and I sense a slight possibility to go there. It's a
progress :-). I'm looking forward to having approval.
Cheers,

Nate

>>
>> Best regards,
>> Erik
>>
>> > Nate
>> >
>>
>>
>
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
