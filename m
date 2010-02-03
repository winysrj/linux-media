Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13HewNJ024860
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 12:40:58 -0500
Received: from snt0-omc3-s18.snt0.hotmail.com (snt0-omc3-s18.snt0.hotmail.com
	[65.55.90.157])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13HekAw003502
	for <video4linux-list@redhat.com>; Wed, 3 Feb 2010 12:40:47 -0500
Message-ID: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>
From: "Owen O' Hehir" <oo_hehir@hotmail.com>
To: <video4linux-list@redhat.com>
Subject: Saving YUVY image from V4L2 buffer to file
Date: Wed, 3 Feb 2010 17:40:46 +0000
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


Hello All,

I'm trying to save a captured image from a USB camera to a file. The capture is based on V4L2 video capture example from the V4L2 API spec. http://v4l2spec.bytesex.org/spec/a16706.htm

The V4L2 set pointers (via mmap) to to the USB image (in YUV 4:2:2 (YUYV)) and as far as I can see the simplest way to save the image in a recognised format is in RGB format, specifically in PPM (Netpbm color image format).

As such I've expanded the process_image function:


static void
process_image                   (const void *           p)
{
    static int count = 0;

    static int r,g,b;
    static int y1,y2,cb,cr;

    int pixel=0;

        FILE* fp = fopen("datadump", "w" );
        // Write PNM header
        fprintf( fp, "P6\n" );
        fprintf( fp, "# YUV422 frame -> RGB \n" );
        fprintf( fp, "%d %d\n", userfmt.fmt.pix.width, userfmt.fmt.pix.height );

        fprintf( fp, "255\n" );

        while(pixel < (userfmt.fmt.pix.width * userfmt.fmt.pix.height)){

        y1 = *(p+pixel);
        pixel++;
        cb= *(p+pixel);    //modified U
        pixel++;
        y2=*(p+pixel);
        pixel++;
        cr= *(p+pixel);    //modified V
        pixel++;

        r =y1 + (1.402*cb);
        g = y1 - (0.344*cb) - (0.714*cr);
            b = y1 + (1.772*cr);

        if (r > 255) r = 255;
        if (g > 255) g = 255;
        if (b > 255) b = 255;

        if (r < 0) r = 0;
        if (g < 0) g = 0;
        if (b < 0) b = 0;

            fprintf( fp, "%c%c%c",r,g,b);

        //Second pixel,reuse cb & cr, new y value

        r =y2 + (1.402*cb);
        g = y2 - (0.344*cb) - (0.714*cr);
        b = y2 + (1.772*cr);

        if (r > 255) r = 255;
        if (g > 255) g = 255;
        if (b > 255) b = 255;

        if (r < 0) r = 0;
        if (g < 0) g = 0;
        if (b < 0) b = 0;

        fprintf( fp, "%c%c%c",r,g,b);

            }

        fclose( fp );
        fprintf( stderr, "frame saved\n" );

    fflush (stdout);
}

However I'm only getting a green frame out. Could anybody point me in the right direction? 

Many thanks,

Owen
 		 	   		  
_________________________________________________________________
Hotmail: Trusted email with powerful SPAM protection.
https://signup.live.com/signup.aspx?id=60969
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
