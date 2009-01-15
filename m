Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0FFWY0R021688
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 10:32:34 -0500
Received: from mail-ew0-f21.google.com (mail-ew0-f21.google.com
	[209.85.219.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0FFWHEO014923
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 10:32:17 -0500
Received: by ewy14 with SMTP id 14so1279899ewy.3
	for <video4linux-list@redhat.com>; Thu, 15 Jan 2009 07:32:16 -0800 (PST)
Message-ID: <b24e53350901150732m2c0298a5wb90b75f0665e1ff7@mail.gmail.com>
Date: Thu, 15 Jan 2009 10:32:16 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: "=?ISO-8859-1?Q?P=E1draig_Brady?=" <P@draigbrady.com>
In-Reply-To: <496F4F1B.1050706@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <b24e53350901141004v6a2ed7d7nb6765fa1d112f7ef@mail.gmail.com>
	<496F18C4.9020009@draigBrady.com>
	<b24e53350901150632u2f031fcm3c6f34b6b0e81100@mail.gmail.com>
	<496F4F1B.1050706@draigBrady.com>
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

On Thu, Jan 15, 2009 at 9:58 AM, Pádraig Brady <P@draigbrady.com> wrote:
> Robert Krakora wrote:
>> On Thu, Jan 15, 2009 at 6:06 AM, Pádraig Brady <P@draigbrady.com> wrote:
>>> Robert Krakora wrote:
>>>> em28xx: Fix audio URB transfer buffer memory leak and race
>>>> condition/corruption of capture pointer
>>>>
>>>>
>>>> Signed-off-by: Robert V. Krakora <rob.krakora@messagenetsystems.com>
>>>>
>>>> diff -r 6896782d783d linux/drivers/media/video/em28xx/em28xx-audio.c
>>>> --- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
>>>> 10:06:12 2009 -0200
>>>> +++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Wed Jan 14
>>>> 12:47:00 2009 -0500
>>>> @@ -62,11 +62,20 @@
>>>>         int i;
>>>>
>>>>         dprintk("Stopping isoc\n");
>>>> -       for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
>>>> -               usb_unlink_urb(dev->adev.urb[i]);
>>>> -               usb_free_urb(dev->adev.urb[i]);
>>>> -               dev->adev.urb[i] = NULL;
>>>> -       }
>>>> +        for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
>>>> +               usb_unlink_urb(dev->adev.urb[i]);
>>>> +               usb_free_urb(dev->adev.urb[i]);
>>>> +               dev->adev.urb[i] = NULL;
>>>> +               if (dev->adev.urb[i]) {
>>>> +                       usb_unlink_urb(dev->adev.urb[i]);
>>>> +                       usb_free_urb(dev->adev.urb[i]);
>>>> +                       dev->adev.urb[i] = NULL;
>>>> +               }
>>>> +                if (dev->adev.transfer_buffer) {
>>>> +                       kfree(dev->adev.transfer_buffer[i]);
>>>> +                       dev->adev.transfer_buffer[i] = NULL;
>>>> +               }
>>>> +        }
>>>>
>>>>         return 0;
>>>>  }
>>> That looks a bit incorrect. I fixed this last week in Markus'
>>> repository, as I thought the leak was specific to that tree:
>>> http://mcentral.de/hg/~mrec/em28xx-new/diff/1cfd9010a552/em28xx-audio.c
>>>
>>
>> I fail to see what looks incorrect about testing for NULL pointers
>> before freeing.
>
> That's redundant/inefficient. kfree(NULL) is fine.
>
>> I did have a bug where I left the index number off of
>> the transfer buffer array which Devin kindly pointed out yesterday.
>
> I was referring to that yes.
>
> I was also referring to the fact you have 2 calls to free the URBs.
>
> I suggest you just do what I did in my patch.
> I've tested it well. Without it I was leaking 48KiB
> every time VLC changed channel.
>
> cheers,
> Pádraig.
>
>

Padraig:

Cool.  I did not know that kfree(NULL) was O.K.  Your patch looks like
the way to go then.  I noticed the same memory leak on channel
changes.  I will edit my patch then to remove that section.  Is this
the correct thing to do?  Thanks for all of your help.

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
