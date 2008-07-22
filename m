Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MHP6vG018013
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 13:25:06 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6MHOqdT007430
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 13:24:53 -0400
Message-ID: <488619C9.6000806@hhs.nl>
Date: Tue, 22 Jul 2008 19:32:57 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: frtzkatz@yahoo.com
References: <859073.27528.qm@web63007.mail.re1.yahoo.com>
In-Reply-To: <859073.27528.qm@web63007.mail.re1.yahoo.com>
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
> 

<snip>

> Unfortunately, the various distros make releases with multiple patches for problems -- but don't send fixes back upstream. FreeBSD-7 has 10 patches on xawtv-3.95. Some of these might be important bugfixes. If someone's interested, I can zip them up and email them to you.
> 

AFAIK xawtv upstream is mostly dead, which is the mean reason why those patches 
are not getting integrated upstream.

It would be good for someone to pick up doing xawtv upstream work, you can 
request a sf.net (or something similar) project for it, import the latest 
version there, then apply a set of patches from a distro of choice and then 
start asking distribution maintainers to merge their patch set with your new xawtv.

If you do this I will poke the Fedora maintainer to get his patches integrated 
and if he doesn't I'll happily do it myself.

Also look here for a small (but somewhat important) bugfix patch to xawtv:
http://linuxtv.org/hg/v4l-dvb/file/f445674ce0d2/v4l2-apps/lib/libv4l/appl-patches/xawtv-3.95-fixes.patch

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
