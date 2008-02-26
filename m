Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QD2uSo027125
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 08:02:56 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1QD2Oer012646
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 08:02:25 -0500
Date: Tue, 26 Feb 2008 14:02:00 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Michel Bardiaux <mbardiaux@mediaxim.be>
Message-ID: <20080226130200.GA215@daniel.bse>
References: <47C3F5CB.1010707@mediaxim.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C3F5CB.1010707@mediaxim.be>
Cc: video4linux-list@redhat.com
Subject: Re: Grabbing 4:3 and 16:9
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

On Tue, Feb 26, 2008 at 12:19:39PM +0100, Michel Bardiaux wrote:
> Here in Belgium the broadcasts is sometimes 4:3, sometimes 16:9. 
> Currently, the card goes automatically in letterbox mode when it 
> receives 16:9, and our software captures the 4:3 frames at size 704x576. 

The card does not go into letterbox mode. It's the broadcaster who
squeezes the 16:9 picture into 432 lines surrounded by 144 black lines.
Some fill the chroma part of the black lines with a PALPlus helper
signal. Although the algorithms to decode PALPlus are well documented in
ETS 300 731, I have never seen a software implementation.

> 1. How do I sense from the software that the mode is currently 16:9 or 4:3?

Some broadcasters use WSS to signal 16:9.
In Germany some signal 4:3 even on 16:9 shows.
Read ETSI EN 300 294.

> 2. How do I setup the bttv so that it does variable anamorphosis instead 
> of letterboxing? If that is at all possible of course...

You can't. Bttv can't stretch vertically.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
