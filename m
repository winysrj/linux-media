Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34EJ7NF010987
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 10:19:07 -0400
Received: from mxout-03.mxes.net (mxout-03.mxes.net [216.86.168.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m34EIrBP022837
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 10:18:53 -0400
Received: from home.eagach.dyndns.org (unknown [81.98.241.27])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.mxes.net (Postfix) with ESMTP id 5BEBC23E4A4
	for <video4linux-list@redhat.com>; Fri,  4 Apr 2008 10:18:50 -0400 (EDT)
Date: Fri, 4 Apr 2008 15:18:48 +0100
From: Laurence Darby <ldarby@tuffmail.com>
To: video4linux-list@redhat.com
Message-Id: <20080404151848.322a7f98.ldarby@tuffmail.com>
In-Reply-To: <20080121195314.2753a46d.ldarby@tuffmail.com>
References: <20071231160243.004506e3.ldarby@tuffmail.com>
	<20080101094547.02f99c3a@gaivota>
	<20080101180954.fe6ddfcf.ldarby@tuffmail.com>
	<20080102000844.10f09d7c@gaivota>
	<20080121195314.2753a46d.ldarby@tuffmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: lirc project needs your help! - no longer
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


Laurence Darby wrote:

> Mauro Carvalho Chehab wrote:
> 
> > > Do you, or someone else, have the hardware to test if bit 0x800 is
> > > all that's needed?  Is so, there are many more masks defined in
> > > lirc_gpio.c, I guess they'll all need to be checked against the
> > > ones in bttv-input.c and check none are missing before lirc_gpio
> > > can be officially deprecated
> > 
> > Unfortunately, I don't have. We may assume that lirc_gpio is
> > correct, and write an experimental patch, asking people to test.
> > Could you prepare such patch?
> 
> 
> Well, I did so, but haven't had any response yet:
> http://www.nabble.com/Support-for-winfast-2000-xp---Preparing-to-drop-lirc_gpio-td14586233.html
> (patch also attached)
> 
> Does anyone else here have the Winfast 2000 XP card to test it?  Even
> if you don't use lirc, please consider helping.  What you'd need to do
> is on linux 2.6.22, check lirc with the input method doesn't work,
> (ie. repeat what aputerguy does in
> http://www.nabble.com/Re%3A-LIRC-GPIO-Unnecessary-now--p13608717.html )
> 

Just in case anyone cares, my patch did get tested and didn't work:
http://sourceforge.net/tracker/index.php?func=detail&aid=1886920&group_id=5444&atid=305444

but anyway this problem was actually fixed several months before I
attempted to fix it:

http://lists.atrpms.net/pipermail/atrpms-users/2007-November/008201.html


Laurence

PS. unsubscribing from this list, please CC me if you reply thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
