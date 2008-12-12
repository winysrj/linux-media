Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBCLd28e022602
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 16:39:02 -0500
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBCLcmJ2004952
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 16:38:48 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 12 Dec 2008 15:38:37 -0600
Message-ID: <A24693684029E5489D1D202277BE894415E6EB23@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>, "Nagalla,
	Hari" <hnagalla@ti.com>
Subject: [RESEND REVIEW PATCH 00/14] OMAP3 camera + ISP + MT9P012 sensor
 driver (tarball)
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

Hi,

I'm resending the same patches but now through a public location, as some patches didn't make it thanks to the message size limiting filter.

Please download the patches stored in this tarball:

https://omapzoom.org/gf/download/docmanfileversion/49/879/l-o_cam_patches_2008_12_11_clean.tar.bz2

I really appreciate your time doing this.

Regards,
Sergio

-----Original Message-----
From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-bounces@redhat.com] On Behalf Of Aguirre Rodriguez, Sergio Alberto
Sent: Thursday, December 11, 2008 2:38 PM
To: linux-omap@vger.kernel.org; video4linux-list@redhat.com
Cc: Sakari Ailus; Tuukka.O Toivonen; Nagalla, Hari
Subject: [REVIEW PATCH 00/14] OMAP3 camera + ISP + MT9P012 sensor driver

Hi,

I'm sending the following patchset for review to the relevant lists (linux-omap and v4l).

Includes:
 - Omap3 camera core + ISP drivers.
 - Preview and Resizer Wrappers for Memory to Memory operation of the ISP.
 - MT9P012 sensor driver (adapted to 3430SDP)
 - DW9710 lens driver ()
 - Necessary v4l2-int-device changes to make above drivers work

Some notes:
 - Uses v4l2-int-device solution.
 - Tested with 3430SDP ES3.0 VG5.0.1 with Camkit v3.0.1
 - Applies cleanly on top of commit 249d6164958e1c8de46fbb30396de9ae6e9a3a50 by David Brownell (ARM: OMAP: use gpio_to_irq)
 - Needed "ARM: OMAP: use GPIO standard in OneNAND driver" patch to be able to compile resulting kernel image using omap_3430sdp_defconfig.

I appreciate in advance your time.

Regards,
Sergio

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
