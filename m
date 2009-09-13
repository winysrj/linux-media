Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZIMSpO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 14:45:14 -0400
Message-ID: <4AAD3E7B.5030606@redhat.com>
Date: Sun, 13 Sep 2009 20:48:27 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	leandro Costantino <lcostantino@gmail.com>
Subject: Re: image quality of Labtec Webcam 2200
References: <4AA9F7A0.5080802@freemail.hu> <20090913092015.485fdbcd@tele>
In-Reply-To: <20090913092015.485fdbcd@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/13/2009 09:20 AM, Jean-Francois Moine wrote:
> On Fri, 11 Sep 2009 09:09:20 +0200
> Németh Márton<nm127@freemail.hu>  wrote:
>
>> You can find my results at
>> http://v4l-test.sourceforge.net/results/test-20090911/index.html
>> There are three types of problems: a) Sometimes the picture contains
>> a 8x8 pixel error, like in image #9
>> http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00009
>> b) Sometimes the brightness of the half picture is changed, like in
>> images #7, #36 and #37
>> http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00007
>> http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00036
>> http://v4l-test.sourceforge.net/results/test-20090911/index.html#img00037
>> c) Sometimes the libv4l cannot convert the raw image and the errno is
>> set to EAGAIN (11), for example image #1, #2 and #3
>>
>> Do you know how can I fix these problems?
>
> The error EAGAIN is normal when decoding pac7311 images, because they
> are rotated 90°. But this error should occur one time only.
>
> I looked at the raw image #1, and it seems that there are JPEG errors
> inside (sequences ff ff). There should be a problem in the pac7311
> driver. Hans, may you confirm?
>

The pac7311 / pac7302 are very cheap crap cams (I bought one brand new
for 3 euros, and that was not in the bargain bin).

These cams use a custom jpeg format, and we are very luky to be able to
decompress this at all (thanks to some of the wizards who worked on the
original gspca driver).

Yes there are still some issues, but with no documentation what soever,
and unreliable hardware (I've seen hang cams which needed to be unplugged
/ replugged to start working again), I'm afraid there is nothing we can do.

Still if people want to work on improving support for them more power to
then, I'll gladly help where I can. The ff ff you've found are special
Pixart padding sequences, see tinyjpeg.c: pixart_fill_nbits()

Also interesting is the comment about some of the special Pxiart markers
in the tinyjpeg.c: pixart_decode_MCU_2x1_3planes() function. Which
summaries what i've learned while getting pac7302 cams to work (to a
certain extend).

Regards,

Hans
