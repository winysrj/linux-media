Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9M9pxE025061
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 17:09:51 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9M9ZoU002214
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 17:09:35 -0500
Date: Tue, 9 Dec 2008 17:08:58 -0500
From: Jim Paris <jim@jtan.com>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20081209220858.GA25496@psychosis.jim.sh>
References: <20081209215837.GA24743@psychosis.jim.sh> <493EEA59.2040406@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493EEA59.2040406@hhs.nl>
Cc: video4linux-list@redhat.com
Subject: Re: gspca: fix vidioc_s_jpegcomp locking
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hans de Goede wrote:
> Jim Paris wrote:
>> This locking looked wrong.
>>
>
> Hi,
>
> I appreciate the effort, but please do not send patches just because 
> something looks wrong. The original code is perfectly fine. It check if 
> the sub driver supports set_jcomp at all, this check does not need 
> locking.

Well, the patch was a request for comments.  But please double-check.
In the current code, if set_jcomp is NULL, the lock is taken but never
released.

I agree that the check does not need locking, which is why my change
moved the check outside the lock.

-jim

>> gspca: fix vidioc_s_jpegcomp locking
>>
>> Signed-off-by: Jim Paris <jim@jtan.com>
>>
>> diff -r b50857fea6df linux/drivers/media/video/gspca/gspca.c
>> --- a/linux/drivers/media/video/gspca/gspca.c	Tue Dec 09 16:20:31 2008 -0500
>> +++ b/linux/drivers/media/video/gspca/gspca.c	Tue Dec 09 16:55:39 2008 -0500
>> @@ -1320,10 +1320,10 @@
>>  	struct gspca_dev *gspca_dev = priv;
>>  	int ret;
>> +	if (!gspca_dev->sd_desc->set_jcomp)
>> +		return -EINVAL;
>>  	if (mutex_lock_interruptible(&gspca_dev->usb_lock))
>>  		return -ERESTARTSYS;
>> -	if (!gspca_dev->sd_desc->set_jcomp)
>> -		return -EINVAL;
>>  	ret = gspca_dev->sd_desc->set_jcomp(gspca_dev, jpegcomp);
>>  	mutex_unlock(&gspca_dev->usb_lock);
>>  	return ret;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
