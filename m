Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f176.google.com ([209.85.222.176]:46899 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0DUXFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 19:05:24 -0400
Received: by pzk6 with SMTP id 6so2667666pzk.1
        for <linux-media@vger.kernel.org>; Wed, 21 Apr 2010 16:05:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <w2ya64f67eb1004190218odbbcbc8ct41ae99f0927d90d8@mail.gmail.com>
References: <x2ha64f67eb1004180534u17079d45lcb224fb3940a27ca@mail.gmail.com>
	 <4BCB2070.5030608@rogers.com>
	 <u2wa64f67eb1004190159w11e6f6c6r6b9ec6fac6a409a3@mail.gmail.com>
	 <j2ta64f67eb1004190209g737ce052vd65949295df8d2b3@mail.gmail.com>
	 <w2ya64f67eb1004190218odbbcbc8ct41ae99f0927d90d8@mail.gmail.com>
Date: Thu, 22 Apr 2010 09:05:24 +1000
Message-ID: <l2xa64f67eb1004211605w662fd7bh8d86e2fd73f1bf31@mail.gmail.com>
Subject: Re: Need Info
From: linux newbie <linux.newbie79@gmail.com>
To: Linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Any suggestions?

Thanks

On Mon, Apr 19, 2010 at 7:18 PM, linux newbie <linux.newbie79@gmail.com> wrote:
> Hi,
>
> It is observed that Lifecam transfer type is Isochronous and ISP1362
> driver does not support this. Is there any driver patch that supports
> Isochronous transfer??
>
> Please help me in this regard.
> Thanks
>
>>> linux newbie wrote:
>>> > Hi,
>>> >
>>> > On my embedded PXA255 platform, we have working USB module. ISP1362 is the
>>> > controller. Recently we want to integrate Microsoft Lifecam Cinema webcam
>>> > and want to take still images.
>>> >
>>> > Linux kernel is 2.6.26.3 and we enabled V4L2 and UVC class drivers. On
>>> > plugging the Cam and querying the proc and sys file system, I can able to
>>> > view cam details.
>>> >
>>> > I want to capture the frame (preferably in jpeg) and write to a file. Is
>>> > there any example code for that? I went through the below web page
>>> > http://v4l2spec.bytesex.org/spec/capture-example.html, but if you can
>>> > suggest some more example, it will be of great help to me.
>>> >
>>> > Thanks
>>> > --
>>> > video4linux-list mailing list
>>> > Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>> > https://www.redhat.com/mailman/listinfo/video4linux-list
>>> >
>>> >
>>>
>>
>>
>
