Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753174AbdBUOVA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 09:21:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 21 Feb 2017 06:20:58 -0800
From: Sodagudi Prasad <psodagud@codeaurora.org>
To: James Morse <james.morse@arm.com>, mchehab@s-opensource.com,
        linux-media@vger.kernel.org
Cc: shijie.huang@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        mark.rutland@arm.com, akpm@linux-foundation.org,
        sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mchehab@s-opensource.com,
        hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
        sakari.ailus@linux.intel.com, tiffany.lin@mediatek.com,
        nick@shmanahar.org, shuah@kernel.org, ricardo.ribalda@gmail.com
Subject: Re: <Query> Looking more details and reasons for using
 orig_add_limit.
In-Reply-To: <58A58162.2020101@arm.com>
References: <def87360266193184dc013a055ec3869@codeaurora.org>
 <58A4450C.3040602@arm.com> <7c727e6043e58077d143e35de0ce632c@codeaurora.org>
 <58A58162.2020101@arm.com>
Message-ID: <568205ddc2e7af6a57a71b8c5cd47d68@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi mchehab/linux-media,

It is not clear why KERNEL_DS was set explicitly here. In this path 
video_usercopy() gets  called  and it
copies the “struct v4l2_buffer” struct to user space stack memory.

Can you please share reasons for setting to KERNEL_DS here?

static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned 
long arg)
{
…
…

         if (compatible_arg)
                 err = native_ioctl(file, cmd, (unsigned long)up);
         else {
                 mm_segment_t old_fs = get_fs();

                 set_fs(KERNEL_DS);
                 err = native_ioctl(file, cmd, (unsigned long)&karg);
                 set_fs(old_fs);
         }
…
}

On 2017-02-16 02:39, James Morse wrote:
> Hi Prasad,
> 
> On 15/02/17 21:12, Sodagudi Prasad wrote:
>> On 2017-02-15 04:09, James Morse wrote:
>>> On 15/02/17 05:52, Sodagudi Prasad wrote:
>>>> that driver is calling set_fs(KERNEL_DS) and  then copy_to_user() to 
>>>> user space
>>>> memory.
>>> 
>>> Don't do this, its exactly the case PAN+UAO and the code you pointed 
>>> to are
>>> designed to catch. Accessing userspace needs doing carefully, setting 
>>> USER_DS
>>> and using the put_user()/copy_to_user() accessors are the required 
>>> steps.
>>> 
>>> Which driver is doing this? Is it in mainline?
>> 
>> Yes. It is mainline driver - 
>> drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> 
>> In some v4l2 use-case kernel panic is observed. Below part
>> of the code has set_fs to KERNEL_DS before calling native_ioctl().
>> 
>> static long do_video_ioctl(struct file *file, unsigned int cmd, 
>> unsigned long arg)
>> {
>> …
>> …
>>         if (compatible_arg)
>>                 err = native_ioctl(file, cmd, (unsigned long)up);
>>         else {
>>                 mm_segment_t old_fs = get_fs();
>> 
>>                 set_fs(KERNEL_DS);   ====> KERNEL_DS.
>>                 err = native_ioctl(file, cmd, (unsigned long)&karg);
>>                 set_fs(old_fs);
>>         }
>> 
>> Here is the call stack which is resulting crash, because user space 
>> memory has
>> read only permissions.
>> [27249.920041] [<ffffff8008357890>] __arch_copy_to_user+0x110/0x180
>> [27249.920047] [<ffffff8008847c98>] video_ioctl2+0x38/0x44
>> [27249.920054] [<ffffff8008840968>] v4l2_ioctl+0x78/0xb4
>> [27249.920059] [<ffffff80088542d8>] do_video_ioctl+0x91c/0x1160
>> [27249.920064] [<ffffff8008854b7c>] v4l2_compat_ioctl32+0x60/0xcc
>> [27249.920071] [<ffffff800822553c>] compat_SyS_ioctl+0x124/0xd88
>> [27249.920077] [<ffffff8008084e30>] el0_svc_naked+0x24/0x2
> 
> It's not totally clear to me what is going on here, but some 
> observations:
> the ioctl is trying to copy_to_user() to some read-only memory.  This 
> would
> normally fail gracefully with -EFAULT, but because KERNEL_DS has been 
> set, the
> kernel checks this before calling the fault handler and calls die() on
> your ioctl().
> 
> The ioctl code is doing this deliberately as a compat mechanism, but 
> the code
> behind file->f_op->unlocked_ioctl() expects fs==USER_DS when it does 
> its work.
> That code needs to be made aware of this compat translation, or a 
> compat_ioctl
> call provided.

> 
> Which v4l driver is this? Which ioctl is being called? Does the driver 
> using the
> v4l framework have a compat_ioctl() call?
Yes. Same kernel crash is seen with both video and camera use cases. 
Yes. Driver have compact_ioctl().

> What path does this call take through v4l2_compat_ioctl32()? It looks 
> like
> compat_ioctl will be skipped in certain cases, v4l2_compat_ioctl32() 
> has:
>> 	if (_IOC_TYPE(cmd) == 'V' && _IOC_NR(cmd) < BASE_VIDIOC_PRIVATE)
>> 		ret = do_video_ioctl(file, cmd, arg);
>> 	else if (vdev->fops->compat_ioctl32)
>> 		ret = vdev->fops->compat_ioctl32(file, cmd, arg);
> 
> Is your ioctl matched by that top if()?
Yes.  Top if condition in true and do_video_ioctl() getting called.

> 
>>>> If there is permission fault for user space address the above 
>>>> condition
>>>> is leading to kernel crash. Because orig_add_limit is having 
>>>> KERNEL_DS as set_fs
>>>> called before copy_to_user().
>>>> 
>>>> 1)    So I would like to understand that,  is that user space 
>>>> pointer leading to
>>>> permission fault not correct(condition_1) in this scenario?
>>> 
>>> The correct thing has happened here. To access user space 
>>> set_fs(USER_DS) first.
>>> (and set it back to whatever it was afterwards).
>>> 
>> 
>> So, Any clean up needed to above call path similar to what was done in 
>> the below
>> commit?
>> commit a7f61e89af73e9bf760826b20dba4e637221fcb9 - compat_ioctl: don't 
>> call
>> do_ioctl under set_fs(KERNEL_DS)
> 
> That's clever. Is that code doing a conversion, or do you have a 
> compat_ioctl()
> in your driver?
> 
> It's possible that fs/compat_ioctl.c has done this work, but 
> do_video_ioctl()
> un-does it. Someone who knows about v4l and compat-ioctls should take a 
> look...
> 
> 
> This looks like a case of:
>> The accidental invocation of an unlocked_ioctl handler that 
>> unexpectedly
>> calls copy_to_user could be a severe security issue.
> 
> that Jann describes in the commit message. Fixing the code behind
> file->f_op->unlocked_ioctl() to consider compat calls from 
> do_video_ioctl() is
> one way to solve this.
> 
> 
> 
> Thanks,
> 
> James

-Thanks, Prasad
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
Linux Foundation Collaborative Project
