Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395Ab0FCIkV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 04:40:21 -0400
Message-ID: <4C076AD5.2090909@redhat.com>
Date: Thu, 03 Jun 2010 10:41:57 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-media@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 16077] New: Drop is video frame rate in kernel
 .34
References: <bug-16077-10286@https.bugzilla.kernel.org/>	<20100602140916.759d7159.akpm@linux-foundation.org>	<4C072451.7090001@infradead.org> <87r5kod2dm.fsf@nemi.mork.no>
In-Reply-To: <87r5kod2dm.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/03/2010 09:03 AM, Bjørn Mork wrote:
> Mauro Carvalho Chehab<mchehab@infradead.org>  writes:
>> Em 02-06-2010 18:09, Andrew Morton escreveu:
>>> On Sun, 30 May 2010 14:29:55 GMT
>>> bugzilla-daemon@bugzilla.kernel.org wrote:
>>>
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=16077
>>>
>>> 2.6.33 ->  2.6.34 performance regression in dvb webcam frame rates.
>>
>> I don't think this is a regression. Probably, the new code is allowing a higher
>> resolution. As the maximum bandwidth from the sensor to the USB bridge doesn't
>> change, and a change from QVGA to VGA implies on 4x more pixels per frame, as
>> consequence, the number of frames per second will likely reduce by a factor of 4x.
>>
>> I've asked the reporter to confirm what resolutions he is setting on 2.6.33
>> and on 2.6.34, just to double check if my thesis is correct.
>
> Well, the two video clips attached to the bug shows the same resolution
> but a much, much lower video (and overall) bitrate in 2.6.34.  Output
> from mediainfo:
>


I notice in the original bug report that you claim that the lower framerate
clip with 2.6.34 has "much better quality", could you define this a bit better.

I think that what is happening is the code for the new (correct) sensor is
setting a higher exposure value (and thus a lighter / less dark image), but
setting a higher exposure value comes at the cost of framerate. As the framerate
can never be higher then 1 / exposure_time_for_1_frame.

2 things:

1) Go the preferences in cheese, and see which resolutions you can select, and
    make sure you are using the same resolution in 2.6.34 and 2.6.33

2) Start a v4l2 control panel applet, like v4l2ucp or gtk-v4l, and try playing
    around with the controls (note the controls inside cheese are software not
    hardware controls so don't use those).

Regards,

Hans
