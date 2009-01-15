Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FBS1dX002565
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 06:28:01 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0FBRide001020
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 06:27:45 -0500
Received: by bwz13 with SMTP id 13so2936821bwz.3
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 03:27:44 -0800 (PST)
Message-ID: <d9def9db0901150327r1c22cb32r36a0e9915d06891e@mail.gmail.com>
Date: Thu, 15 Jan 2009 12:27:43 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "=?ISO-8859-1?Q?P=E1draig_Brady?=" <P@draigbrady.com>
In-Reply-To: <496F18C4.9020009@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <b24e53350901141004v6a2ed7d7nb6765fa1d112f7ef@mail.gmail.com>
	<496F18C4.9020009@draigBrady.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2.6.27.8 1/1] em28xx: Fix audio URB transfer buffer
	memory leak and race condition/corruption of capture pointer
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

On Thu, Jan 15, 2009 at 12:06 PM, Pádraig Brady <P@draigbrady.com> wrote:
> Robert Krakora wrote:
>> em28xx: Fix audio URB transfer buffer memory leak and race
>> condition/corruption of capture pointer
>>
>>
>> Signed-off-by: Robert V. Krakora <rob.krakora@messagenetsystems.com>
>>
>> diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx-audio.c
>> --- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
>> 10:06:12 2009 -0200
>> +++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
>> 12:47:00 2009 -0500
>> @@ -62,11 +62,20 @@
>>         int i;
>>
>>         dprintk("Stopping isoc\n");
>> -       for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
>> -               usb_unlink_urb(dev->adev.urb[i]);
>> -               usb_free_urb(dev->adev.urb[i]);
>> -               dev->adev.urb[i] = NULL;
>> -       }
>> +        for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
>> +               usb_unlink_urb(dev->adev.urb[i]);
>> +               usb_free_urb(dev->adev.urb[i]);
>> +               dev->adev.urb[i] = NULL;
>> +               if (dev->adev.urb[i]) {
>> +                       usb_unlink_urb(dev->adev.urb[i]);
>> +                       usb_free_urb(dev->adev.urb[i]);
>> +                       dev->adev.urb[i] = NULL;
>> +               }
>> +                if (dev->adev.transfer_buffer) {
>> +                       kfree(dev->adev.transfer_buffer[i]);
>> +                       dev->adev.transfer_buffer[i] = NULL;
>> +               }
>> +        }
>>
>>         return 0;
>>  }
>
> That looks a bit incorrect. I fixed this last week in Markus'
> repository, as I thought the leak was specific to that tree:
> http://mcentral.de/hg/~mrec/em28xx-new/diff/1cfd9010a552/em28xx-audio.c
>

The audio implementation was initially taken from my tree, so all the
initial bugs
of course are inherited too there of course.

regards,
Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
