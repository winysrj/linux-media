Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4Efeo2007747
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 09:41:40 -0500
Received: from mgw-mx06.nokia.com (smtp.nokia.com [192.100.122.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB4EfQH1016955
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 09:41:27 -0500
Message-ID: <49367FD3.6080003@nokia.com>
Date: Wed, 03 Dec 2008 14:47:15 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: "ext Hiremath, Vaibhav" <hvaibhav@ti.com>
References: <19F8576C6E063C45BE387C64729E739403E90E6E06@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739403E90E6E06@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Add OMAP2 camera driver
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

ext Hiremath, Vaibhav wrote:
> OMAP3 - 
> 	Display - (Posted twice with old DSS library)
> 		- omap_vout.c
> 		- omap_voutlib.c
> 		- omap_voutlib.h
> 		- omap_voutdef.h
> 	Camera - (Will come soon)
> 		- omap34xxcam.c
> 		- omap34xxcam.h
> 	ISP - (Will come soon)
> 		- Here definitely we will plenty number of files.

I think that the OMAP 3 stuff could go into a separate directory, say 
omap3 or omap3isp. But for the OMAP 1 or OMAP 2 camera drivers, I'd 
perhaps just prefix those with corresponding OMAP (omap1 etc.).

The current OMAP 3 camera driver has few dependencies to OMAP 3 left so 
it seems that it's going to be generic. It's just a question of when the 
OMAP 3 ISP driver can offer a better interface towards the camera driver.

-- 
Sakari Ailus
sakari.ailus@nokia.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
