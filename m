Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58959 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbcC2Nje (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 09:39:34 -0400
Subject: Re: [PATCH v2 1/2] [media] media-device: Fix mutex handling code for
 ioctl
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <fef855a4cd482eb02cff982b01511c893ea6e75d.1459243882.git.mchehab@osg.samsung.com>
 <20160329102402.GI32125@valkosipuli.retiisi.org.uk>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56FA8593.6030301@osg.samsung.com>
Date: Tue, 29 Mar 2016 07:39:32 -0600
MIME-Version: 1.0
In-Reply-To: <20160329102402.GI32125@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/29/2016 04:24 AM, Sakari Ailus wrote:
> Hi Mauro,
> 
> On Tue, Mar 29, 2016 at 06:31:27AM -0300, Mauro Carvalho Chehab wrote:
>> Remove two nested mutex left-overs at find_entity and make sure
>> that the code won't suffer race conditions if the device is
>> being removed while ioctl is being handled nor the topology changes,
>> by protecting all ioctls with a mutex at media_device_ioctl().
>>
>> As reported by Laurent, commit c38077d39c7e ("[media] media-device:
>> get rid of the spinlock") introduced a deadlock in the
>> MEDIA_IOC_ENUM_LINKS ioctl handler:
>>
>> [ 2760.127749] INFO: task media-ctl:954 blocked for more than 120 seconds.
>> [ 2760.131867]       Not tainted 4.5.0+ #357
>> [ 2760.134622] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [ 2760.139310] media-ctl       D ffffffc000086bcc     0   954    671 0x00000001
>> [ 2760.143618] Call trace:
>> [ 2760.145601] [<ffffffc000086bcc>] __switch_to+0x90/0xa4
>> [ 2760.148941] [<ffffffc0004e6ef0>] __schedule+0x188/0x5b0
>> [ 2760.152309] [<ffffffc0004e7354>] schedule+0x3c/0xa0
>> [ 2760.155495] [<ffffffc0004e7768>] schedule_preempt_disabled+0x20/0x38
>> [ 2760.159423] [<ffffffc0004e8d28>] __mutex_lock_slowpath+0xc4/0x148
>> [ 2760.163217] [<ffffffc0004e8df0>] mutex_lock+0x44/0x5c
>> [ 2760.166483] [<ffffffc0003e87d4>] find_entity+0x2c/0xac
>> [ 2760.169773] [<ffffffc0003e8d34>] __media_device_enum_links+0x20/0x1dc
>> [ 2760.173711] [<ffffffc0003e9718>] media_device_ioctl+0x214/0x33c
>> [ 2760.177384] [<ffffffc0003e9eec>] media_ioctl+0x24/0x3c
>> [ 2760.180671] [<ffffffc0001bee64>] do_vfs_ioctl+0xac/0x758
>> [ 2760.184026] [<ffffffc0001bf594>] SyS_ioctl+0x84/0x98
>> [ 2760.187196] [<ffffffc000085d30>] el0_svc_naked+0x24/0x28
>>
>> That's because find_entity() holds the graph_mutex, but both
>> MEDIA_IOC_ENUM_LINKS and MEDIA_IOC_SETUP_LINK logic also take
>> the mutex.
>>
>> Reported-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Tested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 

Please add my

Ran bind/unbind loop test on both au0828 and snd_usb_audio. On au08282, ran into
the media device lifetime related use-after-free which is a known issue present
in older releases. I did include the following bug fix for my testing: 

media: au0828 fix au0828_v4l2_device_register() to not unlock and free
https://lkml.org/lkml/2016/3/28/453

Tested-by: Shuah Khan <shuahkh@osg.samsung.com>

thanks,
-- Shuah
