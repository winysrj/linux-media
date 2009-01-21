Return-path: <linux-media-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:33666 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbZAUBlQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 20:41:16 -0500
Subject: Confusion in usr/include/linux/videodev.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	video4linux-list@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
	Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 07:10:38 +0530
Message-Id: <1232502038.3123.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usr/include/linux/videodev.h is giving 2 warnings in 'make headers_check':
 usr/include/linux/videodev.h:19: leaks CONFIG_VIDEO to userspace where it is not valid
 usr/include/linux/videodev.h:314: leaks CONFIG_VIDEO to userspace where it is not valid

Whole file is covered with #if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)

It means this file is only valid for kernel mode if CONFIG_VIDEO_V4L1_COMPAT is defined but in user mode it is always valid.
		
Can we choose some better alternative Or can we use this file as:

#ifdef CONFIG_VIDEO_V4L1_COMPAT
#include <linux/videodev.h>
#endif


Thanks
--
JSR


