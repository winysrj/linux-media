Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4N6V26g002545
	for <video4linux-list@redhat.com>; Sat, 23 May 2009 02:31:02 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n4N6UkGk003867
	for <video4linux-list@redhat.com>; Sat, 23 May 2009 02:30:46 -0400
Received: by wf-out-1314.google.com with SMTP id 28so716602wfa.6
	for <video4linux-list@redhat.com>; Fri, 22 May 2009 23:30:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380905220640k5b19e190y6382f969fc823e37@mail.gmail.com>
References: <b90a809a0905220050k6f64321g7f72adee3f1e21c3@mail.gmail.com>
	<829197380905220640k5b19e190y6382f969fc823e37@mail.gmail.com>
Date: Sat, 23 May 2009 15:30:46 +0900
Message-ID: <5e9665e10905222330i4fa563dt7e0eb444cacc5f0a@mail.gmail.com>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: How to acces TVP5150 .command function from userspace
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

Actually those controls should be supported by VIDIOC_S_CTRL but not
sure on 2.6.19.
I took a snapshot of 2.6.19 kernel from git but couldn't find any of
v4l2_ioctl_ops in tvp5150. Possibly not have been using v4l2_ioctl_ops
in that time I guess (not sure)
Anyway, controls that william is trying to use should be controled via
VIDIOC_S_CTRL with CID and as far as I checked in 2.6.19, it already
had those CIDs. So, it could be worth to give a shot with
VIDIOC_S_CTRL.
Cheers,

Nate

2009/5/22 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Fri, May 22, 2009 at 3:50 AM, 景文林 <wenlinjing@gmail.com> wrote:
>> Hi,
>>
>> I am working with a video capture chip TVP5150. I want to adjust the
>> "Brightness" "Contrast" "Saturation" and "hue" in user space.
>> In TVP5150 drivers ,the V4l2 commands are in function tvp5150_command.And
>> this function is a member of struct i2c_device.
>>
>> The linux is 2.6.19.2.
>> I write my code according kernel document  Documentation/i2c/dev-interface
>> But I can`t access tvp5150_command.
>> How can i acces i2c_device .command  function from user space?
>
> I thought those controls were already implemented in the tvp5150
> driver, although I could be mistaken (I would have to look at the
> code).  If not, it would probably be much easier to just add the
> commands to the driver than to attempt to program the chip from
> userland (the datasheet for the tvp5150 is freely available).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
