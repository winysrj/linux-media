Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33544 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbcDENVn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2016 09:21:43 -0400
Subject: Re: [RFC PATCH v2 0/5] Media Device Allocator API
To: Takashi Iwai <tiwai@suse.de>
References: <cover.1459825702.git.shuahkh@osg.samsung.com>
 <s5hfuv0ziv0.wl-tiwai@suse.de>
Cc: geliangtang@163.com, ricard.wanderlof@axis.com,
	hans.verkuil@cisco.com, chehabrafael@gmail.com,
	takamichiho@gmail.com, dominic.sacre@gmx.de,
	laurent.pinchart@ideasonboard.com, julian@jusst.de,
	clemens@ladisch.de, pierre-louis.bossart@linux.intel.com,
	johan@oljud.se, javier@osg.samsung.com, mchehab@osg.samsung.com,
	perex@perex.cz, jh1009.sung@samsung.com,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5703BBDC.4020304@osg.samsung.com>
Date: Tue, 5 Apr 2016 07:21:32 -0600
MIME-Version: 1.0
In-Reply-To: <s5hfuv0ziv0.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/05/2016 12:10 AM, Takashi Iwai wrote:
> On Tue, 05 Apr 2016 05:35:55 +0200,
> Shuah Khan wrote:
>>
>> There are known problems with media device life time management. When media
>> device is released while an media ioctl is in progress, ioctls fail with
>> use-after-free errors and kernel hangs in some cases.
>>
>> Media Device can be in any the following states:
>>
>> - Allocated
>> - Registered (could be tied to more than one driver)
>> - Unregistered, not in use (media device file is not open)
>> - Unregistered, in use (media device file is not open)
>> - Released
>>
>> When media device belongs to  more than one driver, registrations should be
>> tracked to avoid unregistering when one of the drivers does unregister. A new
>> num_drivers field in the struct media_device covers this case. The media device
>> should be unregistered only when the last unregister occurs with num_drivers
>> count zero.
>>
>> When a media device is in use when it is unregistered, it should not be
>> released until the application exits when it detects the unregistered
>> status. Media device that is in use when it is unregistered is moved to
>> to_delete_list. When the last unregister occurs, media device is unregistered
>> and becomes an unregistered, still allocated device. Unregister marks the
>> device to be deleted.
>>
>> When media device belongs to more than one driver, as both drivers could be
>> unbound/bound, driver should not end up getting stale media device that is
>> on its way out. Moving the unregistered media device to to_delete_list helps
>> this case as well.
>>
>> I ran bind/unbind loop tests on uvcvideo, au0828, and snd-usb-audio while
>> running application that does ioctls. Didn't see any use-after-free errors
>> on media device. A couple of known issues seen:
>>
>> 1. When application exits, cdev_put() gets called after media device is
>>    released. This is a known issue to resolve and Media Device Allocator
>>    can't solve this one.
>> 2. When au0828 module is removed and then ioctls fail when cdev_get() looks
>>    for the owning module as au0828 is very often the module that owns the
>>    media devnode. This is a cdev related issue that needs to be resolved and
>>    Media Device Allocator can't solve this one.
>>
>> Shuah Khan (5):
>>   media: Add Media Device Allocator API
>>   media: Add driver count to keep track of media device registrations
>>   media: uvcvideo change to use Media Device Allocator API
>>   media: au0828 change to use Media Device Allocator API
>>   sound/usb: Use Media Controller API to share media resources
> 
> I don't think we need to include usb-audio patch at this stage yet.
> The most important thing for now is to improve / stabilize the API
> itself so that other drivers can use it as is.  Once when the API is
> really stabilized, we create a solid git branch that may be based for
> multiple subsystems, and I'll merge usb-audio stuff through sound git
> tree.

Agreed. I included snd-usb-audio as it provides a good test case for
multiple driver use-case. Yes it is a good idea to have a git branch
for wider testing.

> 
> Also, the previous usb-audio MC implementation had a few serious bugs,
> including quirk NULL dereference.  See the bugzilla below for some fix
> patches to 4.6-rc1:
>   https://bugzilla.kernel.org/show_bug.cgi?id=115561
> Feel free to fold them in, if they are still valid.

I folded them in. It is unfortunate that these bugs were introduced towards
the end when I was making changes to address review comments and I didn't
catch them, especially the quirk NULL dereference.

thanks,
-- Shuah

