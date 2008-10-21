Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LLdNYi028603
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 17:39:23 -0400
Received: from eldar.vidconference.de (dns.vs-node5.de [87.106.133.120])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LLd2BS022205
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 17:39:03 -0400
Date: Tue, 21 Oct 2008 23:39:00 +0200
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20081021213859.GH28699@vidsoft.de>
References: <48F335D9.5020104@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F335D9.5020104@hhs.nl>
From: Gregor Jasny <jasny@vidsoft.de>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: libv4l release: 0.5.1 (The Skype release)
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

On Mon, Oct 13, 2008 at 01:49:45PM +0200, Hans de Goede wrote:
> After much frustration about the very poor implementation of v4l in skype, 
> I'm
> happy to announce libv4l-0.5.1, in which after much pain, I've managed to
> implemented a fix for the skype problem in a way which does not make me 
> feel dirty.

With the just submitted ioctl compat patch, this works even with 32 bit
Skype on 64 bit Linux. The soon to be available Debian packages will
provide a cross compiled version of your lib, too. There's a public git
repository available at: http://git.debian.org/?p=collab-maint/libv4l.git

Thanks for your highly appreciated work,
Gregor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
