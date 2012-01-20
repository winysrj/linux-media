Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49319 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab2ATQQd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 11:16:33 -0500
Received: by vcbfo1 with SMTP id fo1so458832vcb.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 08:16:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJySFW+2FOjFEGyitbnNQBdaZ56RhGbZh0u4XhJ_8-7VgKe_cw@mail.gmail.com>
References: <CAJySFW+2FOjFEGyitbnNQBdaZ56RhGbZh0u4XhJ_8-7VgKe_cw@mail.gmail.com>
Date: Fri, 20 Jan 2012 11:16:32 -0500
Message-ID: <CAGoCfiyONO-oY11Umo8GPPB9R3RwPJ7ADFiEyy7mAPBJqu8zUA@mail.gmail.com>
Subject: Re: Remote control driver issue
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tayeb Meftah <tayeb.meftah@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 20, 2012 at 11:14 AM, Tayeb Meftah <tayeb.meftah@gmail.com> wrote:
> Hello folks,
> i am a linux-TV newby;
> dreaming to get my vdr up and runing for up to 4month
> i am a blind user and have a limited access to the linux machine due
> to my blindness, i access windows normaly, then ssh to linux (*SORY
> FOR THAT*)
> so,
> i set up my debian machine correctly, runing, dbvb card detected,
> scaned, working through multicast using mumuDVB
> thank a lot to the #linuxtv people on freenode
> they helped me a lot so i should return something:)
> i installed v4l into my debian machine
> if i do make load my remote control get detected
> but if i reboot;
> Couldn't find any node at /sys/class/rc/rc*.
> so please how to make it auto loadable?
> i should do that every time my pc reboot, make load
> thank you a lot
> BTW, can i help with mailing list moderation ?

What tuner are you using?  That is a very important piece of
information since it tells us what drivers are involved for the IR
support.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
