Return-path: <mchehab@localhost.localdomain>
Received: from mx1.redhat.com ([209.132.183.28]:7571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab0IML2M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 07:28:12 -0400
Message-ID: <4C8E0ABF.5060601@redhat.com>
Date: Mon, 13 Sep 2010 08:27:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc driver
References: <201009122226.11970.hverkuil@xs4all.nl>	 <1284325962.2394.24.camel@localhost> <1284326939.2394.29.camel@localhost>
In-Reply-To: <1284326939.2394.29.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

Em 12-09-2010 18:28, Andy Walls escreveu:
> On Sun, 2010-09-12 at 17:12 -0400, Andy Walls wrote:
>> On Sun, 2010-09-12 at 22:26 +0200, Hans Verkuil wrote:
>>
>>> And other news on the V4L1 front:
>>
>>> I'm waiting for test results on the cpia2 driver. If it works, then the V4L1
>>> support can be removed from that driver as well.
>>
>> FYI, that will break this 2005 vintage piece of V4L1 software people may
>> still be using for the QX5 microscope:
> 
> Sorry, that is of course, if there is no V4L1 compat layer still in
> place.
> 
> BTW, qx5view uses a private ioctl() to change the lights on a QX5 and
> not the V4L2 control.

The better would be to port qx5view to use libv4l and implement the new
illuminator ctrl on the driver and on the userspase app. Do you have
hardware for testing this?

> 
> In qx5view:
> 
> void setlight() {
> #define CPIA2_IOC_SET_GPIO         _IOR('v', BASE_VIDIOCPRIVATE + 17, __u32)
>     ioctl(dev, CPIA2_IOC_SET_GPIO, light_setting);
> }
> 
> 
> In the cpia2 driver:
> 
>        /* CPIA2 extension to Video4Linux API */
>         case CPIA2_IOC_SET_GPIO:
>                 retval = ioctl_set_gpio(arg, cam);
>                 break;
> 
> Yuck.
> 
> Regards,
> Andy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

