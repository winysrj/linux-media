Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41252 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZFWNKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 09:10:36 -0400
Received: by fxm9 with SMTP id 9so48842fxm.37
        for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 06:10:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
References: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
Date: Tue, 23 Jun 2009 21:10:37 +0800
Message-ID: <6ab2c27e0906230610t588ffdf8p7640920b9dbe5a28@mail.gmail.com>
Subject: Re: PxDVR3200 H LinuxTV v4l-dvb patch : Pull GPIO-20 low for DVB-T
From: Terry Wu <terrywu2009@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>,
	linux-media <linux-media@vger.kernel.org>, stoth@kernellabs.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

1. The CX23885's < GPIO 23 thru 19 - On the cx25840 a/v core> is not
implemented yet.
You can find the following codes in the cx23885-core.c :
/* Mask represents 32 different GPIOs, GPIO's are split into multiple
 * registers depending on the board configuration (and whether the
 * 417 encoder (wi it's own GPIO's) are present. Each GPIO bit will
 * be pushed into the correct hardware register, regardless of the
 * physical location. Certain registers are shared so we sanity check
 * and report errors if we think we're tampering with a GPIo that might
 * be assigned to the encoder (and used for the host bus).
 *
 * GPIO  2 thru  0 - On the cx23885 bridge
 * GPIO 18 thru  3 - On the cx23417 host bus interface
 * GPIO 23 thru 19 - On the cx25840 a/v core
 */
void cx23885_gpio_set(struct cx23885_dev *dev, u32 mask)
{
	if (mask & 0x7)
		cx_set(GP0_IO, mask & 0x7);

	if (mask & 0x0007fff8) {
		if (encoder_on_portb(dev) || encoder_on_portc(dev))
			printk(KERN_ERR
				"%s: Setting GPIO on encoder ports\n",
				dev->name);
		cx_set(MC417_RWD, (mask & 0x0007fff8) >> 3);
	}

	/* TODO: 23-19 */
	if (mask & 0x00f80000)
		printk(KERN_INFO "%s: Unsupported\n", dev->name);
}

void cx23885_gpio_clear(struct cx23885_dev *dev, u32 mask)
{
	if (mask & 0x00000007)
		cx_clear(GP0_IO, mask & 0x7);

	if (mask & 0x0007fff8) {
		if (encoder_on_portb(dev) || encoder_on_portc(dev))
			printk(KERN_ERR
				"%s: Clearing GPIO moving on encoder ports\n",
				dev->name);
		cx_clear(MC417_RWD, (mask & 0x7fff8) >> 3);
	}

	/* TODO: 23-19 */
	if (mask & 0x00f80000)
		printk(KERN_INFO "%s: Unsupported\n", dev->name);
}

void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
{
	if ((mask & 0x00000007) && asoutput)
		cx_set(GP0_IO, (mask & 0x7) << 16);
	else if ((mask & 0x00000007) && !asoutput)
		cx_clear(GP0_IO, (mask & 0x7) << 16);

	if (mask & 0x0007fff8) {
		if (encoder_on_portb(dev) || encoder_on_portc(dev))
			printk(KERN_ERR
				"%s: Enabling GPIO on encoder ports\n",
				dev->name);
	}

	/* MC417_OEN is active low for output, write 1 for an input */
	if ((mask & 0x0007fff8) && asoutput)
		cx_clear(MC417_OEN, (mask & 0x7fff8) >> 3);

	else if ((mask & 0x0007fff8) && !asoutput)
		cx_set(MC417_OEN, (mask & 0x7fff8) >> 3);

	/* TODO: 23-19 */
}

2. Also, I can not find GPIO functions in the cx25840-core.c

Something missing or unfinished ?

Best Regards,
Terry

2009/6/23 Hans Verkuil <hverkuil@xs4all.nl>:
>
>> On Tue, 2009-06-23 at 11:39 +0800, Terry Wu wrote:
>>> Hi,
>>>
>>>     I add the following codes in the cx23885_initialize() of
>>> cx25840-core.c:
>>>      /* Drive GPIO2 (GPIO 19~23) direction and values for DVB-T */
>>>      cx25840_and_or(client, 0x160, 0x1d, 0x00);
>>>      cx25840_write(client, 0x164, 0x00);
>>>
>>>     Before that, the tuning status is 0x1e, but <0> service found.
>>>     Now, I can watch DVB-T (Taiwan, 6MHz bandwidth).
>>>
>>>     And if you are living in Australia, you should update the
>>> tuner-xc2028.c too:
>>>     http://tw1965.myweb.hinet.net/Linux/v4l-dvb/20090611-TDA18271HDC2/tuner-xc2028.c
>>>
>>> Best Regards,
>>> Terry
>>
>>
>> Hans,
>>
>> As I think of potential ways to handle this, I thought we may need to
>> add a v4l2_subdev interface for setting and reading GPIO's.
>
> There is already an s_gpio in the core ops. It would be simple to add a
> g_gpio as well if needed.
>
> It is not a good idea to directly control GPIO pins from within a subdev
> driver for the simple reason that the subdev driver has no idea how its
> gpio pins are hooked up. This should really be done from the v4l driver
> itself. If you need a notification from the subdev that the v4l driver
> needs to take some action, then the subdev can send a notification through
> the notify function in v4l2_device. That's currently used by one subdev
> driver that requires that the v4l driver toggles a GPIO pin at the right
> time.
>
> Regards,
>
>          Hans
>
>> A CX23418 based board has a Winbond W8360x GPIO IC connected via I2C.
>> When I get to writing a v4l2_subdevice driver for that, it will need
>> such an internal interface as well.
>>
>> Thoughts?
>>
>> Regards,
>> Andy
>>
>>
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
>
