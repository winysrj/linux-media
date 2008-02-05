Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1584w02007892
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 03:04:58 -0500
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.181])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1583fGI012531
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 03:04:23 -0500
Received: by py-out-1112.google.com with SMTP id a29so2592914pyi.0
	for <video4linux-list@redhat.com>; Tue, 05 Feb 2008 00:04:22 -0800 (PST)
Date: Tue, 5 Feb 2008 00:00:00 -0800
From: Brandon Philips <brandon@ifup.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080205080000.GA8232@plankton.ifup.org>
References: <Pine.LNX.4.64.0801311531440.8478@axis700.grange>
	<20080205015138.GA9729@plankton.ifup.org>
	<Pine.LNX.4.64.0802050754340.3863@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802050754340.3863@axis700.grange>
Cc: video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [NAK] Re: [PATCH] Add V4L2_CID_AUTOEXPOSURE control
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

On 07:56 Tue 05 Feb 2008, Guennadi Liakhovetski wrote:
> On Mon, 4 Feb 2008, Brandon Philips wrote:
> 
> > On 15:34 Thu 31 Jan 2008, Guennadi Liakhovetski wrote:
> > > Add a new AUTOEXPOSURE V4L2 control, will be later used by mt9m001 and 
> > > mt9v022 camera drivers.
> > 
> > Nak.
> > 
> > I am adding V4L2_CID_EXPOSURE_AUTO to a newly created camera control
> > class.  The proposed API changes were sent to the list already.  It
> > hasn't been merged yet because of some discussion, but it will be merged
> > soon.
> > 
> > You can view the V4L2_CID_EXPOSURE_AUTO change here:
> >   http://ifup.org/hg/v4l-spec?cmd=changeset;node=88a377fb918b;style=gitweb
> > 
> > And the API changes here:
> >   http://ifup.org/~philips/review/v4l2-proposed/x784.htm#CAMERA-CLASS
> 
> Yes, Trent Piepho has already told me about those your pending patches, 
> and I was planning to redo my autoexposure handling.

Ok.  Thanks.  :)

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
