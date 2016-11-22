Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44130
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934562AbcKVSmD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 13:42:03 -0500
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <20161109154608.1e578f9e@vento.lan>
 <20161114132722.GR3217@valkosipuli.retiisi.org.uk>
 <20161122154429.62ab1825@vento.lan>
 <a93b03fc-7bbc-f8a6-5359-105382dcad84@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <fad16b20-9397-bc32-de7f-74e82773c9cd@osg.samsung.com>
Date: Tue, 22 Nov 2016 11:41:52 -0700
MIME-Version: 1.0
In-Reply-To: <a93b03fc-7bbc-f8a6-5359-105382dcad84@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/22/2016 11:13 AM, Hans Verkuil wrote:
> On 22/11/16 18:44, Mauro Carvalho Chehab wrote:
>>> * media: fix use-after-free in cdev_put() when app exits after driver unbind
>>>   5b28dde51d0c
>>>
>>> The patch avoids the problem of deleting a character device (cdev_del())
>>> after its memory has been released. The change is sound as such but the
>>> problem is addressed by another, a lot more simple patch in my series:
>>>
>>> <URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=commitdiff;h=26fa8c1a3df5859d34cef8ef953e3a29a432a17b>
>>
>> Your approach is not clean, as it is based on a cdev's hack of doing:
>>
>>     devnode->cdev.kobj.parent = &devnode->dev.kobj;
>>
>> That is an ugly hack, as it touches inside cdev's internal stuff,
>> to do something that the driver's core doesn't expect. This is the
>> kind of patch that could cause messy errors, by cheating with the
>> cdev's internal refcount checking.
> 
> Actually, this is what many frameworks in the kernel do:
> 
> $ git grep "kobj.parent = " drivers/
> drivers/base/bus.c:     dev->kobj.parent = parent_of_root;
> drivers/base/core.c:            dev->kobj.parent = kobj;
> drivers/char/tpm/tpm-chip.c:    chip->cdev.kobj.parent = &chip->dev.kobj;
> drivers/dax/dax.c:      cdev->kobj.parent = &dev->kobj;
> drivers/gpio/gpiolib.c: gdev->chrdev.kobj.parent = &gdev->dev.kobj;
> drivers/iio/industrialio-core.c:        indio_dev->chrdev.kobj.parent = &indio_dev->dev.kobj;
> drivers/infiniband/core/user_mad.c:     port->cdev.kobj.parent = &umad_dev->kobj;
> drivers/infiniband/core/user_mad.c:     port->sm_cdev.kobj.parent = &umad_dev->kobj;
> drivers/infiniband/core/uverbs_main.c:  uverbs_dev->cdev.kobj.parent = &uverbs_dev->kobj;
> drivers/infiniband/hw/hfi1/device.c:    cdev->kobj.parent = parent;
> drivers/input/evdev.c:  evdev->cdev.kobj.parent = &evdev->dev.kobj;
> drivers/input/joydev.c: joydev->cdev.kobj.parent = &joydev->dev.kobj;
> drivers/input/mousedev.c:       mousedev->cdev.kobj.parent = &mousedev->dev.kobj;
> drivers/media/cec/cec-core.c:   devnode->cdev.kobj.parent = &devnode->dev.kobj;
> drivers/media/media-devnode.c:  devnode->cdev.kobj.parent = &devnode->dev.kobj;
> drivers/platform/chrome/cros_ec_dev.c:  ec->cdev.kobj.parent = &ec->class_dev.kobj;
> drivers/rtc/rtc-dev.c:  rtc->char_dev.kobj.parent = &rtc->dev.kobj;
> 
> And it is what Russell King told me to use in CEC as well.

Hans recommended the approach to me when I tied cdev to media_devnode
as its parent while fixing the media_device lifetime issues.

> drivers/media/media-devnode.c:  devnode->cdev.kobj.parent = &devnode->dev.kobj;

> 
> fs/chardev.c currently doesn't have a function that sets cdev.kobj.parent,
> even though it does use it internally to call kobject_get/put on the
> parent kobject. It really expects the caller to set cdev.kobj.parent.
> 
> It ensures that when cdev_add/del is called the parent gets correctly
> refcounted as well.

Yes this is what is done now to make sure cdev lifetime matches its
parent and parent doesn't get released while cdev is in use. There is
seem to some concerns about referencing cdev private object in other
parts of the kernel. However, that is something that could be solved
by adding cdev interface to set parent.

thanks,
-- Shuah
