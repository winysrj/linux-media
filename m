Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33252 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbbK0RtM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 12:49:12 -0500
MIME-Version: 1.0
In-Reply-To: <20151127131843.0416fe2b@recife.lan>
References: <20151127050026.GX22011@ZenIV.linux.org.uk>
	<20151127131843.0416fe2b@recife.lan>
Date: Fri, 27 Nov 2015 09:49:11 -0800
Message-ID: <CA+55aFw-9Y6c-wgiXkyFuce7bqA-RQsRUuW6wC42ayoN4nVo6g@mail.gmail.com>
Subject: Re: ->poll() instances shouldn't be indefinitely blocking
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 27, 2015 at 7:18 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Al Viro <viro@ZenIV.linux.org.uk> escreveu:
>
>> Take a look at this:
>> static unsigned int gsc_m2m_poll(struct file *file,
>>                                         struct poll_table_struct *wait)
>> {
>>         struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
>>         struct gsc_dev *gsc = ctx->gsc_dev;
>>         int ret;
>>
>>         if (mutex_lock_interruptible(&gsc->lock))
>>                 return -ERESTARTSYS;
>>
>>         ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
>>         mutex_unlock(&gsc->lock);
>>
>>         return ret;
>> }
>>
>> a) ->poll() should not return -E...; callers expect just a bitmap of
>> POLL... values.
>
> Yeah. We fixed issues like that on other drivers along the time. I guess
> this is a some bad code that people just cut-and-paste from legacy drivers
> without looking into it.

Actually, while returning -ERESTARTSYS is bogus, returning _zero_
would not be. The top-level poll() code will happily notice the
signal, and return -EINTR like poll should (unless something else is
pending, in which case it will return zero and the bits set for that
something else).

So having a driver with a ->poll() function that does that kind of
conditional locking is not wrong per se. It's just he return value
that is crap.

I also do wonder if we might not make the generic code a bit more
robust wrt things like this. The bitmask we use is only about the low
bits, so we *could* certainly allow the driver poll() functions to
return errors - possibly just ignoring them. Or perhaps have a
WARN_ON_OCNE() to find them.

Al, what do you think? The whole "generic code should be robust wrt
drivers making silly mistakes" just sounds like a good idea. Finding
these things through code inspection is all well and good, but having
a nice warning report from users might be even better.

                Linus
