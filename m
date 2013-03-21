Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43324 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3CURnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 13:43:51 -0400
Received: by mail-ee0-f47.google.com with SMTP id e52so1843945eek.6
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 10:43:50 -0700 (PDT)
Message-ID: <514B470C.6040707@googlemail.com>
Date: Thu, 21 Mar 2013 18:44:44 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 09/10] bttv: fix mute on last close of the video device
 node
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-10-git-send-email-fschaefer.oss@googlemail.com> <201303211156.00584.hverkuil@xs4all.nl>
In-Reply-To: <201303211156.00584.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.03.2013 11:56, schrieb Hans Verkuil:
> On Wed 20 March 2013 20:24:49 Frank Schäfer wrote:
>> Instead of applying the current mute setting on last device node close, always
>> mute the device.
> I am very pleased with the preceding 8 patches. That does exactly what I had
> in mind. For this patch and the next (I would have combined those two into one
> patch BTW) I want to do some testing first. Unfortunately due to travel I will
> not have access to bttv hardware for the next 10 days or so.

No problem, I don't think this is high priority stuff. ;)

> One thing I am considering is adding some basic tuner-ownership functionality
> to the v4l2 core. Without that I don't think we can ever get this working as
> it should.

Sounds good !

> It might be an idea to make a pull request for the first 8 patches some time
> next week. That's all good stuff and it makes the code much easier to
> understand.

Ok, I will resend the first 8 patches witch you ACK added and RFC removed.
Please drop me a message when you have tested the last two patches and
want me to take further actions.

Thanks for reviewing !

Regards,
Frank

> Regards,
>
> 	Hans
>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/pci/bt8xx/bttv-driver.c |    2 +-
>>  1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)
>>
>> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
>> index 2fb2168..469ea06 100644
>> --- a/drivers/media/pci/bt8xx/bttv-driver.c
>> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
>> @@ -3126,7 +3126,7 @@ static int bttv_release(struct file *file)
>>  	bttv_field_count(btv);
>>  
>>  	if (!btv->users)
>> -		audio_mute(btv, btv->mute);
>> +		audio_mute(btv, 1);
>>  
>>  	v4l2_fh_del(&fh->fh);
>>  	v4l2_fh_exit(&fh->fh);
>>

