Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6VDrvZf028152
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 09:53:57 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6VDrfhp007418
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 09:53:42 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KOYb4-000172-IH
	for video4linux-list@redhat.com; Thu, 31 Jul 2008 13:53:38 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 13:53:38 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Thu, 31 Jul 2008 13:53:38 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Thu, 31 Jul 2008 16:53:30 +0300
Message-ID: <g6sg4o$jjg$1@ger.gmane.org>
References: <294f0a37c4feadf87bf8.1217484144@carolinen.hni.uni-paderborn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <294f0a37c4feadf87bf8.1217484144@carolinen.hni.uni-paderborn.de>
Subject: Re: [PATCH] Move .power and .reset from soc_camera platform to
 sensor driver
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

Stefan Herbrechtsmeier wrote:
> Move .power (enable_camera, disable_camera) and .reset from soc_camera
> platform driver (pxa_camera_platform_data, sh_mobile_ceu_info) to sensor
> driver (soc_camera_link) and add .init and .release to request and free
> gpios.
> 
> Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>

While I agree that it is good to move .power and .reset to
soc_camera_link... IMHO controlling of these should be left in
host driver.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
