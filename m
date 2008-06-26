Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5QMrpYR020785
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 18:53:51 -0400
Received: from calf.ext.ti.com (calf.ext.ti.com [198.47.26.144])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5QMrbkt011713
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 18:53:37 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by calf.ext.ti.com (8.13.7/8.13.7) with ESMTP id m5QMrRYH019177
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 17:53:32 -0500
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id m5QMrPRt000311
	for <video4linux-list@redhat.com>; Thu, 26 Jun 2008 17:53:26 -0500 (CDT)
From: "Jalori, Mohit" <mjalori@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Thu, 26 Jun 2008 17:53:25 -0500
Message-ID: <8AA5EFF14ED6C44DB31DA963D1E78F0DAF6DCCD1@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: omap3 camera driver
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

Here is the high level OMAP 3 Camera driver design and link to source code for review.

OMAP3 camera subsystem integrates two serial (CCP2, CSI2) and one parallel camera interface, a ccdc module, a preview module, a resizer module, a statistics collection module and a dedicated MMU.

OMAP camera driver (omap34xxcam.c, omap34xxcam.h): OMAP3 camera driver allows capturing and previewing images through a camera sensor. It is a V4L2-compliant driver with additions targeting an OMAP3 ISP hardware features. It interfaces with V4L2 sensor drivers using the V4L2 master slave i/f. Camera driver is also capable of handling multiple slaves (it can have a sensor as a slave and an associate lens actuator and flash as other slaves.
Each sensor driver exports the type of interface, serial or parallel, and type of sensor, raw or smart sensor. Sensor driver also makes call to ISP library to setup the interface specific parameters and i/p clocks.

ISP Library (isp.c, isp.h, ispreg.h): The ISP library exports APIs to configure ISP module and clocks to the sensor. It is the central interrupt handler where callback routines for ISP interrupts are handled.

CCDC library (ispccdc.c, ispccdc.h): CCDC is a HW block in Camera ISP which acts as a data input port. It receives data from the sensor through parallel or serial interface. The CCDC library exports API to configure CCDC. It is configured by the camera driver based on the sensor attached and desired output from the camera driver.

Preview library (isppreview.c, isppreview.h): Preview is a HW block in Camera ISP which is responsible for image processing and color conversion. It has HW blocks for image processing algorithms. Preview library allows camera driver to configure, enable and disable the individual HW blocks in the preview module.

Resizer library (ispresizer.c, ispresizer.h): Resizer is a HW block in Camera ISP which is responsible for image downscaling and upscaling. It has HW filters which resize the input image based on input/output configuration. Resizer library allows camera driver to query and configure the resizer module. Resizer in OMAP3 ISP supports on the fly resizing with ratios from 1/4 to 4. When used with camera driver resizer only supports on the fly mode of operation. In this mode image is taken from sensor and passed to application without any memory to memory operations in ISP and so multipass resizer operations are not supported. Resizer also has standalone, multipass resizer driver which can be used to overcome this limitation.

H3A library (isph3a.c, isph3a.h, isphist.c, isphist.h): H3A is a HW block in Camera ISP which is responsible for collecting image statistics that can be used by other algorithms. It generates auto focus, auto white balance, auto exposure and histogram statistics. H3A library allows user space algorithms to configure and request these statistics through private IOCTLs.

MMU Library (ispmmu.c, ispmmu.h): The ISP MMU library exports APIs that allow mapping of buffer to ISP MMU. This allows camera to work with discontiguous memory.

Table files (noise filter, gamma tables): Default values for these tables are maintained in the header files.

Private ioctls: We have exported private ioctls through which user space applications can request statistics for the images and apply feedback to OMAP3 ISP or sensor modules. Typically user space applications can request Auto-exposure, Auto white balance and Auto Focus statistics. They can use the same private IOCTL to update the parameters or use V4L2 specific controls to do so.

Private CIDs. One private CID is used to set color effects. Currently supported ones are B&W and Sepia.


Changes in V4L2
Following changes have been made to linux/mediav4l2-int-device.h file:
Additions of enums for power states. There are 4 possible power states defined which can be used with the s_power ioctls. Most sensor support standby mode so this allows us to put the sensors in standby mode.
Addition of CCP2 as one of the i/f types to v4l2_if_types and then we have the structures for supporting this interface.
Adding crop capability in the vidioc_int_ioctls.

Added defines for RAW10 bayer and Bayer DPCM data format in include/linux/videodev2.h


File organization
Camera driver is maintained under drivers/media/video directory
ISP files are under driver/media/video/isp directory
One include file is maintained under include/asm-arm/arch-omap/isp_user.h. this file is needed for private IOCTL implementation for data structure definitions


All files are available at http://linux.omap.com/pub/patches/rfc/34xxcamisp/omap34xx_camera_files.tar.gz. The files are available for review and will be shared as patches once review is complete.


Contributors:
Mohit Jalori
Leonides Martinez de la Cruz
Sameer Venkatraman
Senthilvadidu Guruswamy
Sakari Alius
Thara Gopinath
Tukka Toivanen
Toni Leinonen

Regards
Mohit


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
