Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2638 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3LPRKG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 12:10:06 -0500
Message-ID: <52AF33CF.3010709@xs4all.nl>
Date: Mon, 16 Dec 2013 18:09:35 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/7] V4L2 SDR API
References: <1387037729-1977-1-git-send-email-crope@iki.fi> <52AC8B20.906@iki.fi> <52AC8FD6.2080504@xs4all.nl> <52AC99C1.4050108@iki.fi> <20131215093022.5e6e8d37.m.chehab@samsung.com> <52AF2F72.7030203@iki.fi>
In-Reply-To: <52AF2F72.7030203@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2013 05:50 PM, Antti Palosaari wrote:
> On 15.12.2013 13:30, Mauro Carvalho Chehab wrote:
>> Em Sat, 14 Dec 2013 19:47:45 +0200
>> Antti Palosaari <crope@iki.fi> escreveu:
>>
>>> On 14.12.2013 19:05, Hans Verkuil wrote:
>>>> On 12/14/2013 05:45 PM, Antti Palosaari wrote:
> 
>> I didn't like much that now have 3 ways to describe frequencies.
>> I think we should latter think on moving the frequency conversion to
>> the core, and use u64 with 1Hz step at the internal API, converting all
>> the drivers to use it.
>>
>> IMHO, we should also provide a backward-compatible way that would allow
>> userspace to choose to use u64 1-Hz-stepping frequencies.
>>
>> Of course the changes at the drivers is out of the scope, but perhaps
>> we should not apply patch 4/7, replacing it, instead, by some patch that
>> would move the frequency size to u64.
> 
> Frequency is defined by that structure.
> 
> struct v4l2_frequency {
> 	__u32	tuner;
> 	__u32	type;	/* enum v4l2_tuner_type */
> 	__u32	frequency;
> 	__u32	reserved[8];
> };
> 
> 
> Is it possible to somehow use reserved bytes to extend value to 64. Then 
> change that 1-Hz flag (rename it) to signal it is 64?
> 
> Or add some info to that struct itself? Define both frequency and 
> frequency64 and use the one which is not zero?
> 
> If implementation will not be very complex I could try to do it it the 
> same time with other changes.

I'm inclined not to make any changes. If 32 bits becomes insufficient, then
I would just add a "__u32 frequency_high" field to store the top 32 bits. Or
would "frequency_msb" be a better name?

While I do like the idea to use a 64-bit frequency internally, I am afraid
of touching existing frequency calculation code. It is too easy to make
mistakes and introduce regressions when converting from 62.5 Hz or kHz
units to 1 Hz units.

Personally I do not think it is worth the effort. There is a clean way
of going to 64 bit frequencies should we need it in the future, but that's
not needed today. Note that going to 64 bit frequencies would also require
changes to struct v4l2_tuner and struct v4l2_frequency_band for the rangelow
and rangehigh frequencies.

There is room in both for rangelow_msb and rangehigh_msb fields, so we are
good there. Hmm, an _msb suffix would be better than a _high suffix:
rangehigh_high looks really weird :-)

Regards,

	Hans
