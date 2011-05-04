Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46498 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1EDGlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 02:41:24 -0400
Received: by yxs7 with SMTP id 7so297747yxs.19
        for <linux-media@vger.kernel.org>; Tue, 03 May 2011 23:41:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1105030817030.15004@axis700.grange>
References: <BANLkTiku=G-9rJQT9i59CzQkJ+RSo2fPSA@mail.gmail.com>
	<Pine.LNX.4.64.1105030817030.15004@axis700.grange>
Date: Wed, 4 May 2011 14:41:24 +0800
Message-ID: <BANLkTimGMVv5FekMea0M5pLTtOB30PNXdw@mail.gmail.com>
Subject: Re: problems on soc-camera subsystem
From: =?GB2312?B?wNbD9A==?= <lemin9538@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 Dear Guennadi:

          Thanks for you help,now I think I can send  emails to
<linux-media@vger.kernel.org> .there is still  one thing  I can not
understand.The
question is in the end of this email.

> > > (3) There is a host only, so I think if there are two camera
> > > sensors,when one sensor is working,another sensor will be poweroff and
> > > can not be actived.The method to switch between them I think is to close
> > > the sensor which is not in use.
> > >
> > > Can you tell me whether the CEU can connect multiple sensors or not,If
> > > yes,are there some restrictions?
>
> It should work, yes. Currently soc-camera handles client devices (e.g.,
> sensors) in the following way: first during probing it attaches each such
> client device to the host, performs probing _and_ detaches it immediately.
> Then at open() the same happens - only the respective sensor is attached
> to the host, so, the CEU driver only has to deal with one sensor at a
> time. Just make sure to not try to open both nodes at the same time.
>
> > > If it supports multiple sensors ,what should I do?
>
> Just that - write two independent sensor drivers and two platform data
> blocks for them in your board file. Then open and operate each sensor
> independently. You also might want to provide platform struct
> soc_camera_link::power() and / or reset() callbacks.


You say soc_camera will attach each sensor in the probing,but I think
each time there is
only one sensor can register to soc_camera subsystem.look at the following
code:

struct i2c_board_info ov9640_info1=
{
....
};

struct soc_camera_link ov9640_link1=
{
       .board_info=&ov9640_info1,
       ..........
};

struct platform_device ov9640_device1=
{
       .name = "soc-camera-pdrv",
       .dev=
        {
              .platform_data = &ov9640_link1,
        }
};

struct i2c_board_info ov9640_info2=
{
....
};

struct soc_camera_link ov9640_link2=
{
       .board_info=&ov9640_info2,
       ..........
};

struct platform_device ov9640_device2=
{
       .name = "soc-camera-pdrv",    //the name is same to the ov_9640_device1.
       .dev=
        {
              .platform_data = &ov9640_link2,
        }
};

    There are two sensors,now I want they all exist in /dev after
linux system is
boot.can I do this? if yes I want to use platform_device_register()
twice.but this action is forbindden,because they have the same
platform name,so only one sensor can registered successfully.

    On the other hand if I use soc_camera subsystem to register a
video device to let
system create a node in /dev,like /dev/video0 or /dev/video1.I must
call soc_camera_device_register() to register a soc_camera_device to
soc_camera,
then if there is a camera host is registered to soc_camera,the host
will call scan_add_host() to  probe and attach each sensor,if host can
handle the sensor,
device_register() will be called,finally the probe function of
soc_camera bus------soc_camera_probe() will be called,in this function
a video device will be register to  the system,and a device node will
be create in /dev if all information of the  sensor is ok.

     So if you want to register a video device and create a device
node in /dev using soc_camera,soc_camera_device_register() must be
called.But now the only way to call  soc_camera_device_register() is
to register a platform device whose name is "soc-pdrv".
Is my analysis right ?

    I do not want to use modle to load the driver,I want the two
sensors' device node can all exist in /dev directory after the system
is booted,what should I do.the kernel vesion I used is 2.6.36.Please
help me.


Thanks
LeMin.
