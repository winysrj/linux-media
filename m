Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:14995 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZEVIkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 04:40:40 -0400
Received: by wf-out-1314.google.com with SMTP id 26so570775wfd.4
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 01:40:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b90a809a0905220050k6f64321g7f72adee3f1e21c3@mail.gmail.com>
References: <b90a809a0905220050k6f64321g7f72adee3f1e21c3@mail.gmail.com>
Date: Fri, 22 May 2009 17:40:41 +0900
Message-ID: <5e9665e10905220140r1341f2die6ccb9df6e848eed@mail.gmail.com>
Subject: Re: How to acces TVP5150 .command function from userspace
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: =?ISO-2022-JP?B?GyRCN0pKOE5TGyhC?= <wenlinjing@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello William,

First of all, the video4linux-list has been moved to linux-media list
at vger.kernel.org. The exact list address is
linux-media@vger.kernel.org and you can find other lists on
http://vger.kernel.org. I removed the old list from CC and added the
new list instead. I hope you don't mind.

And about TVP5150 thing, I have been developing in similar way few
years ago but in my case, I had a controller device which was
video4linux device and took care of v4l2 ioctls in that controller and
send command to i2c client. But in case of TVP5150, I can't figure it
out which device could be that kind of controller device acting v4l2
device. I'm sorry about that and hope someone else (I think Mauro can)
can answer this.
Cheers,

Nate

On Fri, May 22, 2009 at 4:50 PM, 景文林 <wenlinjing@gmail.com> wrote:
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
>
>
> william.jing
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
