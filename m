Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5U9dmj5019643
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 05:39:48 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5U9dPmi013527
	for <video4linux-list@redhat.com>; Mon, 30 Jun 2008 05:39:25 -0400
Date: Mon, 30 Jun 2008 11:39:10 +0200
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20080630093910.GH18818@vidsoft.de>
References: <4867F380.1040803@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4867F380.1040803@hhs.nl>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Subject: Re: Announcing libv4l 0.3.1 aka "the vlc release"
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

Hi,

and another patch. The sar instruction allows only an immediate or cl as
shift width.

Thanks,
Gregor


Index: libv4lconvert/jidctflt.c
===================================================================
RCS file: /var/cvs/vidsoft/extern/libv4l/libv4lconvert/jidctflt.c,v
retrieving revision 1.1
diff -r1.1 jidctflt.c
95c95
<       : "0"(x), "Ir"(shift), "ir"(1UL<<(shift-1)), "r" (0xff), "r" (0)
---
>       : "0"(x), "Ic"((unsigned char)shift), "ir"(1UL<<(shift-1)), "r" (0xff), "r" (0)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
