Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4P1WCOU013178
	for <video4linux-list@redhat.com>; Sun, 24 May 2009 21:32:12 -0400
Received: from mail-px0-f126.google.com (mail-px0-f126.google.com
	[209.85.216.126])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n4P1VuMm006988
	for <video4linux-list@redhat.com>; Sun, 24 May 2009 21:31:56 -0400
Received: by pxi32 with SMTP id 32so2416365pxi.23
	for <video4linux-list@redhat.com>; Sun, 24 May 2009 18:31:55 -0700 (PDT)
From: xie <yili.xie@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <20090523160013.909D88E03A1@hormel.redhat.com>
References: <20090523160013.909D88E03A1@hormel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 May 2009 09:31:41 +0800
Message-Id: <1243215101.6402.12.camel@xie>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: about taking picture
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

Dear all ~
     I have to implement the hal in Android with v4l2. Now i use one
thread to preview , i just use V4L2 capture interface to implement the
preview. Now i have one confusion : 
     I think i can implement the taking picture just copy the preview
frame , and  am i right ? I want to use another thread to take picture ,
when I am taking picture ,whether I have to stop the previewing ?
     Thanks a lot ~!~ 


在 2009-05-23六的 12:00 -0400，video4linux-list-request@redhat.com写道：
> Send video4linux-list mailing list submissions to
> 	video4linux-list@redhat.com
> 
> To subscribe or unsubscribe via the World Wide Web, visit
> 	https://www.redhat.com/mailman/listinfo/video4linux-list
> or, via email, send a message with subject or body 'help' to
> 	video4linux-list-request@redhat.com
> 
> You can reach the person managing the list at
> 	video4linux-list-owner@redhat.com
> 
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of video4linux-list digest..."
> Today's Topics:
> 
>    1. Re: Query (Adrian Pardini)
>    2. Re: How to acces TVP5150 .command function from userspace
>       (Dongsoo, Nathaniel Kim)
>    3. Re: How to acces TVP5150 .command function from userspace
>       (Markus Rechberger)
>    4. Re: [not working] Conceptronic USB 2.0 Digital TV Receiver -
>       CTVDIGRCU - Device Information (Jelle de Jong)
> 电子邮件 附件
> > -------- 转发的信件 --------
> > 发件人: Adrian Pardini <pardo.bsso@gmail.com>
> > 收件人: Vandana Vuthoo <vandana.vuthoo@gmail.com>
> > 抄送: video4linux-list@redhat.com
> > 主题: Re: Query
> > 日期: Fri, 22 May 2009 16:49:28 -0300
> > 
> > Hi Vandana,
> > 
> > this list is deprecated, please resend your message to
> > linux-media@vger.kernel.org.
> > For more information visit: http://vger.kernel.org/vger-lists.html#linux-media.
> > 
> > cheers.
> > 
> > On 22/05/2009, Vandana Vuthoo <vandana.vuthoo@gmail.com> wrote:
> > > Hi,
> > > I am a beginner to V4l2 domain, actually I want to know whether we can give
> > > MPEG4 stream as an input to V4L2 driver and show it on the LCD Screen, the
> > > platform being used is the Beagleboard.
> > > Regards,
> > > Vandana
> > 
> > 
> > 
> 电子邮件 附件
> > -------- 转发的信件 --------
> > 发件人: Dongsoo, Nathaniel Kim <dongsoo.kim@gmail.com>
> > 收件人: Devin Heitmueller <dheitmueller@kernellabs.com>
> > 抄送: video4linux-list@redhat.com
> > 主题: Re: How to acces TVP5150 .command function from userspace
> > 日期: Sat, 23 May 2009 15:30:46 +0900
> > 
> > Actually those controls should be supported by VIDIOC_S_CTRL but not
> > sure on 2.6.19.
> > I took a snapshot of 2.6.19 kernel from git but couldn't find any of
> > v4l2_ioctl_ops in tvp5150. Possibly not have been using v4l2_ioctl_ops
> > in that time I guess (not sure)
> > Anyway, controls that william is trying to use should be controled via
> > VIDIOC_S_CTRL with CID and as far as I checked in 2.6.19, it already
> > had those CIDs. So, it could be worth to give a shot with
> > VIDIOC_S_CTRL.
> > Cheers,
> > 
> > Nate
> > 
> > 2009/5/22 Devin Heitmueller <dheitmueller@kernellabs.com>:
> > > On Fri, May 22, 2009 at 3:50 AM, $B7JJ8NS(B <wenlinjing@gmail.com> wrote:
> > >> Hi,
> > >>
> > >> I am working with a video capture chip TVP5150. I want to adjust the
> > >> "Brightness" "Contrast" "Saturation" and "hue" in user space.
> > >> In TVP5150 drivers ,the V4l2 commands are in function tvp5150_command.And
> > >> this function is a member of struct i2c_device.
> > >>
> > >> The linux is 2.6.19.2.
> > >> I write my code according kernel document  Documentation/i2c/dev-interface
> > >> But I can`t access tvp5150_command.
> > >> How can i acces i2c_device .command  function from user space?
> > >
> > > I thought those controls were already implemented in the tvp5150
> > > driver, although I could be mistaken (I would have to look at the
> > > code).  If not, it would probably be much easier to just add the
> > > commands to the driver than to attempt to program the chip from
> > > userland (the datasheet for the tvp5150 is freely available).
> > >
> > > Devin
> > >
> > > --
> > > Devin J. Heitmueller - Kernel Labs
> > > http://www.kernellabs.com
> > >
> > > --
> > > video4linux-list mailing list
> > > Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > > https://www.redhat.com/mailman/listinfo/video4linux-list
> > >
> > 
> > 
> > 
> 电子邮件 附件
> > -------- 转发的信件 --------
> > 发件人: Markus Rechberger <mrechberger@gmail.com>
> > 收件人: Devin Heitmueller <dheitmueller@kernellabs.com>
> > 抄送: video4linux-list@redhat.com
> > 主题: Re: How to acces TVP5150 .command function from userspace
> > 日期: Sat, 23 May 2009 17:26:33 +0200
> > 
> > 2009/5/22 Devin Heitmueller <dheitmueller@kernellabs.com>:
> > > On Fri, May 22, 2009 at 3:50 AM, $B7JJ8NS(B <wenlinjing@gmail.com> wrote:
> > >> Hi,
> > >>
> > >> I am working with a video capture chip TVP5150. I want to adjust the
> > >> "Brightness" "Contrast" "Saturation" and "hue" in user space.
> > >> In TVP5150 drivers ,the V4l2 commands are in function tvp5150_command.And
> > >> this function is a member of struct i2c_device.
> > >>
> > >> The linux is 2.6.19.2.
> > >> I write my code according kernel document  Documentation/i2c/dev-interface
> > >> But I can`t access tvp5150_command.
> > >> How can i acces i2c_device .command  function from user space?
> > >
> > > I thought those controls were already implemented in the tvp5150
> > > driver, although I could be mistaken (I would have to look at the
> > > code).  If not, it would probably be much easier to just add the
> > > commands to the driver than to attempt to program the chip from
> > > userland (the datasheet for the tvp5150 is freely available).
> > >
> > 
> > those are definitely implemented, I remember there was a problem with
> > a too dark videopicture years ago and it was a bug in the tvp5150...
> > 
> > Also by looking at it:
> > V4L2_CID_BRIGHTNESS
> > V4L2_CID_CONTRAST
> > V4L2_CID_SATURATION
> > V4L2_CID_HUE
> > 
> > are supported.
> > 
> > Markus
> > 
> > 
> 电子邮件 附件
> > -------- 转发的信件 --------
> > 发件人: Jelle de Jong <jelledejong@powercraft.nl>
> > 收件人: Antti Palosaari <crope@iki.fi>
> > 抄送: video4linux-list@redhat.com
> > 主题: Re: [not working] Conceptronic USB 2.0 Digital TV Receiver -
> > CTVDIGRCU - Device Information
> > 日期: Sat, 23 May 2009 17:36:02 +0200
> > 
> > Antti Palosaari wrote:
> > > On 04/25/2009 10:52 AM, Jelle de Jong wrote:
> > >> Would somebody be willing to get this device to work with the upstream
> > >> v4l systems? I can sent the device to you. If not I can also return the
> > >> device back to the store. Just sent me an email.
> > > 
> > > I can try. At least some basic driver stub which just works is possible 
> > > to do usually even without specs if tuner chip have one that does have 
> > > Linux driver. Most likely it does have tuner that is supported because 
> > > almost every DVB-T silicon tuner have some kind of driver currently.
> > > 
> > > regards
> > > Antti
> > 
> > Hi Antti,
> > 
> > Sorry for the delay, the package has been lying here for a few weeks. I
> > have sent the device today so I hope it will arrive soon.
> > 
> > Best regards,
> > 
> > Jelle
> > 
> > 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
