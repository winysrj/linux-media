Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0BDsCRC023556
	for <video4linux-list@redhat.com>; Mon, 11 Jan 2010 08:54:12 -0500
Received: from insvr08.insite.com.br (insvr08.insite.com.br [66.135.42.188])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0BDrxmV000332
	for <video4linux-list@redhat.com>; Mon, 11 Jan 2010 08:53:59 -0500
From: Rafael Diniz <diniz@wimobilis.com.br>
To: video4linux-list@redhat.com
Subject: Re: Blackmagic SDI card --> v4l2 ready ?
Date: Mon, 11 Jan 2010 11:57:46 -0200
References: <4B40B9CC.1040108@wp.pl> <4B47948E.1070408@mnn.org>
	<4B479649.1000908@mnn.org>
In-Reply-To: <4B479649.1000908@mnn.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201001111157.46803.diniz@wimobilis.com.br>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I think it would be interesting to write a V4L2 driver for the BlackMagic 
cards using the code already released by BM for the very low level kernel 
driver and some reverse engineering.

Rafael Diniz

On Friday 08 January 2010 18:32:09 Mars Forest wrote:
> Mars Forest wrote:
> > Just a quick question to see if Blackmagic's SDI card (I just have the
> > basic one, not the studio or the extreme) is working under Video4Linux?
> >
> > I have successfully tested this card using the bundled software (for
> > Ubuntu) but I am getting this error when trying to capture from it
> > with VLC:
> >
> >     *[0x2a3e828] v2l2 demux warning: FIXME: v4l2.c ControlListPrint 2738*
>
> Since this question was rather quickly answered on IRC ("none of
> Blackmagic's cards work with v4l.") I am now looking for a
> recommendation on a good card to replace this one. I am running
> Debian/Ubuntu on a Sunfire x2200.
>
> Looking for a half-length PCI-E SDI video capture card that will work
> with v4l2/VLC.
>
> What's the best choice here?
>
> > cheers,
> >
> > forest mars
> > --
> > mnn: you're what's on!
> > http://mnn.org
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
