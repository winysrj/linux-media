Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53549 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0CGRzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 12:55:04 -0500
Received: by vws9 with SMTP id 9so2455041vws.19
        for <linux-media@vger.kernel.org>; Sun, 07 Mar 2010 09:55:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B91CE02.4090200@redhat.com>
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>
	 <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu>
	 <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com>
	 <4B91AADD.4030300@xenotime.net> <4B91CE02.4090200@redhat.com>
Date: Sun, 7 Mar 2010 09:55:00 -0800
Message-ID: <a3ef07921003070955q7d7ce7e8j747c07d56a0ad98e@mail.gmail.com>
Subject: Re: "Invalid module format"
From: VDR User <user.vdr@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 5, 2010 at 7:37 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> I suspect that it may be related to this:
>
> # Select 32 or 64 bit
> config 64BIT
>        bool "64-bit kernel" if ARCH = "x86"
>        default ARCH = "x86_64"
>        ---help---
>          Say yes to build a 64-bit kernel - formerly known as x86_64
>          Say no to build a 32-bit kernel - formerly known as i386
>
> With 2.6.33, it is now possible to compile a 32 bits kernel on a 64 bits
> machine without needing to pass make ARCH=i386 or to use cross-compilation.
>
> Maybe you're running a 32bits kernel, and you've compiled the out-of-tree
> modules with 64bits or vice-versa.
>
> My suggestion is that you should try to force the compilation wit the proper
> ARCH with something like:
>        make distclean
>        make ARCH=`uname -i`
>        make ARCH=`uname -i` install

I had forgot to reply to this but while I do have a 64bit capable cpu,
I compile & use only 32bit.
