Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m14IRIPi014886
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 13:27:18 -0500
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.237])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m14IQk1H012562
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 13:26:46 -0500
Received: by wx-out-0506.google.com with SMTP id t16so1873133wxc.6
	for <video4linux-list@redhat.com>; Mon, 04 Feb 2008 10:26:41 -0800 (PST)
Date: Mon, 4 Feb 2008 09:51:27 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080204175127.GC5075@plankton.ifup.org>
References: <ce6db52d63cbc5139236.1201510493@localhost>
	<200802032010.38211.laurent.pinchart@skynet.be>
	<20080204071420.157f101c@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204071420.157f101c@gaivota>
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

On 07:14 Mon 04 Feb 2008, Mauro Carvalho Chehab wrote:
> On Sun, 3 Feb 2008 20:10:37 +0100
> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> 
> 
> > > +enum  v4l2_exposure_auto_type {
> > > +	V4L2_EXPOSURE_MANUAL = 1,
> > > +	V4L2_EXPOSURE_AUTO = 2,
> > > +	V4L2_EXPOSURE_SHUTTER_PRIORITY = 4,
> > > +	V4L2_EXPOSURE_APERTURE_PRIORITY = 8
> > > +};
> > 
> > V4L2 requires menu items to be numbered from minimum (0) to maximum inclusive 
> > (see the description of VIDIOC_QUERYMENU). If V4L2_CID_EXPOSURE_AUTO is 
> > implemented as a V4L2_CTRL_TYPE_MENU, the above values won't comply with 
> > V4L2. Wether the menu IDs or the V4L2 spec should be changed is of course an 
> > open question :-)
> 
> Since this is "C" and not "Pascal", let's start from 0 ;)

Agreed.  I was following the lead of the UVC spec- which in hindsight
isn't the right thing in this case.

I will send out a new patch.

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
