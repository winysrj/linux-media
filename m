Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FEoeFH022031
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 09:50:40 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0FEnOCj024302
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 09:49:24 -0500
Received: by ewy14 with SMTP id 14so1254894ewy.3
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 06:49:23 -0800 (PST)
Message-ID: <b24e53350901150649w700d6619g47cf2a37272466e6@mail.gmail.com>
Date: Thu, 15 Jan 2009 09:49:23 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: "Markus Rechberger" <mrechberger@gmail.com>
In-Reply-To: <d9def9db0901150327r1c22cb32r36a0e9915d06891e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <b24e53350901141004v6a2ed7d7nb6765fa1d112f7ef@mail.gmail.com>
	<496F18C4.9020009@draigBrady.com>
	<d9def9db0901150327r1c22cb32r36a0e9915d06891e@mail.gmail.com>
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

On Thu, Jan 15, 2009 at 6:27 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Thu, Jan 15, 2009 at 12:06 PM, Pádraig Brady <P@draigbrady.com> wrote:
>> Robert Krakora wrote:
>>> em28xx: Fix audio URB transfer buffer memory leak and race
>>> condition/corruption of capture pointer
>>>
>>>
>>> Signed-off-by: Robert V. Krakora <rob.krakora@messagenetsystems.com>
>>>
>>> diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx-audio.c
>>> --- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
>>> 10:06:12 2009 -0200
>>> +++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
>>> 12:47:00 2009 -0500
>>> @@ -62,11 +62,20 @@
>>>         int i;
>>>
>>>         dprintk("Stopping isoc\n");
>>> -       for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
>>> -               usb_unlink_urb(dev->adev.urb[i]);
>>> -               usb_free_urb(dev->adev.urb[i]);
>>> -               dev->adev.urb[i] = NULL;
>>> -       }
>>> +        for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
>>> +               usb_unlink_urb(dev->adev.urb[i]);
>>> +               usb_free_urb(dev->adev.urb[i]);
>>> +               dev->adev.urb[i] = NULL;
>>> +               if (dev->adev.urb[i]) {
>>> +                       usb_unlink_urb(dev->adev.urb[i]);
>>> +                       usb_free_urb(dev->adev.urb[i]);
>>> +                       dev->adev.urb[i] = NULL;
>>> +               }
>>> +                if (dev->adev.transfer_buffer) {
>>> +                       kfree(dev->adev.transfer_buffer[i]);
>>> +                       dev->adev.transfer_buffer[i] = NULL;
>>> +               }
>>> +        }
>>>
>>>         return 0;
>>>  }
>>
>> That looks a bit incorrect. I fixed this last week in Markus'
>> repository, as I thought the leak was specific to that tree:
>> http://mcentral.de/hg/~mrec/em28xx-new/diff/1cfd9010a552/em28xx-audio.c
>>
>
> The audio implementation was initially taken from my tree, so all the
> initial bugs
> of course are inherited too there of course.
>
> regards,
> Markus
>
>

Guys:

I will look at Markus' tree first to see if a potential em28xx fix has
already been done.  Yes, my first patch had a double free problem.  I
fixed last night but did not resubmit until this morning.  I would
have probably forgotten if it were not for Padraig's e-mail.  I am
sorry if I stepped on anyone's toes.

Best Regards,

-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
