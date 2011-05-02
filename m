Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47515 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1EBU7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 16:59:10 -0400
Received: by ewy4 with SMTP id 4so1872474ewy.19
        for <linux-media@vger.kernel.org>; Mon, 02 May 2011 13:59:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105022202.57946.hverkuil@xs4all.nl>
References: <E1QGwlS-0006ys-15@www.linuxtv.org>
	<201105022111.40604.hverkuil@xs4all.nl>
	<4DBF0791.5070805@redhat.com>
	<201105022202.57946.hverkuil@xs4all.nl>
Date: Mon, 2 May 2011 16:59:09 -0400
Message-ID: <BANLkTinzrccpQHk1qrDyT6VbfTPVBCGKkQ@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw
 YUV video capture
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, May 2, 2011 at 4:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> It was merged without *asking* Andy. I know he has had some private stuff to
> deal with this month so I wasn't surprised that he hadn't reviewed it yet.
>
> It would have been nice if he was reminded first of this patch. It's a
> fairly substantial change that also has user-visible implications. The simple
> fact is that this patch has not been reviewed and as a former cx18 maintainer
> I think that it needs a review first.
>
> If someone had asked and Andy wouldn't have been able to review, then I'd have
> jumped in and would have reviewed it.
>
> Andy, I hope you can look at it, but if not, then let me know and I'll do a
> more in-depth review rather than just the simple scan I did now.
>
>> Now that the patch were committed, I won't revert it without a very good reason.
>>
>> With respect to the "conversion from UYVY format to YUYV", a simple patch could
>> fix it, instead of removing the entire patchset.
>
> No, please remove the patchset because I have found two other issues:
>
> The patch adds this field:
>
>        struct v4l2_framebuffer fbuf;
>
> This is not needed, videobuf_iolock can be called with a NULL pointer instead
> of &fbuf.
>
> The patch also adds tvnorm fields, but never sets s->tvnorm. And it's
> pointless anyway since you can't change tvnorm while streaming.
>
> Given that I've found three things now without even trying suggests to me that
> it is too soon to commit this. Sorry.
>
> Regards,
>
>        Hans

Indeed comments/review are always welcome, although it would have been
great if it had happened a month ago.  It's the maintainer's
responsibility to review patches, and if he has issues to raise them
in a timely manner.  If he doesn't care enough or is too busy to
publicly say "hold off on this" for whatever reason, then you can
hardly blame Mauro for merging it.

Likewise, I know there have indeed been cases in the past where code
got upstream that caused regressions (in fact, you have personally
been responsible for some of these if I recall).

Let's not throw the baby out with the bathwater.  If there are real
structural issues with the patch, then let's get them fixed.  But if
we're just talking about a few minor "unused variable" type of
aesthetic issues, then that shouldn't constitute reverting the commit.
 Do your review, and if an additional patch is needed with a half
dozen removals of dead/unused code, then so be it.

We're not talking about an untested board profile submitted by some
random user.  We're talking about a patch written by someone highly
familiar with the chipset and it's *working code* that has been
running in production for almost a year.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
