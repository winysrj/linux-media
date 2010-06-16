Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57423 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab0FPKML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:11 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 16 Jun 2010 12:11:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC] Samsung multimedia (FIMC and FB) drivers proposal
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, ben-linux@fluff.org,
	kgene.kim@samsung.com
Message-id: <1276683123-30224-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello, 

This RFC concerns Samsung's S3C/S5P SoC series and the proposal 
of a general solution for managing direct data pipelines between 
numerous graphics IPs present in these chips.

Background
-----------------

Selected multimedia devices in Samsung S3C/S5P SoCs are capable of 
transferring data directly between each other over so called fifo 
channels, bypassing the main memory system bus. The fifo links, for 
instance exist between tv scaler and framebuffer (S3C64xx), camera 
interface and framebuffer (S3C64xx, S5PC1xx and others) or framebuffer 
and video postprocessor (S3C64xx). Usually a framebuffer (display 
controller) is the data receiver in a different configurations. 
The framebuffer is divided into logic windows which represent 
data transfer destination objects in each fifo configurations. 

Implementation
-----------------

To enable the fifo link both ends need to be switched in a synchronized 
way to so called "local fifo mode". Depending on the SoC it mostly needs 
to be done shortly after an interrupt invocation and excess latencies 
are not acceptable. 

The proposed solution supports the following kinds of fifo links between
source and target devices:
 - "one to one", e.g. fimc-0 -> framebuffer window-0 (s5pv210 like)
 - "one to many" e.g. fimc-1 or TV scaler -> framebufer window-1
   (s3c64xx like)
 - "many to one", e.g. camera interface -> framebuffer window-0 or
   window-1 (s3c64xx like)

Implementing support for the local fifo mode requires partial control of 
one (slave) device from within other (master) device. The v4l2_subdev 
API seem to seem to be a concise solution for this problem. 

The following patches are a preliminary implementation of the V4L2 
driver of the camera interface/video postprocessor, which is found in 
S3C/S5P SoCs and required logic in s3c-fb driver. 

We decided to create a v4l2 subdevice instance at framebuffer per its each 
possible data source, depending on SoC architecture, as shown below:

                  -------------------          ---------------
                 |                   |        |               |
                 |   fb window-0     |  ....  |  fb window-N  |<---
                  -------------------         |               |    |
       ----------|  v4l2_subdev-0.1  |        |               |    |
      |           -------------------          ---------------     |
      |          |  v4l2_subdev-0.2  |        | v4l2_subdev-N |    |
      |           -------------------          ---------------     |
      |                 |                        |   ^             |
      |                 |    -------------------     |          slave_dev
      |                 |   |                     sub_dev          |
 --------------     ----------------                 |             |
|  v4l2_device |   |  v4l2_device   |       [ s3c_fifo_link ]------
 --------------     ----------------           | 
|              |   |                |      master_dev
|  tv scaler   |   | video postproc.|          |
|              |   |   (fimc-0)     |<---------
 --------------     ---------------- 


The s3c_fifo_link data structure allows to define possible device driver's 
connections, depending on the physical hardware architecture.

struct s3c_fifo_link {
	struct device	*master_dev;
	struct device	*slave_dev;
	struct v4l2_subdev *sub_dev;
};


Driver initialization sequence
-------------------------------

At slave (fb window) side:

- during probe() call fb driver initializes each window's subdevice 
  and s3c_fifo_link data structure 
  

At master (fimc-X) side:

- in video device open() fimc iterates through its list of pointers 
  to target subdevices earlier setup by the platform code 
  and initialized by fb probe() and calls v4l2_device_register_subdev() 


Driver module release sequence
-------------------------------

When the video postprocessor acquires one of the framebuffer subdevices 
the framebuffer module is marked as "in use" so it cannot be removed 
until the postprocessor has completed its perations on fb v4l2-subdev.

On slave module removal (unless any subdevice is in use):

- slave device driver deletes its all subdevices and sets to null
  corresponding sub_dev field in s3c_fifo_link instance

On master removal/close:

-  master device driver calls v4l2_device_register_subdev() on sub_dev; 
   after that subdevice/fifo interface may be used by any 
   other master device


I would like to ask for any comments on such a v4l2-subdev API usage
and on any possible drawbacks it might have.

Kernel tree
-----------------

This patch series has been prepared in assumption that the following
patches for s3c-fb driver has been applied:
1. S3C Frame Buffer patches prepared by Ben Dooks:
   git://git.fluff.org/bjdooks/linux for-2635/s3c-fb
2. S3C Frame Buffer patches prepared by Pawel Osciak:
   http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg01527.html
   
For easier code review all the patches will be also available in
few hours on:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/ 
branch s5pv210-fimc-fb

Patches
-----------------

The following patch series contains:

[PATCH 1/7] ARM: Samsung: Add FIMC driver register definition and platform helpers
[PATCH 2/7] ARM: Samsung: Add platform definitions for local FIMC/FIMD fifo path
[PATCH 3/7] s3c-fb: Add v4l2 subdevice to support framebuffer local fifo input path
[PATCH 4/7] v4l: Add Samsung FIMC (video postprocessor) driver
[PATCH 5/7] ARM: S5PV210: Add fifo link definitions for fimc and framebuffer
[PATCH 6/7] ARM: S5PV210: enable FIMC on Aquila
[PATCH 7/7] ARM: S5PC100: enable FIMC on SMDKC100

Best regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center


