Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9NCa0Co002021
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 08:36:09 -0400
Received: from d1.scratchtelecom.com (69.42.52.179.scratchtelecom.com
	[69.42.52.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9NCZ1Md012668
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 08:35:02 -0400
Received: from vegas (CPE00a02477ff82-CM001225d885d8.cpe.net.cable.rogers.com
	[99.249.154.65])
	by d1.scratchtelecom.com (8.13.8/8.13.8/Debian-3) with ESMTP id
	m9NCZ1mV012558
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 08:35:01 -0400
Received: from lawsonk (helo=localhost)
	by vegas with local-esmtp (Exim 3.36 #1 (Debian)) id 1KszP0-00045g-00
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 08:34:58 -0400
Date: Thu, 23 Oct 2008 08:34:58 -0400 (EDT)
From: Keith Lawson <lawsonk@lawson-tech.com>
To: video4linux-list@redhat.com
In-Reply-To: <65b651b40810221308g2642db2aq3f95d60b991cf375@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810230832170.15646@vegas>
References: <65b651b40810201228k435cff91x58a67417eb0882c2@mail.gmail.com>
	<65b651b40810221308g2642db2aq3f95d60b991cf375@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Subject: Re: TM5600/XC2028 based USB Tv Tuner
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



On Thu, 23 Oct 2008, Rakesh Peter wrote:

> Hello there...
>
> I've been trying to get my Enter Multimedia E-220U USB TV Tuner Stick up and
> running in Linux. I've downloaded your dev-branch on the same from linuxtv
> mercurial repository. But I'm yet to figure out how to go about extracting
> the firmware from the device driver.
>
> The driver file found in the CD is uploaded here:
>
> http://www.esnips.com/doc/b042f5cd-1eca-4616-a875-5f7791eabd8d/e220u-driver
>
> The photos of the device is available at:
>
> http://www.flickr.com/photos/31592772@N04/
>
> For lsusb, the device is showing up as
>
> Bus 005 Device 007: ID 6000:560a
>
> If you can provide me some idea on how to proceed with detecting and
> extracting the firmware content, it will be great.
>

I was able to extract the firmware for my TM5600 based device using the dd 
commands documented here (at bottom of page):

http://www.linuxtv.org/v4lwiki/index.php/Trident_TM6000

My thread regarding the issue:

http://lists-archives.org/video4linux/24483-tm6010-tm5600-firmware-file-s.html

> Awaiting your kind response...
>
> Regards,
>
> Rakesh Peter
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
