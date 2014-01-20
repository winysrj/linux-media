Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:52474 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaATTI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 14:08:58 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZP00GR1RUX7A80@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Jan 2014 14:08:58 -0500 (EST)
Date: Mon, 20 Jan 2014 17:08:52 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "=?UTF-8?B?Sm/Do28=?= M. S. Silva" <joao.m.santos.silva@gmail.com>
Cc: v4l2-library@linuxtv.org, LMML <linux-media@vger.kernel.org>
Subject: Re: [V4l2-library] Valgrind error
Message-id: <20140120170852.63989be3@samsung.com>
In-reply-to: <CAAv-bCyHxjKvbhBRoALOiLis4OGvqPaxuwWqgavbTA+ofj6wmA@mail.gmail.com>
References: <CAAv-bCyHxjKvbhBRoALOiLis4OGvqPaxuwWqgavbTA+ofj6wmA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi João,

Better to report it to linux-media@vger.kernel.org, as I suspect that almost
nobody is using v4l2-library ML anymore.

Regards,
Mauro

Em Mon, 20 Jan 2014 16:24:36 +0000
João M. S. Silva <joao.m.santos.silva@gmail.com> escreveu:

> Hi,
> 
> I faced the Valgrind error described in
> https://bugs.launchpad.net/ubuntu/+source/libv4l/+bug/432477 and
> reported it: https://bugs.kde.org/show_bug.cgi?id=330180
> 
> But then I also tried v4l version 1.0.1 and it seems to me that the
> above mentioned error was corrected, but another exists:
> 
> ==15368== Syscall param ioctl(generic) points to uninitialised byte(s)
> ==15368==    at 0x439EFB7: syscall (syscall.S:30)
> ==15368==    by 0x4488F52: dev_ioctl (libv4lconvert.c:43)
> ==15368==    by 0x44A0BF1: v4lcontrol_create (libv4lcontrol.c:591)
> ==15368==    by 0x44897FF: v4lconvert_create_with_dev_ops (libv4lconvert.c:217)
> ==15368==    by 0x4037BDF: v4l2_fd_open (libv4l2.c:666)
> ==15368==    by 0x42CB904: (below main) (libc-start.c:260)
> ==15368==  Address 0xbe8c5bc4 is on thread 1's stack
> ==15368==  Uninitialised value was created by a stack allocation
> ==15368==    at 0x44A0161: v4lcontrol_create (libv4lcontrol.c:566)
> ==15368==
> ==15368== Syscall param ioctl(generic) points to uninitialised byte(s)
> ==15368==    at 0x439EFB7: syscall (syscall.S:30)
> ==15368==    by 0x4488F52: dev_ioctl (libv4lconvert.c:43)
> ==15368==    by 0x44A02D9: v4lcontrol_create (libv4lcontrol.c:630)
> ==15368==    by 0x44897FF: v4lconvert_create_with_dev_ops (libv4lconvert.c:217)
> ==15368==    by 0x4037BDF: v4l2_fd_open (libv4l2.c:666)
> ==15368==    by 0x42CB904: (below main) (libc-start.c:260)
> ==15368==  Address 0xbe8c6018 is on thread 1's stack
> ==15368==  Uninitialised value was created by a stack allocation
> ==15368==    at 0x44A0161: v4lcontrol_create (libv4lcontrol.c:566)
> 
> Is this correct?
> 
> Thanks.
> 


-- 

Cheers,
Mauro
