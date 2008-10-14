Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9EFV9Rr016606
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 11:31:09 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9EFUsM5026371
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 11:30:54 -0400
Received: by ug-out-1314.google.com with SMTP id o38so795726ugd.13
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:30:54 -0700 (PDT)
Message-ID: <226dee610810140830i113118ecre455821efadeeeeb@mail.gmail.com>
Date: Tue, 14 Oct 2008 21:00:53 +0530
From: "JoJo jojo" <onetwojojo@gmail.com>
To: jj@ds.pg.gda.pl
In-Reply-To: <48f4b3d25c6e39.82979954@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <48f4b3d25c6e39.82979954@wp.pl>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
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

Hi Janusz

try posting your query here
video4linux-list@redhat.com

then let us know at microdia groups if your issue was resolved


-JoJo

2008/10/14 Janusz Jurski <jurskij@wp.pl>:
> Hi,
>
> I am trying to get my USB camera working on Debian (regular Etch install
> with all updates). gspca compiles well and when I plug in the camera the
> sonixj module gets loaded to support this camera (0c45:612a Microdia)
> and the /dev/video0 device appears - no errors or suspicious messages in
> kernel log returned by dmesg.
>
> However, when I start streamer, I get the following errors:
>
> jj@piw:~$ ./streamer -ddddd -c /dev/video0 -o a.jpeg
> checking writer files [multiple image files] ...
>  video name=ppm ext=ppm: ext mismatch [need jpeg]
>  video name=pgm ext=pgm: ext mismatch [need jpeg]
>  video name=jpeg ext=jpeg: OK
> files / video: JPEG (JFIF) / audio: none
> vid-open: trying: v4l2-old...
> vid-open: failed: v4l2-old
> vid-open: trying: v4l2...
> ioctl:
> VIDIOC_QUERYCAP(driver="";card="";bus_info="";version=0.0.0;capabilities=0x0
> []): Invalid argument
> vid-open: failed: v4l2
> vid-open: trying: v4l...
> vid-open: failed: v4l
> no grabber device available
> jj@piw:~$
>
> A problem (similar?) with motion as well:
>
> jj@piw:/mnt/dane/samba/motion.src/motion-3.2.3$ ./motion -n -ddd -c
> `pwd`/motion.conf
> [0] Processing thread 0 - config file
> /mnt/dane/samba/motion.src/motion-3.2.3/motion.conf
> [1] Thread is from /mnt/dane/samba/motion.src/motion-3.2.3/motion.conf
> [1] Thread started
> [1] ioctl (VIDIOCGCAP): Invalid argument
> [1] Capture error calling vid_start
> [1] Thread finishing...
> jj@piw:/mnt/dane/samba/motion.src/motion-3.2.3$
>
> The same problem when starting stream or motion from root account. Any
> Idea what is wrong?
>
> Thanks,
> JJ
>
> ----------------------------------------------------
> Masters of Dirt - mistrzostwie Freestyle Motocrossu
> z ca³ego ¶wiata w Katowickim Spodku!
> Zobacz to z nami:
> http://klik.wp.pl/?adr=http%3A%2F%2Fcorto.www.wp.pl%2Fas%2Fextrema10338501.html&sid=518
>
>
>
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Spca50x-devs mailing list
> Spca50x-devs@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spca50x-devs
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
