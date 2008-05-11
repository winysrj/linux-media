Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4B6rl7w030151
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 02:53:47 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4B6rEhZ021958
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 02:53:14 -0400
Date: Sun, 11 May 2008 08:52:54 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Jody Gugelhupf <knueffle@yahoo.com>
Message-ID: <20080511065254.GA323@daniel.bse>
References: <140248.59791.qm@web36105.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <140248.59791.qm@web36105.mail.mud.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: problems with 4 port video capture card with conexant fusion
	878a 25878-132 chip, please help
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

On Sat, May 10, 2008 at 07:45:30PM -0400, Jody Gugelhupf wrote:
> [   60.601732] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]


>  Subsystem: 0x00000000


> At the current state when I try to view the inputs with e.g. xawtv i can change the "video source"
> (the current option in xawtv are called Television,Composite1,SVideo,Composite3) it shows me some
> very distored picture but also not all four resources, so what do i have to do to get it working,


Ok, you have two problems:

1. You live in a PAL country and your card can not automatically be detected
2. You want to watch four channels while your card has only one 878

Solutions:
1. As the subsystem ID is zero, you have to manually specify the card number.
When card is UNKNOWN/GENERIC, the driver does not program the PLL.
Usually cards are manufactured with a NTSC quartz, so programming the
PLL is necessary for PAL. Otherwise one gets a "very distored picture".
Try loading the bttv module with pll=28 . If you don't have a svhs
input, you may want to additionally set svhs=-1 to get color on the third
input.

2. There is no solution. The chip can capture only one input at a time.
If you switch inputs fast enough, you can achieve something below 6
frames per second. Your Windows application may have some clever logic
to switch inputs as soon as possible and in the optimal order. Using
only one field of a frame makes this significantly easier.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
