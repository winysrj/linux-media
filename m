Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2526 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaFWMdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 08:33:19 -0400
Message-ID: <53A81E65.4050202@xs4all.nl>
Date: Mon, 23 Jun 2014 14:32:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: bttv and colorspace
References: <53A3DDC7.50909@xs4all.nl> <1403259897.2144.4.camel@palomino.walls.org>
In-Reply-To: <1403259897.2144.4.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On 06/20/2014 12:24 PM, Andy Walls wrote:
> On Fri, 2014-06-20 at 09:07 +0200, Hans Verkuil wrote:
>> Hi Mauro,
>>
>> I wonder if you remember anything about the reported broken colorspace handling
>> of bttv. The spec talks about V4L2_COLORSPACE_BT878 where the Y range is 16-253
>> instead of the usual 16-235.
>>
>> I downloaded a bt878 datasheet and that mentions the normal 16-235 range.
>>
>> I wonder if this was perhaps a bug in older revisions of the bt878. Do you
>> remember anything about this?
> 
> I have a Rockwell datasheet for the BrookTree 878/879 that has the Y
> 16-253 (16 is the pedestal level) and Cr/Cb 2-253 on page 118.

I did look at this closer and this is actually not what you think it is.

Page 40 describes the actual YCrCb to RGB conversion and this clearly
states that the Y range is [16, 235].

However, as is standard with YCrCb values, you can get excursions into the
<16 or >235 ranges. Depending on how it is digitized these may be clamped
to the 16-235 range by the hardware, or they are just passed on.

The purpose of the RANGE bit in the OFORM register is to prevent the SAV/EAV
0x00 and 0xff control codes from being output as part of the actual video should
excursions that low/high happen.

So the bttv does not have a 'broken' colorspace, it is doing standard YCrCb
format. It doesn't do any hardware clamping to the [16-235] range ([16-240]
for Cr/Cb), so it is perfectly possible that lower/higher values are captured.

That probably confused people in the past into thinking that there was a problem
with the bttv colorspace.

This also means that the bttv driver works properly since it sets the SMPTE170M
colorspace and never uses the 'broken' bttv colorspace.

The spec should be enhanced to document this.

Regards,

	Hans
