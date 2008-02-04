Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m149GILk026582
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 04:16:18 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m149Fpuw015578
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 04:15:51 -0500
Date: Mon, 4 Feb 2008 07:14:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Message-ID: <20080204071420.157f101c@gaivota>
In-Reply-To: <200802032010.38211.laurent.pinchart@skynet.be>
References: <ce6db52d63cbc5139236.1201510493@localhost>
	<200802032010.38211.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [PATCH 1 of 2] [v4l] Add camera class control definitions
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

On Sun, 3 Feb 2008 20:10:37 +0100
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:


> > +enum  v4l2_exposure_auto_type {
> > +	V4L2_EXPOSURE_MANUAL = 1,
> > +	V4L2_EXPOSURE_AUTO = 2,
> > +	V4L2_EXPOSURE_SHUTTER_PRIORITY = 4,
> > +	V4L2_EXPOSURE_APERTURE_PRIORITY = 8
> > +};
> 
> V4L2 requires menu items to be numbered from minimum (0) to maximum inclusive 
> (see the description of VIDIOC_QUERYMENU). If V4L2_CID_EXPOSURE_AUTO is 
> implemented as a V4L2_CTRL_TYPE_MENU, the above values won't comply with 
> V4L2. Wether the menu IDs or the V4L2 spec should be changed is of course an 
> open question :-)

Since this is "C" and not "Pascal", let's start from 0 ;)

IMO, V4L2_EXPOSURE_AUTO = 0 makes more sense, since values are initialized as
zero, and auto-exposure should be the default.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
