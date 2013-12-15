Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1659 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab3LOLbs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 06:31:48 -0500
Message-ID: <52AD9306.1060408@xs4all.nl>
Date: Sun, 15 Dec 2013 12:31:18 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v2 7/7] v4l: define own IOCTL ops for SDR FMT
References: <1387037729-1977-1-git-send-email-crope@iki.fi> <1387037729-1977-8-git-send-email-crope@iki.fi> <52AC8645.2010707@iki.fi> <20131215092326.74c28792.m.chehab@samsung.com>
In-Reply-To: <20131215092326.74c28792.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2013 12:23 PM, Mauro Carvalho Chehab wrote:
> Em Sat, 14 Dec 2013 18:24:37 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
> 
>> Hello, Mauro, Hans,
>>
>> On 14.12.2013 18:15, Antti Palosaari wrote:
>>> Use own format ops for SDR data:
>>> vidioc_enum_fmt_sdr_cap
>>> vidioc_g_fmt_sdr_cap
>>> vidioc_s_fmt_sdr_cap
>>> vidioc_try_fmt_sdr_cap
>>
>> To be honest, I am a little bit against that patch. Is there any good 
>> reason we duplicate these FMT ops every-time when new stream format is 
>> added? For my eyes that is mostly just bloating the code without good 
>> reason.
> 
> The is one reason: when the same device can be used in both SDR and non
> SDR mode (radio, video, vbi), then either the driver or the core would
> need to select the right set of vidioc_*fmt_* ops.
> 
> In the past, all drivers had about the same logic for such tests.
> Yet, as the implementations weren't the same, several of them were
> implementing it wrong.
> 
> So, we ended by moving those validations to the core.

I do think there is room for improvement here, though. Rather than
passing v4l2_format to the ops I would have preferred passing the appropriate
struct of the union instead.

And I never really liked it that try and set were split up. A 'try' boolean
would reduce the number of ops.

The first improvement is something that can be done at some point. It's too
late (and probably not worth it) to do anything about the second.

Regards,

	Hans

PS: Antti, I'll review the code in more detail tomorrow.
