Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33159 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1BOEKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 23:10:00 -0500
Received: by iyj8 with SMTP id 8so5531250iyj.19
        for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 20:09:59 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Feb 2011 12:09:59 +0800
Message-ID: <AANLkTikXCu1OrHoYtW_3E_UciHk0Pf=kRkHtj_F_EMUt@mail.gmail.com>
Subject: There is a long delay when I use v4l2(uvc) with epoll (but select
 works well)
From: aeogiss@gmail.com
To: bill@thedirks.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is the strace result when use select

12:08:30 select(5, [4], NULL, NULL, {1, 684498}) = 1 (in [4], left {1,
648368}) <0.036166>
12:08:30 ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000024>
12:08:30 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000021>
12:08:30 select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1,
680471}) <0.319565>
12:08:30 ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000023>
12:08:30 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
12:08:30 select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1,
680356}) <0.319680>
12:08:31 ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
12:08:31 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
12:08:31 select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1,
648366}) <0.351672>
12:08:31 ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
12:08:31 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000018>
12:08:31 select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1,
680368}) <0.319669>
12:08:31 ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
12:08:31 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
12:08:31 select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1,
680367}) <0.319669>
12:08:32 ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
12:08:32 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
12:08:32 select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1,
648363}) <0.351673>
12:08:32 ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
12:08:32 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000020>
12:08:32 select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1,
680359}) <0.319679>
12:08:32 ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000023>
12:08:32 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
12:08:32 select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1,
680369}) <0.319667>
12:08:33 ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
12:08:33 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>

This is the strace result when use epoll almost 3 sec delay.

11:57:13 epoll_wait(3, {{EPOLLIN, {u32=1632530473,
u64=140734825918505}}}, 64, 4294967295) = 1 <2.942568>
11:57:16 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000021>
11:57:16 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000017>
11:57:16 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
11:57:16 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000017>
11:57:16 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
11:57:16 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
11:57:16 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:16 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = -1 EAGAIN (Resource
temporarily unavailable) <0.000017>
11:57:16 epoll_wait(3, {{EPOLLIN, {u32=1632530473,
u64=140734825918505}}}, 64, 4294967295) = 1 <2.974568>
11:57:19 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000020>
11:57:19 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000017>
11:57:19 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
11:57:19 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000017>
11:57:19 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
11:57:19 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
11:57:19 ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
11:57:19 ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = -1 EAGAIN (Resource
temporarily unavailable) <0.000016>
11:57:19 epoll_wait(3, {{EPOLLIN, {u32=1632530473,
u64=140734825918505}}}, 64, 4294967295) = 1 <2.974579>
