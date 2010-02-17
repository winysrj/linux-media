Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934175Ab0BQI5P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 03:57:15 -0500
Message-ID: <4B7BAF8C.9070700@redhat.com>
Date: Wed, 17 Feb 2010 09:57:48 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: Frans Pop <elendil@planet.nl>, linux-media@vger.kernel.org
Subject: Re: pac207: problem with Trust USB webcam
References: <201002150038.03060.elendil@planet.nl> <4B7B089A.4060504@redhat.com> <201002170004.51883.linux@baker-net.org.uk>
In-Reply-To: <201002170004.51883.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/17/2010 01:04 AM, Adam Baker wrote:
> On Tuesday 16 Feb 2010, Hans de Goede wrote:
>> Hi,
>>
>> You need to use libv4l and have your apps patched
>> to use libv4l or use the LD_PRELOAD wrapper.
>>
>> Here is the latest libv4l:
>> http://people.fedoraproject.org/~jwrdegoede/libv4l-0.6.5-test.tar.gz
>>
>> And here are install instructions:
>> http://hansdegoede.livejournal.com/7622.html
>>
> Hi,
>
> libv4l is already packaged by lenny but doing
>
> LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so xawtv
>
> results in either a plain green screen or a mostly green screen with some
> picture visible behind it. IIRC this is due to a bug in older versions of
> xawtv. I didn't try vlc as it wanted to install too many dependencies but I
> did try cheese which also wouldn't work.
>
> I did find I could capture single frames with
>
> LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so vgrabbj -d /dev/video0>grab.jpg
>
> or
>
> LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so fswebcam --save grab2.jpg
>
> which suggests that the packaged libv4l is fine and it is just the apps that
> are an issue.
>

Yes that is very likely I'm the author and maintainer of both libv4l and the
pac207 kernel driver and I have 5 different pac207 based cams to test with and
all work well on a variety of computers.

xawtv indeed is known to be buggy, and cheese too has had some bad releases.

Anyways I don't know how old the libv4l is in Lenny, but you will want at least
version 0.6.0, as that has some fixes for the pac207 compression, and prefarably
0.6.1 as that some desirable bug fixes. The releases past 0.6.2 mainly add
support for other webcam compressions.

Regards,

Hans
