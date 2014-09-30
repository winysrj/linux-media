Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:50227 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaI3N32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 09:29:28 -0400
Received: by mail-ig0-f173.google.com with SMTP id uq10so1101292igb.6
        for <linux-media@vger.kernel.org>; Tue, 30 Sep 2014 06:29:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <542AAC21.70804@collabora.com>
References: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com>
 <542AAC21.70804@collabora.com>
From: Paulo Assis <pj.assis@gmail.com>
Date: Tue, 30 Sep 2014 14:29:08 +0100
Message-ID: <CAPueXH752iCA3QkCaxuQyUUkXveYLmG5NkpYV3AtS+vq72WBEQ@mail.gmail.com>
Subject: Re: uvcvideo fails on 3.16 and 3.17 kernels
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yes,
but disabling libv4l2 and accessing the driver directly, has the same
effect. Also like I said, gspca works fine, even through libv4l2.
So I'm pretty sure this is related to uvcvideo.
My libv4l2 version is 1.2.0 and the reported problems with libv4l2
I've received relate to version 1.4.0 (debian), virtual formats (rgb3,
bgr3, yu12, yv12) are not working with that version.

Regards,
Paulo

2014-09-30 14:12 GMT+01:00 Nicolas Dufresne <nicolas.dufresne@collabora.com>:
>
> Le 2014-09-30 04:50, Paulo Assis a écrit :
>
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1362358
>>
>> I've run some tests and after increasing verbosity for uvcvideo, I get:
>> EOF on empty payload
>>
>> this seems consistent with the zero size frames returned by the driver.
>> After VIDIOC_DQBUF | VIDIOC_QBUF, I get buf.bytesused=0
>>
>> Testing with an eye toy 2 (gspca), everything works fine, so this is
>> definitly related to uvcvideo.
>> This happens on all available formats (YUYV and MJPEG)
>
> Might be related to the libv4l2 bug I reported yesterday, are you using
> libv4l2 in these tests ?
>
> Nicolas
