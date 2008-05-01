Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m41CbfZm029507
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 08:37:41 -0400
Received: from pat.laterooms.com (fon.laterooms.com [194.24.251.1])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m41CbTUD017616
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 08:37:30 -0400
From: Gavin Hamill <gdh@acentral.co.uk>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1209604349.3219.36.camel@palomino.walls.org>
References: <1209505252.6270.11.camel@gdh-home>
	<1209506151.5699.7.camel@palomino.walls.org>
	<1209575728.6125.5.camel@gdh-home>
	<1209604349.3219.36.camel@palomino.walls.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 13:37:27 +0100
Message-Id: <1209645447.6051.1.camel@gdh-home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Ident for Bt848 card
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

On Wed, 2008-04-30 at 21:12 -0400, Andy Walls wrote:

> # modprobe -r bttv
> # modprobe bttv card=57

Ah cool - that seems to have done the trick - no delay at all on
modprobe now - a pity the cheapass way the card was manufactured
prevented a fix that could benefit other people. Oh well. <shrug>

Cheers,
Gavin.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
