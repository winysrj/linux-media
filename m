Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:46259 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab3JNW7H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 18:59:07 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so6790341wgh.27
        for <linux-media@vger.kernel.org>; Mon, 14 Oct 2013 15:59:05 -0700 (PDT)
Message-ID: <525C7736.4050502@gmail.com>
Date: Tue, 15 Oct 2013 00:59:02 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PULL FOR v3.13] Various fixes
References: <524E9A77.7090205@xs4all.nl> <20131014092839.6049ee6a@samsung.com>
In-Reply-To: <20131014092839.6049ee6a@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/14/2013 02:28 PM, Mauro Carvalho Chehab wrote:
>> Sylwester Nawrocki (1):
>>        v4l2-ctrls: Correct v4l2_ctrl_get_int_menu() function prototype
>
> This patch is wrong or incomplete, as it calls hundreds of warnings (see below).
> I'll just drop it:
>
> $ make ARCH=i386 CONFIG_DEBUG_SECTION_MISMATCH=y W=1 M=drivers/staging/media
>
>    WARNING: Symbol version dump /devel/v4l/patchwork/Module.symvers
>             is missing; modules will have no dependencies and modversions.
>
> In file included from include/media/v4l2-subdev.h:28:0,
>                   from include/media/v4l2-device.h:25,
>                   from drivers/staging/media/go7007/s2250-board.c:24:
> include/media/v4l2-common.h:89:19: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
>   const s64 * const v4l2_ctrl_get_int_menu(u32 id, u32 *len);

Yes, it rightfully does so, since even if the pointer is const, it will
still be modifiable, due to pass-by-value language conventions. Sorry for
wasting your time with that crappy patch, I'll post a new one with the
second 'const' removed.

Regards,
Sylwester
