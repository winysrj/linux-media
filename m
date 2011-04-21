Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44866 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1DUIUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 04:20:37 -0400
Received: by qwk3 with SMTP id 3so731418qwk.19
        for <linux-media@vger.kernel.org>; Thu, 21 Apr 2011 01:20:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110421075947.GA8178@minime.bse>
References: <1303355862-17507-1-git-send-email-lliubbo@gmail.com>
	<20110421075947.GA8178@minime.bse>
Date: Thu, 21 Apr 2011 16:20:36 +0800
Message-ID: <BANLkTimHX8aYoeSU1ES0Tw0Swaz9xYLt=Q@mail.gmail.com>
Subject: Re: [PATCH v3] media:uvc_driver: add uvc support on no-mmu arch
From: Bob Liu <lliubbo@gmail.com>
To: Bob Liu <lliubbo@gmail.com>, linux-media@vger.kernel.org,
	dhowells@redhat.com, linux-uvc-devel@lists.berlios.de,
	mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
	jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
	agust@denx.de, gregkh@suse.de, vapier@gentoo.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Apr 21, 2011 at 3:59 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> Hi Bob,
>
> On Thu, Apr 21, 2011 at 11:17:42AM +0800, Bob Liu wrote:
>> +#ifdef CONFIG_MMU
>>       if (i == queue->count || size != queue->buf_size) {
>> +#else
>> +     if (i == queue->count || PAGE_ALIGN(size) != queue->buf_size) {
>> +#endif
>
> on mmu systems do_mmap_pgoff contains a len = PAGE_ALIGN(len); line.
> If we depend on this behavior, why not do it here as well and get rid
> of the #ifdef?
>

If do it in do_mmap_pgoff() the whole system will be effected, I am
not sure whether
it's correct and needed for other subsystem.

>> +unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
>> +             unsigned long addr, unsigned long len, unsigned long pgoff)
>> +{
>> +     struct uvc_buffer *buffer;
>> +     unsigned int i;
>> +     int ret = 0;
>
> You still didn't change ret to unsigned long.
>

Oh, Sorry. My fault.

>> +     addr = (unsigned long)queue->mem + buffer->buf.m.offset;
>> +     ret = addr;
>
> Why the intermediate step using addr?
>

If don't return addr, do_mmap_pgoff() will return failure and we can't
setup vma correctly.
See mm/nommu.c line 1386(add = file->f_op->get_unmmapped_area() ).

>> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
>> index 498e674..221e73f 100644
>> --- a/drivers/media/video/v4l2-dev.c
>> +++ b/drivers/media/video/v4l2-dev.c
>> @@ -368,6 +368,23 @@ static int v4l2_mmap(struct file *filp, struct vm_area_struct *vm)
>>       return ret;
>>  }
>>
>> +#ifdef CONFIG_MMU
>> +#define v4l2_get_unmapped_area NULL
>> +#else
>> +static unsigned long v4l2_get_unmapped_area(struct file *filp,
>> +             unsigned long addr, unsigned long len, unsigned long pgoff,
>> +             unsigned long flags)
>> +{
>> +     struct video_device *vdev = video_devdata(filp);
>> +
>> +     if (!vdev->fops->get_unmapped_area)
>> +             return -ENOSYS;
>> +     if (!video_is_registered(vdev))
>> +             return -ENODEV;
>> +     return vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
>> +}
>> +#endif
>> +
>>  /* Override for the open function */
>>  static int v4l2_open(struct inode *inode, struct file *filp)
>>  {
>> @@ -452,6 +469,7 @@ static const struct file_operations v4l2_fops = {
>>       .write = v4l2_write,
>>       .open = v4l2_open,
>>       .mmap = v4l2_mmap,
>> +     .get_unmapped_area = v4l2_get_unmapped_area,
>>       .unlocked_ioctl = v4l2_ioctl,
>>  #ifdef CONFIG_COMPAT
>>       .compat_ioctl = v4l2_compat_ioctl32,
>> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
>> index 8266d5a..0616a43 100644
>> --- a/include/media/v4l2-dev.h
>> +++ b/include/media/v4l2-dev.h
>> @@ -63,6 +63,8 @@ struct v4l2_file_operations {
>>       long (*ioctl) (struct file *, unsigned int, unsigned long);
>>       long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>>       int (*mmap) (struct file *, struct vm_area_struct *);
>> +     unsigned long (*get_unmapped_area) (struct file *, unsigned long,
>> +                     unsigned long, unsigned long, unsigned long);
>>       int (*open) (struct file *);
>>       int (*release) (struct file *);
>>  };
>
> I'd prefer a git revert c29fcff3daafbf46d64a543c1950bbd206ad8c1c for
> this block instead of reverting it together with the UVC changes.
>

Okay, I will confirm that and do it.

Thanks a lot for your review.

-- 
Regards,
--Bob
