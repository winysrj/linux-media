Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2VEP6uv000753
	for <video4linux-list@redhat.com>; Tue, 31 Mar 2009 10:25:06 -0400
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2VEOkoi014811
	for <video4linux-list@redhat.com>; Tue, 31 Mar 2009 10:24:46 -0400
Received: from steven-toths-macbook-pro.local
	(ool-45721e5a.dyn.optonline.net [69.114.30.90]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0KHD001Y8K0YW720@mta5.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Tue, 31 Mar 2009 10:24:37 -0400 (EDT)
Date: Tue, 31 Mar 2009 10:24:35 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <49D20B0B.1030701@australiaonline.net.au>
To: john knops <jknops@australiaonline.net.au>
Message-id: <49D227A3.5000601@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <49D20B0B.1030701@australiaonline.net.au>
Cc: video4linux-list@redhat.com
Subject: Re: No scan with DViCo FusionHDTV DVB-T Dual Express
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

Hi John,

john knops wrote:
> I'm using the DViCo card with  Ubuntu 8.10amd64. I've followed the 
> various instructions for installing drivers and firmware viz:-
> loaded the drivers(v4l-dvb-b44a3aed3d1.tar.gz) as suggested on 
> www.linuxtv.org/wiki/index.php/DViCo_FusionHDTV_DVB-T_Dual_Express 
> <http://www.linuxtv.org/wiki/index.php/DViCo_FusionHDTV_DVB-T_Dual_Express> 
> from linuxtv.org/hg/~stoth/v4l-dvb. I also had to load gspca_m5602.ko in 
> /lib/modules/2.6.27-11-generic/kernel/drivers/media/video/gspca.


The wiki url points to a page that doesn't exist.


> 
> The card wasn't auto-loaded until I added "options cx23885 card=11" to 
> /etc/modprobe.d/options.
> I obtained xc3028-v27.fw.tar.bz2 via ubuntuforums.org then copied the 
> untarred file xc3028-v27.fw to /lib/firmware.

It's probably a new rev of the card with a new subid, which is why you have to 
force load it.

What does lspci -vn look like? (Show the section specific to the cx23885).


> [34889.915511] xc2028 0-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 
> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> [34889.949353] xc2028 0-0061: Incorrect readback of firmware version.
> 
> Any ideas why I'm getting " Incorrect readback of firmware version" What 
> have I missed/done wrong?

... and it may not have a xc3028 onboard, or may have the low power version 
which is why the firmware fails to load. A few other things come to mind but 
given that the vendor has switch subid details, it's probably best to cross 
reference with the wiki to ensure it still has the same parts.

Assuming the wiki entry truly doesn't exist, maybe you could create it with the 
newer rev details, maybe with some pictures and component details?

- Steve




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
