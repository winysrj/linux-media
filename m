Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o16Kmkii031571
	for <video4linux-list@redhat.com>; Sat, 6 Feb 2010 15:48:46 -0500
Received: from snt0-omc4-s24.snt0.hotmail.com (snt0-omc4-s24.snt0.hotmail.com
	[65.55.90.227])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o16KmZ3B001115
	for <video4linux-list@redhat.com>; Sat, 6 Feb 2010 15:48:35 -0500
Message-ID: <SNT123-W78FBB8046F28E60B1DBC9EE530@phx.gbl>
From: "Owen O' Hehir" <oo_hehir@hotmail.com>
To: <dheitmueller@kernellabs.com>
Subject: RE: Saving YUVY image from V4L2 buffer to file - SOLVED
Date: Sat, 6 Feb 2010 20:48:34 +0000
In-Reply-To: <829197381002031018yc5f8b45gc6e8303b44ca7b34@mail.gmail.com>
References: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>,
	<829197381002030954j6ebc845fl269e2f72bffbcba@mail.gmail.com>,
	<SNT123-W631AD70788CCBA562F2E20EE560@phx.gbl>,
	<829197381002031018yc5f8b45gc6e8303b44ca7b34@mail.gmail.com>
MIME-Version: 1.0
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


Hello All, 

Solved this problem.

For info for others here is a function to unpacked YUYV (Also known as YUY422 & YUY2) -> RGB and save it to a file. I've included other formats that I came across that others might find useful but are untested.

int frame_save(const void *p, const char* filename )
{

    static int packed_value, i;
    FILE* fp = fopen(filename, "w" );

    // Write PNM header
    fprintf( fp, "P6\n" );
    fprintf( fp, "# YUV422 frame -> RGB \n" );
    fprintf( fp, "%d %d\n", userfmt.fmt.pix.width,userfmt.fmt.pix.height);
    
    // fprintf( stderr, "&userframe address %d\n", &userframe );
    // fprintf( stderr, "&p address %d\n", &p );
    // fprintf( stderr, "sizeof(userframe) %d\n", sizeof(userframe) );
    
//     switch (userfmt.fmt.pix.pixelformat){
//     case V4L2_PIX_FMT_RGB24:
//         
//         // Max val
//         // NOTE UNTESTED!!!!!!!!!
//         fprintf( fp, "255\n" );
//         fprintf( stderr, "frame_save(): RGB24 Unsupported type!\n" );
// 
//         //Write image data
//         for ( i = 0; i < ( userfmt.fmt.pix.width * userfmt.fmt.pix.height ); i++ )
//         {
//         // 3 bytes per pixel
// //         rgb = ((FRAME_RGB*)(p))[i];
// // 
// //         fprintf( fp, "%c%c%c",
// //              rgb.blue,
// //              rgb.green,
// //              rgb.red );
//         }
//         break;
//         
//     case V4L2_PIX_FMT_RGB32:
//         // NOTE UNTESTED!!!!!!!!!
//         // Max val
//         fprintf( fp, "255\n" );
//         
//         // Write image data
//         for ( i = 0; i < ( userfmt.fmt.pix.width * userfmt.fmt.pix.height ); i++ )
//         {
//         // Retrieve lower 24 bits of ARGB
//         packed_value = ((int*)(p))[i] & 0x00ffffff;
//         
//         fprintf( fp, "%c%c%c",
//              ( packed_value & 0x00ff0000 ) >> 16, // Blue
//              ( packed_value & 0x0000ff00 ) >>  8, // Green
//              ( packed_value & 0x000000ff )        // Red
//              );
//         }
//         break;
//         
//     case V4L2_PIX_FMT_RGB565:
//     case V4L2_PIX_FMT_RGB555:
//         // NOTE UNTESTED!!!!!!!!!
//         // Max val
//         fprintf( fp, "65535\n" );
//         
//         // Write image data
//         for ( i = 0; i < ( userfmt.fmt.pix.width *userfmt.fmt.pix.height ); i++ ){
//         // Retrieve 16-bit words
//         packed_value = ((short*)(p))[i];
//         
//         fprintf( fp, "%c%c",frame
//              ( packed_value & 0xff00 ) >> 8, // High
//              ( packed_value & 0x00ff )       // Low
//              );
//             }
//         break;
// 
//     case V4L2_PIX_FMT_YUYV:
        int Y0, Y1, Cb, Cr;            /* gamma pre-corrected input [0;255] */
        int ER0,ER1,EG0,EG1,EB0,EB1;    /* output [0;255] */
        double r0,r1,g0,g1,b0,b1;             /* temporaries */
        double y0,y1, pb, pr;

        // Max val
        fprintf( fp, "255\n" );
        //fprintf( stderr, "frame_save(): YUYV file type!\n" );

        while(i < (userfmt.fmt.pix.width * userfmt.fmt.pix.height/2)){

        packed_value = *((int*)p+i);

        Y0 = (char)(packed_value & 0xFF);
        Cb = (char)((packed_value >> 8) & 0xFF);
        Y1 = (char)((packed_value >> 16) & 0xFF);
        Cr = (char)((packed_value >> 24) & 0xFF);

        // Strip sign values after shift (i.e. unsigned shift)
        Y0 = Y0 & 0xFF;
        Cb = Cb & 0xFF;
        Y1 = Y1 & 0xFF;
        Cr = Cr & 0xFF;

        //fprintf( fp, "Value:%x Y0:%x Cb:%x Y1:%x Cr:%x ",packed_value,Y0,Cb,Y1,Cr);

        y0 = (255 / 219.0) * (Y0 - 16);
        y1 = (255 / 219.0) * (Y1 - 16);
        pb = (255 / 224.0) * (Cb - 128);
        pr = (255 / 224.0) * (Cr - 128);

        // Generate first pixel
        r0 = 1.0 * y0 + 0     * pb + 1.402 * pr;
        g0 = 1.0 * y0 - 0.344 * pb - 0.714 * pr;
        b0 = 1.0 * y0 + 1.772 * pb + 0     * pr;

        // Generate next pixel - must reuse pb & pr as 4:2:2
        r1 = 1.0 * y1 + 0     * pb + 1.402 * pr;
        g1 = 1.0 * y1 - 0.344 * pb - 0.714 * pr;
        b1 = 1.0 * y1 + 1.772 * pb + 0     * pr;

        ER0 = clamp (r0);
        ER1 = clamp (r1);
        EG0 = clamp (g0);
        EG1 = clamp (g1);
        EB0 = clamp (b0);
        EB1 = clamp (b1);

        fprintf( fp, "%c%c%c%c%c%c",ER0,EG0,EB0,ER1,EG1,EB1); // Output two pixels
        //fprintf( fp, "Memory:%p Pixel:%d R:%d G:%d B:%d     Pixel:%d R:%d G:%d B:%d \n",location,val,ER0,EG0,EB0,(val+1),ER1,EG1,EB1);

        i++;
        }

        //fprintf( stderr, "Size of packed_value:%d Y0:%d Cb:%d Cr:%d Y1:%d\n", sizeof(packed_value), sizeof(y0), sizeof(cb0), sizeof(y1), sizeof(cr0));

//        break;
// 
//     default:
//         // Unsupported!
//         fprintf( stderr, "frame_save(): Unsupported type!\n" );
//         return -1;
//         }

    fprintf( stderr, "frame saved\n" );
    fclose( fp );
    return 0;
}

All the best,

 

Owen


> Date: Wed, 3 Feb 2010 13:18:44 -0500
> Subject: Re: Saving YUVY image from V4L2 buffer to file
> From: dheitmueller@kernellabs.com
> To: oo_hehir@hotmail.com
> CC: video4linux-list@redhat.com
> 
> On Wed, Feb 3, 2010 at 1:06 PM, Owen O' Hehir <oo_hehir@hotmail.com> wrote:
> >
> > Devin,
> >
> > Many thanks for the quick reply.
> >
> > Yes I'm getting some sort of an image. When I was experimenting I managed to get an image but in grayscale & showing multiple copies of the same image covering the top half of the image. I imagine it was distorted because I was not converting to RGB correctly.
> >
> > All the best,
> 
> Well, a picture is worth a thousand words, so if you perhaps would
> consider throwing one up on imagebin and providing a link, someone
> might be able to give you some insight as to the nature of the
> problem.
> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
 		 	   		  
_________________________________________________________________
Hotmail: Free, trusted and rich email service.
https://signup.live.com/signup.aspx?id=60969
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
