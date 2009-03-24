Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:27976 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZCXWfc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 18:35:32 -0400
MIME-Version: 1.0
In-Reply-To: <1237933535.9222.12.camel@tux.localhost>
References: <1237930711-16200-1-git-send-email-stoyboyker@gmail.com>
	 <1237933535.9222.12.camel@tux.localhost>
Date: Tue, 24 Mar 2009 17:35:30 -0500
Message-ID: <6d291e080903241535x7002f01fq9f42ce594ea8ee91@mail.gmail.com>
Subject: Re: [PATCH 12/13][Resubmit][drivers/media] changed ioctls to unlocked
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 24, 2009 at 5:25 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
> Hello, Stoyan
>
> On Tue, 2009-03-24 at 16:38 -0500, stoyboyker@gmail.com wrote:
>> From: Stoyan Gaydarov <stoyboyker@gmail.com>
>>
>> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
>> ---
>>  drivers/media/dvb/bt8xx/dst_ca.c |    7 +++++--
>>  drivers/media/video/dabusb.c     |   11 ++++++++---
>>  2 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
>> index 0258451..d3487c5 100644
>> --- a/drivers/media/dvb/bt8xx/dst_ca.c
>> +++ b/drivers/media/dvb/bt8xx/dst_ca.c
>> @@ -552,8 +552,10 @@ free_mem_and_exit:
>>       return result;
>>  }
>>
>> -static int dst_ca_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long ioctl_arg)
>> +static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioctl_arg)
>>  {
>> +     lock_kernel();
>> +
>>       struct dvb_device* dvbdev = (struct dvb_device*) file->private_data;
>>       struct dst_state* state = (struct dst_state*) dvbdev->priv;
>>       struct ca_slot_info *p_ca_slot_info;
>> @@ -647,6 +649,7 @@ static int dst_ca_ioctl(struct inode *inode, struct file *file, unsigned int cmd
>>       kfree (p_ca_slot_info);
>>       kfree (p_ca_caps);
>>
>> +     unlock_kernel();
>>       return result;
>>  }
>>
>> @@ -684,7 +687,7 @@ static ssize_t dst_ca_write(struct file *file, const char __user *buffer, size_t
>>
>>  static struct file_operations dst_ca_fops = {
>>       .owner = THIS_MODULE,
>> -     .ioctl = dst_ca_ioctl,
>> +     .unlocked_ioctl = dst_ca_ioctl,
>>       .open = dst_ca_open,
>>       .release = dst_ca_release,
>>       .read = dst_ca_read,
>> diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
>> index 298810d..c31e76f 100644
>> --- a/drivers/media/video/dabusb.c
>> +++ b/drivers/media/video/dabusb.c
>> @@ -657,22 +657,26 @@ static int dabusb_release (struct inode *inode, struct file *file)
>>       return 0;
>>  }
>>
>> -static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
>> +static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
>>  {
>>       pdabusb_t s = (pdabusb_t) file->private_data;
>>       pbulk_transfer_t pbulk;
>>       int ret = 0;
>>       int version = DABUSB_VERSION;
>>
>> +     lock_kernel();
>>       dbg("dabusb_ioctl");
>>
>> -     if (s->remove_pending)
>> +     if (s->remove_pending) {
>> +             unlock_kernel();
>>               return -EIO;
>> +     }
>>
>>       mutex_lock(&s->mutex);
>>
>>       if (!s->usbdev) {
>>               mutex_unlock(&s->mutex);
>> +             unlock_kernel();
>>               return -EIO;
>>       }
>>
>> @@ -713,6 +717,7 @@ static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cm
>>               break;
>>       }
>>       mutex_unlock(&s->mutex);
>> +     unlock_kernel();
>
> May i ask why big kernel lock is used here?
> Where is an advantage of BKL here?
> Why not to use, for example, one more mutex lock?

The big kernel lock was already being used here, the call to ioctl is
surrounded by lock/unlock kernel, this patch just pushes it down so
that the __locked__ ioctl can be removed and also makes the
maintainers of the code aware that the lock was there. If the lock is
not needed then it can be removed and the function can remain under
the unlocked_ioctl.

>
> --
> Best regards, Klimov Alexey
>
>

-- 

-Stoyan
