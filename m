Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0U0rf5L032125
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 19:53:41 -0500
Received: from comal.ext.ti.com (comal.ext.ti.com [198.47.26.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0U0rOAb014592
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 19:53:24 -0500
From: Dominic Curran <dcurran@ti.com>
To: "linux-omap" <linux-omap@vger.kernel.org>, video4linux-list@redhat.com
Date: Thu, 29 Jan 2009 18:53:17 -0600
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291853.17775.dcurran@ti.com>
Cc: greg.hofer@hp.com
Subject: [OMAPZOOM][PATCH 0/6] Add support for Sony imx046 sensor.
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

From: Dominic Curran <dcurran@ti.com>
Subject: [OMAPZOOM][PATCH 0/6] Add support for Sony imx046 sensor.

This set of patches adds support for the Sony IMX046 camera.

Driver supports:
 - Sensor output format RAW10 (YUV conversion through CCDC)
 - Base output resolutions:
    - 3280x2464 @ 7.5fps  (8MP)
    - 3280x616  @ 7.5fps
    - 820x616   @ 30fps
 - Exposure & Gain control
 - Platforms: SDP3430 & Zoom2

thanks
dom

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
