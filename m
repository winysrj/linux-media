Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4MDebV8023697
	for <video4linux-list@redhat.com>; Fri, 22 May 2009 09:40:37 -0400
Received: from mail-px0-f126.google.com (mail-px0-f126.google.com
	[209.85.216.126])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n4MDeKGc009953
	for <video4linux-list@redhat.com>; Fri, 22 May 2009 09:40:20 -0400
Received: by pxi32 with SMTP id 32so1497086pxi.23
	for <video4linux-list@redhat.com>; Fri, 22 May 2009 06:40:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b90a809a0905220050k6f64321g7f72adee3f1e21c3@mail.gmail.com>
References: <b90a809a0905220050k6f64321g7f72adee3f1e21c3@mail.gmail.com>
Date: Fri, 22 May 2009 09:40:11 -0400
Message-ID: <829197380905220640k5b19e190y6382f969fc823e37@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-2022-JP?B?GyRCN0pKOE5TGyhC?= <wenlinjing@gmail.com>
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

On Fri, May 22, 2009 at 3:50 AM, 景文林 <wenlinjing@gmail.com> wrote:
> Hi,
>
> I am working with a video capture chip TVP5150. I want to adjust the
> "Brightness" "Contrast" "Saturation" and "hue" in user space.
> In TVP5150 drivers ,the V4l2 commands are in function tvp5150_command.And
> this function is a member of struct i2c_device.
>
> The linux is 2.6.19.2.
> I write my code according kernel document  Documentation/i2c/dev-interface
> But I can`t access tvp5150_command.
> How can i acces i2c_device .command  function from user space?

I thought those controls were already implemented in the tvp5150
driver, although I could be mistaken (I would have to look at the
code).  If not, it would probably be much easier to just add the
commands to the driver than to attempt to program the chip from
userland (the datasheet for the tvp5150 is freely available).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
