Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m21Laxg3012900
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 16:36:59 -0500
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m21LaSMe016899
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 16:36:28 -0500
Received: by gv-out-0910.google.com with SMTP id l14so1912855gvf.13
	for <video4linux-list@redhat.com>; Sat, 01 Mar 2008 13:36:27 -0800 (PST)
Message-ID: <226dee610803011336j2ced4da1w32f54ab39a348c32@mail.gmail.com>
Date: Sun, 2 Mar 2008 03:06:26 +0530
From: "JoJo jojo" <onetwojojo@gmail.com>
To: Peter.Nabbefeld@gmx.de
In-Reply-To: <fqccdj$flf$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fqccdj$flf$1@ger.gmane.org>
Cc: video4linux-list@redhat.com
Subject: Re: Problems with microdia webcam
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

Hi Peter

Your webcam is currently not supported by any free kernel driver.

-JoJo

On Sun, Mar 2, 2008 at 3:30 AM, Peter Nabbefeld <Peter.Nabbefeld@gmx.de> wrote:
>
>  Hello!
>
>  I'm new to video4linux, and I've got a "0c45:624e Microdia" webcam. I've
>  already installed the microdia driver from google newsgroup, /dev/v4l
>  and /dev/video0 exist.
>
>  I've tried to use camorama, vidcat, xsane. Camorama freezes, vidcat with
>  default size says "VIDIOCMCAPTURE: Resource temporarily unavailable".
>  Calling vidcat with "vidcat -d /dev/video0 -s 640x480" seems at least to
>  wait for picture data, but nothing happens. Xsane does detect my camera,
>  but when I try to "scan", it also freezes. Seems, the apps are waiting
>  for data, but no data arrives for some reason.
>
>  Any ideas?
>
>  Kind regards
>
>  Peter Nabbefeld
>
>
>
>  BTW: Are there any Java bindings for V4L? Then I could probably try to
>  write my own hacks to find out what happens ...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
