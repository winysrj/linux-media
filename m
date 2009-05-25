Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:47089 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZEYCG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 22:06:58 -0400
Received: by pzk7 with SMTP id 7so2269121pzk.33
        for <linux-media@vger.kernel.org>; Sun, 24 May 2009 19:06:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243215101.6402.12.camel@xie>
References: <20090523160013.909D88E03A1@hormel.redhat.com>
	 <1243215101.6402.12.camel@xie>
Date: Mon, 25 May 2009 11:06:59 +0900
Message-ID: <5e9665e10905241906y1e1f159akfb43f556a36cc27a@mail.gmail.com>
Subject: Re: about taking picture
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: xie <yili.xie@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	=?EUC-KR?B?sejH/MHYILHo?= <riverful.kim@samsung.com>,
	"dongsoo45.kim@samsung.com" <dongsoo45.kim@samsung.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Xie,

As far as I know, this list on redhat.com has been moved to
linux-media@vger.kernel.org.
I removed and CCed the new list instead of video4linux-list and I hope
you to don't mind.

What you asked was about taking picture with camera device, and I
should say that there could be few different ways depending on H/W
features or S/W concepts.

Actually I've been facing similar issue and tried to figure out the
better way in taking camera snapshots. You can find my RFC at
following archive :
http://www.spinics.net/lists/linux-media/msg05013.html

I have no idea about what kind of camera module you are using, I mean
how big resolution, how many colorspaces it supports kind of things.

To go easier  we can sort it out with H/W features like whether the
camera module supports JPEG capture or not. (in that case, you can
take a look at my earlier RFC that I mentioned above about capturing
JPEG). So, if your H/W is supporting JPEG capture, you have to stop
previewing and change your camera module into JPEG capture mode, and
sync data with your camera interface and copy to user space.

But, if your camera module is not supporting that cool JPEG capturing
feature, you have to think about and establish your baseline about the
resolutions. Let me take an example of taking picture without a JPEG
capturing features.

CASE 1: Preview resolution and expecting captured image's resolution
doesn't differ
It means that you are running preview image with 640*480 (or
whatever..I'm just assuming) and take snapshot also with 640*480.
In this case you don't even need to stop previewing. just take the
image frame you want and encode with you S/W encoder or just leave it
with RAW format and save as a file.

CASE 2: Preview resolution and expecting captured image resolution are
different.
This is totally more complicated than CASE 1. Apparently, you should
stop previewing before taking snapshot. Because your camera interface
H/W should be reset to sync the upcoming image frame with other
resolution. Of course you can do that without reset in some H/W but
the  received image in the switching resolution moment can be ugly
with noise or distorted image.
So, If you are taking picture bigger than preview Image, you should
better stop previewing with VIDIOC_STREAMOFF and try VIDIOC_S_FMT with
new resolution and start capturing with VIDIOC_STREAMON.
I'm not sure about this kind of order is recommended in V4L2
specification, but it comes from my experience.

I hope it is the answer you expected.
Cheers,

Nate



On Mon, May 25, 2009 at 10:31 AM, xie <yili.xie@gmail.com> wrote:
> Dear all ~
>     I have to implement the hal in Android with v4l2. Now i use one
> thread to preview , i just use V4L2 capture interface to implement the
> preview. Now i have one confusion :
>     I think i can implement the taking picture just copy the preview
> frame , and  am i right ? I want to use another thread to take picture ,
> when I am taking picture ,whether I have to stop the previewing ?
>     Thanks a lot ~!~
>
>
> 在 2009-05-23六的 12:00 -0400，video4linux-list-request@redhat.com写道：
>> Send video4linux-list mailing list submissions to
>>       video4linux-list@redhat.com
>>
>> To subscribe or unsubscribe via the World Wide Web, visit
>>       https://www.redhat.com/mailman/listinfo/video4linux-list
>> or, via email, send a message with subject or body 'help' to
>>       video4linux-list-request@redhat.com
>>
>> You can reach the person managing the list at
>>       video4linux-list-owner@redhat.com
>>
>> When replying, please edit your Subject line so it is more specific
>> than "Re: Contents of video4linux-list digest..."
>> Today's Topics:
>>
>>    1. Re: Query (Adrian Pardini)
>>    2. Re: How to acces TVP5150 .command function from userspace
>>       (Dongsoo, Nathaniel Kim)
>>    3. Re: How to acces TVP5150 .command function from userspace
>>       (Markus Rechberger)
>>    4. Re: [not working] Conceptronic USB 2.0 Digital TV Receiver -
>>       CTVDIGRCU - Device Information (Jelle de Jong)
>> 电子邮件 附件
>> > -------- 转发的信件 --------
>> > 发件人: Adrian Pardini <pardo.bsso@gmail.com>
>> > 收件人: Vandana Vuthoo <vandana.vuthoo@gmail.com>
>> > 抄送: video4linux-list@redhat.com
>> > 主题: Re: Query
>> > 日期: Fri, 22 May 2009 16:49:28 -0300
>> >
>> > Hi Vandana,
>> >
>> > this list is deprecated, please resend your message to
>> > linux-media@vger.kernel.org.
>> > For more information visit: http://vger.kernel.org/vger-lists.html#linux-media.
>> >
>> > cheers.
>> >
>> > On 22/05/2009, Vandana Vuthoo <vandana.vuthoo@gmail.com> wrote:
>> > > Hi,
>> > > I am a beginner to V4l2 domain, actually I want to know whether we can give
>> > > MPEG4 stream as an input to V4L2 driver and show it on the LCD Screen, the
>> > > platform being used is the Beagleboard.
>> > > Regards,
>> > > Vandana
>> >
>> >
>> >
>> 电子邮件 附件
>> > -------- 转发的信件 --------
>> > 发件人: Dongsoo, Nathaniel Kim <dongsoo.kim@gmail.com>
>> > 收件人: Devin Heitmueller <dheitmueller@kernellabs.com>
>> > 抄送: video4linux-list@redhat.com
>> > 主题: Re: How to acces TVP5150 .command function from userspace
>> > 日期: Sat, 23 May 2009 15:30:46 +0900
>> >
>> > Actually those controls should be supported by VIDIOC_S_CTRL but not
>> > sure on 2.6.19.
>> > I took a snapshot of 2.6.19 kernel from git but couldn't find any of
>> > v4l2_ioctl_ops in tvp5150. Possibly not have been using v4l2_ioctl_ops
>> > in that time I guess (not sure)
>> > Anyway, controls that william is trying to use should be controled via
>> > VIDIOC_S_CTRL with CID and as far as I checked in 2.6.19, it already
>> > had those CIDs. So, it could be worth to give a shot with
>> > VIDIOC_S_CTRL.
>> > Cheers,
>> >
>> > Nate
>> >
>> > 2009/5/22 Devin Heitmueller <dheitmueller@kernellabs.com>:
>> > > On Fri, May 22, 2009 at 3:50 AM,  $B7JJ8NS (B <wenlinjing@gmail.com> wrote:
>> > >> Hi,
>> > >>
>> > >> I am working with a video capture chip TVP5150. I want to adjust the
>> > >> "Brightness" "Contrast" "Saturation" and "hue" in user space.
>> > >> In TVP5150 drivers ,the V4l2 commands are in function tvp5150_command.And
>> > >> this function is a member of struct i2c_device.
>> > >>
>> > >> The linux is 2.6.19.2.
>> > >> I write my code according kernel document  Documentation/i2c/dev-interface
>> > >> But I can`t access tvp5150_command.
>> > >> How can i acces i2c_device .command  function from user space?
>> > >
>> > > I thought those controls were already implemented in the tvp5150
>> > > driver, although I could be mistaken (I would have to look at the
>> > > code).  If not, it would probably be much easier to just add the
>> > > commands to the driver than to attempt to program the chip from
>> > > userland (the datasheet for the tvp5150 is freely available).
>> > >
>> > > Devin
>> > >
>> > > --
>> > > Devin J. Heitmueller - Kernel Labs
>> > > http://www.kernellabs.com
>> > >
>> > > --
>> > > video4linux-list mailing list
>> > > Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> > > https://www.redhat.com/mailman/listinfo/video4linux-list
>> > >
>> >
>> >
>> >
>> 电子邮件 附件
>> > -------- 转发的信件 --------
>> > 发件人: Markus Rechberger <mrechberger@gmail.com>
>> > 收件人: Devin Heitmueller <dheitmueller@kernellabs.com>
>> > 抄送: video4linux-list@redhat.com
>> > 主题: Re: How to acces TVP5150 .command function from userspace
>> > 日期: Sat, 23 May 2009 17:26:33 +0200
>> >
>> > 2009/5/22 Devin Heitmueller <dheitmueller@kernellabs.com>:
>> > > On Fri, May 22, 2009 at 3:50 AM,  $B7JJ8NS (B <wenlinjing@gmail.com> wrote:
>> > >> Hi,
>> > >>
>> > >> I am working with a video capture chip TVP5150. I want to adjust the
>> > >> "Brightness" "Contrast" "Saturation" and "hue" in user space.
>> > >> In TVP5150 drivers ,the V4l2 commands are in function tvp5150_command.And
>> > >> this function is a member of struct i2c_device.
>> > >>
>> > >> The linux is 2.6.19.2.
>> > >> I write my code according kernel document  Documentation/i2c/dev-interface
>> > >> But I can`t access tvp5150_command.
>> > >> How can i acces i2c_device .command  function from user space?
>> > >
>> > > I thought those controls were already implemented in the tvp5150
>> > > driver, although I could be mistaken (I would have to look at the
>> > > code).  If not, it would probably be much easier to just add the
>> > > commands to the driver than to attempt to program the chip from
>> > > userland (the datasheet for the tvp5150 is freely available).
>> > >
>> >
>> > those are definitely implemented, I remember there was a problem with
>> > a too dark videopicture years ago and it was a bug in the tvp5150...
>> >
>> > Also by looking at it:
>> > V4L2_CID_BRIGHTNESS
>> > V4L2_CID_CONTRAST
>> > V4L2_CID_SATURATION
>> > V4L2_CID_HUE
>> >
>> > are supported.
>> >
>> > Markus
>> >
>> >
>> 电子邮件 附件
>> > -------- 转发的信件 --------
>> > 发件人: Jelle de Jong <jelledejong@powercraft.nl>
>> > 收件人: Antti Palosaari <crope@iki.fi>
>> > 抄送: video4linux-list@redhat.com
>> > 主题: Re: [not working] Conceptronic USB 2.0 Digital TV Receiver -
>> > CTVDIGRCU - Device Information
>> > 日期: Sat, 23 May 2009 17:36:02 +0200
>> >
>> > Antti Palosaari wrote:
>> > > On 04/25/2009 10:52 AM, Jelle de Jong wrote:
>> > >> Would somebody be willing to get this device to work with the upstream
>> > >> v4l systems? I can sent the device to you. If not I can also return the
>> > >> device back to the store. Just sent me an email.
>> > >
>> > > I can try. At least some basic driver stub which just works is possible
>> > > to do usually even without specs if tuner chip have one that does have
>> > > Linux driver. Most likely it does have tuner that is supported because
>> > > almost every DVB-T silicon tuner have some kind of driver currently.
>> > >
>> > > regards
>> > > Antti
>> >
>> > Hi Antti,
>> >
>> > Sorry for the delay, the package has been lying here for a few weeks. I
>> > have sent the device today so I hope it will arrive soon.
>> >
>> > Best regards,
>> >
>> > Jelle
>> >
>> >
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
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
