Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1M8NRsZ029595
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 03:23:27 -0500
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1M8MuD2003281
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 03:22:56 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JSTBD-0002GF-BU
	for video4linux-list@redhat.com; Fri, 22 Feb 2008 08:22:51 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 08:22:51 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 22 Feb 2008 08:22:51 +0000
To: video4linux-list@redhat.com
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Fri, 22 Feb 2008 00:22:39 -0800
Message-ID: <pan.2008.02.22.08.22.39.310335@gimpelevich.san-francisco.ca.us>
References: <200802220138.31050.vanessaezekowitz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: New(ish) card support needed, sorta
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

On Fri, 22 Feb 2008 01:38:31 -0600, Vanessa Ezekowitz wrote:

> responding to my own post as a follow-up...
> 
> I finally figured out that there shouldn't be anything relating to DVB on my 
> Kworld ATSC120 card, since it's for North America.  So ATSC for digital and 
> NTSC for analog.  That explains why Xine and Kaffeine complained about lack 
> of DVB support.  heh.
> 
> So...what do I do now? :)

To the drivers, ATSC cards are indeed DVB cards. Support for the tuner
your card uses is in the process of being rewritten, so your testing is
appreciated.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
