Return-path: <linux-media-owner@vger.kernel.org>
Received: from wipro-blr-out01.wipro.com ([203.91.198.74]:57526 "EHLO
	wipro-blr-out02.wipro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754683Ab0E1NzF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 09:55:05 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: Regarding  OMAP 35xx  ISP subsystem and SoC-Camera
Date: Fri, 28 May 2010 19:24:57 +0530
Message-ID: <336834A7A2D8B34BA5A8906E6E71DF870113EC41@BLR-SJP-MBX01.wipro.com>
From: <manjunathan.padua@wipro.com>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Linux-media group
  I am a newbie and have recently started working on integration of a new camera sensor MT9M112 sensor with OMAP ISP Camera subsystem on a OMAP 3530 based custom board.  So I checked in mainline kernel if driver is available for this camera sensor and  I found it in the  Linux/driver/media/video/mt9m11.c, this supports both MT9M111 and MT9M112. It is based on SoC-Camera framework.   But unfortunately this is not compatible with OMAP 35xx  Camera ISP subsystem  as OMAP camera ISP subsystem is based on V4L2-INT.

Also I got know that there are there are 3 different frameworks for camera sensor drivers in Linux
a. V4L2-INT is deprecated but currently supported by OMAP35xx ISP Linux BSP
b. SoC-Camera is  also deprecated.
c. Sub-Device is the current architecture supported from Open source community 

1. Is this understanding correct ?
2. Since V4L2-INT and SoC-Camera frameworks are deprecated, can you please let me know the roadmap for Sub-Device framework ?
3. What is the best option/recommendation from community for me to integrate MT9M112 with Camera ISP system on OMAP 3530 based board ?
4. And lastly are there any other different camera sensors which have Sub-Device based drivers available in Mainline Linux?

Thanks & best regards
Manjunathan


For your reference : Below are some references that I found on the internet/mailing list while researching on this. These are extra information on OMAP's Camera ISP subsystem implementation on Linux and SoC camera.

As per the following websites/mailing lists, it seems that we there is no direct way to integrate SoC camera framework based drivers with OMAP and SoC CAM is deprecated.
 1) http://processors.wiki.ti.com/index.php/OMAP3_GIT_Linux_Kernel#Video_Capture
 2) http://www.archivum.info/video4linux-list@redhat.com/2008-08/00125/Re:-%5BPATCH-v2%5D-soc-camera:-add-API-documentation.html

----------- extract from #2 mailing list dated August 2008 ----------------
......
.....
I've been thinking it could make sense to unify v4l2-int-if and SoC camera efforts in longer term.

Although the approach in SoC camera is somewhat different than in v4l2-int-if they share some similarities. V4l2-int-if tries to define common set of commands for commanding different hardware devices that make one V4L2 device, e.g. /dev/video0. SoC camera, OTOH, is a hardware-independent camera driver that can interface with different camera controllers and image sensors.

Interestingly, the concepts used in v4l2-int-if and SoC camera are quite
similar. Roughly equivalent pieces can be found easily:

v4l2-int-if + OMAP 3 camera             SoC camera

OMAP 3 camera driver (int if master)    SoC camera driver
OMAP 3 ISP driver                       host
sensor (int if slave)                   device
lens (int if slave)
flash (int if slave)

Control flow:

SoC camera
|    \
|     \
|      \
|       \
host    device

OMAP 3 camera driver
|    |        |   \
|    |        |    \
|    |        |     \
|    |        |      \
|    sensor   lens    flash
|    |
|    |
|    machine/platform specific code
|      /
|     /
|    /
|   /
|  /
ISP

------------------------------end of the extract from mailing list-------------------------------------------

