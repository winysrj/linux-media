Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38597 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2DQNac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 09:30:32 -0400
Received: by wibhq7 with SMTP id hq7so655593wib.1
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2012 06:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F6DDB10.8000503@redhat.com>
References: <CAL9G6WXZLdJqpivn2qNXb+oP9o4n=uyq6ywiRrzP13vmUYvaxw@mail.gmail.com>
	<4F6DDB10.8000503@redhat.com>
Date: Tue, 17 Apr 2012 15:30:29 +0200
Message-ID: <CAL9G6WUNp1gHibG74L8VXyJ0KPDYY+amKy3JZ7MBkjB8DBwERA@mail.gmail.com>
Subject: Re: dvb lock patch
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/24 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Em 04-03-2012 17:49, Josu Lazkano escreveu:
>> Hello all, I am using this patch to get virtual adapters for DVB
>> devices: https://aur.archlinux.org/packages/sa/sascng-linux3-patch/sascng-linux3-patch.tar.gz
>>
>> Here is more info: https://aur.archlinux.org/packages.php?ID=51325
>>
>> Is it possible to add this patch on the dvb source?
>>
>> This patch is needed for people who not have a CI and need to create
>> virtual adapters to get a working pay-tv system.
>
> Please always send the diff, instead to a point to some tarball, otherwise
> most developers won't care enough to see what's there.
>
> Anyway:
>
>> diff -Nur linux-2.6.39/drivers/media/dvb/dvb-core/dvbdev.c linux-2.6.39/drivers/media/dvb/dvb-core/dvbdev.c
>> --- linux-2.6.39/drivers/media/dvb/dvb-core/dvbdev.c
>> +++ linux-2.6.39/drivers/media/dvb/dvb-core/dvbdev.c
>> @@ -83,8 +83,11 @@ static int dvb_device_open(struct inode *inode, struct file *file)
>>                       file->f_op = old_fops;
>>                       goto fail;
>>               }
>> -             if(file->f_op->open)
>> +             if(file->f_op->open) {
>> +                     mutex_unlock(&dvbdev_mutex);
>>                       err = file->f_op->open(inode,file);
>> +                     mutex_lock(&dvbdev_mutex);
>> +             }
>>               if (err) {
>>                       fops_put(file->f_op);
>>                       file->f_op = fops_get(old_fops);
>> --
>>
>
> That doesn't sound right to me, and can actually cause race issues.
>
> Regards,
> Mauro.

Thanks for the patch Mauro.

Regards.

-- 
Josu Lazkano
