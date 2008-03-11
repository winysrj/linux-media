Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2BHdllp024725
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 13:39:47 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2BHdEg1008881
	for <video4linux-list@redhat.com>; Tue, 11 Mar 2008 13:39:14 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: video4linux-list@redhat.com
Date: Tue, 11 Mar 2008 18:39:00 +0100
References: <47C40563.5000702@claranet.fr> <47D24404.9050708@claranet.fr>
	<20080308075929.3ccbd012@gaivota>
In-Reply-To: <20080308075929.3ccbd012@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Disposition: inline
Message-Id: <200803111839.01690.zzam@gentoo.org>
Content-Transfer-Encoding: 8bit
Cc: g.liakhovetski@pengutronix.de, Brandon Philips <bphilips@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: kernel oops since changeset e3b8fb8cc214
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

On Samstag, 8. M�rz 2008, Mauro Carvalho Chehab wrote:
> On Sat, 08 Mar 2008 08:45:08 +0100
>
> Eric Thomas <ethomas@claranet.fr> wrote:
> > Eric Thomas wrote:
> > > Hi all,
> > >
> > > My box runs with kernel 2.6.24 + main v4l-dvb tree from HG.
> > > The card is a Haupauge HVR-3000 running in analog mode only. No *dvd*
> > > module loaded.
> > > Since this videobuf-dma-sg patch, I face kernel oops in several
> > > situations.
> > > These problems occur with real tv applications, but traces below come
> > > from the capture_example binary from v4l2-apps/test.
>
> Although I don't believe that this is related to the conversion to generic
> DMA API.
>
> Anyway, I'm enclosing a patch reverting the changeset. It is valuable if
> people can test to revert this and see if the issue remains.
>
> I suspect, however, that the bug is on some other place, and it is related
> to some bad locking. It seems that STREAMOFF processing here interrupted by
> a video buffer arrival, at IRQ code.
>
> PS.: I'm c/c Brandon, since he is working on fixing a bad lock on
> videobuf_dma.
>

No idea about the reason, but this patch solves the Oops for me.

Regards
Matthias

-- 
Matthias Schwarzott (zzam)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
