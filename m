Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13IvGIo012979
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 13:57:16 -0500
Received: from gateway04.websitewelcome.com (gateway04.websitewelcome.com
	[67.18.52.3])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o13Iv5wo032608
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 13:57:06 -0500
From: "Charlie X. Liu" <charlie@sensoray.com>
To: "'Owen O' Hehir'" <oo_hehir@hotmail.com>, <video4linux-list@redhat.com>
References: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>,
	<829197381002030954j6ebc845fl269e2f72bffbcba@mail.gmail.com>
	<SNT123-W631AD70788CCBA562F2E20EE560@phx.gbl>
In-Reply-To: <SNT123-W631AD70788CCBA562F2E20EE560@phx.gbl>
Subject: RE: Saving YUVY image from V4L2 buffer to file
Date: Wed, 3 Feb 2010 10:57:03 -0800
Message-ID: <005801caa502$ad686ca0$083945e0$@com>
MIME-Version: 1.0
Content-Language: en-us
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

Why don't you directly set it with: fmt.fmt.pix.pixelformat =
V4L2_PIX_FMT_BGR24, instead of converting?

Then, save like:

        sprintf( ppmheader, "P6\n#ppm image\n%d %d\n255\n", info->width,
info->height);
        fwrite( ppmheader, 1, strlen(ppmheader), fptr);
        // write out the rows
        for ( i=0; i<info->height; i++)
        {
            //fwrite( &image[info->stride*i], 1, info->stride, fptr);
            for ( j=0; j<info->width; j++ ) {
            fwrite( &image[info->stride*i+j*3+2], 1, 1, fptr);
            fwrite( &image[info->stride*i+j*3+1], 1, 1, fptr);
            fwrite( &image[info->stride*i+j*3+0], 1, 1, fptr);
            }
        }


Charlie X. Liu @ Sensoray Co.


-----Original Message-----
From: video4linux-list-bounces@redhat.com
[mailto:video4linux-list-bounces@redhat.com] On Behalf Of Owen O' Hehir
Sent: Wednesday, February 03, 2010 10:06 AM
To: video4linux-list@redhat.com
Subject: RE: Saving YUVY image from V4L2 buffer to file


Devin,

Many thanks for the quick reply.

Yes I'm getting some sort of an image. When I was experimenting I managed to
get an image but in grayscale & showing multiple copies of the same image
covering the top half of the image. I imagine it was distorted because I was
not converting to RGB correctly.

All the best,

 

Owen




> Date: Wed, 3 Feb 2010 12:54:02 -0500
> Subject: Re: Saving YUVY image from V4L2 buffer to file
> From: dheitmueller@kernellabs.com
> To: oo_hehir@hotmail.com
> CC: video4linux-list@redhat.com
> 
> On Wed, Feb 3, 2010 at 12:40 PM, Owen O' Hehir <oo_hehir@hotmail.com>
wrote:
> >
> > Hello All,
> >
> > I'm trying to save a captured image from a USB camera to a file. The
capture is based on V4L2 video capture example from the V4L2 API spec.
http://v4l2spec.bytesex.org/spec/a16706.htm
> >
> > The V4L2 set pointers (via mmap) to to the USB image (in YUV 4:2:2
(YUYV)) and as far as I can see the simplest way to save the image in a
recognised format is in RGB format, specifically in PPM (Netpbm color image
format).
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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
