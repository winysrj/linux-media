Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GHoZYm031876
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 13:50:35 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GHo3Wh026694
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 13:50:04 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jawzh-0006wK-02
	for video4linux-list@redhat.com; Sun, 16 Mar 2008 17:50:01 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 17:50:00 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 17:50:00 +0000
To: video4linux-list@redhat.com
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Sun, 16 Mar 2008 10:49:52 -0700
Message-ID: <pan.2008.03.16.17.49.51.923202@gimpelevich.san-francisco.ca.us>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161724.20459.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
	<200803161840.37910.peter.missel@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
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

On Sun, 16 Mar 2008 19:40:37 +0100, Peter Missel wrote:

> Hi Daniel!
> 
>> The 0502 definition is incorrect for this card, due to its GPIO use. The
>> Mini definition _is_ correct for it, in every way possible.
> 
> ... except that the input list isn't. You got SVideo and Composite.

Yes, it is. Both S-Video and composite work correctly with card=39. Note
that the Windows .inf file distinguishes between 5168/1502 and 5169/1502
as different cards.

> What exactly is the problem with GPIO use? Please give us your regspy results.
> 
> Peter

The GPIO under Windows is 0xc010000 and never changes. V4l card
definitions that write to GPIO throw the tuning off in various ways.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
