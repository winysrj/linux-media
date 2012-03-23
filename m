Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe09.c2i.net ([212.247.155.2]:54087 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754526Ab2CWHcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 03:32:16 -0400
Received: from [176.74.212.201] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe09.swip.net (CommuniGate Pro SMTP 5.4.2)
  with ESMTPA id 79859403 for linux-media@vger.kernel.org; Fri, 23 Mar 2012 08:21:17 +0100
From: Hans Petter Selasky <hselasky@c2i.net>
To: linux-media@vger.kernel.org
Subject: Question about V4L2_MEMORY_USERPTR
Date: Fri, 23 Mar 2012 08:19:45 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203230819.45385.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a question about V4L2_MEMORY_USERPTR:

>From which context are the kernel's "copy_to_user()" functions called in 
relation to V4L2_MEMORY_USERPTR ? Can this be a USB callback function or is it 
only syscalls, like read/write/ioctl that are allowed to call "copy_to_user()" 
?

The reason for asking is that I am maintaining a userland port of the media 
tree's USB drivers for FreeBSD. At the present moment it is not allowed to 
call copy_to_user() or copy_from_user() unless the backtrace shows a syscall, 
so the V4L2_MEMORY_USERPTR feature is simply removed and disabled. I'm 
currently thinking how I can enable this feature.

--HPS
