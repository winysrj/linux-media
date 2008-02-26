Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QG7Y90012624
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 11:07:34 -0500
Received: from viefep11-int.chello.at (viefep11-int.chello.at [62.179.121.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1QG6xiH025386
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 11:07:00 -0500
From: Michael Schimek <mschimek@gmx.at>
To: Brandon Philips <bphilips@suse.de>
In-Reply-To: <20080226055359.GA9178@plankton>
References: <20080127103819.856157143@suse.de>
	<20080127104008.554561732@suse.de>  <20080226055359.GA9178@plankton>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Feb 2008 17:04:54 +0100
Message-Id: <1204041895.15586.655.camel@localhost>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, mchehab@infradead.org
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

On Mon, 2008-02-25 at 21:53 -0800, Brandon Philips wrote:
> On 02:38 Sun 27 Jan 2008, Brandon Philips wrote:
> > - Add V4L2_CID_EXPOSURE_ABSOLUTE, V4L2_CID_EXPOSURE_AUTO,
> >   V4L2_CID_EXPOSURE_AUTO_PRIORITY
> > - Add V4L2_CID_PAN_RELATIVE, V4L2_CID_TILT_RELATIVE, V4L2_CID_PAN_ABSOLUTE,
> >   V4L2_CID_TILT_ABSOLUTE, V4L2_CID_PAN_RESET, V4L2_CID_TILT_RESET,
> > - Add V4L2_CID_FOCUS_RELATIVE/ABSOLUTE/AUTO 
>
> This series needs to be merged into the spec along with the
> clarification about changing frame rates while streaming.

I'm working on it.

> Also, we need to have the discussion about putting the spec
> into the Kernel Documentation/ tree.

Fine with me, after porting the sources to DocBook 4.1. You're aware
that would be a 1.3 MB patch?

Michael

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
