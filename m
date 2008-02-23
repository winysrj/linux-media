Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1N504KR004844
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 00:00:04 -0500
Received: from mail6.sea5.speakeasy.net (mail6.sea5.speakeasy.net
	[69.17.117.8])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1N4xU6D014511
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 23:59:30 -0500
Date: Fri, 22 Feb 2008 20:59:24 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <20080222223933.GA26113@plankton>
Message-ID: <Pine.LNX.4.58.0802222057530.30835@shell2.speakeasy.net>
References: <20080222223933.GA26113@plankton>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4lm <v4l-dvb-maintainer@linuxtv.org>, v4l <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH][RFC] make kernel-links compile by
 adding version.h
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

On Fri, 22 Feb 2008, Brandon Philips wrote:
> Many people have been complaining about kernel-links not working with
> UVC.  I tried to look into it but I couldn't even get kernel-links to
> compile on 2.6.25-rc2 without these changes... am I doing something
> wrong?

The v4l-dvb build system adds version.h as a gcc command line flag.  That
way otherwise useless (because the compat stuff is stripped) includes of
version.h don't need to be placed in the source in the kernel.

Try adding -include version.h to EXTRA_CFLAGS

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
