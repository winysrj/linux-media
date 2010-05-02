Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:35668 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab0EBRZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 13:25:18 -0400
Received: by ywh36 with SMTP id 36so812926ywh.4
        for <linux-media@vger.kernel.org>; Sun, 02 May 2010 10:25:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005012312.14082.hverkuil@xs4all.nl>
References: <201005012312.14082.hverkuil@xs4all.nl>
Date: Sun, 2 May 2010 13:25:16 -0400
Message-ID: <k2w829197381005021025ra9b453bfv54900a16ae5fb580@mail.gmail.com>
Subject: Re: em28xx & sliced VBI
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 1, 2010 at 5:12 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi all,
>
> I played a bit with my HVR900 and tried the sliced VBI API. Unfortunately I
> discovered that it is completely broken. Part of it is obvious: lots of bugs
> and code that does not follow the spec, but I also wonder whether it ever
> actually worked.
>
> Can anyone shed some light on this? And is anyone interested in fixing this
> driver?
>
> I can give pointers and help with background info, but I do not have the time
> to work on this myself.
>
> Regards,
>
>        Hans

Hi Hans,

I did the em28xx raw VBI support, and I can confirm that the sliced
support is completely broken.  I just forgot to send the patch
upstream which removes it from the set of v4l2 capabilities advertised
for the device.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
