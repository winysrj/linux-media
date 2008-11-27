Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARENQUv005052
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 09:23:26 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAREMsnN004390
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 09:23:10 -0500
Received: by qw-out-2122.google.com with SMTP id 3so225393qwe.39
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 06:22:54 -0800 (PST)
Date: Thu, 27 Nov 2008 12:22:49 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20081127122249.7063d255@gmail.com>
In-Reply-To: <20081127074139.25d2c576@pedra.chehab.org>
References: <200811270832.22341.hverkuil@xs4all.nl>
	<20081127074139.25d2c576@pedra.chehab.org>
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

Hello,

On Thu, 27 Nov 2008 07:41:39 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> On Thu, 27 Nov 2008 08:32:22 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
> > Hi all,
> > 
> > It been my opinion for quite some time now that we are too generous
> > in the number of kernel versions we support. I think that the
> > benefits no longer outweight the effort we have to put in.
> > 
> > This is true in particular for the i2c support since that changed a
> > lot over time. Kernel 2.6.22 is a major milestone for that since it 
> > introduced the new-style i2c API.
> 
> I prefer to keep backward compat with older kernels. Enterprise
> distros like RHEL is shipped with older kernels (for example RHEL5
> uses kernel 2.6.18). We should support those kernels.

Agreed. I'm using 2.6.18 kernel on some of my machines.
 
Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
