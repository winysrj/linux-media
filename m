Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60663 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1EBTkF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 15:40:05 -0400
Received: by ewy4 with SMTP id 4so1853351ewy.19
        for <linux-media@vger.kernel.org>; Mon, 02 May 2011 12:40:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DBF0791.5070805@redhat.com>
References: <E1QGwlS-0006ys-15@www.linuxtv.org>
	<201105022111.40604.hverkuil@xs4all.nl>
	<4DBF0791.5070805@redhat.com>
Date: Mon, 2 May 2011 15:40:04 -0400
Message-ID: <BANLkTikLRwg=Q2wdMZ_O7w7YX40Rni_JyA@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw
 YUV video capture
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, May 2, 2011 at 3:35 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 02-05-2011 16:11, Hans Verkuil escreveu:
>> NACK.
>>
>> For two reasons: first of all it is not signed off by Andy Walls, the cx18
>> maintainer. I know he has had other things on his plate recently which is
>> probably why he hasn't had the chance to review this.
>>
>> Secondly, while doing a quick scan myself I noticed that this code does a
>> conversion from UYVY format to YUYV *in the driver*. Format conversion is
>> not allowed in the kernel, we have libv4lconvert for that. So at the minimum
>> this conversion code must be removed first.
>
> Patch is there at the ML since Apr, 6 and nobody acked/nacked it. If you or
> andy were against it, why none of you commented it there?
>
> Now that the patch were committed, I won't revert it without a very good reason.
>
> With respect to the "conversion from UYVY format to YUYV", a simple patch could
> fix it, instead of removing the entire patchset.
>
> Steven/Simon,
> could you please work on such change?

Simon,

If you're willing to do a bit of work to actually prepare the patch
and test the results, I can walk you through pretty much exactly what
needs to change (basically you just need to remove one block of code
and change a #define).

Steven has been really busy with other stuff, so I don't think we
should count on his participation in this process.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
