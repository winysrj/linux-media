Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:2154 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0AECcT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 21:32:19 -0500
Message-ID: <4B42A498.10801@toaster.net>
Date: Mon, 04 Jan 2010 18:31:52 -0800
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: bugzilla-daemon@bugzilla.kernel.org
CC: moinejf@free.fr, Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [Bug 14564] capture-example sleeping function called from invalid
 context at arch/x86/mm/fault.c
References: <bug-14564-16732@http.bugzilla.kernel.org/> <201001030702.o0372phV004707@demeter.kernel.org>
In-Reply-To: <201001030702.o0372phV004707@demeter.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=14564
>
>
> Jean-Francois Moine <moinejf@free.fr> changed:
>
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |moinejf@free.fr
>
>
>
>
> --- Comment #22 from Jean-Francois Moine <moinejf@free.fr>  2010-01-03 07:02:45 ---
> Hello Sean,
>
> Sorry to be a bit late. Looking at the dmesg, I found that the gspca version
> was 2.7.0. May you upgrade your linux media stuff from LinuxTv.org and check if
> this problem still occurs?
>
> Jef
>   
Jef,

I upgraded to the latest v4l-dvb from http://linuxtv.org/hg/v4l-dvb, 
made the kernel modules, made the v4l libraries, and recompiled 
capture-example.c. Gspca now shows 2.8.0. The error still persists. Alan 
Stern's latest patch to ohci-q.c traps the error. I think it is an issue 
with the cpu or usb controller on the Vortex86SX SoC.

Sean
