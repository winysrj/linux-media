Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9NLXOjc017275
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 17:33:24 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9NLX6GN023713
	for <video4linux-list@redhat.com>; Thu, 23 Oct 2008 17:33:06 -0400
Message-ID: <4900EDA7.6070000@free.fr>
Date: Thu, 23 Oct 2008 23:33:27 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Thomas Kaiser <linux-dvb@kaiser-linux.li>
References: <4900DA6B.4050902@kaiser-linux.li>
In-Reply-To: <4900DA6B.4050902@kaiser-linux.li>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Video 4 Linux <video4linux-list@redhat.com>
Subject: Re: gspca, what do I am wrong?
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

Hi Thomas,

Thomas Kaiser a écrit :
> Hey
> 
> I think this mail came not through, so I send it again. Sorry, when it
> comes twice.
> 
> I just pasted the interesting things into this email (With some comments
> inline). Hope somebody can help:
> 
> thomas@LAPI01:~$ lsb_release -a
> No LSB modules are available.
> Distributor ID:    Ubuntu
> Description:    Ubuntu 8.04.1
> Release:    8.04
> Codename:    hardy
> 
> thomas@LAPI01:~$ uname -a
> Linux LAPI01 2.6.24-21-generic #1 SMP Mon Aug 25 17:32:09 UTC 2008 i686
> GNU/Linux
> 
> thomas@LAPI01:~/Projects/webcams$ hg clone http://linuxtv.org/hg/v4l-dvb
> to get the newest v4l source.
> 
> make menuconfig in ~/Projects/webcams/v4l-dvb and remove all stuff
> except the gspca and V4l2.
> After this, I did not find a .config file in the
> ~/Projects/webcams/v4l-dvb folder. Where is the .config stored?
~/Projects/webcams/v4l-dvb/v4l/.config

> Several dvb and/or analog capture driver where made. Why?, I disabled!
> 
Look at the .config, perhaps you forgot to disable some additional modules
> thomas@LAPI01:~/Projects/webcams/v4l-dvb$ make
> ¨make -C /home/thomas/Projects/webcams/v4l-dvb/v4l
> make[1]: Entering directory `/home/thomas/Projects/webcams/v4l-dvb/v4l'
> creating symbolic links...
> Kernel build directory is /lib/modules/2.6.24-21-generic/build
> make -C /lib/modules/2.6.24-21-generic/build
> SUBDIRS=/home/thomas/Projects/webcams/v4l-dvb/v4l  modules
[SNIP]
> After plugging the cam in the kernel log:
> 
> Oct 23 20:52:54 LAPI01 kernel: [ 2015.905111] usb 1-1: new full speed
> USB device using uhci_hcd and address 5
> Oct 23 20:52:54 LAPI01 kernel: [ 2016.075400] usb 1-1: configuration #1
> chosen from 1 choice
> Oct 23 20:52:54 LAPI01 kernel: [ 2016.078879] usb 1-1: ZC0301[P] Image
> Processor and Control Chip detected (vid/pid 0x041E:0x401C)
> Oct 23 20:52:55 LAPI01 kernel: [ 2016.164172] usb 1-1: No supported
> image sensor detected
> Oct 23 20:52:55 LAPI01 kernel: [ 2016.194043] gspca_main: disagrees
> about version of symbol video_ioctl2
Please try make rmmod before plugging-in your device and check that no
v4l-dvb module is loaded.
This will remove any old v4l-dvb module already present.

Cheers,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
