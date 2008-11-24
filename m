Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAO89iP4000583
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:09:44 -0500
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAO89Vgk029948
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 03:09:32 -0500
Message-ID: <492A629C.1010808@hhs.nl>
Date: Mon, 24 Nov 2008 09:15:24 +0100
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
	<49292417.30100@hhs.nl>
	<Pine.LNX.4.64.0811231522510.6135@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811231522510.6135@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Apparent inconsistency in the labels of Bayer tilings
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
> Thanks for the recommendation about gettimeofday. I will try putting 
> that in. Right now, I wonder if you know something about the following:
> 
> In order to make your Bayer demosaicing algorithm work, I had to do the 
> following because otherwise the colors were mapped backwards:
> 
> 1. create new entries in your libv4lconvert-priv.h like this
> 
> #ifndef V4L2_PIX_FMT_SBGGR8
> #define V4L2_PIX_FMT_SBGGR8 v4l2_fourcc('B','G','G','R')
> #endif
> 

Erm, that one is defined in linux/videodev2.h and has been for a long time:
#define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. 
GRGR.. */

But I see I did not include it in libv4lconvert-priv.h, my bad.

Anyways to which fourcc you define V4L2_PIX_FMT_SBGGR8 should not matter, as 
for the meaning of the defines, as the command above shows in v4l BGGR means 
first line: BGBG.. second line: GRGR.., and then third line BGBG.. again, etc.

That seems pretty straightforward to me, how are libgphoto's defines supposed 
to be interpreted?

> #ifndef BAYER_TILE_BGGR
> #define BAYER_TILE_BGGR V4L2_PIX_FMT_SBGGR8
> #endif
> 
> and then use these. But in libgphoto2 the same photo from the same 
> camera has to use
> 
> BAYER_TILE_RGGB
> 
> So in other words when changing over the Bayer algorithm I also had to 
> change the label for the tiling from RGGB over to BGGR.
> 
> What gives? Do you happen to know? The two labels clearly disagree to 
> such an extent that they cannot both be right. Of course, the whole 
> thing is a matter of convention, presumably settled a long time ago by 
> someone who was neither of us. Also, the labeling of the Bayer tiles in 
> Gphoto was done long before I came along and thus I am not responsible 
> for it. So I explicitly do not give and do not have an opinion about who 
> is right.

The v4l convention also stems from before I came a long, I merely added the 
other 3 possible bayer patterns to the list.

Regards,

Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
