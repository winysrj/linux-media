Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:18206 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZBRSEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 13:04:46 -0500
Received: by fk-out-0910.google.com with SMTP id f33so15565fkf.5
        for <linux-media@vger.kernel.org>; Wed, 18 Feb 2009 10:04:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <36c518800902121206u26b57e8r3b80741718bbb34b@mail.gmail.com>
References: <36c518800902111042j2fd8db53q58d7e3960d26120c@mail.gmail.com>
	 <20090212194242.17ae6abb@free.fr>
	 <36c518800902121206u26b57e8r3b80741718bbb34b@mail.gmail.com>
Date: Wed, 18 Feb 2009 20:04:43 +0200
Message-ID: <36c518800902181004q273d9a5djb3129d0347e679b6@mail.gmail.com>
Subject: Re: v4l2 and skype
From: vasaka@gmail.com
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 12, 2009 at 10:06 PM,  <vasaka@gmail.com> wrote:
> On Thu, Feb 12, 2009 at 8:42 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
>> On Wed, 11 Feb 2009 20:42:07 +0200
>> vasaka@gmail.com wrote:
>>
>>> hello, I am writing v4l2 loopback driver and now it is at working
>>> stage. for now it can feed mplayer and luvcview, but silently fails
>>> with skype it just shows green screen while buffer rotation is going
>>> on. can you help me with debug? I think I missing small and obvious
>>> detail. Is there something special about skype way of working with
>>> v4l2?
>>
>> Hello Vasily,
>>
>> I think skype is not v4l2. Also, I don't know about the frames you send
>> to it, but I know it does not understand JPEG.
>
> I started writing this driver just because Skype does not understand
> existing v4l loopback drivers and understands uvcvideo, which is pure
> v4l2 driver. I am sending to Skype raw yuv frames, also tryed just
> random generated Images and skype is just shows green rectangle.
>>
>>> loopback is here:
>>> http://code.google.com/p/v4l2loopback/source/checkout
>>> I am feeding it with this app
>>> http://code.google.com/p/v4lsink/source/checkout
>>> this is the simple gstreamer app which takes data from /dev/video0 and
>>> puts it to /dev/video1 which should be my loopback device.
>>
>> I did not look at your code, but it may be interesting for usermode
>> drivers...
>>
>> BTW, don't use the video4linux-list@redhat.com mailing list. The new
>> list is in the Cc: field.
>>
>> Regards.
>>
>> --
>> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
>> Jef             |               http://moinejf.free.fr/
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>
> Vasily Levin
>
I maneged to make it work :-) skype seems to do some checks on sanity
of image it gets, so testing it with just noise does not work.

do you need loopback driver in kernel? I am willing to make it good
enough to pass in.

--
Vasily Levin
