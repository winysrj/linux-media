Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58720 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbcC1TEz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 15:04:55 -0400
Date: Mon, 28 Mar 2016 16:04:49 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] media-devnode: Alloc cdev dynamically
Message-ID: <20160328160449.40d34fc3@recife.lan>
In-Reply-To: <56F451CF.5060604@xs4all.nl>
References: <3cfd380703d0fb2b756c96729ef417fa2a7a343d.1458849586.git.mchehab@osg.samsung.com>
	<56F451CF.5060604@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 24 Mar 2016 21:45:03 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/24/2016 08:59 PM, Mauro Carvalho Chehab wrote:
> > Currently, cdev is embedded inside media_devnode. This causes
> > a problem with the fs core, as __fput() will try to release
> > its access by calling cdev_put():
> > 
> > [  399.653545] BUG: KASAN: use-after-free in media_release+0xe1/0xf0 [media] at addr ffff88036a9ba4e0
> > [  399.653550] Read of size 8 by task mc_nextgen_test/19761
> > [  399.653554] page:ffffea000daa6e80 count:0 mapcount:0 mapping:          (null) index:0xffff88036a9bad20
> > [  399.653559] flags: 0x2ffff8000000000()
> > [  399.653562] page dumped because: kasan: bad access detected
> > [  399.653567] CPU: 1 PID: 19761 Comm: mc_nextgen_test Tainted: G    B           4.5.0+ #62
> > [  399.653570] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
> > [  399.653574]  ffff88036a9ba4e0 ffff8803c465fd10 ffffffff819447c1 ffff88036a9ba4e0
> > [  399.653582]  ffff8803c465fda8 ffff8803c465fd98 ffffffff8156ef05 0000000800000001
> > [  399.653591]  ffff8803c689fa10 0000000000000292 0000000041b58ab3 ffffffff82813e00
> > [  399.653599] Call Trace:
> > [  399.653604]  [<ffffffff819447c1>] dump_stack+0x85/0xc4
> > [  399.653609]  [<ffffffff8156ef05>] kasan_report_error+0x525/0x550
> > [  399.653615]  [<ffffffff81685d10>] ? __fsnotify_inode_delete+0x20/0x20
> > [  399.653620]  [<ffffffff8124acd0>] ? debug_check_no_locks_freed+0x290/0x290
> > [  399.653626]  [<ffffffff8156f063>] __asan_report_load8_noabort+0x43/0x50
> > [  399.653633]  [<ffffffffa11f53b1>] ? media_release+0xe1/0xf0 [media]
> > [  399.653640]  [<ffffffffa11f53b1>] media_release+0xe1/0xf0 [media]
> > [  399.653646]  [<ffffffff815c2c4f>] __fput+0x20f/0x6d0
> > [  399.653651]  [<ffffffff815c317e>] ____fput+0xe/0x10
> > [  399.653656]  [<ffffffff811acde7>] task_work_run+0x137/0x200
> > [  399.653662]  [<ffffffff81005d54>] exit_to_usermode_loop+0x154/0x180
> > [  399.653667]  [<ffffffff8124a1b6>] ? trace_hardirqs_on_caller+0x16/0x590
> > [  399.653672]  [<ffffffff810073a6>] syscall_return_slowpath+0x186/0x1c0
> > [  399.653678]  [<ffffffff822e7a1c>] entry_SYSCALL_64_fastpath+0xbf/0xc1
> > 
> > There are two alternatives to solve it: we could either use a static
> > var for cdev or to dynamically allocate it. Let's choose the last one,
> > as this is the same solution at v4l2 core, from where this code seems
> > to have originated.  
> 
> For reference only: when I posted my CEC framework code it was based on what
> v4l2-dev.c did, and I got yelled at by Russell King. I took his advice and
> the new approach seems to work well without having to allocate cdev.
> 
> The code is here:
> 
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/100380/focus=100378
> 
> Search for cec_devnode_register.

That's about exactly the same code that is not working with the
media controller: it is getting errors when __fput() tries to free
the memory on this code snippet (from fs/file_table.c):

	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
		     !(file->f_mode & FMODE_PATH))) {
		cdev_put(inode->i_cdev);
	}

As the media controller is a chardev and inode->i_cdev is not NULL,
this will call cdev_put(), with will cause an error at __fput().

This patch fixes it by using dynamic cdev allocation.

> 
> Russell's mail is here:
> 
> http://www.spinics.net/lists/dri-devel/msg88417.html
> 
> However, the struct cec_adapter itself does have to be allocated, otherwise you
> will get nasty lifetime issues. 

Well, at the media controller, the equivalent for it would be 
struct media_devnode. 

The patch:
    [PATCH 4/4] [media] media-device: dynamically allocate struct media_devnode

makes struct media_devnode to be allocated. 

It is indeed needed, no matter how cdev is allocated, as this seem to be
the only way to fix lifetime issues there.

> This seems to be a common theme: allocate the
> main struct (cec_adapter, video_device, rc_device), then register the character
> device as a separate step. On advantage of this is that a driver can allocate
> everything first and do the registration of the devices as the last step when
> it knows everything is consistent and initialized properly.
> 
> We've been embedding video_device/media_device in top-level structs and that looks
> like it was a bad idea.
> 
> Digging into this mess is time consuming, but I thought I should at least share
> this advice from Russell as an example.



-- 
Thanks,
Mauro
