Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13I6KgB022825
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 13:06:20 -0500
Received: from snt0-omc3-s34.snt0.hotmail.com (snt0-omc3-s34.snt0.hotmail.com
	[65.55.90.173])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13I69mY012383
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 13:06:09 -0500
Message-ID: <SNT123-W631AD70788CCBA562F2E20EE560@phx.gbl>
From: "Owen O' Hehir" <oo_hehir@hotmail.com>
To: <video4linux-list@redhat.com>
Subject: RE: Saving YUVY image from V4L2 buffer to file
Date: Wed, 3 Feb 2010 18:06:08 +0000
In-Reply-To: <829197381002030954j6ebc845fl269e2f72bffbcba@mail.gmail.com>
References: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>,
	<829197381002030954j6ebc845fl269e2f72bffbcba@mail.gmail.com>
MIME-Version: 1.0
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


Devin,

Many thanks for the quick reply.

Yes I'm getting some sort of an image. When I was experimenting I managed to get an image but in grayscale & showing multiple copies of the same image covering the top half of the image. I imagine it was distorted because I was not converting to RGB correctly.

All the best,

 

Owen




> Date: Wed, 3 Feb 2010 12:54:02 -0500
> Subject: Re: Saving YUVY image from V4L2 buffer to file
> From: dheitmueller@kernellabs.com
> To: oo_hehir@hotmail.com
> CC: video4linux-list@redhat.com
> 
> On Wed, Feb 3, 2010 at 12:40 PM, Owen O' Hehir <oo_hehir@hotmail.com> wrote:
> >
> > Hello All,
> >
> > I'm trying to save a captured image from a USB camera to a file. The capture is based on V4L2 video capture example from the V4L2 API spec. http://v4l2spec.bytesex.org/spec/a16706.htm
> >
> > The V4L2 set pointers (via mmap) to to the USB image (in YUV 4:2:2 (YUYV)) and as far as I can see the simplest way to save the image in a recognised format is in RGB format, specifically in PPM (Netpbm color image format).
> >
> > As such I've expanded the process_image function:
> 
> Independent of the conversion function, are you sure you are getting a
> valid YUV frame at all?  A completely green frame is what you will get
> back if you had a buffer which was memset(0).  Hence it's possible
> that the data you are passing *into* your conversion function is
> completely blank.
> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
 		 	   		  
_________________________________________________________________
Hotmail: Powerful Free email with security by Microsoft.
https://signup.live.com/signup.aspx?id=60969
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
