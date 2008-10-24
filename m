Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9O9tYKi001981
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 05:55:34 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9O9sp5k022636
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 05:54:51 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-fbdev-devel@lists.sourceforge.net"
	<linux-fbdev-devel@lists.sourceforge.net>, "video4linux-list@redhat.com"
	<video4linux-list@redhat.com>
Date: Fri, 24 Oct 2008 15:20:18 +0530
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D629792A@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: [PATCH 0/4] OMAP 2/3 DSS Library and V4L2 Display Driver
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

Hi All,
I will be posting the version 2 of the DSS library and V4L2 display driver 
with almost all the comments from the community taken care of.
It will be series of 4 patches containing

OMAP 2/3 DSS Library
OMAP3 EVM TV encoder Driver.
New IOCTLS added to V4L2 Framework (Already posted on V4L2 mailing list)
OMAP 2/3 V4L2 Display driver on the Video planes of DSS hardware.

We are enhancing the DSS library.  This is the first post containing the
features like power management, video pipeline, Digital overlay manager,
clock management support.

Further plan is to add graphics pipeline, LCD overlay manager, RFBI, DSI,
support and frame buffer interface for graphics pipeline

Please let us know your comments on further enhancements of the DSS Library
and V4L2 display driver.

Further discussions on DSS Library and V4L2 driver can be found at below threads.

http://lists-archives.org/video4linux/24597-new-display-subsystem-for-omap2-3.html
http://lists-archives.org/video4linux/24409-omap2-3-dss-library.html
http://lists-archives.org/video4linux/24410-omap-2-3-v4l2-display-driver-on-video-planes.html
http://lists-archives.org/video4linux/24600-omap-2-3-v4l2-display-driver-on-video-planes.html

 
Thanks and Regards,
Hardik Shah

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
