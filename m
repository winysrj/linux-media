Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62961 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0ITATG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 20:19:06 -0400
Received: by eyb6 with SMTP id 6so1434743eyb.19
        for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 17:19:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201009192317.57761.hverkuil@xs4all.nl>
References: <201009191229.35800.hverkuil@xs4all.nl>
	<4C967082.3040405@redhat.com>
	<1284930151.2079.156.camel@morgan.silverblock.net>
	<201009192317.57761.hverkuil@xs4all.nl>
Date: Sun, 19 Sep 2010 20:19:03 -0400
Message-ID: <AANLkTimDUJbrrLkTHspRh+56bx_GDr+Rbpd2w9veK+rQ@mail.gmail.com>
Subject: Re: RFC: BKL, locking and ioctls
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Sep 19, 2010 at 5:17 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Sunday, September 19, 2010 23:02:31 Andy Walls wrote:
>> Hans,
>>
>> On an somewhat related note, but off-topic: what is the proper way to
>> implement VIDIOC_QUERYCAP for a driver that implements read()
>> on /dev/video0 (MPEG) and mmap() streaming on /dev/video32 (YUV)?
>>
>> I'm assuming the right way is for VIDIOC_QUERYCAP to return different
>> caps based on which device node was queried.
>
> The spec is not really clear about this. It would be the right thing to do
> IMHO, but the spec would need a change.
>
> The caps that are allowed to change between device nodes would have to be
> clearly documented. Basically only the last three in the list, and the phrase
> 'The device supports the...' should be replaced with 'The device node supports
> the...'.

This would be great to straighten out.  One of the common problems new
users have setting up MythTV is trying to figure out what type of
device they should be choosing (e.g. "V4L2 capture device" versus
"IVTV MPEG capture device").  The problem is that the application
cannot limit the list of /dev/videoX entries for a given type because
some devices report both for all device nodes (even though, for
example, the cx18 can only do MPEG on /dev/video1 and raw video on
/dev/video0).

This results in all sorts of confusion when people wonder why they
cannot watch TV because they picked "IVTV MPEG capture device", and
then picked /dev/video0 as the device node.

And of course the real fun comes around when they cannot figure out
why they cannot capture video on /dev/video24 and /dev/video32 because
those aren't actually video capture devices *at all*.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
