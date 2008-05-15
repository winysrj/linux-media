Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4FFJnFh010018
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 11:19:49 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4FFJaPS008027
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 11:19:37 -0400
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 3130417F5B1
	for <video4linux-list@redhat.com>;
	Thu, 15 May 2008 17:19:36 +0200 (CEST)
Received: from jef.local (lns-bzn-32-82-254-26-141.adsl.proxad.net
	[82.254.26.141])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 0D8CF17F55C
	for <video4linux-list@redhat.com>;
	Thu, 15 May 2008 17:19:35 +0200 (CEST)
Received: from jef by jef.moine.bzh with local (masqmail 0.2.21) id
	1Jwfji-0SI-00 for <video4linux-list@redhat.com>; Thu, 15 May 2008
	17:51:18 +0200
To: video4linux-list@redhat.com
From: Jean-Francois Moine <moinejf@free.fr>
References: <62e5edd40805150604h6d0f23ffybf13eb6b07d87a76@mail.gmail.com>
Message-ID: <TTY-Grin-jef-482C5BF6.4DDD7B2D@jef>
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Date: Thu, 15 May 2008 17:51:18 +0200
Subject: Re: In-kernel frame conversion
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

On Thu, 15 May 2008 15:04:45 +0200, "Erik_Andrén" 
<erik.andren@gmail.com> wrote:
>Hi list,

Hi Erik,

>I'm one of the developers of the m560x project. (
>http://sourceforge.net/projects/m560x-driver/ )
>aiming to provide a driver for the ALi m5602, m5603 chipsets.
	[snip]
>This driver is unfortunately braindead, always sending Bayer-encoded frames
>at a fixed VGA resolution.
>Color recovery, resizing and format conversion is all done in software.
>
>Currently we do the same in order to make the camera useful as many relevant
>linux v4l2 applications fail to have user-space routines converting
>Bayer-frames.
>
>Is it possible to get a driver included upstream and still have such
>kernel-space frame conversion routines or do they have to go in order to get
>the driver in an acceptable shape?

I am working on a driver, gspca v2, which does frame conversion in
user-space. It is based on gspca v1 which handles over 270 USB
webcams. It is composed of:
- a main driver with the USB exchanges and the v4l2 interface,
- kernel modules for the different webcam types (actually 20) and
- a helper process which does frame conversion (JPEG and Bayer to
  YUV420, YUYV and RGB24/32).

I planned to put it under mercurial as soon as most of the webcams
will be tested (and the code will be purified ;)). Feel free to get
a tarball from my site (see below) and to tell me if you may enter
into this scheme.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
