Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6315pBZ021797
	for <video4linux-list@redhat.com>; Thu, 2 Jul 2009 21:05:51 -0400
Received: from mail-fx0-f223.google.com (mail-fx0-f223.google.com
	[209.85.220.223])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6315ZEV013790
	for <video4linux-list@redhat.com>; Thu, 2 Jul 2009 21:05:35 -0400
Received: by fxm23 with SMTP id 23so1921785fxm.3
	for <video4linux-list@redhat.com>; Thu, 02 Jul 2009 18:05:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090602220233.GA23136@geppetto>
References: <20090602220233.GA23136@geppetto>
Date: Fri, 3 Jul 2009 04:05:34 +0300
Message-ID: <36c518800907021805v41ba3837n8dbd43fcdc0effcc@mail.gmail.com>
From: vasaka@gmail.com
To: video4linux-list Mailing List <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: video loopback device
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

On Wed, Jun 3, 2009 at 1:02 AM, Stefano
Sabatini<stefano.sabatini-lala@poste.it> wrote:
> Hi all,
>
> I'm looking for an application/driver which let to create a
> virtual device where to send the video output of an application or of
> another video device.
>
> Typical application would be for example to capture from a webcam,
> apply some filter to it, and finally pulish it to another application
> reading from a video device.
>
> I see there are at least three distinct projects which provides a
> video for loopback device:
>
> * video4linux loopback device/vloopback:
>  http://www.lavrsen.dk/twiki/bin/view/Motion/VideoFourLinuxLoopbackDevice
>
>  Seems to be unmaintained, also if I'm not wrong it only supports
>  video4linux and not video4linux 2 API.
>
> * video4linux2 virtual device
>  http://sourceforge.net/projects/v4l2vd/
>
>  This should be the successor of vloopback, unfortunately it seem not
>  to work with linux 2.6.26:
>  https://sourceforge.net/forum/forum.php?thread_id=2897804&forum_id=579262
>
>  and also seems a little unmaintained.
>
> * http://code.google.com/p/v4l2loopback/
>
>  I don't know if there are applications using it, just read about it
>  in this ML.
>
> I wonder if someone can express an opinion on these projects, for
> example to tell their current status / usability.
>
> TIA, regards.
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

Hello, I am an author of http://code.google.com/p/v4l2loopback/
this driver works with kernels up to 2.6.30 and I also written small
helper program to apply video effects
http://code.google.com/p/v4lsink/

It works fine with skype and there is bug report about interaction
with adobe flash. I started this driver exactly because all others did
not work with skype.

by the way, this mailing list is no longer used, please go to
linux-media@vger.kernel.org mailing list


vasaka

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
