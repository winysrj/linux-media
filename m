Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:40391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab0LaQS4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 11:18:56 -0500
Message-ID: <4D1E0263.8050206@redhat.com>
Date: Fri, 31 Dec 2010 14:18:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: nasty bug at qv4l2
References: <4D11E170.6050500@redhat.com> <201012241520.01460.hverkuil@xs4all.nl> <4D1DF072.7080408@redhat.com> <201012311608.25285.hverkuil@xs4all.nl>
In-Reply-To: <201012311608.25285.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 31-12-2010 13:08, Hans Verkuil escreveu:
> On Friday, December 31, 2010 16:02:10 Hans de Goede wrote:
>> Hi,
>>
>> Hans V. I've tested your patch for avoiding the double
>> conversion problem, and I can report it fixes the issue seen with
>> webcameras which need 90 degrees rotation.
>>
>> While testing I found a bug in gspca, which gets triggered by
>> qv4l2 which makes it impossible to switch between userptr and
>> mmap mode. While fixing that I also found some locking issues in
>> gspca. As these all touch the gscpa core I'll send a patch set
>> to Jean Francois Moine for this.
>>
>> With the issues in gspca fixed, I found a bug in qv4l2 when using
>> read mode in raw mode (not passing the correct src_size to
>> libv4lconvert_convert).
>>
>> I've attached 2 patches to qv4l2, fixing the read issue and a similar
>> issue in mmap / userptr mode. These apply on top of your patch.
> 
> Thanks for testing this! I've committed mine and your patches for qv4l2.

Ok, I did some tests here too. The applied patches fix the bugs I've
reported: the pac7302 driver formats are properly reported (the emulated ones),
and it is now possible to change resolution/format with the uvc driver.

Cheers,
Mauro
