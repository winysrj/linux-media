Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44788 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbcCJSFg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 13:05:36 -0500
Subject: Re: [PATCH] Revert "[media] au0828: use v4l2_mc_create_media_graph()"
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1457493972-4063-1-git-send-email-shuahkh@osg.samsung.com>
 <56E19DDE.9080307@osg.samsung.com> <20160310145309.30c47210@recife.lan>
Cc: hans.verkuil@cisco.com, nenggun.kim@samsung.com,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56E1B76E.5030205@osg.samsung.com>
Date: Thu, 10 Mar 2016 11:05:34 -0700
MIME-Version: 1.0
In-Reply-To: <20160310145309.30c47210@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2016 10:53 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 10 Mar 2016 09:16:30 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> On 03/08/2016 08:26 PM, Shuah Khan wrote:
>>> This reverts commit 9822f4173f84cb7c592edb5e1478b7903f69d018.
>>> This commit breaks au0828_enable_handler() logic to find the tuner.
>>> Audio, Video, and Digital applications are broken and fail to start
>>> streaming with tuner busy error even when tuner is free.
>>>
>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>> ---
>>>  drivers/media/usb/au0828/au0828-video.c | 103 ++++++++++++++++++++++++++++++--
>>>  drivers/media/v4l2-core/v4l2-mc.c       |  21 +------
>>>  2 files changed, 99 insertions(+), 25 deletions(-)
>>>   
>>
>> Hi Mauro,
>>
>> Please pull this revert in as soon as possible. Without
>> the revert, auido, video, and digital applications won't
>> start even. There is a bug in the common routine introduced
>> in the commit 9822f4173f84cb7c592edb5e1478b7903f69d018 which
>> causes the link between source and sink to be not found.
>> I am testing on WIn-TV HVR 950Q
> 
> No, this patch didn't seem to have broken anything. The problems
> you're reporting seem to be related, instead, to this patch:
> 
> 	https://patchwork.linuxtv.org/patch/33422/
> 
> I rebased it on the top of the master tree (without reverting this
> patch).

I don't think so. I sent https://patchwork.linuxtv.org/patch/33422/
after I did the revert. I tested with linux_media branch with this
top commit:

commit de08b5a8be0df1eb7c796b0fe6b30cf1d03d14a6
Author: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Date:   Tue Mar 1 06:31:53 2016 -0300

when I found the problem and reverting the commit 
9822f4173f84cb7c592edb5e1478b7903f69d018 - solved the proble,

Could you please test with and without the revert.

> 
> Please check if it solved for you.
> 
> Yet, I'm seeing several troubles with au0828 after your patch series:
> 
> 1) when both snd-usb-audio and au0828 are compiled as module and not
> blacklisted, I'm getting some errors:
> 	http://pastebin.com/nMzr3ueM

Also without the good graph in place, you won't see the problem
I am talking about with 9822f4173f84cb7c592edb5e1478b7903f69d018

> 
> 2) removing/reprobing au0828 driver ~3 times, the Kernel becomes
> unstable. Probably, some kobj ref were decremented every time a
> module insert/removal pair is called from userspace, causing the
> kref to reach zero, thus causing the trouble;

I answered this in detail on the other thread. Cutting and pasting
from that thread:

>>I'm also getting some other weird behavior when removing/reinserting
>>the modules a few times. OK, officially we don't support it, but,
>>as devices can be bind/unbind all the times, removing modules is
>>a way to simulate such things. Also, I use it a lot while testing
>>USB drivers ;)

>>This one is after removing both the media drivers and snd-usb-audio, 
>>and then modprobing snd-usb-audio:

I did see some issues when I did the following sequence:

- blacklisted au0828 and snd-usb-audio was probed first
  graph is good just with audio entities as expected
- modprobed au0828 - graph looks good.
- rmmod au0828 - no problems seen in dmesg
- modprobe au0828 - problems kasan reports bad access etc.
  http://pastebin.com/FFqNzx9G

Here is what's going on after each step:

blacklisted au0828 and snd-usb-audio was probed first
1. snd-usb-audio creates media device and registers it
   Creates its graph etc.
2. modprobed au0828
   au0828 finds the media device created and registered.
   Adds its graph
3. rmmod au0828
   Even though there are no problems reported, at this
   time media device is unregistered, and /dev/mediaX is
   removed. We still have snd_usb-audio and media device.
   As media device is a device resource on usb device parent,
   it will still be there, but no way to access the device
   itself, because it is no longer registered.
4. modprobe au0828
   At this point, au0828 finds the media device as it still
   there, registers it and adds its graph. No audio graph
   present at this time.

Please note that the media device will not be deleted until
the last put on the parent usb struct device. So even when
both snd-usb-audio, and au0828 modules are removed, media
device is still there without its graph and associated devnode
(/dev/mediax is removed).

This isn't bad, however, media_device could still have
stale information.

e.g: enable/disable handlers - when au0828 is removed,
these are no longer valid. Could be cleaned up in
media device unregister just like entity_notify() handler
gets deleted from media device unregister. At the moment,
either driver can call unregister and same cleanup happens.

I will send a patch to do enable/disable handler cleanup
in unregister path.

However, the root of the problem is media device is
still there without its graph and associated devnode
(/dev/mediax is removed) when any one of the drivers
is removed. This leaves the remaining drivers in a
degenerate state.

The problem can be solved with some handshaking at
unregister time. We could add a callback for each
if the drivers to handle media device unregister.
However, that would add delays in device removal path
when all the drivers exit. I think it will be hard to
handle all the corner cases without adding run-time overhead.

Any thoughts on whether we want to unofficially support
being able to remove individual drivers?

> 
> 3) the media entities that should have been created by
> media_snd_stream_init() are never created. Maybe this is related
> with (1).
> 

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
