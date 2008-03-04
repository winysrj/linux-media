Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24KGRhu030604
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 15:16:27 -0500
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m24KFtB4021191
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 15:15:55 -0500
Received: by el-out-1112.google.com with SMTP id n30so1342929elf.7
	for <video4linux-list@redhat.com>; Tue, 04 Mar 2008 12:15:54 -0800 (PST)
Date: Tue, 4 Mar 2008 12:14:20 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080304201420.GB3817@plankton.ifup.org>
References: <54fa1a0d9c5bcdfcb2ba.1204098881@localhost>
	<20679.1204128530@vena.lwn.net>
	<20080228025651.GA16322@plankton.ifup.org>
	<20080229063458.0f49ddb0@areia>
	<20080303081305.GA18774@plankton.ifup.org>
	<20080304104516.21fcf30f@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304104516.21fcf30f@gaivota>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] v4l: Deadlock in videobuf-core for DQBUF waiting on QBUF
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

On 10:45 Tue 04 Mar 2008, Mauro Carvalho Chehab wrote:
> On Mon, 3 Mar 2008 00:13:05 -0800 Brandon Philips <brandon@ifup.org>
> wrote:
>
> About your testing program, it would be a good idea to add it at
> v4l2-apps/test dir. The original non-threaded code from V4L2 specs is
> also there.

I will add some polish and just add in the pthread stuff to the original
program.  It is super hacky right now.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
