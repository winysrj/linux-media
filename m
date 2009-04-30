Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:56086 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZD3Vym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 17:54:42 -0400
MIME-Version: 1.0
In-Reply-To: <20090430144840.6605e564.akpm@linux-foundation.org>
References: <49F0A61D.1010002@simon.arlott.org.uk>
	 <20090430131818.d8aded42.akpm@linux-foundation.org>
	 <49FA1B2E.8030402@simon.arlott.org.uk>
	 <20090430144840.6605e564.akpm@linux-foundation.org>
Date: Thu, 30 Apr 2009 17:54:39 -0400
Message-ID: <412bdbff0904301454x46fb9de5hbe8f7d67da7bf887@mail.gmail.com>
Subject: Re: [PATCH] dvb-core: Fix potential mutex_unlock without mutex_lock
	in dvb_dvr_read
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
	mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 30, 2009 at 5:48 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 30 Apr 2009 22:42:06 +0100
> Simon Arlott <simon@fire.lp0.eu> wrote:
>
>> >> diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
>> >> index c35fbb8..d6d098a 100644
>> >> --- a/drivers/media/dvb/dvb-core/dmxdev.c
>> >> +++ b/drivers/media/dvb/dvb-core/dmxdev.c
>> >> @@ -247,7 +247,7 @@ static ssize_t dvb_dvr_read(struct file *file, char __user *buf, size_t count,
>> >>    int ret;
>> >>
>> >>    if (dmxdev->exit) {
>> >> -          mutex_unlock(&dmxdev->mutex);
>> >> +          //mutex_unlock(&dmxdev->mutex);
>> >>            return -ENODEV;
>> >>    }
>> >
>> > Is there any value in retaining all the commented-out lock operations,
>> > or can we zap 'em?
>>
>> I'm assuming they should really be there - it's just not practical
>> because the call to dvb_dmxdev_buffer_read is likely to block waiting
>> for data.
>
> well..  such infomation is much better communicated via a nice comment,
> rather than mystery-dead-code?

I'm doing some review of the locking in dvb core as a result of a race
condition I found earlier in the week.  I'll take a look at this too
when I get a few minutes.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
