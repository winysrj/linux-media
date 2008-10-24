Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9O7BOLB020699
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 03:11:24 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9O7BIM5008618
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 03:11:19 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Thomas Kaiser <linux-dvb@kaiser-linux.li>
In-Reply-To: <4900DA6B.4050902@kaiser-linux.li>
References: <4900DA6B.4050902@kaiser-linux.li>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 24 Oct 2008 09:01:39 +0200
Message-Id: <1224831699.1761.13.camel@localhost>
Mime-Version: 1.0
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

On Thu, 2008-10-23 at 22:11 +0200, Thomas Kaiser wrote:
> Hey

Hi Thomas,

	[snip]
> make menuconfig in ~/Projects/webcams/v4l-dvb and remove all stuff
> except the gspca and V4l2.
> After this, I did not find a .config file in the
> ~/Projects/webcams/v4l-dvb folder. Where is the .config stored?
> Several dvb and/or analog capture driver where made. Why?, I disabled!

You may copy the /boot/config to <hg root>/vl4/ and do a make menuconfig
(but this will not work without the kernel sources).

	[snip]
> After plugging the cam in the kernel log:
	[snip]
> Oct 23 20:52:55 LAPI01 kernel: [ 2016.194043] gspca_main: disagrees
> about version of symbol video_ioctl2

This means you have old versions of the video modules loaded in memory.

	[snip]
> Oct 23 20:52:55 LAPI01 kernel: [ 2016.231335]
> /build/buildd/linux-ubuntu-modules-2.6.24-2.6.24/debian/build/build-generic/media/gspcav1/gspca_core.c: 
> 
> USB GSPCA camera found.(ZC3XX)
> Oct 23 20:52:55 LAPI01 kernel: [ 2016.425349] usbcore: registered new
> interface driver gspca
> Oct 23 20:52:55 LAPI01 kernel: [ 2016.425364]
> /build/buildd/linux-ubuntu-modules-2.6.24-2.6.24/debian/build/build-generic/media/gspcav1/gspca_core.c: 
> 
> gspca driver 01.00.20 registered

This is the old driver gspca v1. If it is still present
in /lib/modules/... , remove it.

I think these old modules are loaded at system startup time from initrd.
You should rebuild this one.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
