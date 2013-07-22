Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48527 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab3GVTsx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 15:48:53 -0400
Received: by mail-we0-f174.google.com with SMTP id q54so1174841wes.19
        for <linux-media@vger.kernel.org>; Mon, 22 Jul 2013 12:48:52 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 22 Jul 2013 15:48:52 -0400
Message-ID: <CAGoCfiyGJQFCrqaSW3da7YUjL7hEFvun0YgZr6vJL6pstu8q2g@mail.gmail.com>
Subject: Expected behavior for S_INPUT while streaming in progress?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm doing some cleanup on the au8522 driver, and one thing I noticed
was that you are actually allowed to issue an S_INPUT while streaming
is active.  This seems like dangerous behavior, since it can result in
things like the standard and/or resolution changing while the device
is actively streaming video.

Should we be returning -EBUSY for S_INPUT if streaming is in progress?
 I see cases in drivers where we prevent S_STD from working while
streaming is in progress, but it seems like S_INPUT is a superset of
S_STD (it typically happens earlier in the setup process).

If we did do this, how badly do we think it would break existing
applications?  It could require applications to do a STREAMOFF before
setting the input (to handle the possibility that the call wasn't
issued previously when an app was done with the device), which I
suspect many applications aren't doing today.

Alternatively, we can based it on not just whether streamon was called
and instead base it on the combination of streamon having been called
and a filehandle actively doing streaming.  In this case case would
return EBUSY if both conditions were met, but if only streamon was
called but streaming wasn't actively being done by a filehandle, we
would internally call streamoff and then change the input.  This would
mean that if an application like tvtime were running, externally
toggling the input would return EBUSY.  But if nothing was actively
streaming via a /dev/videoX device then the call to set input would be
successful (after internally stopping the stream).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
