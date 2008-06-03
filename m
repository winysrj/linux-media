Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53LnnHP006866
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:49:49 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m53Lnb5w022553
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:49:37 -0400
Date: Tue, 3 Jun 2008 23:49:18 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Sam Logen <starz909@yahoo.com>
Message-ID: <20080603214917.GA596@daniel.bse>
References: <986038.14508.qm@web35602.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <986038.14508.qm@web35602.mail.mud.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: Question - Component input via software card
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

On Tue, Jun 03, 2008 at 01:55:07PM -0700, Sam Logen wrote:
> Now, software capture cards collect raw information
> from their video and audio composite jacks, right? 

Some capture cards can collect raw information.

> Then the software processes these streams into a file.

No, drivers make the card process the raw data for normal use.
This is too much to be done in software.

>  Would it be possible to connect component cables from
> a high def. video source to the video and audio
> composite plugs of the capture card, and have a
> program process the three streams together as video
> streams instead of video and audio streams, then save
> the result in a file?

Baseband audio inputs are usually sampled at a much lower frequency than
video inputs.
And if audio is not input as baseband signal, there is only one ADC.

> Or would the hardware on the capture card filter out
> anything it would not perceive as audio?

In baseband audio there may be an analog low pass filter corresponding
to the low sampling rate.

I don't know any chip that captures raw modulated audio.
But on the other hand I don't know that many chips.

> I'm not taking into consideration processing power or
> hard drive access bottlenecks, or other hardware
> limitations beyond the capture card.

It is a bit difficult to consider the limitations of an unknown capture
card.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
