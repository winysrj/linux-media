Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab2CSWeR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 18:34:17 -0400
Message-ID: <4F67B463.5080009@redhat.com>
Date: Mon, 19 Mar 2012 19:34:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
CC: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: A second easycap driver implementation
References: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com> <4F572611.50607@redhat.com> <CALF0-+V5kTMXZ+Nfy4yqOSgyMwBYmjGH4EfFbqjju+d3GdsvSA@mail.gmail.com> <20120307154311.GB14836@kroah.com> <4F578E65.4070409@redhat.com> <CALF0-+W5HwFFnp96sK=agjc07V_GuizrD6k+Eu9b7sQXOW=Ngw@mail.gmail.com> <4F579815.2060207@redhat.com> <CALF0-+VovM_ykpyosETH5oBG-iEfxCZpg7yqF4Y4LRH0JW7=Gw@mail.gmail.com>
In-Reply-To: <CALF0-+VovM_ykpyosETH5oBG-iEfxCZpg7yqF4Y4LRH0JW7=Gw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-03-2012 19:05, Ezequiel García escreveu:
> Hi Mauro,
> 
> On 3/7/12, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>
>> The usage of saa711x is simple. All you need to do is to implement
>> an I2C bus at your easycap driver, load the module, and then, redirect
>> any demod ioctl call to the I2C bus, like:
>>
>> static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
>> {
>> 	struct em28xx_fh   *fh  = priv;
>> 	struct em28xx      *dev = fh->dev;
>> 	int                rc;
>>
>> 	rc = check_dev(dev);
>> 	if (rc < 0)
>> 		return rc;
>>
>> 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
>>
>> 	return 0;
>> }
>>
>>
>> An I2C device has an address that needs to be send through the I2C
>> bus.
>>
>> The saa711x devices use one of the I2C addresses below:
>>
>> static unsigned short saa711x_addrs[] = {
>> 	0x4a >> 1, 0x48 >> 1,   /* SAA7111, SAA7111A and SAA7113 */
>> 	0x42 >> 1, 0x40 >> 1,   /* SAA7114, SAA7115 and SAA7118 */
>> 	I2C_CLIENT_END };
>>
> 
> I made my easycap driver use saa7115 driver to detect its saa7113 chip.
> It wasn't so hard after some head scratching.

Good!

> The problem is now modprobe is taking too long, mainly because saa7115 does
> some probing.
> I was thinking (since we already discussed deferring stuff to a workqueue):
> 
> Would it be problematic (in any fashion) to do add the i2c sub device
> 
>   v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
>                         "saa7115_auto", 0, saa711x_addrs);
> 
> in a workqueue, (in the same way modules are loaded in workqueues)?
> 
> I think not, since we won't call i2c directly, but rather through
> v4l2_device_call_all(), right?

It would likely work. I would add some locking maybe at open or at ioctl
level, to prevent calling the device while the init doesn't finish.

Regards,
Mauro
> 
> Thanks,
> Ezequiel.

