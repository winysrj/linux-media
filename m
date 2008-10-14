Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9EJYq0c009590
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 15:34:52 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9EJXYuX023916
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 15:33:35 -0400
Message-ID: <48F4D9DC.5080008@hhs.nl>
Date: Tue, 14 Oct 2008 19:41:48 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: jj@ds.pg.gda.pl, SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux and Kernel Video <video4linux-list@redhat.com>
References: <48f4b3d25c6e39.82979954@wp.pl>
In-Reply-To: <48f4b3d25c6e39.82979954@wp.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: [Spca50x-devs] sonixj problems
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

Janusz Jurski wrote:
> Hi,
> 
> I am trying to get my USB camera working on Debian (regular Etch install 
> with all updates). gspca compiles well and when I plug in the camera the 
> sonixj module gets loaded to support this camera (0c45:612a Microdia) 
> and the /dev/video0 device appears - no errors or suspicious messages in 
> kernel log returned by dmesg.
> 

What does get returned by dmesg?

> However, when I start streamer, I get the following errors:
> 
> jj@piw:~$ ./streamer -ddddd -c /dev/video0 -o a.jpeg
> checking writer files [multiple image files] ...
>   video name=ppm ext=ppm: ext mismatch [need jpeg]
>   video name=pgm ext=pgm: ext mismatch [need jpeg]
>   video name=jpeg ext=jpeg: OK
> files / video: JPEG (JFIF) / audio: none
> vid-open: trying: v4l2-old...
> vid-open: failed: v4l2-old
> vid-open: trying: v4l2...
> ioctl: 
> VIDIOC_QUERYCAP(driver="";card="";bus_info="";version=0.0.0;capabilities=0x0 
> []): Invalid argument
> vid-open: failed: v4l2

This means that this is probably not gspcav2 as it has been merged into the 
2.6.27 kernel, please use that version. See:
http://moinejf.free.fr/gspca_README.txt

Note that streamer is part of xawtv and xawtv has known bugs which are 
triggered in certain use cases when used together with gspca, you should really 
compile xawtv with this patch:
https://bugzilla.redhat.com/attachment.cgi?id=313380

What we *really* need is a new upstream for xawtv (as its still quite popular) 
even its just a place to collect all fixes currently scattered over many 
different distros. So any volunteers to organize this?

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
