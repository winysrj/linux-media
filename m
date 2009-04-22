Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55490 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZDVI1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 04:27:54 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: "tomi.valkeinen@nokia.com" <tomi.valkeinen@nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Wed, 22 Apr 2009 13:57:40 +0530
Subject: RE: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03051F7FCB@dbde02.ent.ti.com>
In-Reply-To: <1240388578.12545.14.camel@tubuntu>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Tomi Valkeinen [mailto:tomi.valkeinen@nokia.com]
> Sent: Wednesday, April 22, 2009 1:53 PM
> To: Shah, Hardik
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav, Brijesh R;
> Hiremath, Vaibhav
> Subject: Re: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
> 
> Hi,
> 
> On Wed, 2009-04-22 at 08:25 +0200, ext Hardik Shah wrote:
> > This is the version 5th of the Driver.
> >
> > Following are the features supported.
> > 1. Provides V4L2 user interface for the video pipelines of DSS
> > 2. Basic streaming working on LCD and TV.
> > 3. Support for various pixel formats like YUV, UYVY, RGB32, RGB24, RGB565
> > 4. Supports Alpha blending.
> > 5. Supports Color keying both source and destination.
> > 6. Supports rotation with RGB565 and RGB32 pixels formats.
> > 7. Supports cropping.
> > 8. Supports Background color setting.
> > 9. Works on latest DSS2 library from Tomi
> > http://www.bat.org/~tomba/git/linux-omap-dss.git/
> > 10. 1/4x scaling added.  Detail testing left
> >
> > TODOS
> > 1. Ioctls needs to be added for color space conversion matrix
> > coefficient programming.
> > 2. To be tested on DVI resolutions.
> >
> > Comments fixed from community.
> > 1. V4L2 Driver for OMAP3/3 DSS.
> > 2.  Conversion of the custom ioctls to standard V4L2 ioctls like alpha
> blending,
> > color keying, rotation and back ground color setting
> > 3.  Re-organised the code as per community comments.
> > 4.  Added proper copyright year.
> > 5.  Added module name in printk
> > 6.  Kconfig option copy/paste error
> > 7.  Module param desc addded.
> > 8.  Query control implemented using standard query_fill
> > 9.  Re-arranged if-else constructs.
> > 10. Changed to use mutex instead of semaphore.
> > 11. Removed dual usage of rotation angles.
> > 12. Implemented function to convert the V4L2 angle to DSS angle.
> > 13. Y-position was set half by video driver for TV output
> > Now its done by DSS so removed that.
> > 14. Minor cleanup
> > 15. Added support to pass the page offset to application.
> > 14. Minor cleanup
> > 15. Added support to pass the page offset to application.
> > 16. Renamed V4L2_CID_ROTATION to V4L2_CID_ROTATE
> > 17. Major comment from Hans fixed.
> > 18. Copy right year changed.
> > 19. Added module name for each error/warning print message.
> >
> > Changes from Previous Version.
> > 1. Supported YUV rotation.
> > 2. Supported Flipping.
> > 3. Rebased line with Tomi's latest DSS2 master branch with commit  id
> > f575a02edf2218a18d6f2ced308b4f3e26b44ce2.
> > 4. Kconfig option removed to select between the TV and LCD.
> > Now supported dynamically by DSS2 library.
> > 5. Kconfig option for the NTSC_M and PAL_BDGHI mode but not
> > supported by DSS2.  so it will not work now.
> 
> There is basic support for this. See the DSS doc:
> 
> /sys/devices/platform/omapdss/display? directory:
> ...
> timings         Display timings (pixclock,xres/hfp/hbp/hsw,yres/vfp/vbp/vsw)
>                 When writing, two special timings are accepted for tv-out:
>                 "pal" and "ntsc"
[Shah, Hardik] I was not aware of it will remove the compile time option and for now let the sysfs entry change the standard.  In future I will try to do it with the S_STD and G_STD ioctls of the V4L2 framework.
> 
>  Tomi
> 
> 

