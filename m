Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:39416 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2LXK4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 05:56:07 -0500
Received: by mail-bk0-f48.google.com with SMTP id jc3so3225415bkc.7
        for <linux-media@vger.kernel.org>; Mon, 24 Dec 2012 02:56:05 -0800 (PST)
Message-ID: <50D834D6.7080207@googlemail.com>
Date: Mon, 24 Dec 2012 11:56:22 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patch update notification: 37 patches updated
References: <20121223000802.14820.14465@www.linuxtv.org> <50D70AFB.5070702@googlemail.com> <20121223125715.782e17e0@redhat.com>
In-Reply-To: <20121223125715.782e17e0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.12.2012 15:57, schrieb Mauro Carvalho Chehab:
> Em Sun, 23 Dec 2012 14:45:31 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Hi Mauro,
>>
>> Am 23.12.2012 01:08, schrieb Patchwork:
>>> Hello,
>>>
>>> The following patches (submitted by you) have been updated in patchwork:
>>>
>>>  * [3/6] em28xx: fix capture type setting in em28xx_urb_data_copy_vbi()
>>>      - http://patchwork.linuxtv.org/patch/15651/
>>>     was: New
>>>     now: Accepted
>>>
>>>  * [8/9] em28xx: move the em2710/em2750/em28xx specific frame data processing code to a separate function
>>>      - http://patchwork.linuxtv.org/patch/15798/
>>>     was: New
>>>     now: Accepted
>>>
>>>  * [4/6] em28xx: fix/improve frame field handling in em28xx_urb_data_copy_vbi()
>>>      - http://patchwork.linuxtv.org/patch/15652/
>>>     was: New
>>>     now: Accepted
>> This patch has not been applied yet to the media-tree.
>> Without this patch, frame data processing for non-interlaced devices is
>> broken.
> Not sure what happened there: I couldn't see this specific patch. Yet,
> at least some of the changes there seem to be applied. My guess is that
> somehow, this patch got merged with some other patch, or maybe the
> conflicts solving when the vbi-merge patches got applied (partially)
> fixed it.
>
> In any case, you'll need to rebase it, as it doesn't apply anymore.

Ok, I did a git diff against my local version and all changes (except
the remaining i2c stuff) seem to be applied.

One thing I noticed: you fixed strings with lines > 80 characters.
This is handled differently everywhere...
I know splitting strings breaks grepping, OTOH checkpatch complains.
So you prefer violating the 80 chars rule ?

Regards,
Frank

> Cheers,
> Mauro

