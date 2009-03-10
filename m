Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3653 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZCJNua (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 09:50:30 -0400
Message-ID: <41460.62.70.2.252.1236693001.squirrel@webmail.xs4all.nl>
Date: Tue, 10 Mar 2009 14:50:01 +0100 (CET)
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] v4l2-ioctl: get rid of      
     video_decoder.h
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"Hans de Goede" <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I've got several of these: w9968cf, usbvideo, cpia_usb, stv680 (I think)
>> and ov511.
>
> Once converted one, the other conversions will probably be easy. maybe
> Jean-Francois or another gspca-submaintainer could convert one of the
> webcam
> drivers you have. Then, you can test (and fix). After this changeset, the
> conversion for the others will likely be trivial.

I'd be happy to test and fix if someone else can do the initial conversion
to gspca. I have neither the gspca experience nor the time to do that part
myself.

>>
>> > A few capture drivers:
>> > 	linux/drivers/media/video/zoran/zoran_driver.c
>> > 	linux/drivers/media/video/stradis.c
>> > 	linux/drivers/media/video/pms.c
>> >
>> > And two i2c helper drivers:
>> > 	linux/drivers/media/video/msp3400-driver.c
>> > 	linux/drivers/media/video/tuner-core.c
>> >
>> > Most of the above are the legacy V4L1 webcam drivers. It would be
>> really
>> > nice
>> > if someone could volunteer to port those Webcam drivers to gspca.
>> >
>> > I suspect that it shouldn't hard to remove the few V4L1 bits from
>> > zoran_driver, after all
>> > the conversions made. Yet, there are some Zoran specific ioctls that
>> use
>> > this.
>> > We should probably discontinue those zoran-specific ioctls.
>>
>> I didn't dare do that when I did the conversion. Someone would have to
>> analyze these BUZ ioctls, but I think they all have proper v4l2
>> equivalents.
>
> The only BUZ_foo that requires may require some work are the
> BUZIOC_G_PARAMS/BUZIOC_S_PARAMS, since it has some controls to the MJPEG
> stream. I'm not sure if everything is implemented. There are some BUZ_
> ioctls
> that are similar to V4L2 (REQBUFS, QBUF). I don't see why we need yet
> another
> set of mmap methods here. The BUZIOC_SYNC doesn't make much sense to my
> eyes,
> except if you're stopping a stream. In this case, VIDIOC_STREAMOFF should
> already provide a sync functionality. The last one BUZIOC_G_STATUS is a
> merge
> of some other status already existent on V4L2.
>
> The only detail here is that the Zoran mmap methods provide two modes:
> QBUF_PLAY and
> QBUF_CAPT. We should take some care to understand the logic behind this.
>>
>> > It seems also safe to remove V4L1 code from msp3400, since, AFAIK, all
>> > drivers
>> > that supports it are already converted to V4L2.
>>
>> I didn't realize that there was still some V4L1 code in that driver. It
>> can certainly be removed.
>
> Ok. Maybe you could provide us an strip patch for those legacy code.
> Otherwise,
> I'll handle that later.

I'll added it to my v4l-dvb tree that contains all the other miscellaneous
set of patches from me. It would be nice if that could be pulled soon
since it fixes a lot of daily build breakages.

>> > After converting stradis, it will be probably safe also to remove V4L1
>> > code
>> > from tuner-core.
>> >
>> > I doubt that there are still some pms hardware around, but it would be
>> > interesting to keep this module, since this is the first V4L driver
>> wrote.
>>
>> I have one! I managed to get one for $4 (+$16 shipping :-) ).
>>
>> It actually works (sort of) and I want to convert it to v4l2, just as a
>> fun project.
>
> Yes, this seems a very interesting fun project ;)

Yup!

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

