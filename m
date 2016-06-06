Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44234 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbcFFXNR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2016 19:13:17 -0400
Subject: Re: [PATCH 2/2] [media] media-device: dynamically allocate struct
 media_devnode
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1462633500.git.mchehab@osg.samsung.com>
 <83247b8a21c292a08949b3fe619cc56dc4709896.1462633500.git.mchehab@osg.samsung.com>
 <20160606084500.GW26360@valkosipuli.retiisi.org.uk>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <57560388.7030903@osg.samsung.com>
Date: Mon, 6 Jun 2016 17:13:12 -0600
MIME-Version: 1.0
In-Reply-To: <20160606084500.GW26360@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/06/2016 02:45 AM, Sakari Ailus wrote:
> Hi Mauro,
> 
> On Sat, May 07, 2016 at 12:12:09PM -0300, Mauro Carvalho Chehab wrote:
>> struct media_devnode is currently embedded at struct media_device.
>>
>> While this works fine during normal usage, it leads to a race
>> condition during devnode unregister. the problem is that drivers
>> assume that, after calling media_device_unregister(), the struct
>> that contains media_device can be freed. This is not true, as it
>> can't be freed until userspace closes all opened /dev/media devnodes.
>>
>> In other words, if the media devnode is still open, and media_device
>> gets freed, any call to an ioctl will make the core to try to access
>> struct media_device, with will cause an use-after-free and even GPF.
>>
>> Fix this by dynamically allocating the struct media_devnode and only
>> freeing it when it is safe.
> 
> A few general comments on the patch --- I agree we've had the problem from
> the day one, but it's really started showing up recently. I agree with the
> taken approach of separating the lifetimes of both media device and the
> devnode. However, I don't think the patch as such is enough.

It is more like, we started actively testing for this problem. I added a new
test under selftests/media for this problem. Laurent brought this up at our
Finland media summit and I have been looking to solve this since then starting
with writing a test to reliably reproduce the problem.

You are right that this patch alone isn't enough and I sent in another patch that
sets cdev kref parent to media_devnode struct device kref.

https://patchwork.linuxtv.org/patch/34201/

> 
> For one, there are some issue that remain. In particular, access to the data
> structures (i.e. media_device and media_devnode) aren't serialised: the
> IOCTL or a system call passes media-devnode framework asynchronously with a
> possible unregister() call coming from media_device_unregister() (in
> media-device.c). This may, unless I'm mistaken, to the following sequence:
> 
> process 1				process 2
> fd = open(/dev/media0)
> 
> 					media_device_unregister()
> 						(things are being cleaned up
> 						here but the devnode isn't
> 						unregistered yet)
> 					...
> ioctl(fd, ...)
> __media_ioctl()
> media_devnode_is_registered()
> 	(returns true here)
> 					...
> 					media_devnode_unregister()
> 					...
> 					(driver releases the media device
> 					memory)
> 
> media_device_ioctl()
> 	(By this point
> 	devnode->media_dev does not
> 	point to allocated memory.
> 	Bad things will happen here.)
> 
> 
> You could try to serialise the operations. I wonder how ugly that might
> be, and I'm not sure this would be a workable approach.

I don't believe this problem can be solved with serializing operations.
media_devnode_is_registered() relies on media devnode to be valid until
the corresponding close is done.

We have:

struct media_device embedding struct media_devnode and media_devnode
embeds cdev. Each one of these have their own refcounts. media_device
can be released even when the cdev is busy. When media_device is released,
media_devnode goes away. The only sure way to ensure media_devnode sticks
around is by dynamically allocating it. This decouples media_devnode life
time management from media_device management. Granted media_devnode is tied
to media_device, but by decoupling, we make the media_devnode_is_registered()
safe even when media_device is released.

The next step is coupling media_devnode cdev lifetime with media_devnode
lifetime, by setting devnode strucr device kobj as the cdev kobj parent.
Please see the following patch I sent out:

https://patchwork.linuxtv.org/patch/34201/

This patch ensures devnode isn't released until the last application
closes the device and the last cdev kobj parent is released.

> 
> Secondly, a dependency is created from media devnode (i.e. media devnode
> becomes aware of the media device). This is against the original design of
> the two, as the media devnode was intended for other kinds of device nodes
> as well and is more generic than media device. I'm not necessarily arguing
> we have to keep it this way (as media devnode is only used by media device),
> but if we're not keeping it then it'd make sense to unify the two to keep it
> clean.

Unless there is a string reason to not make media devnode aware of the media
device, this is a good direction. As such, our current design is not ideal.
media devnode isn't aware of the structure its life depends on. :)

> 
> 
> Have you thought about taking a reference to the said structs (by the means
> of kref) where one is acquired?
> 
> That way, we should be able to rather easily keep around everything that's
> needed until the last remaining user has gone away: opening a file handle
> should get a reference to both media device and media devnode as well as
> registering them (media_device_register() and media_devnode_register()).

Please see above. The patch I sent out does this exactly. Decoupling devnode
from media_device structure is necessary to avoid multiple concurrent lifetimes.

I do think, this is a good direction for us to go. I also have media device
allocator patch API out and reviewed which is based on these two patches and
it is simple and clean as I could rely on this problem being addressed with
these two patches.

thanks,
-- Shuah


