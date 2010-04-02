Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34932 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0DBOW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 10:22:29 -0400
Received: by gwb19 with SMTP id 19so157901gwb.19
        for <linux-media@vger.kernel.org>; Fri, 02 Apr 2010 07:22:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <y2w994f7fe91004020715o18226cfdt565a7f40582e537a@mail.gmail.com>
References: <y2w994f7fe91004020715o18226cfdt565a7f40582e537a@mail.gmail.com>
Date: Fri, 2 Apr 2010 10:22:28 -0400
Message-ID: <y2v829197381004020722w496f5220y6c1f776c3b89ef21@mail.gmail.com>
Subject: Re: em28xx vbi read timeout
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tim Stowell <stowellt@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 2, 2010 at 10:15 AM, Tim Stowell <stowellt@gmail.com> wrote:
> Hi,
>
> I have a KWorld usb 2800D device and am using the newest em28xx
> v4l-dvb drivers from linuxtv.org. I'm running Gentoo with a 2.6.31
> kernel. The driver compiles fine, and then I issue the following
> commands:
>
> v4lctl setnorm NTSC
> zvbi-ntsc-cc -c -d /dev/vbio -v
>
>
> after that I just get constant "VBI Read Timeout (Ignored)" messages.
> Any help is greatly appreciated. (I initially posted this question to
> the kernellabs blog, I apologize I didn't know there was a mailing
> list at the time, so I'm posting my question here now.) Thanks

Hi Tim,

Yeah, I'm a couple of hours behind on the blog postings and just
getting caught up on email.  I just sent a reply now.

http://www.kernellabs.com/blog/?p=755#comment-1344

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
