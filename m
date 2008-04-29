Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3TJMJfL021475
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 15:22:19 -0400
Received: from smtp2e.orange.fr (smtp2e.orange.fr [80.12.242.111])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3TJLstp017806
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 15:21:58 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2e02.orange.fr (SMTP Server) with ESMTP id AC2397000125
	for <video4linux-list@redhat.com>;
	Tue, 29 Apr 2008 21:21:49 +0200 (CEST)
Date: Tue, 29 Apr 2008 21:21:49 +0200
From: mahakali <mahakali@orange.fr>
Message-ID: <20080429192149.GB10635@orange.fr>
References: <20080428182959.GA21773@orange.fr>
	<alpine.DEB.1.00.0804282103010.22981@sandbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0804282103010.22981@sandbox.cz>
Cc: video4linux-list@redhat.com
Subject: Re: Card Asus P7131 hybrid > no signal
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

On Mon, Apr 28, 2008 at 09:07:19PM +0200, Adam Pribyl wrote :
> I have this card too - at least I think, and it works. Not 
> withoutproblems but works. Make sure you set up properly TV time, then 
> try to use "nv" driver instead "nvidia". Most probably if you get the 
> picture, you'll have problems with sound. You have to use module 
> saa7134-alsa and sox. See e.g.: 
> https://lowlevel.cz/log/pivot/entry.php?id=122
> at the end.
>
> Adam Pribyl
>

On Mon, Apr 28, 2008 at 09:07:19PM +0200, Adam Pribyl wrote :
> I have this card too - at least I think, and it
> works. Not withoutproblems but works. Make sure you set up
>properly TV time, then try to use "nv" driver instead "nvidia". Most
>probably if you get the picture, you'll have problems with sound. You have
>to use module saa7134-alsa and sox. See e.g.:
> https://lowlevel.cz/log/pivot/entry.php?id=122
> at the end
> Adam Pribyl

  
The problem is: No picture .... I thinkk, if you
have no signal, it is pretty normal.

What are the options you pass to the saa7134 module ?
I mean card=<number> tuner=<number>
I have card=112 tuner=61 (auto detect).
In one Saa7134-hardware how-to the autor gives
following values : card=78 tuner=54.

Any help would be great.

mahakali


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
