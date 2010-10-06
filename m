Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o96JYjNW025807
	for <video4linux-list@redhat.com>; Wed, 6 Oct 2010 15:34:45 -0400
Received: from mail-wy0-f174.google.com (mail-wy0-f174.google.com
	[74.125.82.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o96JYWDG012521
	for <video4linux-list@redhat.com>; Wed, 6 Oct 2010 15:34:33 -0400
Received: by wyb28 with SMTP id 28so10176086wyb.33
	for <video4linux-list@redhat.com>; Wed, 06 Oct 2010 12:34:32 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 6 Oct 2010 10:56:01 -0700
Message-ID: <AANLkTinEUDfpsFvmt6WhiPQcr3oOuimiypBMRrMcZhGj@mail.gmail.com>
Subject: Acquiring / accessing video data
From: halm <halm@ieee.org>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

The usual v4l list newbie apologies: first time posting here, new to V4L(2),
sorry if this is
too obvious a question or the wrong forum.

I'm writing an app for Arago Linux running on a TI OMAP "evm" evaluation
board.  I didn't create
this system, but V4L2 seems to be there just fine.

I downloaded and built the capture example (
http://v4l2spec.bytesex.org/spec/capture-example.html).  I
added code to init_device() to initialize my particular camera (it's
listening via I2C for configuration settings),
and can run it no problem.  I'm certain that the camera is running since
after my I2C setup I can use an
oscilloscope and see sync and video.

The process_image() function simply prints '.' for every frame.  I wanted to
verify that image data
is really accessible and so I've added the following code to
process_image():

static void process_image( const void * p, size_t len )

{

#ifdef WAS_THIS

  fputc ('.', stdout);

#else //WAS_THIS

  char      * cP = (char *)p;

  int         hi  = cP[0];

  int         lo  = cP[0];

  long long   sum = 0;

  int i;


  for( i = 0; i < len; i++ ) {

      if( (int)(cP[i]) > hi ) hi = cP[i];

      if( (int)(cP[i]) < lo ) lo = cP[i];

      sum += cP[i];

  }

  printf("[%p] Hi<%d> low<%d> mean<%d> (%d bytes)\n", p, hi, lo, (int)(sum /
len), len);
  fflush (stdout);
#endif //WAS_THIS

}


I can see that process_image() is repeatedly called and so I do believe that
I'm getting frames, however I
don't seem to have any image data:
    [0x402ec000] Hi<128> low<16> mean<72> (691200 bytes)
    [0x40395000] Hi<128> low<16> mean<72> (691200 bytes)

... and so on.  The min/max/mean never change.  I can change the lighting
and with an oscilloscope on the
video, and I can see that the pixel values do change.  I added another
printf to show me the first few bytes
of video buffer:
  10 80 10 80 10 80 10 80  10 80 10 80 10 80 10 80
  10 80 10 80 10 80 10 80  10 80 10 80 10 80 10 80

What am I missing here?  I believe that the V4L2 driver knows about the
video hardware on my board and doesn't
need to know any other camera specifics.  Is there something else I need to
know or do to acquire images?

I do know that the camera is outputting 640x480 8-bit per pixel grayscale.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
