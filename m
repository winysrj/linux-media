Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail44.e.nsc.no ([193.213.115.44]:42420 "EHLO mail44.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZDBHWz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 03:22:55 -0400
From: "Stian Skjelstad" <stian@nixia.no>
To: "'Jean-Francois Moine'" <moinejf@free.fr>
Cc: <linux-media@vger.kernel.org>
References: <1238347504.5232.17.camel@laptop> <20090402091112.5411b711@free.fr>
In-Reply-To: <20090402091112.5411b711@free.fr>
Subject: RE: gpsca kernel BUG when disconnecting camera while streaming with mmap (2.6.29-rc8)
Date: Thu, 2 Apr 2009 09:22:41 +0200
Message-ID: <000301c9b363$d0533ce0$70f9b6a0$@no>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: no
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Stian Skjelstad <stian@nixia.no> wrote:
> 	[snip]
> > usb 2-2: USB disconnect, address 47
>> gspca: urb status: -108
>> gspca: urb status: -108
>> gspca: disconnect complete
>> BUG: unable to handle kernel NULL pointer dereference at 00000014
>> IP: [<c02bc98e>] usb_set_interface+0x1e/0x1e0
>> *pde = 00000000 
>> Oops: 0000 [#1] PREEMPT 
>	[snip]
>
>You did not tell which version of gspca you use. If it is the one of a
>kernel older than 2.6.30, you should update. Also, may this problem
>be reproduced?

I'm using the built in one. I'm going to upgrade to 2.6.29 very soon. And if
problem still persists, I can build gspca outside the kernel instead.

Yes, the error happens often, and the process attached to it stucks in
kernel mode, being unkillable (not even SIGKILL, followed be a SIGCONT
helps). I believe it stucks with ioctl DQUE call; I'll do a strace later
when I get the time available. 

The USB ports available are USB 1.1 only (old laptop).

