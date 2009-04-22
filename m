Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:22454 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZDVIXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 04:23:18 -0400
Subject: Re: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Reply-To: tomi.valkeinen@nokia.com
To: ext Hardik Shah <hardik.shah@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Brijesh Jadav <brijesh.j@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
In-Reply-To: <1240381551-11012-1-git-send-email-hardik.shah@ti.com>
References: <1240381551-11012-1-git-send-email-hardik.shah@ti.com>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 11:22:58 +0300
Message-Id: <1240388578.12545.14.camel@tubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, 2009-04-22 at 08:25 +0200, ext Hardik Shah wrote:
> This is the version 5th of the Driver.
> 
> Following are the features supported.
> 1. Provides V4L2 user interface for the video pipelines of DSS
> 2. Basic streaming working on LCD and TV.
> 3. Support for various pixel formats like YUV, UYVY, RGB32, RGB24, RGB565
> 4. Supports Alpha blending.
> 5. Supports Color keying both source and destination.
> 6. Supports rotation with RGB565 and RGB32 pixels formats.
> 7. Supports cropping.
> 8. Supports Background color setting.
> 9. Works on latest DSS2 library from Tomi
> http://www.bat.org/~tomba/git/linux-omap-dss.git/
> 10. 1/4x scaling added.  Detail testing left
> 
> TODOS
> 1. Ioctls needs to be added for color space conversion matrix
> coefficient programming.
> 2. To be tested on DVI resolutions.
> 
> Comments fixed from community.
> 1. V4L2 Driver for OMAP3/3 DSS.
> 2.  Conversion of the custom ioctls to standard V4L2 ioctls like alpha blending,
> color keying, rotation and back ground color setting
> 3.  Re-organised the code as per community comments.
> 4.  Added proper copyright year.
> 5.  Added module name in printk
> 6.  Kconfig option copy/paste error
> 7.  Module param desc addded.
> 8.  Query control implemented using standard query_fill
> 9.  Re-arranged if-else constructs.
> 10. Changed to use mutex instead of semaphore.
> 11. Removed dual usage of rotation angles.
> 12. Implemented function to convert the V4L2 angle to DSS angle.
> 13. Y-position was set half by video driver for TV output
> Now its done by DSS so removed that.
> 14. Minor cleanup
> 15. Added support to pass the page offset to application.
> 14. Minor cleanup
> 15. Added support to pass the page offset to application.
> 16. Renamed V4L2_CID_ROTATION to V4L2_CID_ROTATE
> 17. Major comment from Hans fixed.
> 18. Copy right year changed.
> 19. Added module name for each error/warning print message.
> 
> Changes from Previous Version.
> 1. Supported YUV rotation.
> 2. Supported Flipping.
> 3. Rebased line with Tomi's latest DSS2 master branch with commit  id
> f575a02edf2218a18d6f2ced308b4f3e26b44ce2.
> 4. Kconfig option removed to select between the TV and LCD.
> Now supported dynamically by DSS2 library.
> 5. Kconfig option for the NTSC_M and PAL_BDGHI mode but not
> supported by DSS2.  so it will not work now.

There is basic support for this. See the DSS doc:

/sys/devices/platform/omapdss/display? directory:
...
timings         Display timings (pixclock,xres/hfp/hbp/hsw,yres/vfp/vbp/vsw)
                When writing, two special timings are accepted for tv-out:
                "pal" and "ntsc"

 Tomi


