Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1585DfF008281
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 03:05:13 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.187])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1584T8h012924
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 03:04:29 -0500
Received: by rv-out-0910.google.com with SMTP id k15so1787380rvb.51
	for <video4linux-list@redhat.com>; Tue, 05 Feb 2008 00:04:25 -0800 (PST)
Date: Tue, 5 Feb 2008 00:00:38 -0800
From: Brandon Philips <brandon@ifup.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080205080038.GB8232@plankton.ifup.org>
References: <20080205012451.GA31004@plankton.ifup.org>
	<Pine.LNX.4.64.0802050815200.3863@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802050815200.3863@axis700.grange>
Cc: video4linux-list@redhat.com,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: NACK NACK!  [PATCH] Add two new fourcc codes for 16bpp formats
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

On 08:16 Tue 05 Feb 2008, Guennadi Liakhovetski wrote:
> On Mon, 4 Feb 2008, Brandon Philips wrote:
> 
> > On 15:31 Thu 31 Jan 2008, Guennadi Liakhovetski wrote:
> > > From: Steven Whitehouse <steve@chygwyn.com>
> > > 
> > > This adds two new fourcc codes (as per info at fourcc.org)
> > > for 16bpp mono and 16bpp Bayer formats.
> > 
> > This patch was merged in the following commit:
> >  http://linuxtv.org/hg/v4l-dvb/rev/d002378ff8c2
> > 
> > I have a number of issues:
> >  
> > - Why was V4L2_CID_AUTOEXPOSURE added!  I am working to get an auto
> >   exposure control into the spec but this was merged without discussion.
> >   Please remove this and wait for my patch.
> > 
> > - Why was a SoC config option added with this commit?
> > 
> > - mailimport changes in this commit too!  Why is mailimport running
> >   sudo!?! 
> > 
> > A mistake was obviously made here.
> 
> Yes, strange. In the original patch
> 
> http://marc.info/?l=linux-video&m=120179045830566&w=2
> 
> it was still ok.

Yea, it must have been something on Mauro's end.

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
