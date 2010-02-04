Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o14FwL0K014379
	for <video4linux-list@redhat.com>; Thu, 4 Feb 2010 10:58:22 -0500
Received: from mail.redembedded.co.uk (mail.redembedded.co.uk [83.100.215.137])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o14Fw9O2012297
	for <video4linux-list@redhat.com>; Thu, 4 Feb 2010 10:58:09 -0500
Message-ID: <4B6AEE8D.4070507@redembedded.com>
Date: Thu, 04 Feb 2010 15:58:05 +0000
From: Darren Longhorn <darren.longhorn@redembedded.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Re: Saving YUVY image from V4L2 buffer to file
References: <SNT123-W319B38F63C77A4CFB0FD99EE560@phx.gbl>	
	<4B69C29B.4010405@redembedded.com>
	<1265250209.3122.86.camel@palomino.walls.org>
In-Reply-To: <1265250209.3122.86.camel@palomino.walls.org>
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

Andy Walls wrote:
> On Wed, 2010-02-03 at 18:38 +0000, Darren Longhorn wrote:
>> Owen O' Hehir wrote:
>>> Hello All,
>>>
>>> I'm trying to save a captured image from a USB camera to a file. The capture is based on V4L2 video capture example from the V4L2 API spec. http://v4l2spec.bytesex.org/spec/a16706.htm
>>>
>>> The V4L2 set pointers (via mmap) to to the USB image (in YUV 4:2:2 (YUYV)) and as far as I can see the simplest way to save the image in a recognised format is in RGB format, specifically in PPM (Netpbm color image format).
>>>
>>> As such I've expanded the process_image function:
>>>
>>>
>>> static void
>>> process_image                   (const void *           p)
>>> {
>>>     static int count = 0;
>>>
>>>     static int r,g,b;
>>>     static int y1,y2,cb,cr;
>>>
>>>     int pixel=0;
>>>
>>>         FILE* fp = fopen("datadump", "w" );
>>>         // Write PNM header
>>>         fprintf( fp, "P6\n" );
>>>         fprintf( fp, "# YUV422 frame -> RGB \n" );
>>>         fprintf( fp, "%d %d\n", userfmt.fmt.pix.width, userfmt.fmt.pix.height );
>>>
>>>         fprintf( fp, "255\n" );
>>>
>>>         while(pixel < (userfmt.fmt.pix.width * userfmt.fmt.pix.height)){
>>>
>>>         y1 = *(p+pixel);
>> Are you sure that's your real code? I don't think you should dereference
>> a void pointer like that.
> 
> Old-ish C-compilers treated that as a char * in that case.  The behavior
> is unreliable of course.  This certainly could be a cause of problems.

Ah, yes. Well remembered!

Cheers

Darren

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
