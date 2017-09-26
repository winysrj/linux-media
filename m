Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56709
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S966382AbdIZUKL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:10:11 -0400
To: Kyungmin Park <kyungmin.park@samsung.com>, kamil@wypas.org,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: s5p-mfc - WARNING: possible circular locking dependency detected,[
 4.14.0-rc2
Message-ID: <1cecc4d2-58e7-8876-1492-6ce97fe8082a@osg.samsung.com>
Date: Tue, 26 Sep 2017 14:10:01 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When running gstreamer pipeline with s5p-mfc → exynos-gsc→ exynos-drm,
I am seeing circular locking dependency detected warning in 4.14-rc2.
This is a regression from 4.13. The pipeline does run to completion
video streaming works. Are you aware of this problem, or would you
like it to be bisected.

gst-launch-1.0 filesrc location=/media/shuah_arm/GH3_MOV_HD.mp4 ! qtdemux ! h264parse ! v4l2video4dec capture-io-mode=dmabuf ! v4l2video7convert output-io-mode=dmabuf-import ! kmssink force-modesetting=true

[ 2134.994539] ======================================================
[ 2135.000661] WARNING: possible circular locking dependency detected
[ 2135.006815] 4.14.0-rc2 #1 Not tainted
[ 2135.010452] ------------------------------------------------------
[ 2135.016606] qtdemux0:sink/2700 is trying to acquire lock:
[ 2135.021978]  (&dev->mfc_mutex){+.+.}, at: [<bf109540>] s5p_mfc_mmap+0x28/0xd4 [s5p_mfc]
[ 2135.029950]
               but task is already holding lock:
[ 2135.035755]  (&mm->mmap_sem){++++}, at: [<c01df2e4>] vm_mmap_pgoff+0x44/0xb8
[ 2135.042774]
               which lock already depends on the new lock.

[ 2135.050920]
               the existing dependency chain (in reverse order) is:
[ 2135.058372]
               -> #2 (&mm->mmap_sem){++++}:
[ 2135.063751]        __might_fault+0x80/0xb0
[ 2135.067822]        filldir64+0xc0/0x2f8
[ 2135.071635]        call_filldir+0xb0/0x14c
[ 2135.075705]        ext4_readdir+0x768/0x90c
[ 2135.079864]        iterate_dir+0x74/0x168
[ 2135.083851]        SyS_getdents64+0x7c/0x1a0
[ 2135.088099]        ret_fast_syscall+0x0/0x28
[ 2135.092340]
               -> #1 (&type->i_mutex_dir_key#2){++++}:
[ 2135.098671]        down_read+0x48/0x90
[ 2135.102395]        lookup_slow+0x74/0x178
[ 2135.106380]        walk_component+0x1a4/0x2e4
[ 2135.110713]        link_path_walk+0x174/0x4a0
[ 2135.115045]        path_openat+0x68/0x944
[ 2135.119031]        do_filp_open+0x60/0xc4
[ 2135.123019]        file_open_name+0xe4/0x114
[ 2135.127263]        filp_open+0x28/0x48
[ 2135.130990]        kernel_read_file_from_path+0x30/0x78
[ 2135.136193]        _request_firmware+0x3ec/0x78c
[ 2135.140782]        request_firmware+0x3c/0x54
[ 2135.145133]        s5p_mfc_load_firmware+0x44/0x140 [s5p_mfc]
[ 2135.150848]        s5p_mfc_open+0x2d4/0x4e0 [s5p_mfc]
[ 2135.155892]        v4l2_open+0xa0/0x104 [videodev]
[ 2135.160627]        chrdev_open+0xa4/0x18c
[ 2135.164612]        do_dentry_open+0x208/0x310
[ 2135.168945]        path_openat+0x28c/0x944
[ 2135.173017]        do_filp_open+0x60/0xc4
[ 2135.177002]        do_sys_open+0x118/0x1c8
[ 2135.181076]        ret_fast_syscall+0x0/0x28
[ 2135.185320]
               -> #0 (&dev->mfc_mutex){+.+.}:
[ 2135.190871]        lock_acquire+0x6c/0x88
[ 2135.194855]        __mutex_lock+0x68/0xa34
[ 2135.198927]        mutex_lock_interruptible_nested+0x1c/0x24
[ 2135.204575]        s5p_mfc_mmap+0x28/0xd4 [s5p_mfc]
[ 2135.209430]        v4l2_mmap+0x54/0x88 [videodev]
[ 2135.214093]        mmap_region+0x3a8/0x638
[ 2135.218163]        do_mmap+0x330/0x3a4
[ 2135.221890]        vm_mmap_pgoff+0x90/0xb8
[ 2135.225962]        SyS_mmap_pgoff+0x90/0xc0
[ 2135.230122]        ret_fast_syscall+0x0/0x28
[ 2135.234366]
               other info that might help us debug this:

[ 2135.242339] Chain exists of:
                 &dev->mfc_mutex --> &type->i_mutex_dir_key#2 --> &mm->mmap_sem

[ 2135.253690]  Possible unsafe locking scenario:

[ 2135.259583]        CPU0                    CPU1
[ 2135.264089]        ----                    ----
[ 2135.268594]   lock(&mm->mmap_sem);
[ 2135.271974]                                lock(&type->i_mutex_dir_key#2);
[ 2135.278820]                                lock(&mm->mmap_sem);
[ 2135.284712]   lock(&dev->mfc_mutex);
[ 2135.288265]
                *** DEADLOCK ***

[ 2135.294159] 1 lock held by qtdemux0:sink/2700:
[ 2135.298577]  #0:  (&mm->mmap_sem){++++}, at: [<c01df2e4>] vm_mmap_pgoff+0x44/0xb8
[ 2135.306029]
               stack backtrace:
[ 2135.310365] CPU: 7 PID: 2700 Comm: qtdemux0:sink Not tainted 4.14.0-rc2 #1
[ 2135.317208] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2135.323282] [<c01102c8>] (unwind_backtrace) from [<c010cabc>] (show_stack+0x10/0x14)
[ 2135.330992] [<c010cabc>] (show_stack) from [<c08543a4>] (dump_stack+0x98/0xc4)
[ 2135.338184] [<c08543a4>] (dump_stack) from [<c016b2fc>] (print_circular_bug+0x254/0x410)
[ 2135.346241] [<c016b2fc>] (print_circular_bug) from [<c016c580>] (check_prev_add+0x468/0x938)
[ 2135.354647] [<c016c580>] (check_prev_add) from [<c016f4dc>] (__lock_acquire+0x1314/0x14fc)
[ 2135.362878] [<c016f4dc>] (__lock_acquire) from [<c016fefc>] (lock_acquire+0x6c/0x88)
[ 2135.370591] [<c016fefc>] (lock_acquire) from [<c0869fb4>] (__mutex_lock+0x68/0xa34)
[ 2135.378217] [<c0869fb4>] (__mutex_lock) from [<c086aa08>] (mutex_lock_interruptible_nested+0x1c/0x24)
[ 2135.387419] [<c086aa08>] (mutex_lock_interruptible_nested) from [<bf109540>] (s5p_mfc_mmap+0x28/0xd4 [s5p_mfc])
[ 2135.397489] [<bf109540>] (s5p_mfc_mmap [s5p_mfc]) from [<bf019120>] (v4l2_mmap+0x54/0x88 [videodev])
[ 2135.406571] [<bf019120>] (v4l2_mmap [videodev]) from [<c01f4798>] (mmap_region+0x3a8/0x638)
[ 2135.414870] [<c01f4798>] (mmap_region) from [<c01f4d58>] (do_mmap+0x330/0x3a4)
[ 2135.422063] [<c01f4d58>] (do_mmap) from [<c01df330>] (vm_mmap_pgoff+0x90/0xb8)
[ 2135.429255] [<c01df330>] (vm_mmap_pgoff) from [<c01f28cc>] (SyS_mmap_pgoff+0x90/0xc0)
[ 2135.437054] [<c01f28cc>] (SyS_mmap_pgoff) from [<c0108820>] (ret_fast_syscall+0x0/0x28)


thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com
