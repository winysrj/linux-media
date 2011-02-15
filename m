Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx12.extmail.prod.ext.phx2.redhat.com
	[10.5.110.17])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1F9lpsJ023240
	for <video4linux-list@redhat.com>; Tue, 15 Feb 2011 04:47:51 -0500
Received: from mail-iw0-f174.google.com (mail-iw0-f174.google.com
	[209.85.214.174])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1F9ldOE025257
	for <video4linux-list@redhat.com>; Tue, 15 Feb 2011 04:47:39 -0500
Received: by iwn9 with SMTP id 9so6131569iwn.33
	for <video4linux-list@redhat.com>; Tue, 15 Feb 2011 01:47:39 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Feb 2011 17:47:39 +0800
Message-ID: <AANLkTimMb2KvmP5Lf7NxcnX3w9ji6chD1QxPqBEpAQmS@mail.gmail.com>
Subject: There is a long delay when I use v4l2(uvc) with epoll (but select
	works well)
From: xinglp <xinglp@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

This is the strace result when use select

select(5, [4], ...) = 1 (in [4], left {1, 648368}) <0.036166>
ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000024>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000021>
select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1, 680471}) <0.319565>
ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000023>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1, 680356}) <0.319680>
ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1, 648366}) <0.351672>
ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000018>
select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1, 680368}) <0.319669>
ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1, 680367}) <0.319669>
ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1, 648363}) <0.351673>
ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000020>
select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1, 680359}) <0.319679>
ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000023>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>
select(5, [4], NULL, NULL, {2, 0}) = 1 (in [4], left {1, 680369}) <0.319667>
ioctl(4, VIDIOC_DQBUF, 0x7fffbe72ce50) = 0 <0.000022>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fffbe72ce50) = 0 <0.000019>

This is the strace result when use epoll almost 3 sec delay.

epoll_wait(3, {{EPOLLIN, ...}}, 64, 4294967295) = 1 <2.942568>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000021>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = -1 EAGAIN  <0.000017>
epoll_wait(3, {{EPOLLIN, ...}}, 64, 4294967295) = 1 <2.974568>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000020>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = 0 <0.000017>
ioctl(4, VIDIOC_QBUF or VT_SETACTIVATE, 0x7fff614e6b50) = 0 <0.000016>
ioctl(4, VIDIOC_DQBUF, 0x7fff614e6b50) = -1 EAGAIN  <0.000016>
epoll_wait(3, {{EPOLLIN, ...}}, 64, 4294967295) = 1 <2.974579>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
