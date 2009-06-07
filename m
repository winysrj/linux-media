Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f181.google.com ([209.85.216.181]:41621 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZFGBWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 21:22:03 -0400
Received: by pxi11 with SMTP id 11so270063pxi.33
        for <linux-media@vger.kernel.org>; Sat, 06 Jun 2009 18:22:04 -0700 (PDT)
Subject: Re: [PATCH]videobuf-core.c: add pointer check
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <1244337379.3355.1.camel@myhost>
References: <1244337379.3355.1.camel@myhost>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 09:21:29 +0800
Message-Id: <1244337689.3355.6.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-06-07 at 09:16 +0800, Figo.zhang wrote:
> On Wed, 2009-06-03 at 10:01 +0800, Figo.zhang wrote:
> > add poiter check for videobuf_queue_core_init().
> > 
> > any guys who write a v4l driver, pass a NULL pointer or a non-inintial
> > pointer to the first parameter such as videobuf_queue_sg_init() , it 
> > would be crashed.
> > 
> > Signed-off-by: Figo.zhang <figo1802@xxxxxxxxx>
> > --- 
> > drivers/media/video/videobuf-core.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
> > index b7b0584..5f41fd9 100644
> > --- a/drivers/media/video/videobuf-core.c
> > +++ b/drivers/media/video/videobuf-core.c
> > @@ -118,6 +118,7 @@ void videobuf_queue_core_init(struct videobuf_queue *q,
> >  			 void *priv,
> >  			 struct videobuf_qtype_ops *int_ops)
> >  {
> > +	BUG_ON(!q);
> >  	memset(q, 0, sizeof(*q));
> >  	q->irqlock   = irqlock;
> >  	q->dev       = dev;
> > 
> 
> i do a test driver for it, the main code like this.
> 
> struct mydev_dev{
> 	struct video_device *video_dev;
> 	...
> 	struct videobuf_queue      *cap;
> };
> 
> 
> 
> static int video_open(struct inode *inode, struct file *file)
> {
> 	...
> 	videobuf_queue_dma_contig_init(dev->cap, &video_qops,
> 				&dev->pci->dev, &dev->slock,
> 				V4L2_BUF_TYPE_VIDEO_CAPTURE,
> 				V4L2_FIELD_ALTERNATE,
> 				sizeof(struct mydev_buf),
> 				dev);
> 
> 	...
> }
> 
> i pass a non-initial pointer for the first argment, so it crashed.
> 
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<f8d6bd67>] :videobuf_core:videobuf_queue_core_init+0x1b/0xbf
> *pde = 7ed5a067 
> Oops: 0002 [#1] SMP 
> Modules linked in: mydev_drv tvp5160_vd videobuf_dma_contig videobuf_dma_sg
>  videobuf_core videocodec videodev v4l2_int_device v4l2_common v4l1_compat
>  compat_ioctl32 fuse i915 drm sco bridge stp bnep l2cap bluetooth sunrpc ipv6
> cpufreq_ondemand acpi_cpufreq dm_multipath uinput snd_hda_intel snd_seq_dummy 
> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ppdev snd_pcm_oss parport_pc
>  snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_hwdep parport snd i2c_i801 
> i2c_core pcspkr soundcore iTCO_wdt iTCO_vendor_support r8169 mii ftdi_sio usbserial
>  ata_generic pata_acpi [last unloaded: microcode]
> 
> Pid: 4053, comm: capture Not tainted (2.6.27.5-117.fc10.i686 #1)
> EIP: 0060:[<f8d6bd67>] EFLAGS: 00210246 CPU: 1
> EIP is at videobuf_queue_core_init+0x1b/0xbf [videobuf_core]
> EAX: 00000000 EBX: 00000000 ECX: 00000036 EDX: 00000036
> ESI: f8e1e158 EDI: 00000000 EBP: f15f3e28 ESP: f15f3e18
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process capture (pid: 4053, ti=f15f3000 task=f1550000 task.ti=f15f3000)
> Stack: f790905c f5fd5224 f15d8840 f5811560 f15f3e48 f8e01163 f5fd5224 00000001 
>        00000007 0000006c f5fd5200 f8e0202c f15f3e70 f8e1b5a0 f5fd5224 00000001 
>        00000007 0000006c f5fd5200 f8e0faa4 00000000 f15d8840 f15f3e88 f8e0c195 
> Call Trace:
>  [<f8e01163>] ? videobuf_queue_dma_contig_init+0x1c/0x21 [videobuf_dma_contig]
>  [<f8e1b5a0>] ? video_open+0x8b/0xb1 [kt2741drv]
>  [<f8e0c195>] ? video_open+0xc7/0x125 [videodev]
>  [<c0492767>] ? chrdev_open+0x12b/0x142
>  [<c048edd2>] ? __dentry_open+0x10e/0x1fc
>  [<c048ef47>] ? nameidata_to_filp+0x1f/0x33
>  [<c049263c>] ? chrdev_open+0x0/0x142
>  [<c0498a3c>] ? do_filp_open+0x31c/0x611
>  [<c048a971>] ? virt_to_head_page+0x22/0x2e
>  [<c041d8ba>] ? need_resched+0x18/0x22
>  [<c048ebf0>] ? do_sys_open+0x42/0xb7
>  [<c048eca7>] ? sys_open+0x1e/0x26
>  [<c0403c76>] ? syscall_call+0x7/0xb
>  [<c06a007b>] ? init_intel_cacheinfo+0x0/0x421
>  =======================
> Code: d8 e8 69 ff ff ff 89 d8 e8 6d a9 93 c7 5b 5d c3 55 89 e5 57 89 c7 56 89
>  d6 53 ba 36 00 00 00 83 ec 04 89 c3 89 4d f0 31 c0 89 d1 <f3> ab 8b 45 08 8b
>  4d f0 89 b3 b8 00 00 00 89 43 10 8b 45 0c 89 
> EIP: [<f8d6bd67>] videobuf_queue_core_init+0x1b/0xbf [videobuf_core] SS:ESP 0068:f15f3e18
> ---[ end trace 4bfe52d17b82af8c ]---
> 
> so i think it need to add pointer checking for the first argment of videobuf_queue_core_init(),
> the videobuf code would be more stronger and reliable.
> 

hi, Mauro & Hans,

at this point, would you agree with me or would you like to give me some
advice?

Best Regards,

Figo.zhang

