Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37936 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbcFPNlC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 09:41:02 -0400
Subject: Re: [PATCH 3/3] drivers/media/media-device: fix double free bug in
 _unregister()
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602171226.9818.8828702464432665144.stgit@woodpecker.blarg.de>
 <5761BB4A.9040309@osg.samsung.com> <20160615203753.GA30666@swift.blarg.de>
 <20160616092926.GA1333@swift.blarg.de>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5762AC64.6090309@osg.samsung.com>
Date: Thu, 16 Jun 2016 07:40:52 -0600
MIME-Version: 1.0
In-Reply-To: <20160616092926.GA1333@swift.blarg.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 03:29 AM, Max Kellermann wrote:
> (Shuah, I did not receive your second reply; I only found it in an
> email archive.)
> 
>> Yes media_devnode_create() creates the interfaces links and these
>> links are deleted by media_devnode_remove().
>> media_device_unregister() still needs to delete the interfaces
>> links. The reason for that is the API dynalic use-case.
>>
>> Drivers (other than dvb-core and v4l2-core) can create and delete
>> media devnode interfaces during run-time
> 
> My point was that they do not.  There are no other
> media_devnode_create() callers.

Correct. There are none in the base now. However as I explained the
dynamic use-case. There is work in progress that uses this feature
in the API.

> 
>> So removing kfree() from media_device_unregister() isn't the correct
>> fix.
> 
> Then what is?  I don't know anything other than the (mostly
> undocumented) code I read, and my patch implements the design that I
> interpreted from the code.  Apparently my interpretation of the design
> is wrong after all.
> 
>> I don't see the stack trace for the double free error you are
>> seeing?
> 
> Actually, it didn't crash at the double free; it hung forever because
> it tried to lock a mutex which was already stale.  I don't have a
> stack trace of that; would it help to produce one?

I think you are running into another set of problems related to media
devnode, cdev, and race between media ioctl/syscall and media unregister
sequence. These patches are in

git://linuxtv.org/media_tree.git master branch

> 
>> Could it be that there is a driver problem in the order in which it
>> is calling media_device_unregister()?
> 
> Maybe it's due to my patch 1/3 which adds a kref, and it only occurs
> if one process still has a file handle.

So you are adding another refcounted object to the mix, in addition to
media_device, media_devnode, and cdev. Now you have three or more objects
with varying lifetimes. Not a good situation to be in.

> 
> In any case, the kernel must decide who's responsible for freeing the
> object, and how the dvbdev.c library gets to know that its pointer has
> been invalidated.

Yes it does that. intf links need to be free'd in both cases, one when
driver does a devnode_remove() and then when unregister is done. There
could be two drivers that are bound to the media hardware and both might
own their own sections of the media graph. Media Controller core has to
allow the possibility of one driver unbind/rmmod and be able to delete
the devnode it created.

I don't think the problem you are running into is due to this code path.
Without seeing the stack trace, it is hard to debug as you really don't
know what the problem is, leave alone being able to fix it.

thanks,
-- Shuah

