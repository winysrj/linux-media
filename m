Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4ITHvI011997
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 13:29:17 -0500
Received: from bear.ext.ti.com (bear.ext.ti.com [192.94.94.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB4IT1Re008244
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 13:29:01 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Sakari Ailus <sakari.ailus@nokia.com>, "Hiremath, Vaibhav"
	<hvaibhav@ti.com>
Date: Thu, 4 Dec 2008 12:28:52 -0600
Message-ID: <A24693684029E5489D1D202277BE894415C11947@dlee02.ent.ti.com>
In-Reply-To: <49367FD3.6080003@nokia.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] Add OMAP2 camera driver
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

> Sakari Ailus wrote:
> ext Hiremath, Vaibhav wrote:
> > OMAP3 -
> > 	Display - (Posted twice with old DSS library)
> > 		- omap_vout.c
> > 		- omap_voutlib.c
> > 		- omap_voutlib.h
> > 		- omap_voutdef.h
> > 	Camera - (Will come soon)
> > 		- omap34xxcam.c
> > 		- omap34xxcam.h
> > 	ISP - (Will come soon)
> > 		- Here definitely we will plenty number of files.
> 
> I think that the OMAP 3 stuff could go into a separate directory, say
> omap3 or omap3isp. But for the OMAP 1 or OMAP 2 camera drivers, I'd
> perhaps just prefix those with corresponding OMAP (omap1 etc.).
> 
> The current OMAP 3 camera driver has few dependencies to OMAP 3 left so
> it seems that it's going to be generic. It's just a question of when the
> OMAP 3 ISP driver can offer a better interface towards the camera driver.
> 
[Aguirre, Sergio] Hi, I have some comments about this:

IMHO, I think that we can keep same names for OMAP3 camera driver, and keep it at the same level than omap1 and omap2 cam drivers, but for isp folder, I agree with Sakari that has to be named omap3isp.

Although the end result of making OMAP3 cam driver independent from ISP doesn't make much sense to me, as in OMAP3 the ISP is needed even for the minimal handling required for receiving data from the sensors that the camera driver supports. (Minimal datapath is CCP2->SDRAM or CSI2->SDRAM, and that requires ISP MMU and the corresponding receivers, which are considered part of the ISP)

About display filenames, if they are compatible with all OMAP versions (1, 2, 3), then current name makes sense, if no, then omap3_vout* will look clearer.

What do you think?

Regards,
Sergio


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
