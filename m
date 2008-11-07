Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA7Bxap2017253
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 06:59:36 -0500
Received: from smtp-out26.alice.it (smtp-out26.alice.it [85.33.2.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA7BxL6d015009
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 06:59:21 -0500
Date: Fri, 7 Nov 2008 12:59:19 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081107125919.ddf028a6.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [PATCH, RFC] mt9m111: allow data to be received on pixelclock
 falling edge?
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

with the attached patch I can work around a problem I had adding camera
support to the Motorola A780 phone, but I again don't know if it is a
proper fix. Could you help me to find out, please?

Using the same pxa-camera working setup I have for A910 (the other
phone which I am working on) I got incorrect data, see[1]. It turned
out to be because pxa CIF was getting data on pixelclock rising edge
but the sensor hardware on A780 wanted otherwise. So I tried to set
PXA_CAMERA_PCP in pxacamera_platform_data flags, but the sensor bus
config prevented pxa-camera to honour this setting. With the attached
patch I can set PCP high in pxa-camera and get the right data[2] out of
CIF, using this platform config:

struct pxacamera_platform_data a780_pxacamera_platform_data = {
	.init	= a780_pxacamera_init,
	.flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 |
		PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN |
		PXA_CAMERA_PCP,
	.mclk_10khz = 1000,
};

Now I have many questions:

* Can the same sensor model have different default hardwired values?
  I am referring to IO/Timings differences between mt9m111 on A910
  and A780
* Should I change the sensor setup instead of changing its advertised
  capabilities? Maybe modifying mt9m111 so it can use platform data?
* Is the pxa-camera code dealing with PXA_CAMERA_PCP too conservative?
  Shouldn't PXA_CAMERA_PCP be independent from the specific sensor
  capabilities? it is a valid pxa-camera setting even if it produces
  wrong results with the specific sensor.

Note that the two phones set up a different set of GPIOs as data
lines between mt9m111 and pxa.

Please let me know if you need more details.

Thanks,
   Antonio Ospite

[1] http://people.openezx.org/ao2/a780-not-yet.jpg
[2] http://people.openezx.org/ao2/a780-finally-works.jpg


Pixeldata can be sent on pixelclock falling edge, allow this option in
mt9m111 so pxa-camera can honour PXA_CAMERA_PCP platform data flag.

See pxa-camera.c, pxa_camera_set_bus_param():

	if ((common_flags & SOCAM_PCLK_SAMPLE_RISING) &&
	    (common_flags & SOCAM_PCLK_SAMPLE_FALLING)) {
		if (pcdev->platform_flags & PXA_CAMERA_PCP)
			common_flags &= ~SOCAM_PCLK_SAMPLE_RISING;
		else
			common_flags &= ~SOCAM_PCLK_SAMPLE_FALLING;
	}

...

	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
		cicr4 |= CICR4_PCP;


I needed this patch to make camera work properly on Motorola A780 phone.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 76fb0cb..69e103c 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -410,7 +410,8 @@ static int mt9m111_stop_capture(struct soc_camera_device *icd)

 static unsigned long mt9m111_query_bus_param(struct soc_camera_device *icd)
 {
- return SOCAM_MASTER | SOCAM_PCLK_SAMPLE_RISING |
+ return SOCAM_MASTER |
+   SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
    SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
    SOCAM_DATAWIDTH_8;
 }

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
