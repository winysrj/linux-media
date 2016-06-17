Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54412 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbcFQNmv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 09:42:51 -0400
Subject: Re: [PATCH] media: fix media devnode ioctl/syscall and unregister
 race
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1465580243-7274-1-git-send-email-shuahkh@osg.samsung.com>
 <20160617060843.GE24980@valkosipuli.retiisi.org.uk>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5763FE4C.3040007@osg.samsung.com>
Date: Fri, 17 Jun 2016 07:42:36 -0600
MIME-Version: 1.0
In-Reply-To: <20160617060843.GE24980@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/17/2016 12:08 AM, Sakari Ailus wrote:
> Hi Shuah,
> 
> On Fri, Jun 10, 2016 at 11:37:23AM -0600, Shuah Khan wrote:
>> Media devnode open/ioctl could be in progress when media device unregister
>> is initiated. System calls and ioctls check media device registered status
>> at the beginning, however, there is a window where unregister could be in
>> progress without changing the media devnode status to unregistered.
>>
>> process 1				process 2
>> fd = open(/dev/media0)
>> media_devnode_is_registered()
>> 	(returns true here)
>>
>> 					media_device_unregister()
>> 						(unregister is in progress
>> 						and devnode isn't
>> 						unregistered yet)
>> 					...
>> ioctl(fd, ...)
>> __media_ioctl()
>> media_devnode_is_registered()
>> 	(returns true here)
>> 					...
>> 					media_devnode_unregister()
>> 					...
>> 					(driver releases the media device
>> 					memory)
>>
>> media_device_ioctl()
>> 	(By this point
>> 	devnode->media_dev does not
>> 	point to allocated memory.
>> 	use-after free in in mutex_lock_nested)
>>
>> BUG: KASAN: use-after-free in mutex_lock_nested+0x79c/0x800 at addr
>> ffff8801ebe914f0
>>
>> Fix it by clearing register bit when unregister starts to avoid the race.
> 
> Does this patch solve the problem? You'd have to take the mutex for the
> duration of the IOCTL which I don't see the patch doing.
> 
> Instead of serialising operations using mutexes, I believe a proper fix for
> this is to take a reference to the data structures required.
> 

It fixes the problem Mauro and I have seen. It closes the window enough
to avoid problem. We have disconnected data structure issue as you pointed
out. media devnode register/unregister are protected by media_devnode_lock
and the graph is protected by graph_mutex. I avoided taking the mutex for
the entire duration of the ioctl.

I think what you are suggesting is that the ioctl take a reference to
media_device? One reason I avoided that is by doing that we will end up
with 3 different objects with varied lifetimes dependent on each other.
We have media_devnode and cdev dependency which handled by using devnode
struct dev as cdev parent. It is possible to link media_device to devnode
lifetime, by having media_ioctl or media_opne take reference to media_device.
Is that what you have in mind?

thanks,
-- Shuah

