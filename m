Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAN9UoJ0019082
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 04:30:50 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAN9UbEW007889
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 04:30:38 -0500
Message-ID: <49292417.30100@hhs.nl>
Date: Sun, 23 Nov 2008 10:36:23 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
	<200811190020.15663.linux@baker-net.org.uk>
	<4923D159.9070204@hhs.nl>
	<alpine.LNX.1.10.0811192005020.2980@banach.math.auburn.edu>
	<49253004.4010504@hhs.nl>
	<Pine.LNX.4.64.0811201130410.3570@banach.math.auburn.edu>
	<4925BC94.7090008@hhs.nl>
	<Pine.LNX.4.64.0811202306360.3930@banach.math.auburn.edu>
	<49269369.90805@hhs.nl>
	<Pine.LNX.4.64.0811211244120.4475@banach.math.auburn.edu>
	<49272762.80304@hhs.nl>
	<Pine.LNX.4.64.0811211929220.4832@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811211929220.4832@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Report on time needed for completing v4l Bayer interpolation.
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

kilgota@banach.math.auburn.edu wrote:
> 
> Hans,
> 
> I made your Bayer code to work. It was not terribly difficult, but did 
> need a bit of fixing and fooling.
> 
> So now the gp_bayer_decode function (in byr2ppm.c)says
> 
> int
> gp_bayer_decode (unsigned char *input, int w, int h, unsigned char *output,
>                  BayerTile tile)
> {
> //      gp_bayer_expand (input, w, h, output, tile);
> //      gp_bayer_interpolate (output, w, h, tile);
>         clock_t time_start=clock();
>                 fprintf(stderr, "Starting bayer v4l-interpolation\n");
> 
> 
> 
> v4lconvert_bayer_to_rgb24(input,
>  output, w, h, tile);
> 
>         clock_t time_end=clock();
>         fprintf(stderr,"Total time of v4l Bayer :\t%i ms\n",
>                                     (int)(time_end-time_start)/1000);
> 
> 
>         return (0);
> }
> 
> and the result for the same photo as before is
> 
> Total time of v4l Bayer :       0 ms
> 
> In other words, the time is reduced by a factor of approximately ten 
> from the code in the original libgphoto2/bayer.c (the straight bilinear 
> version).
> 

Well 10x might be a bit exaggerating, see my comments about clock() precision 
below.

> With a larger 640x480 image the time required is variously 0 ms or 
> sometimes 10 ms, so again a dramatic improvement.
> 

Hmm, if it jumps between 0 and 10 then clock() apparently has a 10 ms 
resolution I know the resolution of clock() wasn't all that great, but this is 
kinda bad actually.

> What would you suggest to do in order to get a more meaningful 
> measurement, at this point? Remove the dividend 1000 completely?
> 

That wont help, I advice you to use gettimeofday instead that much much better 
precision (sub microsecond on most systems).


> As far as the output image is concerned, the results are as I would 
> expect, though. To me, the output appears to be pretty much identical to 
> what the unmodified bilinear interpolation gives, which was in the 
> "original" libgphoto2/bayer.c. That is, there is lots of zipper effect 
> or ladder effect which is visible at vertical and horizontal edges all 
> over the photo, and this artifacting can be easily seen even at the 
> original 320x240 resolution without doing any magnification.
> 

Ack.

> Incidentally, the photo is the "infamous number 23" and you can see the 
> same photo on the website, as 023.ppm (now that I got the permissions 
> problem fixed). In the paper there are also some magnified views of a 
> small portion of the same photo, which show the effects of the three 
> different algorithms that show up especially at the edges of the balcony 
> railing and at the tops of the buildings in the distance.
> 
> Bottom line: I will see if I can figure out anything to get rid of the 
> zippering without excessively jacking up the time needed. Probably the 
> first thing to test is the accrue functionality, or a modification of that.

Ok and Thanks!

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
