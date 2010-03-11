Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249Ab0CKWF6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 17:05:58 -0500
Message-ID: <4B996936.8030905@redhat.com>
Date: Thu, 11 Mar 2010 19:05:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: ir: Add a link to associate /sys/class/ir/irrcv
 with the input device
References: <4B99104B.3090307@redhat.com> <20100311175214.GB7467@core.coreip.homeip.net>
In-Reply-To: <20100311175214.GB7467@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry,

Dmitry Torokhov wrote:
> Hi Mauro,
> 
> On Thu, Mar 11, 2010 at 12:46:19PM -0300, Mauro Carvalho Chehab wrote:
>> In order to allow userspace programs to autoload an IR table, a link is
>> needed to point to the corresponding input device.
>>
>> $ tree /sys/class/irrcv/irrcv0
>> /sys/class/irrcv/irrcv0
>> |-- current_protocol
>> |-- input -> ../../../pci0000:00/0000:00:0b.1/usb1/1-3/input/input22
>> |-- power
>> |   `-- wakeup
>> |-- subsystem -> ../../../../class/irrcv
>> `-- uevent
>>
>> It is now easy to associate an irrcv device with the corresponding
>> device node, at the input interface.
>>
> 
> I guess the question is why don't you make input device a child of your
> irrcvX device? Then I believe driver core will link them properly. It
> will also ensure proper power management hierarchy.
> 
> That probably will require you changing from class_dev into device but
> that's the direction kernel is going to anyway.

I remember you asked me to create a separate class for IR. The current code
does it, using class_create(). Once the class is created, I'm using 
device_create() to create the nodes. 

The current code is:

int ir_register_class(struct input_dev *input_dev)
{
	...
	ir_dev->class_dev = device_create(ir_input_class, NULL,
					  input_dev->dev.devt, ir_dev,
					  "irrcv%d", devno);
	...
	rc = sysfs_create_group(kobj, &ir_dev->attr);
	...
	rc = sysfs_create_link(kobj, &input_dev->dev.kobj, "input");
	...
	return 0;
};

int ir_input_register(struct input_dev *input_dev,
		      const struct ir_scancode_table *rc_tab,
		      const struct ir_dev_props *props)
{
	...
	rc = input_register_device(input_dev);
	...
	rc = ir_register_class(input_dev);
	...
}

static int __init ir_core_init(void)
{
	ir_input_class = class_create(THIS_MODULE, "irrcv");
	...
}

I couldn't find any other way to create the link without explicitly
calling sysfs_create_link().

Do you have a better idea?

-- 

Cheers,
Mauro
