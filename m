Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAK7gvIk009000
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 02:42:57 -0500
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAK7gisN025658
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 02:42:44 -0500
Message-ID: <4925163E.80902@hhs.nl>
Date: Thu, 20 Nov 2008 08:48:14 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
	<200811190020.15663.linux@baker-net.org.uk>
	<alpine.LNX.1.10.0811191937370.2980@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.1.10.0811191937370.2980@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, sqcam-devel@lists.sourceforge.net
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
	driver
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

<snip>

>>>> Correct, there is nothing special you need to do for that, just pass
>>>> frames with the raw bayer data to userspace and set the pixelformat to
>>>> one of: V4L2_PIX_FMT_SBGGR8 /* v4l2_fourcc('B', 'A', '8', '1'), 8 bit
>>>> BGBG.. GRGR.. */ V4L2_PIX_FMT_SGBRG8 /* v4l2_fourcc('G', 'B', 'R', 
>>>> 'G'),
>>>> 8 bit GBGB.. RGRG.. */ V4L2_PIX_FMT_SGRBG8 /*
>>>> v4l2_fourcc('G','R','B','G'), 8 bit GRGR.. BGBG.. */ 
>>>> V4L2_PIX_FMT_SRGGB8
>>>> /* v4l2_fourcc('R','G','G','B'), 8 bit RGRG.. GBGB.. */
> 
> Hmmm. If the userspace app wants the data presented like this, then I 
> would have to take back my previous remark. If the userspace app is 
> supposed to know something about the particular camera, though, my 
> previous remark stands.
> 

No this is just an example, if the cam can send compressed data too for 
example, then we need to define a new V4L2_PIX_FMT_FOO for that, and add suport 
for decompressing that to raw bayer to libv4l. Which could be an issue as 
libv4l is LGPL, to allow using it from any app, so we need to get permission 
from the author(s) to get the decompression code relicensed.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
