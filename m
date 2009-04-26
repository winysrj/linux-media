Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:49794 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZDZEzb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 00:55:31 -0400
Message-ID: <49F3E917.70604@freemail.hu>
Date: Sun, 26 Apr 2009 06:54:47 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l2: fill the unused fields with zeros in case of VIDIOC_S_FMT
References: <49F2C59A.9010703@freemail.hu> <Pine.LNX.4.58.0904251045070.3753@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0904251045070.3753@shell2.speakeasy.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho wrote:
> On Sat, 25 Apr 2009, [UTF-8] Németh Márton wrote:
>> The VIDIOC_S_FMT is a write-read ioctl: it sets the format and returns
>> the current format in case of success. The parameter of VIDIOC_S_FMT
>> ioctl is a pointer to struct v4l2_format. [1] This structure contains some
>> fields which are not used depending on the .type value. These unused
>> fields are filled with zeros with this patch.
> 
> It's a union, so it's not really the case the the fields are unused.  If
> it's a non-private format, the structure will have some empty padding space
> at the end of the structure after the last field for the format's type.

Maybe I used the wrong word: my intention was to clear the unused padding bytes
at the end of the fmt union.

> Since it's just padding space and there are no fields defined, I don't
> think we have to clear it.

Think about a case when in a future kernel version one additional field
is defined for example for struct v4l2_pix_format. Then an application is
built with this extended structure. When the application runs on an older
kernel then this new field will be not touched by the older kernel in other
words the last field(s) of struct v4l2_pix_format will be uninitialized.

The other reason why I think is useful to fill the padding bytes with zero
is that this prevents doing dirty tricks between the application and the
driver, for example communicating through padding bytes in case of a
non-private format.

>>  		struct v4l2_format *f = (struct v4l2_format *)arg;
>>
>> +#define CLEAR_UNUSED_FIELDS(data, last_member) \
>> +	memset(((u8 *)f)+ \
>> +		offsetof(struct v4l2_format, fmt)+ \
>> +		sizeof(struct v4l2_ ## last_member), \
>> +		0, \
>> +		sizeof(*f)- \
>> +		offsetof(struct v4l2_format, fmt)+ \
>> +		sizeof(struct v4l2_ ## last_member))
>> +
> 
> What is "data" used for?  The length in your memset is wrong.  You didn't
> run this through "make patch" did you?  Because there are spacing/formatting
> errors that that would have caught.

Thank you for pointing out these problems. I'll send an update soon.

I don't know anything about "make patch", but I have run the
linux/scripts/checkpatch.pl against my patch and it found the patch OK.

Regards,

	Márton Németh
