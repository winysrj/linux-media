Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4BHuK8o007673
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 13:56:20 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4BHtWaI013323
	for <video4linux-list@redhat.com>; Sun, 11 May 2008 13:55:32 -0400
Date: Sun, 11 May 2008 19:55:08 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Jody Gugelhupf <knueffle@yahoo.com>
Message-ID: <20080511175507.GA255@daniel.bse>
References: <67277.16991.qm@web36106.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67277.16991.qm@web36106.mail.mud.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: kodicom 8 channel 240 fps real time dvr capture card in linux
	help please
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

On Sun, May 11, 2008 at 07:22:37AM -0400, Jody Gugelhupf wrote:
> 240 fps real time 8 channel kodicom dvr capture card
> I attached a picture of it, but I was wondering if anyone knows if I can get this to run under
> linux without problems or not?

I think I recognize eight Conexant chips on that card.
I'm not shure if these are 878 or 2388X chips.
It should be supported either by the bttv or by the cx88 driver.

This card is equivalent to using eight of your low budget cards with
each having only two inputs.

In any case, the PCI bus does not have enough bandwidth to capture eight
channels at full resolution. You are restricted to smaller videos.

By the way, the Kodicom DigiNet devices are usually sold as complete
computers. Look at the dimensions given in the table of the eBay auction.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
