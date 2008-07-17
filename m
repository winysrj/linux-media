Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HGf9o5013674
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 12:41:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HGetOu023583
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 12:40:56 -0400
Date: Thu, 17 Jul 2008 12:40:47 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200807171816.22303.hverkuil@xs4all.nl>
Message-ID: <alpine.LFD.1.10.0807171238080.20641@bombadil.infradead.org>
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<Pine.LNX.4.58.0806240032081.535@shell2.speakeasy.net>
	<20080624225951.GF8831@plankton.ifup.org>
	<200807171816.22303.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce "index"
 attribute for?persistent video4linux device nodes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, 17 Jul 2008, Hans Verkuil wrote:

> On Wednesday 25 June 2008 00:59:51 Brandon Philips wrote:
>> On 00:34 Tue 24 Jun 2008, Trent Piepho wrote:
>>> On Mon, 23 Jun 2008, Brandon Philips wrote:
>>>> +	for (i = 0; i < 32; i++) {
>>>> +		if (used & (1 << i))
>>>> +			continue;
>>>> +		return i;
>>>> +	}
>>>
>>> 	i = ffz(used);
>>> 	return i >= 32 ? -ENFILE : i;
>>
>> Err. Right :D  Tested and pushed.
>>
>> Mauro-
>>
>> Updated http://ifup.org/hg/v4l-dvb to have Trent's improvement.
>>
>> Cheers,
>>
>> 	Brandon
>
>
> Hi Mauro,
>
> I think you missed this pull request from Brandon. Can you merge this?

Yes, I missed that one.

Yet, I didn't like the usage of "32" magic numbers on those parts:

-       if (num >= VIDEO_NUM_DEVICES)
+
+       if (num >= 32) {
+               printk(KERN_ERR "videodev: %s num is too large\n", __func__);

+       return i >= 32 ? -ENFILE : i;


It seems better to use VIDEO_NUM_DEVICES as the maximum limit on both 
usages of "32".

Brandon,

Could you fix and re-send me a pull request?

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
