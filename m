Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab2CGRRV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 12:17:21 -0500
Message-ID: <4F579815.2060207@redhat.com>
Date: Wed, 07 Mar 2012 14:17:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
CC: gregkh <gregkh@linuxfoundation.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: A second easycap driver implementation
References: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com> <4F572611.50607@redhat.com> <CALF0-+V5kTMXZ+Nfy4yqOSgyMwBYmjGH4EfFbqjju+d3GdsvSA@mail.gmail.com> <20120307154311.GB14836@kroah.com> <4F578E65.4070409@redhat.com> <CALF0-+W5HwFFnp96sK=agjc07V_GuizrD6k+Eu9b7sQXOW=Ngw@mail.gmail.com>
In-Reply-To: <CALF0-+W5HwFFnp96sK=agjc07V_GuizrD6k+Eu9b7sQXOW=Ngw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-03-2012 13:45, Ezequiel García escreveu:
> On Wed, Mar 7, 2012 at 1:35 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>>
>> Yes, the driver is weird, as it encapsulates the demod code
>> inside it , instead of using the saa7115 driver, that covers most
>> of saa711x devices, including saa7113.
>>
>> Btw, is this driver really needed? The em28xx driver has support
>> for the Easy Cap Capture DC-60 model (I had access to one of those
>> in the past, and I know that the driver works properly).
>>
>> What's the chipset using on your Easycap device?
> 
> Chipset is STK116. I'm not entirely sure but is seems that
> there are to models: DC60 and DC60+.

Hmmm... so there are two different chipsets for DC60.
> 
> Apparently, the former would be using STK1160.
> 
>>
>> If it is not an Empiatech em28xx USB bridge, then it makes sense
>> to have a separate driver for it. Otherwise, it is just easier
>> and better to add support for your device there.
> 
> Ok, I'll take a look at the em28xx driver and also at the saa711x
> to see how would it be possible to add support for this device.

em28xx is a good reference.

The usage of saa711x is simple. All you need to do is to implement
an I2C bus at your easycap driver, load the module, and then, redirect
any demod ioctl call to the I2C bus, like:

static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
{
	struct em28xx_fh   *fh  = priv;
	struct em28xx      *dev = fh->dev;
	int                rc;

	rc = check_dev(dev);
	if (rc < 0)
		return rc;

	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);

	return 0;
}


An I2C device has an address that needs to be send through the I2C
bus.

The saa711x devices use one of the I2C addresses below:

static unsigned short saa711x_addrs[] = {
	0x4a >> 1, 0x48 >> 1,   /* SAA7111, SAA7111A and SAA7113 */
	0x42 >> 1, 0x40 >> 1,   /* SAA7114, SAA7115 and SAA7118 */
	I2C_CLIENT_END };

It is not clear, from the easycap code, where the I2C address
is stored:

int write_saa(struct usb_device *p, u16 reg0, u16 set0)
{
	if (!p)
		return -ENODEV;
	SET(p, 0x200, 0x00);
	SET(p, 0x204, reg0);
	SET(p, 0x205, set0);
	SET(p, 0x200, 0x01);
	return wait_i2c(p);
}

int read_saa(struct usb_device *p, u16 reg0)
{
	u8 igot;

	if (!p)
		return -ENODEV;
	SET(p, 0x208, reg0);
	SET(p, 0x200, 0x20);
	if (0 != wait_i2c(p))
		return -1;
	igot = 0;
	GET(p, 0x0209, &igot);
	return igot;
}

Maybe they're stored on some other register, or maybe this device
has the I2C hardcoded (with would be very ugly and unlikely, but
I won't doubt that some vendor might be doing that).

Anyway, if you take a look at cx231xx and tm6000, you'll see that
some I2C bad implementations require a per-address type of logic.

> Perhaps, we'll end up with a separate driver but based on
> some common code.

As it is not an em28xx, a separate implementation for the stk chipset
is required. You should not need to re-invent the wheel for saa711x.
> 
> Thanks,
> Ezequiel.

