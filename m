Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4616 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZCNKa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 06:30:27 -0400
To: Sri Deevi <Srinivasa.Deevi@conexant.com>
Subject: Re: [PATCH] Fix the issue with audio module & correction of Names
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Disposition: inline
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sat, 14 Mar 2009 11:30:39 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200903141130.39954.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 March 2009 04:08:26 Sri Deevi wrote:
> Mauro and Hans,
>
> Please see the attached mailbox attachment created with 'hg email..'
>
> I still need some more time to setup the email a/c with linux box that I
> am using.

Sri, I got a "Recipient address rejected: User unknown in relay recipient 
table" after mailing this reply to you.

I'm CC-ing this to the list as well in the hope that you'll see it here.

> This patch corrects the following:
>
> 1. Wrong PID for RDU250 board
> 2. Audio module was missing as driver was expecting in different name as
> cx231xx-alsa.ko 3. Fixed some names in printk
> 3. Fixed v4l2_sub_dev issue with the driver.

Hi Sri,

Can you use normal attachments in the future rather than a mailbox 
attachment? My mailer had some problems with that.

I've reviewed the v4l2_subdev patch and there are still a few things that 
need to be done:

1) In cx231xx_usb_probe() you need to unregister the just registered 
v4l2_device before you return with an error. It's part of the cleanup, just 
like the kfree(dev).

2) cx231xx_vdev_init should assign vfd->v4l2_dev rather than assigning 
vfd->parent. That way the video_device struct has a pointer to the 
top-level v4l2_device struct.

3) the attach_inform and detach_inform should be removed as these are only 
relevant to the old i2c autoprobing behavior. BTW, you asked me before why 
I thought that the Hammerhead could also be on address 0x80. That's from 
the attach_inform function that reports a Hammerhead on both 0x80 and 0x88.

4) There is still a request_module("tuner") that has to be replaced by a 
v4l2_i2c_new_subdev() call as well.

5) cx231xx_i2c_call_clients must be removed as well. Instead use the new 
v4l2_device_call_all() macro (see the framework doc). The big advantage of 
using this is that the command goes to all subdevices, regardless of the 
i2c adapter they are on (in fact, they don't have to be i2c devices at 
all!). If you need to send a command to a specific device then you can 
either store the v4l2_subdev pointer in your main cx231xx struct and use 
v4l2_subdev_call, or set the grp_id field of the v4l2_subdev and use that 
to direct where the command will go to (again, see the framework doc).

I tend to just store the subdev pointer if there is only one or two subdevs 
that need this treatment, and I use grp_id if it gets more complicated than 
that. For example, ivtv makes full use of the grp_id since it has to juggle 
so many different i2c devices.

I think this is all that it needed to have it fully comply to the new API. 
Thanks for the quick work!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
