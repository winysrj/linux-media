Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MJP56k015357
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 15:25:05 -0400
Received: from web63002.mail.re1.yahoo.com (web63002.mail.re1.yahoo.com
	[69.147.96.213])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6MJOp2x022311
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 15:24:51 -0400
Date: Tue, 22 Jul 2008 12:24:46 -0700 (PDT)
From: Fritz Katz <frtzkatz@yahoo.com>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
In-Reply-To: <488619C9.6000806@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <239674.31754.qm@web63002.mail.re1.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: xawtv fails to compile with quicktime
Reply-To: frtzkatz@yahoo.com
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

Hello Hans de Goede,

OK, I'll volunteer to support xawtv.  It's sad when a good program becomes an un-loved orphan. :-)

I just started a project last week to support Video-4-Linux applications and drivers on the various *BSDs -- xawtv-3.96 could be the first application released by the project: 

    http://video4bsd.sourceforge.net/

My plan is to go from xawtv-3.95 -> xawtv-3.96 by applying all the  available patches including the one you pointed me at below. 

After that, if there's interest, we can look at the work that was done for the xawtv-4.x-snapshot.  

I can test on FreeBSD and Fedora-8, I'll need help testing on the other distros.

Regards,
-- Fritz Katz
____________________________________

--- Hans de Goede wrote:
>
> <snip>
> 
> > Unfortunately, the various distros make releases with
> multiple patches for problems -- but don't send fixes
> back upstream. FreeBSD-7 has 10 patches on xawtv-3.95. Some
> of these might be important bugfixes. If someone's
> interested, I can zip them up and email them to you.
> > 
> 
> AFAIK xawtv upstream is mostly dead, which is the mean
> reason why those patches 
> are not getting integrated upstream.
> 
> It would be good for someone to pick up doing xawtv
> upstream work, you can request a sf.net (or something 
> similar) project for it, import the latest 
> version there, then apply a set of patches from a distro of
> choice and then start asking distribution maintainers to 
> merge their patch set with your new xawtv.
> 
> If you do this I will poke the Fedora maintainer to get his
> patches integrated and if he doesn't I'll happily do it myself.
> 
> Also look here for a small (but somewhat important) bugfix
> patch to xawtv:
> http://linuxtv.org/hg/v4l-dvb/file/f445674ce0d2/v4l2-apps/lib/libv4l/appl-patches/xawtv-3.95-fixes.patch
> 
> Regards,
> 
> Hans


      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
