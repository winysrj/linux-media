Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAR7Nbt4011662
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 02:23:37 -0500
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAR7NKGC003766
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 02:23:20 -0500
Received: by qb-out-0506.google.com with SMTP id c8so845821qbc.7
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 23:23:20 -0800 (PST)
Message-ID: <5d5443650811262323l759d8c02s835c9a7454508b85@mail.gmail.com>
Date: Thu, 27 Nov 2008 12:53:19 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>,
	"Sakari Ailus" <sakari.ailus@nokia.com>
In-Reply-To: <200811262116.42364.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>
	<200811262116.42364.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Add OMAP2 camera driver
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

Hi Hans,

>
> 1) The makefile isn't right: it compiles omap24xxcam.c and
> omap24xxcam-dma.c as two modules, but I suspect you want only one since
> the symbols that omap24xxcam.c needs from omap24xxcam-dma.c are not
> exported. See e.g. the msp3400 driver in the Makefile for how to do it.

I will make this change.

>
> 2) The Kconfig is probably missing a ARCH_OMAP dependency (sounds
> reasonable, at least), so now it also compiles for the i686 but that
> architecture doesn't have a clk_get function.

I will add this dependency.

>
> 3) I was wondering whether Sakari also wants to add a Signed-off-by
> line? Looking at the comments it seems that he was involved as well.

I CCed from the first e-mail, so that he can review and give
Signed-off-by to this patch.

>
> 4) I get a bunch of compile warnings (admittedly when compiling for
> i686) that you might want to look at. Compiled against the 2.6.27
> kernel with gcc-4.3.1. It might be bogus since I didn't compile for the
> omap architecture.

I will update my toolchain to gcc-4.3.x for ARM and see if it
generates the warnings like below. But I think we are fine once we add
ARCH_OMAP dependency to this driver.

Thanks for the review comments. I will resubmit the patch.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
