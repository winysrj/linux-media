Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m78Ea0mQ007626
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 10:36:00 -0400
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m78EZmEA006751
	for <video4linux-list@redhat.com>; Fri, 8 Aug 2008 10:35:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Fri, 8 Aug 2008 16:35:39 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808081635.39745.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: RFC: removal of the miroSOUND PCM20 radio module
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi all,

I noticed that the miroSOUND PCM20 radio module is no longer compiled in 
the kernel. After some digging I discovered that the ACI mixer module 
this driver depends on was removed in 2.6.23 and it's config section 
was removed from the Kconfig starting with 2.6.20. So it can't be built 
in any kernels from 2.6.20 onwards.

Since nobody complained in all that time, and since the ACI stuff this 
driver depends on has been removed completely (so no easy fix for 
this), I propose that this module is removed as well, together with the 
aci.[ch] files that were copied to v4l-dvb, apparently to allow this 
driver to be compiled from v4l-dvb.

If there are no objections, then I'll try to contact the original 
author(s) to see if they are OK with it.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
