Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAR9fw3o000571
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 04:41:58 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAR9fkc1012005
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 04:41:46 -0500
Date: Thu, 27 Nov 2008 07:41:39 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20081127074139.25d2c576@pedra.chehab.org>
In-Reply-To: <200811270832.22341.hverkuil@xs4all.nl>
References: <200811270832.22341.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: RFC: drop support for kernels < 2.6.22
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

On Thu, 27 Nov 2008 08:32:22 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi all,
> 
> It been my opinion for quite some time now that we are too generous in 
> the number of kernel versions we support. I think that the benefits no 
> longer outweight the effort we have to put in.
> 
> This is true in particular for the i2c support since that changed a lot 
> over time. Kernel 2.6.22 is a major milestone for that since it 
> introduced the new-style i2c API.

I prefer to keep backward compat with older kernels. Enterprise distros like
RHEL is shipped with older kernels (for example RHEL5 uses kernel 2.6.18). We
should support those kernels.

> In order to keep the #ifdefs to a minimum I introduced the 
> v4l2-i2c-drv.h and v4l2-i2c-drv-legacy.h headers. These make sense when 
> used in the v4l-dvb tree context, but when they are stripped and used 
> in the actual kernel source they look very weird.

We may use a different approach for the above files. For example, we may
include the headers just for older kernels, like we did in the past with i2c
backward compat with kernel 2.4. gentree can easily remove a #include line from
the upstream patch.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
