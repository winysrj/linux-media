Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1RATiCW010645
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 05:29:44 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1RAT7XM020360
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 05:29:08 -0500
Date: Wed, 27 Feb 2008 07:28:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Schimek <mschimek@gmx.at>
Message-ID: <20080227072804.64f96ff1@areia>
In-Reply-To: <1204041895.15586.655.camel@localhost>
References: <20080127103819.856157143@suse.de>
	<20080127104008.554561732@suse.de> <20080226055359.GA9178@plankton>
	<1204041895.15586.655.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Brandon Philips <bphilips@suse.de>
Subject: Re: PING! Re: [patch 1/3] Add camera class controls for UVC merge
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

On Tue, 26 Feb 2008 17:04:54 +0100
Michael Schimek <mschimek@gmx.at> wrote:

> On Mon, 2008-02-25 at 21:53 -0800, Brandon Philips wrote:
> > On 02:38 Sun 27 Jan 2008, Brandon Philips wrote:
> > > - Add V4L2_CID_EXPOSURE_ABSOLUTE, V4L2_CID_EXPOSURE_AUTO,
> > >   V4L2_CID_EXPOSURE_AUTO_PRIORITY
> > > - Add V4L2_CID_PAN_RELATIVE, V4L2_CID_TILT_RELATIVE, V4L2_CID_PAN_ABSOLUTE,
> > >   V4L2_CID_TILT_ABSOLUTE, V4L2_CID_PAN_RESET, V4L2_CID_TILT_RESET,
> > > - Add V4L2_CID_FOCUS_RELATIVE/ABSOLUTE/AUTO 
> >
> > This series needs to be merged into the spec along with the
> > clarification about changing frame rates while streaming.
> 
> I'm working on it.
> 
> > Also, we need to have the discussion about putting the spec
> > into the Kernel Documentation/ tree.
> 
> Fine with me, after porting the sources to DocBook 4.1. You're aware
> that would be a 1.3 MB patch?

Seems a little big to my eyes ;)

Maybe we could split this into two separate docs. A concise one, with the API
itself, and an "user guide" with V4L2 history and the complimentary info for
developers.

Yet, IMO, the better is to keep the API part together with the kernel.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
