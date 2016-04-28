Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47378 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbcD1LmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 07:42:04 -0400
Date: Thu, 28 Apr 2016 08:41:55 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 4/4] [meida] media-device: dynamically allocate struct
 media_devnode
Message-ID: <20160428084155.65c812b1@recife.lan>
In-Reply-To: <57213B48.50109@samsung.com>
References: <cover.1458760750.git.mchehab@osg.samsung.com>
	<0e1737bc1fd4fb4c114cd1f4823767a35b5c5b77.1458760750.git.mchehab@osg.samsung.com>
	<4033448.cTfoZapJ5n@avalon>
	<20160324083710.24d0d57e@recife.lan>
	<57213B48.50109@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Apr 2016 16:20:56 -0600
Shuah Khan <shuah.kh@samsung.com> escreveu:

> On 03/24/2016 05:37 AM, Mauro Carvalho Chehab wrote:
> > Em Thu, 24 Mar 2016 10:24:44 +0200
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> >   
> >> On Wednesday 23 Mar 2016 16:27:46 Mauro Carvalho Chehab wrote:  
> >>> struct media_devnode is currently embedded at struct media_device.
> >>>
> >>> While this works fine during normal usage, it leads to a race
> >>> condition during devnode unregister. the problem is that drivers
> >>> assume that, after calling media_device_unregister(), the struct
> >>> that contains media_device can be freed. This is not true, as it
> >>> can't be freed until userspace closes all opened /dev/media devnodes.
> >>>
> >>> In other words, if the media devnode is still open, and media_device
> >>> gets freed, any call to an ioctl will make the core to try to access
> >>> struct media_device, with will cause an use-after-free and even GPF.
> >>>
> >>> Fix this by dynamically allocating the struct media_devnode and only
> >>> freeing it when it is safe.    
> 
> Hi Mauro,
> 
> I think this is the patch you were referring to in response to the patch
> I sent out. Looks like this is still under review and some outstanding
> issues. This patch itself doesn't ensure media_devnode sticks around
> until the last app. closes the cdev. More work is needed such as adding
> cdev parent and providing kobject release function that can be called
> from cdev-core which will free media_devnode when the last cdev ref
> is gone.
> 
> Anyway, since you asked me to do the fix on top of your patch, I am asking
> to see if this patch is in a good shape for me to apply. As such, we no
> longer have sound/us/media.c in the mix. Hence this patch needs work before
> I can base my work on it.

Well, the only issue on it is that it needed to be rebased on the top of
the current tree. I did such rebase for you, at:
	https://git.linuxtv.org/mchehab/experimental.git/log/?h=au0828-unbind-fixes-v5

As said before, it doesn't touch cdev, nor adds any kref.

I'm running it today with the stress test. So far (~100 unbind loops, with 5
concurrent accesses via mc_nextgen_test), the only issue it got so
far seems to be at V4L2 cdev stuff (not at the media side, but at the
V4L2 API side):


[  445.428212] kasan: CONFIG_KASAN_INLINE enabled
[  445.428346] kasan: GPF could be caused by NULL-ptr deref or user memory access
[  445.428750] general protection fault: 0000 [#2] SMP KASAN
[  445.429417] Modules linked in: ir_lirc_codec lirc_dev au8522_dig xc5000 tuner au8522_decoder au8522_common au0828 videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core tveeprom dvb_core rc_core v4l2_common videodev media cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i915 snd_hda_codec_realtek snd_hda_codec_generic sha256_ssse3 sha256_generic hmac drbg btusb btrtl btbcm aesni_intel evdev snd_hda_intel aes_x86_64 lrw btintel i2c_algo_bit snd_hda_codec gf128mul bluetooth glue_helper drm_kms_helper snd_hwdep ablk_helper cryptd snd_hda_core drm serio_raw
[  445.431431]  rfkill sg snd_pcm pcspkr snd_timer mei_me snd mei lpc_ich i2c_i801 mfd_core soundcore battery dw_dmac video dw_dmac_core i2c_designware_platform i2c_designware_core acpi_pad button tpm_tis tpm ext4 crc16 jbd2 mbcache dm_mod sd_mod ahci libahci psmouse libata e1000e ehci_pci xhci_pci ptp scsi_mod ehci_hcd pps_core xhci_hcd fan thermal sdhci_acpi sdhci mmc_core i2c_hid hid
[  445.431907] CPU: 0 PID: 32248 Comm: v4l_id Tainted: G      D         4.6.0-rc2+ #68
[  445.431984] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[  445.436336] task: ffff8803bde0b000 ti: ffff8803a22d8000 task.ti: ffff8803a22d8000
[  445.440571] RIP: 0010:[<ffffffff81d77a61>]  [<ffffffff81d77a61>] usb_ifnum_to_if+0x31/0x270
[  445.444745] RSP: 0018:ffff8803a22df8d0  EFLAGS: 00010282
[  445.448765] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 1ffff10074699c5e
[  445.452648] RDX: 000000000000009e RSI: 0000000000000000 RDI: 00000000000004f0
[  445.456339] RBP: ffff8803a22df908 R08: 0000000000000001 R09: 0000000000000001
[  445.459885] R10: ffff8803a2254580 R11: 0000000000000000 R12: ffffffffa12be0c0
[  445.463473] R13: ffff8803a34ceb3c R14: ffff8803a34cc080 R15: ffffffffa12a89b0
[  445.466938] FS:  00007f4629888700(0000) GS:ffff8803c6800000(0000) knlGS:0000000000000000
[  445.470457] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  445.473960] CR2: 00007f0e00d19000 CR3: 00000003b0bca000 CR4: 00000000003406f0
[  445.477441] Stack:
[  445.480959]  ffff8803a3480ba0 ffff8803a34ce2f0 ffff8803a34cc000 ffffffffa12be0c0
[  445.484563]  ffff8803a34ceb3c ffff8803a34cc080 ffffffffa12a89b0 ffff8803a22df940
[  445.488178]  ffffffffa12a4a45 ffff8803a22df940 ffff8803a34cc000 0000000000000000
[  445.491780] Call Trace:
[  445.495317]  [<ffffffffa12a89b0>] ? au0828_v4l2_close+0x5a0/0x5a0 [au0828]
[  445.498886]  [<ffffffffa12a4a45>] au0828_analog_stream_enable+0x85/0x330 [au0828]
[  445.502461]  [<ffffffffa12a8b11>] au0828_v4l2_open+0x161/0x350 [au0828]
[  445.506012]  [<ffffffffa12a89b0>] ? au0828_v4l2_close+0x5a0/0x5a0 [au0828]
[  445.509531]  [<ffffffffa1169561>] v4l2_open+0x1d1/0x350 [videodev]
[  445.513097]  [<ffffffff815cc071>] chrdev_open+0x1f1/0x580
[  445.516643]  [<ffffffff815cbe80>] ? cdev_put+0x50/0x50
[  445.520129]  [<ffffffff815b98a7>] do_dentry_open+0x5d7/0xac0
[  445.523582]  [<ffffffff815cbe80>] ? cdev_put+0x50/0x50
[  445.526994]  [<ffffffff815bc05b>] vfs_open+0x16b/0x1e0
[  445.530442]  [<ffffffff815e1c0b>] ? may_open+0x14b/0x260
[  445.533882]  [<ffffffff815eb3f7>] path_openat+0x4f7/0x3a00
[  445.537253]  [<ffffffff8156cc95>] ? alloc_debug_processing+0x75/0x1c0
[  445.540731]  [<ffffffff815eaf00>] ? vfs_create+0x390/0x390
[  445.544198]  [<ffffffff811ad88e>] ? __kernel_text_address+0x7e/0xa0
[  445.547650]  [<ffffffff8109154f>] ? print_context_stack+0x7f/0xf0
[  445.551089]  [<ffffffff8124b110>] ? debug_check_no_locks_freed+0x290/0x290
[  445.554512]  [<ffffffff815b105b>] ? create_object+0x3eb/0x940
[  445.558004]  [<ffffffff8124a5f6>] ? trace_hardirqs_on_caller+0x16/0x590
[  445.561511]  [<ffffffff815f1cd5>] do_filp_open+0x175/0x230
[  445.565031]  [<ffffffff815f1b60>] ? user_path_mountpoint_at+0x40/0x40
[  445.568540]  [<ffffffff822d8567>] ? _raw_spin_unlock+0x27/0x40
[  445.572056]  [<ffffffff81615b1a>] ? __alloc_fd+0x19a/0x4b0
[  445.575491]  [<ffffffff8156d653>] ? kmem_cache_alloc+0x233/0x300
[  445.579023]  [<ffffffff815bc615>] do_sys_open+0x195/0x340
[  445.582510]  [<ffffffff8123eb5f>] ? up_read+0x1f/0x40
[  445.585079]  [<ffffffff815bc480>] ? filp_open+0x60/0x60
[  445.588457]  [<ffffffff81242681>] ? trace_hardirqs_off_caller+0x21/0x290
[  445.591960]  [<ffffffff8100401b>] ? trace_hardirqs_on_thunk+0x1b/0x1d
[  445.595413]  [<ffffffff815bc7de>] SyS_open+0x1e/0x20
[  445.598904]  [<ffffffff822d8dc0>] entry_SYSCALL_64_fastpath+0x23/0xc1
[  445.602394]  [<ffffffff81242681>] ? trace_hardirqs_off_caller+0x21/0x290
[  445.605902] Code: 48 b8 00 00 00 00 00 fc ff df 48 89 e5 41 57 41 56 41 55 41 54 53 48 89 fb 48 81 c7 f0 04 00 00 48 89 fa 48 c1 ea 03 48 83 ec 10 <80> 3c 02 00 0f 85 c6 01 00 00 4c 8b bb f0 04 00 00 4d 85 ff 0f 
[  445.609826] RIP  [<ffffffff81d77a61>] usb_ifnum_to_if+0x31/0x270
[  445.613516]  RSP <ffff8803a22df8d0>
[  445.617247] ---[ end trace 9127ab975e0f4104 ]---

I got two of those errors already.


> Lars gave a few comments on the patch I sent out in the code that makes
> devnode dynamic which are relevant to be folded into your patch. Added
> Lars to this thread.

Yeah, I saw Lars comments. I'll answer to his emails in a few.

> 
> P.S: removed alsa folks and alsa list and added linux-media
> 
> thanks,
> -- Shuah
> >>
> >> We have the exact same issue with video_device, and there we've solved the 
> >> problem by passing the release call all the way up to the driver. I'm open to 
> >> discuss what the best solution is, but I don't think we should special-case 
> >> media_device unless there are compelling arguments regarding why different 
> >> solutions are needed for media_device and video_device.  
> > 
> > The relationship between a video driver and  video_device/v4l2_dev is
> > different. On V4L2 we have:
> > 	- One driver using video_device resources;
> > 	- multiple video_device devnodes.
> > 
> > For media devices, the relationship is the opposite:
> > 	- multiple independent drivers using media_devnode.
> > 	- One media device node;
> > 
> > On media devices, when multiple drivers are sharing the same devnode, the
> > .probe() order can be different than the .release() order.
> > 
> > So, we don't need to use the same solution as we did for video_device
> > on media controller. Actually, the V4L2 solution won't work.
> > 
> > On V4L2, a video device is typically initialized with:
> > 
> >         video-dev->release = video_device_release;
> >         err = video_register_device(video_dev,VFL_TYPE_GRABBER,
> >                                     video_nr[dev->nr]);
> > 
> > And video_device_release is simply a kfree:
> > 
> > void video_device_release(struct video_device *vdev)
> > {
> >         kfree(vdev);
> > }
> > 
> > The caller driver may opt to use its own code to free the resources
> > instead of the core one, but it needs to free vdev in the end
> > (or some struct that embedds it).
> > 
> > In the specific case of media, drivers don't need to touch or even
> > be aware of media_devnode, as the creation of the media devnode is
> > handled internally by the core. Also, there's no good reason to
> > make the caller drivers to be aware of that.
> > 
> > So, the approach taken by this patch is actually simpler, as the
> > kfree() is internal to the core, and it doesn't require
> > any callbacks. This patch provides all that it is needed to make devnode
> > destroy safe. 
> > 
> > On the common case where one driver allocates one /dev/media devnode,
> > using the standard media_device_register()/media_device_unregister(),
> > grants that a media_devnode instance will only be freed after all uses
> > have gone, including open() descriptors. It also grants that the caller
> > can free its own resources after media_device_unregister(), because
> > media_devnode won't use media_device anymore.
> > 
> > This happens because media_devnode_is_registered() will return
> > false after media_device_unregister(), and the media_ioctl logic
> > will return an error in this case:
> > __media_ioctl(struct file *filp, unsigned int cmd, unsigned long arg,
> > 	      long (*ioctl_func)(struct file *filp, unsigned int cmd,
> > 				 unsigned long arg))
> > {
> > 	struct media_devnode *devnode = media_devnode_data(filp);
> > 
> > 	if (!ioctl_func)
> > 		return -ENOTTY;
> > 
> > 	if (!media_devnode_is_registered(devnode))
> > 		return -EIO;
> > 		/* IMHO, it should be -ENODEV here */
> > 
> > 	return ioctl_func(filp, cmd, arg);
> > }
> > 
> > all other syscalls have a similar test.
> > 
> > When more than one driver shares the same media devnode - e. g. the
> > case that it is currently using media_device_*_devres(), the V4L2
> > solution of exposing the .release() callback to the caller driver
> > won't work, as the unbind order can be different than the binding
> > one. So, it is not possible to have .release() callbacks.
> > 
> > On the multiple drivers scenario, a kref is used to identify when
> > all drivers called media_device_unregister_devres(). Only when the
> > last driver called it, it will do the actual media_device cleanups
> > and will wait for userspace to close all opened file descriptors,
> > calling kfree(media_devnode) only after that. It is also safe for
> > a device driver to cleanup its own resources after
> > media_device_release_devres(), as, if the driver is not the last
> > one, media_device and media_devnode will still be allocated, and,
> > if it is the last one, this will fallback on the case of a single
> > driver.
> > 
> > I can't think on any other race-free solution than the one implemented
> > by this patch, and still being simple.
> >   
> >> I also suspect we will need to consider dynamic pipeline management sooner 
> >> than later to solve the problem properly if we don't want to create code today 
> >> that will need to be completely reworked tomorrow.  
> > 
> > On the stress testing we're doing, we're removing/recreating part of the
> > graph, by unbinding/rebinding one one of the drivers, while keep calling
> > G_TOPOLOGY on an endless loop.
> > 
> > It is working quite well. The change from semaphore->mutex, suggested
> > by Sakari seemed to solve all the locking issues we had before.
> > 
> > Ok, I didn't test SETUP_LINK, but, as it is now protected by the same
> > mutex, except for some hidden bug, I guess it will work just fine.
> > 
> > So, I don't see any need to change the locking schema at the core,
> > to avoid race issues.
> >   
> >>  
> >>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >>> ---
> >>>  drivers/media/media-device.c           | 38 +++++++++++++++++++------------
> >>>  drivers/media/media-devnode.c          |  7 ++++++-
> >>>  drivers/media/usb/au0828/au0828-core.c |  4 ++--
> >>>  drivers/media/usb/uvc/uvc_driver.c     |  2 +-
> >>>  include/media/media-device.h           |  5 +----
> >>>  include/media/media-devnode.h          | 15 ++++++++++++--
> >>>  sound/usb/media.c                      |  8 +++----
> >>>  7 files changed, 52 insertions(+), 27 deletions(-)
> >>>
> >>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> >>> index 10cc4766de10..d10dc615e7a8 100644
> >>> --- a/drivers/media/media-device.c
> >>> +++ b/drivers/media/media-device.c
> >>> @@ -428,7 +428,7 @@ static long media_device_ioctl(struct file *filp,
> >>> unsigned int cmd, unsigned long arg)
> >>>  {
> >>>  	struct media_devnode *devnode = media_devnode_data(filp);
> >>> -	struct media_device *dev = to_media_device(devnode);
> >>> +	struct media_device *dev = devnode->media_dev;
> >>>  	long ret;
> >>>
> >>>  	switch (cmd) {
> >>> @@ -504,7 +504,7 @@ static long media_device_compat_ioctl(struct file *filp,
> >>> unsigned int cmd, unsigned long arg)
> >>>  {
> >>>  	struct media_devnode *devnode = media_devnode_data(filp);
> >>> -	struct media_device *dev = to_media_device(devnode);
> >>> +	struct media_device *dev = devnode->media_dev;
> >>>  	long ret;
> >>>
> >>>  	switch (cmd) {
> >>> @@ -540,7 +540,8 @@ static const struct media_file_operations
> >>> media_device_fops = { static ssize_t show_model(struct device *cd,
> >>>  			  struct device_attribute *attr, char *buf)
> >>>  {
> >>> -	struct media_device *mdev = to_media_device(to_media_devnode(cd));
> >>> +	struct media_devnode *devnode = to_media_devnode(cd);
> >>> +	struct media_device *mdev = devnode->media_dev;
> >>>
> >>>  	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
> >>>  }
> >>> @@ -718,25 +719,36 @@ EXPORT_SYMBOL_GPL(media_device_cleanup);
> >>>  int __must_check __media_device_register(struct media_device *mdev,
> >>>  					 struct module *owner)
> >>>  {
> >>> +	struct media_devnode *devnode;
> >>>  	int ret;
> >>>
> >>>  	mutex_lock(&mdev->graph_mutex);
> >>>
> >>> +	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
> >>> +	if (!devnode)
> >>> +		return -ENOMEM;
> >>> +
> >>>  	/* Register the device node. */
> >>> -	mdev->devnode.fops = &media_device_fops;
> >>> -	mdev->devnode.parent = mdev->dev;
> >>> -	mdev->devnode.release = media_device_release;
> >>> +	mdev->devnode = devnode;
> >>> +	devnode->fops = &media_device_fops;
> >>> +	devnode->parent = mdev->dev;
> >>> +	devnode->release = media_device_release;
> >>>
> >>>  	/* Set version 0 to indicate user-space that the graph is static */
> >>>  	mdev->topology_version = 0;
> >>>
> >>> -	ret = media_devnode_register(&mdev->devnode, owner);
> >>> -	if (ret < 0)
> >>> +	ret = media_devnode_register(mdev, devnode, owner);
> >>> +	if (ret < 0) {
> >>> +		mdev->devnode = NULL;
> >>> +		kfree(devnode);
> >>>  		goto err;
> >>> +	}
> >>>
> >>> -	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
> >>> +	ret = device_create_file(&devnode->dev, &dev_attr_model);
> >>>  	if (ret < 0) {
> >>> -		media_devnode_unregister(&mdev->devnode);
> >>> +		mdev->devnode = NULL;
> >>> +		media_devnode_unregister(devnode);
> >>> +		kfree(devnode);
> >>>  		goto err;
> >>>  	}
> >>>
> >>> @@ -800,9 +812,9 @@ static void __media_device_unregister(struct
> >>> media_device *mdev) }
> >>>
> >>>  	/* Check if mdev devnode was registered */
> >>> -	if (media_devnode_is_registered(&mdev->devnode)) {
> >>> -		device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> >>> -		media_devnode_unregister(&mdev->devnode);
> >>> +	if (media_devnode_is_registered(mdev->devnode)) {
> >>> +		device_remove_file(&mdev->devnode->dev, &dev_attr_model);
> >>> +		media_devnode_unregister(mdev->devnode);
> >>>  	}
> >>>
> >>>  	dev_dbg(mdev->dev, "Media device unregistered\n");
> >>> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> >>> index ae2bc0b7a368..db47063d8801 100644
> >>> --- a/drivers/media/media-devnode.c
> >>> +++ b/drivers/media/media-devnode.c
> >>> @@ -44,6 +44,7 @@
> >>>  #include <linux/uaccess.h>
> >>>
> >>>  #include <media/media-devnode.h>
> >>> +#include <media/media-device.h>
> >>>
> >>>  #define MEDIA_NUM_DEVICES	256
> >>>  #define MEDIA_NAME		"media"
> >>> @@ -74,6 +75,8 @@ static void media_devnode_release(struct device *cd)
> >>>  	/* Release media_devnode and perform other cleanups as needed. */
> >>>  	if (devnode->release)
> >>>  		devnode->release(devnode);
> >>> +
> >>> +	kfree(devnode);
> >>>  }
> >>>
> >>>  static struct bus_type media_bus_type = {
> >>> @@ -218,7 +221,8 @@ static const struct file_operations media_devnode_fops =
> >>> { .llseek = no_llseek,
> >>>  };
> >>>
> >>> -int __must_check media_devnode_register(struct media_devnode *devnode,
> >>> +int __must_check media_devnode_register(struct media_device *mdev,
> >>> +					struct media_devnode *devnode,
> >>>  					struct module *owner)
> >>>  {
> >>>  	int minor;
> >>> @@ -237,6 +241,7 @@ int __must_check media_devnode_register(struct
> >>> media_devnode *devnode, mutex_unlock(&media_devnode_lock);
> >>>
> >>>  	devnode->minor = minor;
> >>> +	devnode->media_dev = mdev;
> >>>
> >>>  	/* Part 2: Initialize and register the character device */
> >>>  	cdev_init(&devnode->cdev, &media_devnode_fops);
> >>> diff --git a/drivers/media/usb/au0828/au0828-core.c
> >>> b/drivers/media/usb/au0828/au0828-core.c index 85c13ca5178f..598a85388d77
> >>> 100644
> >>> --- a/drivers/media/usb/au0828/au0828-core.c
> >>> +++ b/drivers/media/usb/au0828/au0828-core.c
> >>> @@ -142,7 +142,7 @@ static void au0828_unregister_media_device(struct
> >>> au0828_dev *dev) struct media_device *mdev = dev->media_dev;
> >>>  	struct media_entity_notify *notify, *nextp;
> >>>
> >>> -	if (!mdev || !media_devnode_is_registered(&mdev->devnode))
> >>> +	if (!mdev || !media_devnode_is_registered(mdev->devnode))
> >>>  		return;
> >>>
> >>>  	/* Remove au0828 entity_notify callbacks */
> >>> @@ -480,7 +480,7 @@ static int au0828_media_device_register(struct
> >>> au0828_dev *dev, if (!dev->media_dev)
> >>>  		return 0;
> >>>
> >>> -	if (!media_devnode_is_registered(&dev->media_dev->devnode)) {
> >>> +	if (!media_devnode_is_registered(dev->media_dev->devnode)) {
> >>>
> >>>  		/* register media device */
> >>>  		ret = media_device_register(dev->media_dev);
> >>> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> >>> b/drivers/media/usb/uvc/uvc_driver.c index 451e84e962e2..302e284a95eb
> >>> 100644
> >>> --- a/drivers/media/usb/uvc/uvc_driver.c
> >>> +++ b/drivers/media/usb/uvc/uvc_driver.c
> >>> @@ -1674,7 +1674,7 @@ static void uvc_delete(struct uvc_device *dev)
> >>>  	if (dev->vdev.dev)
> >>>  		v4l2_device_unregister(&dev->vdev);
> >>>  #ifdef CONFIG_MEDIA_CONTROLLER
> >>> -	if (media_devnode_is_registered(&dev->mdev.devnode))
> >>> +	if (media_devnode_is_registered(dev->mdev.devnode))
> >>>  		media_device_unregister(&dev->mdev);
> >>>  	media_device_cleanup(&dev->mdev);
> >>>  #endif
> >>> diff --git a/include/media/media-device.h b/include/media/media-device.h
> >>> index e59772ed8494..b04cfa907350 100644
> >>> --- a/include/media/media-device.h
> >>> +++ b/include/media/media-device.h
> >>> @@ -347,7 +347,7 @@ struct media_entity_notify {
> >>>  struct media_device {
> >>>  	/* dev->driver_data points to this struct. */
> >>>  	struct device *dev;
> >>> -	struct media_devnode devnode;
> >>> +	struct media_devnode *devnode;
> >>>
> >>>  	char model[32];
> >>>  	char driver_name[32];
> >>> @@ -403,9 +403,6 @@ struct usb_device;
> >>>  #define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
> >>>  #define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
> >>>
> >>> -/* media_devnode to media_device */
> >>> -#define to_media_device(node) container_of(node, struct media_device,
> >>> devnode) -
> >>>  /**
> >>>   * media_entity_enum_init - Initialise an entity enumeration
> >>>   *
> >>> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> >>> index e1d5af077adb..cc2b3155593c 100644
> >>> --- a/include/media/media-devnode.h
> >>> +++ b/include/media/media-devnode.h
> >>> @@ -33,6 +33,8 @@
> >>>  #include <linux/device.h>
> >>>  #include <linux/cdev.h>
> >>>
> >>> +struct media_device;
> >>> +
> >>>  /*
> >>>   * Flag to mark the media_devnode struct as registered. Drivers must not
> >>> touch * this flag directly, it will be set and cleared by
> >>> media_devnode_register and @@ -81,6 +83,8 @@ struct media_file_operations {
> >>>   * before registering the node.
> >>>   */
> >>>  struct media_devnode {
> >>> +	struct media_device *media_dev;
> >>> +
> >>>  	/* device ops */
> >>>  	const struct media_file_operations *fops;
> >>>
> >>> @@ -103,7 +107,8 @@ struct media_devnode {
> >>>  /**
> >>>   * media_devnode_register - register a media device node
> >>>   *
> >>> - * @devnode: media device node structure we want to register
> >>> + * @media_dev: struct media_device we want to register a device node
> >>> + * @devnode: the device node to unregister
> >>>   * @owner: should be filled with %THIS_MODULE
> >>>   *
> >>>   * The registration code assigns minor numbers and registers the new device
> >>> node @@ -116,7 +121,8 @@ struct media_devnode {
> >>>   * the media_devnode structure is *not* called, so the caller is
> >>> responsible for * freeing any data.
> >>>   */
> >>> -int __must_check media_devnode_register(struct media_devnode *devnode,
> >>> +int __must_check media_devnode_register(struct media_device *mdev,
> >>> +					struct media_devnode *devnode,
> >>>  					struct module *owner);
> >>>
> >>>  /**
> >>> @@ -146,9 +152,14 @@ static inline struct media_devnode
> >>> *media_devnode_data(struct file *filp) *	false otherwise.
> >>>   *
> >>>   * @devnode: pointer to struct &media_devnode.
> >>> + *
> >>> + * Note: If mdev is NULL, it also returns false.
> >>>   */
> >>>  static inline int media_devnode_is_registered(struct media_devnode
> >>> *devnode) {
> >>> +	if (!devnode)
> >>> +		return false;
> >>> +
> >>>  	return test_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
> >>>  }
> >>>
> >>> diff --git a/sound/usb/media.c b/sound/usb/media.c
> >>> index 6db4878045e5..8fed0adec9e1 100644
> >>> --- a/sound/usb/media.c
> >>> +++ b/sound/usb/media.c
> >>> @@ -136,7 +136,7 @@ void media_snd_stream_delete(struct snd_usb_substream
> >>> *subs) struct media_device *mdev;
> >>>
> >>>  		mdev = mctl->media_dev;
> >>> -		if (mdev && media_devnode_is_registered(&mdev->devnode)) {
> >>> +		if (mdev && media_devnode_is_registered(mdev->devnode)) {
> >>>  			media_devnode_remove(mctl->intf_devnode);
> >>>  			media_device_unregister_entity(&mctl->media_entity);
> >>>  			media_entity_cleanup(&mctl->media_entity);
> >>> @@ -241,14 +241,14 @@ static void media_snd_mixer_delete(struct
> >>> snd_usb_audio *chip) if (!mixer->media_mixer_ctl)
> >>>  			continue;
> >>>
> >>> -		if (media_devnode_is_registered(&mdev->devnode)) {
> >>> +		if (media_devnode_is_registered(mdev->devnode)) {
> >>>  			media_device_unregister_entity(&mctl->media_entity);
> >>>  			media_entity_cleanup(&mctl->media_entity);
> >>>  		}
> >>>  		kfree(mctl);
> >>>  		mixer->media_mixer_ctl = NULL;
> >>>  	}
> >>> -	if (media_devnode_is_registered(&mdev->devnode))
> >>> +	if (media_devnode_is_registered(mdev->devnode))
> >>>  		media_devnode_remove(chip->ctl_intf_media_devnode);
> >>>  	chip->ctl_intf_media_devnode = NULL;
> >>>  }
> >>> @@ -268,7 +268,7 @@ int media_snd_device_create(struct snd_usb_audio *chip,
> >>>  	if (!mdev->dev)
> >>>  		media_device_usb_init(mdev, usbdev, NULL);
> >>>
> >>> -	if (!media_devnode_is_registered(&mdev->devnode)) {
> >>> +	if (!media_devnode_is_registered(mdev->devnode)) {
> >>>  		ret = media_device_register(mdev);
> >>>  		if (ret) {
> >>>  			dev_err(&usbdev->dev,    
> >>  
> > 
> >   
> 
> 


-- 
Thanks,
Mauro
