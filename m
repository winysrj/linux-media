Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MJu8MY006300
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 15:56:08 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6MJtvrt009012
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 15:55:57 -0400
Message-ID: <48863D27.5040506@hhs.nl>
Date: Tue, 22 Jul 2008 22:03:51 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: frtzkatz@yahoo.com
References: <239674.31754.qm@web63002.mail.re1.yahoo.com>
In-Reply-To: <239674.31754.qm@web63002.mail.re1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: xawtv fails to compile with quicktime
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

Fritz Katz wrote:
> Hello Hans de Goede,
> 
> OK, I'll volunteer to support xawtv.  It's sad when a good program becomes an un-loved orphan. :-)
> 

Excellent!

> I just started a project last week to support Video-4-Linux applications and drivers on the various *BSDs -- xawtv-3.96 could be the first application released by the project: 
> 
>     http://video4bsd.sourceforge.net/
> 
> My plan is to go from xawtv-3.95 -> xawtv-3.96 by applying all the  available patches including the one you pointed me at below. 
> 

Sounds like a good plan.
> 
> I can test on FreeBSD and Fedora-8, I'll need help testing on the other distros.
> 

I wouldn't worry too much about the other distro's for now, once you have an 
3.96 release (iow something to show) you should mail the maintainers of xawtv 
from the various distro's and ask them to update to 3.96, adjusting any of 
their patches in the progress and then send their patches to you for upstream 
merging.

Don't be shy in sending distro specific hacks back to the distro maintainers 
for them to implement a more general solution.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
