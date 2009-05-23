Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4NFQlt5018845
	for <video4linux-list@redhat.com>; Sat, 23 May 2009 11:26:47 -0400
Received: from mail-fx0-f214.google.com (mail-fx0-f214.google.com
	[209.85.220.214])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n4NFQYSN026636
	for <video4linux-list@redhat.com>; Sat, 23 May 2009 11:26:34 -0400
Received: by fxm10 with SMTP id 10so2246528fxm.3
	for <video4linux-list@redhat.com>; Sat, 23 May 2009 08:26:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380905220640k5b19e190y6382f969fc823e37@mail.gmail.com>
References: <b90a809a0905220050k6f64321g7f72adee3f1e21c3@mail.gmail.com>
	<829197380905220640k5b19e190y6382f969fc823e37@mail.gmail.com>
Date: Sat, 23 May 2009 17:26:33 +0200
Message-ID: <d9def9db0905230826t6338ff00ye7db7c2eb2a62695@mail.gmail.com>
From: Markus Rechberger <mrechberger@gmail.com>
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

those are definitely implemented, I remember there was a problem with
a too dark videopicture years ago and it was a bug in the tvp5150...

Also by looking at it:
V4L2_CID_BRIGHTNESS
V4L2_CID_CONTRAST
V4L2_CID_SATURATION
V4L2_CID_HUE

are supported.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
