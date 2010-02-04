Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o142NrV8015536
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 21:23:53 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o142NefF031077
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 21:23:41 -0500
Subject: Re: Saving YUVY image from V4L2 buffer to file
From: Andy Walls <awalls@radix.net>
To: Darren Longhorn <darren.longhorn@redembedded.com>
In-Reply-To: <4B69C29B.4010405@redembedded.com>
References: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>
	<4B69C29B.4010405@redembedded.com>
Date: Wed, 03 Feb 2010 21:23:29 -0500
Message-Id: <1265250209.3122.86.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
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

On Wed, 2010-02-03 at 18:38 +0000, Darren Longhorn wrote:
> Owen O' Hehir wrote:
> > Hello All,
> > 
> > I'm trying to save a captured image from a USB camera to a file. The capture is based on V4L2 video capture example from the V4L2 API spec. http://v4l2spec.bytesex.org/spec/a16706.htm
> > 
> > The V4L2 set pointers (via mmap) to to the USB image (in YUV 4:2:2 (YUYV)) and as far as I can see the simplest way to save the image in a recognised format is in RGB format, specifically in PPM (Netpbm color image format).
> > 
> > As such I've expanded the process_image function:
> > 
> > 
> > static void
> > process_image                   (const void *           p)
> > {
> >     static int count = 0;
> > 
> >     static int r,g,b;
> >     static int y1,y2,cb,cr;
> > 
> >     int pixel=0;
> > 
> >         FILE* fp = fopen("datadump", "w" );
> >         // Write PNM header
> >         fprintf( fp, "P6\n" );
> >         fprintf( fp, "# YUV422 frame -> RGB \n" );
> >         fprintf( fp, "%d %d\n", userfmt.fmt.pix.width, userfmt.fmt.pix.height );
> > 
> >         fprintf( fp, "255\n" );
> > 
> >         while(pixel < (userfmt.fmt.pix.width * userfmt.fmt.pix.height)){
> > 
> >         y1 = *(p+pixel);
> 
> Are you sure that's your real code? I don't think you should dereference
> a void pointer like that.

Old-ish C-compilers treated that as a char * in that case.  The behavior
is unreliable of course.  This certainly could be a cause of problems.

Regards,
Andy

> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
