Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:47551 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934561AbdKCAnD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 20:43:03 -0400
MIME-Version: 1.0
In-Reply-To: <93d0668e-1fa6-ac2b-d998-9e0317469dd1@osg.samsung.com>
References: <cover.1507325072.git.shuahkh@osg.samsung.com> <CGME20171006213016epcas3p20e34abea60ca43f7c3f79a68fc7a38d7@epcas3p2.samsung.com>
 <fab205fc9ba1bc00e5dda4db6d426fde69116c37.1507325072.git.shuahkh@osg.samsung.com>
 <c1704d1b-95e8-e6a2-9086-3079f78daa00@samsung.com> <93d0668e-1fa6-ac2b-d998-9e0317469dd1@osg.samsung.com>
From: Marian Mihailescu <marian.mihailescu@adelaide.edu.au>
Date: Fri, 3 Nov 2017 11:13:01 +1030
Message-ID: <CAM3PiRxjO-sP22v5ZSRvKUCwn7B8S_G_GVWW_Uk75aZd3CsoMQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: s5p-mfc: fix lock confection -
 request_firmware() once and keep state
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, kamil@wypas.org,
        jtp.park@samsung.com, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can confirm, with this patch, there is always error loading MFC in
boot log, since FS is not mounted.

-Marian

On Fri, Nov 3, 2017 at 10:57 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> On 11/02/2017 02:31 AM, Andrzej Hajda wrote:
>> On 06.10.2017 23:30, Shuah Khan wrote:
>>> Driver calls request_firmware() whenever the device is opened for the
>>> first time. As the device gets opened and closed, dev->num_inst == 1
>>> is true several times. This is not necessary since the firmware is saved
>>> in the fw_buf. s5p_mfc_load_firmware() copies the buffer returned by
>>> the request_firmware() to dev->fw_buf.
>>>
>>> fw_buf sticks around until it gets released from s5p_mfc_remove(), hence
>>> there is no need to keep requesting firmware and copying it to fw_buf.
>>>
>>> This might have been overlooked when changes are made to free fw_buf from
>>> the device release interface s5p_mfc_release().
>>>
>>> Fix s5p_mfc_load_firmware() to call request_firmware() once and keep state.
>>> Change _probe() to load firmware once fw_buf has been allocated.
>>>
>>> s5p_mfc_open() and it continues to call s5p_mfc_load_firmware() and init
>>> hardware which is the step where firmware is written to the device.
>>>
>>> This addresses the mfc_mutex contention due to repeated request_firmware()
>>> calls from open() in the following circular locking warning:
>>>
>>> [  552.194115] qtdemux0:sink/2710 is trying to acquire lock:
>>> [  552.199488]  (&dev->mfc_mutex){+.+.}, at: [<bf145544>] s5p_mfc_mmap+0x28/0xd4 [s5p_mfc]
>>> [  552.207459]
>>>                but task is already holding lock:
>>> [  552.213264]  (&mm->mmap_sem){++++}, at: [<c01df2e4>] vm_mmap_pgoff+0x44/0xb8
>>> [  552.220284]
>>>                which lock already depends on the new lock.
>>>
>>> [  552.228429]
>>>                the existing dependency chain (in reverse order) is:
>>> [  552.235881]
>>>                -> #2 (&mm->mmap_sem){++++}:
>>> [  552.241259]        __might_fault+0x80/0xb0
>>> [  552.245331]        filldir64+0xc0/0x2f8
>>> [  552.249144]        call_filldir+0xb0/0x14c
>>> [  552.253214]        ext4_readdir+0x768/0x90c
>>> [  552.257374]        iterate_dir+0x74/0x168
>>> [  552.261360]        SyS_getdents64+0x7c/0x1a0
>>> [  552.265608]        ret_fast_syscall+0x0/0x28
>>> [  552.269850]
>>>                -> #1 (&type->i_mutex_dir_key#2){++++}:
>>> [  552.276180]        down_read+0x48/0x90
>>> [  552.279904]        lookup_slow+0x74/0x178
>>> [  552.283889]        walk_component+0x1a4/0x2e4
>>> [  552.288222]        link_path_walk+0x174/0x4a0
>>> [  552.292555]        path_openat+0x68/0x944
>>> [  552.296541]        do_filp_open+0x60/0xc4
>>> [  552.300528]        file_open_name+0xe4/0x114
>>> [  552.304772]        filp_open+0x28/0x48
>>> [  552.308499]        kernel_read_file_from_path+0x30/0x78
>>> [  552.313700]        _request_firmware+0x3ec/0x78c
>>> [  552.318291]        request_firmware+0x3c/0x54
>>> [  552.322642]        s5p_mfc_load_firmware+0x54/0x150 [s5p_mfc]
>>> [  552.328358]        s5p_mfc_open+0x4e4/0x550 [s5p_mfc]
>>> [  552.333394]        v4l2_open+0xa0/0x104 [videodev]
>>> [  552.338137]        chrdev_open+0xa4/0x18c
>>> [  552.342121]        do_dentry_open+0x208/0x310
>>> [  552.346454]        path_openat+0x28c/0x944
>>> [  552.350526]        do_filp_open+0x60/0xc4
>>> [  552.354512]        do_sys_open+0x118/0x1c8
>>> [  552.358586]        ret_fast_syscall+0x0/0x28
>>> [  552.362830]
>>>                -> #0 (&dev->mfc_mutex){+.+.}:
>>>                -> #0 (&dev->mfc_mutex){+.+.}:
>>> [  552.368379]        lock_acquire+0x6c/0x88
>>> [  552.372364]        __mutex_lock+0x68/0xa34
>>> [  552.376437]        mutex_lock_interruptible_nested+0x1c/0x24
>>> [  552.382086]        s5p_mfc_mmap+0x28/0xd4 [s5p_mfc]
>>> [  552.386939]        v4l2_mmap+0x54/0x88 [videodev]
>>> [  552.391601]        mmap_region+0x3a8/0x638
>>> [  552.395673]        do_mmap+0x330/0x3a4
>>> [  552.399400]        vm_mmap_pgoff+0x90/0xb8
>>> [  552.403472]        SyS_mmap_pgoff+0x90/0xc0
>>> [  552.407632]        ret_fast_syscall+0x0/0x28
>>> [  552.411876]
>>>                other info that might help us debug this:
>>>
>>> [  552.419848] Chain exists of:
>>>                  &dev->mfc_mutex --> &type->i_mutex_dir_key#2 --> &mm->mmap_sem
>>>
>>> [  552.431200]  Possible unsafe locking scenario:
>>>
>>> [  552.437092]        CPU0                    CPU1
>>> [  552.441598]        ----                    ----
>>> [  552.446104]   lock(&mm->mmap_sem);
>>> [  552.449484]                                lock(&type->i_mutex_dir_key#2);
>>> [  552.456329]                                lock(&mm->mmap_sem);
>>> [  552.462222]   lock(&dev->mfc_mutex);
>>> [  552.465775]
>>>                 *** DEADLOCK ***
>>
>> I am not 100% but it looks like false positive. Could you describe
>> scenario when it deadlocks?
>>
>>>
>>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>>> ---
>>>  drivers/media/platform/s5p-mfc/s5p_mfc.c        | 4 ++++
>>>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 3 +++
>>>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 5 +++++
>>>  3 files changed, 12 insertions(+)
>>>
>>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>>> index 1afde50..4c253fb 100644
>>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>>> @@ -1315,6 +1315,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>>>              goto err_dma;
>>>      }
>>>
>>> +    ret = s5p_mfc_load_firmware(dev);
>>> +    if (ret)
>>> +            mfc_err("Failed to load FW - try loading from open()\n");
>>> +
>>
>> What is the point of adding it? It will produce error log in case
>> filesystem is not yet mounted, and as I remember it was the reason to
>> put fw load to open callback.
>
> "What is the point of adding it" does it mean the error message or the
> attempt to load the firmware. Would it be okay to just try to load and
> not print error if it fails? If it works at this stage, _open() doesn't
> have to take time hit trying to load it.
>
> thanks,
> -- Shuah
>
