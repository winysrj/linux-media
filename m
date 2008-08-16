Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7G6mLKW018060
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 02:48:21 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7G6mAGR018701
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 02:48:10 -0400
Message-ID: <48A67A8D.8040104@hhs.nl>
Date: Sat, 16 Aug 2008 08:58:21 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: majortrips@gmail.com
References: <20080816050023.GB30725@thumper>
In-Reply-To: <20080816050023.GB30725@thumper>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

majortrips@gmail.com wrote:
> Adds suport for OmniVision OV534 based cameras:
>  - Hercules Blog Webcam
>  - Hercules Dualpix HD Webcam
>  - Sony HD PS3 Eye (SLEH 00201)
> 
> Currently only supports 640x480 YUYV non-interlaced output.
> 
> Signed-off-by: Mark Ferrell <majortrips@gmail.com>

Hi Mark,

Have you taken a look at the ov519 driver which is currently in gspca, which is 
  in 2.6.27rc1 and more general (latest version) available here:
http://linuxtv.org/hg/~jfrancois/gspca/

That driver does do jpeg, maybe it can give some clues. gspca is a webcam 
driver framework. Would you consider porting your driver to gspca, I (we ?) 
really want to see all usb webcam drivers start using the gspca framework to 
share as much code as possible.

> +The ov534 outputs frames in YUYV format, non-interlaced, at 640x480. This
> +format does not yet have wide support among user-land applications.  Though at
> +the time of this writing xawtv was known to work correctly.
> +

This (custom cam formats) was a big problem with gspca too, for this I've 
written libv4l, which is a library which does format conversion from many cam 
specific formats to more general formats in userspace. A joined effort between 
Debian, Suse and Fedora is currently working on making all v4l apps use libv4l, 
patches have already been written for gstreamer (cheese), pwlib (ekiga) and xawtv.

For more on libv4l see:
http://hansdegoede.livejournal.com/3636.html
http://linuxtv.org/v4lwiki/index.php/Libv4l_Progress

Maybe you can write a patch to add YUYV input support to libv4l, if you do that 
please base your work on the latest version which is available here:
http://linuxtv.org/hg/~hgoede/v4l-dvb

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
