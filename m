Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABJ41kE006884
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 14:04:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABJ3hjD030447
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 14:03:46 -0500
Date: Tue, 11 Nov 2008 17:03:49 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Pete Eberlein <pete@sensoray.com>
Message-ID: <20081111170349.39856de5@pedra.chehab.org>
In-Reply-To: <1226420905.6231.31.camel@pete-desktop>
References: <1226357539.8035.20.camel@pete-desktop>
	<1226367478.2493.39.camel@pc10.localdom.local>
	<20081111122306.0bb05431@pedra.chehab.org>
	<1226420905.6231.31.camel@pete-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Greg KH <greg@kroah.com>, video4linux-list@redhat.com
Subject: Re: [PATCH] saa7134: Add new cards
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

On Tue, 11 Nov 2008 08:28:25 -0800
Pete Eberlein <pete@sensoray.com> wrote:

> On Tue, 2008-11-11 at 12:23 -0200, Mauro Carvalho Chehab wrote:
> > On Tue, 11 Nov 2008 02:37:58 +0100
> > hermann pitton <hermann-pitton@arcor.de> wrote:
> 
> Hermann, thanks for the catching the input duplication in the struct.
> 
> > > I probably missed it and there is a plan, but if this should go to
> > > v4l-dvb now and SAA7134_MPEG_GO7007 support comes only with staging,
> > > should we not #if 0 it until all is merged?
> > > 
> > > Thanks for your work.
> > 
> > It is better to hold the patch until go7007 driver enters at v4l/dvb tree and
> > go outside staging.
> 
> Thanks.  The saa7134-go7007.c portion of the go7007 driver in staging
> doesn't compile without the changes to the saa7134 headers, but I'll
> talk with Greg and find a way to make it work.  It would be helpful to
> have the saa7134 changes in first, though.

Maybe you can add a #if testing for go7007 for the card entries that require
go7007 to be compiled. It may also be a good idea to add go7007 driver at
v4l-dvb repository to allow us to test and to avoid it to break when newer API
changes happen.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
