Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:28826 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZD3MtT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 08:49:19 -0400
MIME-Version: 1.0
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB030548BB5E@dbde02.ent.ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB030548BA1B@dbde02.ent.ti.com>
	 <5A47E75E594F054BAF48C5E4FC4B92AB030548BB5E@dbde02.ent.ti.com>
Date: Thu, 30 Apr 2009 21:49:18 +0900
Message-ID: <90b950fc0904300549t26a3104u4fa1399753ec193c@mail.gmail.com>
Subject: Re: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
From: InKi Dae <daeinki@gmail.com>
To: "Shah, Hardik" <hardik.shah@ti.com>
Cc: "tomi.valkeinen@nokia.com" <tomi.valkeinen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you Shah, Hardik.
I have patched your driver through that git.

but your patch recognizes video2 layer as video1 device node in case
that DSS2 has fb0 and fb1.

you said my patch will give rise to couple of more bugs related to
global_alpha and pixel formats
maybe that would be because of vout->vid_info.id = k + vout_count;

so I have applied your patch to my way.
this patch is more flexible and recognizes video2 layer correctly as
video2 device node.
------------------------------------------------------------------------------------------------------------------------------------------------------
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2204,7 +2204,7 @@ free_buffers:
 /* Create video out devices */
 static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 {
-       int r = 0, k;
+       int r = 0, k, vout_count;
        struct omap_vout_device *vout;
        struct video_device *vfd = NULL;
        struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
@@ -2212,6 +2212,8 @@ static int __init
omap_vout_create_video_devices(struct platform_device *pdev)
        struct omap2video_device *vid_dev = container_of(v4l2_dev, struct
                        omap2video_device, v4l2_dev);

+       vout_count = 3 - pdev->num_resources;
+
        for (k = 0; k < pdev->num_resources; k++) {

                vout = kmalloc(sizeof(struct omap_vout_device), GFP_KERNEL);
@@ -2225,12 +2227,7 @@ static int __init
omap_vout_create_video_devices(struct platform_device *pdev)
                vout->vid = k;
                vid_dev->vouts[k] = vout;
                vout->vid_dev = vid_dev;
-               /* Select video2 if only 1 overlay is controlled by V4L2 */
-               if (pdev->num_resources == 1)
-                       vout->vid_info.overlays[0] = vid_dev->overlays[k + 2];
-               else
-                       /* Else select video1 and video2 one by one. */
-                       vout->vid_info.overlays[0] = vid_dev->overlays[k + 1];
+               vout->vid_info.overlays[0] = vid_dev->overlays[k + vout_count];
                vout->vid_info.num_overlays = 1;
                vout->vid_info.id = k + 1;
                vid_dev->num_videos++;
@@ -2253,7 +2250,7 @@ static int __init
omap_vout_create_video_devices(struct platform_device *pdev)
                /* Register the Video device with V4L2
                */
                vfd = vout->vfd;
-               if (video_register_device(vfd, VFL_TYPE_GRABBER, k + 1) < 0) {
+               if (video_register_device(vfd, VFL_TYPE_GRABBER, k +
vout_count) < 0) {
                        printk(KERN_ERR VOUT_NAME ": could not register "
                                        "Video for Linux device\n");
                        vfd->minor = -1
---------------------------------------------------------------------------------------------------------------------------------------------------------------------

2009/4/30 Shah, Hardik <hardik.shah@ti.com>:

>
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Shah, Hardik
>> Sent: Thursday, April 30, 2009 11:51 AM
>> To: InKi Dae
>> Cc: tomi.valkeinen@nokia.com; linux-media@vger.kernel.org; linux-
>> omap@vger.kernel.org; Jadav, Brijesh R; Hiremath, Vaibhav
>> Subject: RE: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
>>
>>
>>
>> > -----Original Message-----
>> > From: InKi Dae [mailto:daeinki@gmail.com]
>> > Sent: Thursday, April 30, 2009 11:48 AM
>> > To: Shah, Hardik
>> > Cc: tomi.valkeinen@nokia.com; linux-media@vger.kernel.org; linux-
>> > omap@vger.kernel.org; Jadav, Brijesh R; Hiremath, Vaibhav
>> > Subject: Re: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
>> >
>> > hello Shah, Hardik..
>> >
>> > your omap_vout.c has the problem that it disables video1 or fb1.
>> > so I have modified your code.
>> >
>> > I defined and set platform_data for DSS2 in machine code.(or board file)
>> >
>> > static struct omapfb_platform_data xxx_dss_platform_data = {
>> >     .mem_desc.region[0].format = OMAPFB_COLOR_ARGB32,
>> >     .mem_desc.region[0].format_used=1,
>> >
>> >     .mem_desc.region[1].format = OMAPFB_COLOR_RGB24U,
>> >     .mem_desc.region[1].format_used=1,
>> >
>> >     .mem_desc.region[2].format = OMAPFB_COLOR_ARGB32,
>> >     .mem_desc.region[2].format_used=1,
>> > };
>> >
>> > omapfb_set_platform_data(&xxx_dss_platform_data);
>> >
>> > after that, omap_vout has resource count got referring to framebuffer count,
>> > registers overlay as vout's one and would decide to use which overlay.
>> >
>> > at that time, your code would face with impact on some overlay(fb or video).
>> >
>> > this patch would solve that problem.
>> > when it sets overlay to vout, vout would get overlay array index to
>> > avoid overlapping with other overlay.
>> >
>> >
>> > sighed-off-by: InKi Dae. <inki.dae@samsung.com>
>> > ---
>> > diff --git a/drivers/media/video/omap/omap_vout.c
>> > b/drivers/media/video/omap/omap_vout.c
>> > index 9b4a0d7..051298a 100644
>> > --- a/drivers/media/video/omap/omap_vout.c
>> > +++ b/drivers/media/video/omap/omap_vout.c
>> > @@ -2246,11 +2246,13 @@ free_buffers:
>> >  /* Create video out devices */
>> >  static int __init omap_vout_create_video_devices(struct platform_device
>> > *pdev)
>> >  {
>> > -   int r = 0, k;
>> > +   int r = 0, k, vout_count;
>> >     struct omap_vout_device *vout;
>> >     struct video_device *vfd = NULL;
>> >     struct omap2video_device *vid_dev = platform_get_drvdata(pdev);
>> >
>> > +   vout_count = 3 - pdev->num_resources;
>> > +
>> >     for (k = 0; k < pdev->num_resources; k++) {
>> >
>> >             vout = kmalloc(sizeof(struct omap_vout_device), GFP_KERNEL);
>> > @@ -2266,9 +2268,9 @@ static int __init
>> > omap_vout_create_video_devices(struct platform_device *pdev)
>> >             vout->vid = k;
>> >             vid_dev->vouts[k] = vout;
>> >             vout->vid_info.vid_dev = vid_dev;
>> > -           vout->vid_info.overlays[0] = vid_dev->overlays[k + 1];
>> > +           vout->vid_info.overlays[0] = vid_dev->overlays[k + vout_count];
>> >             vout->vid_info.num_overlays = 1;
>> > -           vout->vid_info.id = k + 1;
>> > +           vout->vid_info.id = k + vout_count;
>> >             vid_dev->num_videos++;
>> >
>> >             /* Setup the default configuration for the video devices
>> > @@ -2289,7 +2291,7 @@ static int __init
>> > omap_vout_create_video_devices(struct platform_device *pdev)
>> >             /* Register the Video device with V4L2
>> >              */
>> >             vfd = vout->vfd;
>> > -           if (video_register_device(vfd, VFL_TYPE_GRABBER, k + 1) < 0) {
>> > +           if (video_register_device(vfd, VFL_TYPE_GRABBER, k + vout_count) <
>> > 0) {
>> >                     printk(KERN_ERR VOUT_NAME ": could not register \
>> >                                     Video for Linux device\n");
>> >                     vfd->minor = -1;
>> >
>> >
>> > 2009/4/22 Shah, Hardik <hardik.shah@ti.com>:
>> [Shah, Hardik] Yes this is correct,
>> I will apply this patch.  I already found it and fixed it in different way but
>> any way I will apply your patch.
> [Shah, Hardik] Further on this inki.  Solving this bug will give rise to couple of more bugs related to global_alpha and pixel formats. That also is fixed. You can refer http://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git?p=people/vaibhav/ti-psp-omap-video.git;a=summary
>> > >
>> > >
>> > >> -----Original Message-----
>> > >> From: Tomi Valkeinen [mailto:tomi.valkeinen@nokia.com]
>> > >> Sent: Wednesday, April 22, 2009 1:53 PM
>> > >> To: Shah, Hardik
>> > >> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav,
>> Brijesh
>> > R;
>> > >> Hiremath, Vaibhav
>> > >> Subject: Re: [PATCH 3/3] OMAP2/3 V4L2 Display Driver
>> > >>
>> > >> Hi,
>> > >>
>> > >> On Wed, 2009-04-22 at 08:25 +0200, ext Hardik Shah wrote:
>> > >> > This is the version 5th of the Driver.
>> > >> >
>> > >> > Following are the features supported.
>> > >> > 1. Provides V4L2 user interface for the video pipelines of DSS
>> > >> > 2. Basic streaming working on LCD and TV.
>> > >> > 3. Support for various pixel formats like YUV, UYVY, RGB32, RGB24,
>> RGB565
>> > >> > 4. Supports Alpha blending.
>> > >> > 5. Supports Color keying both source and destination.
>> > >> > 6. Supports rotation with RGB565 and RGB32 pixels formats.
>> > >> > 7. Supports cropping.
>> > >> > 8. Supports Background color setting.
>> > >> > 9. Works on latest DSS2 library from Tomi
>> > >> > http://www.bat.org/~tomba/git/linux-omap-dss.git/
>> > >> > 10. 1/4x scaling added.  Detail testing left
>> > >> >
>> > >> > TODOS
>> > >> > 1. Ioctls needs to be added for color space conversion matrix
>> > >> > coefficient programming.
>> > >> > 2. To be tested on DVI resolutions.
>> > >> >
>> > >> > Comments fixed from community.
>> > >> > 1. V4L2 Driver for OMAP3/3 DSS.
>> > >> > 2.  Conversion of the custom ioctls to standard V4L2 ioctls like alpha
>> > >> blending,
>> > >> > color keying, rotation and back ground color setting
>> > >> > 3.  Re-organised the code as per community comments.
>> > >> > 4.  Added proper copyright year.
>> > >> > 5.  Added module name in printk
>> > >> > 6.  Kconfig option copy/paste error
>> > >> > 7.  Module param desc addded.
>> > >> > 8.  Query control implemented using standard query_fill
>> > >> > 9.  Re-arranged if-else constructs.
>> > >> > 10. Changed to use mutex instead of semaphore.
>> > >> > 11. Removed dual usage of rotation angles.
>> > >> > 12. Implemented function to convert the V4L2 angle to DSS angle.
>> > >> > 13. Y-position was set half by video driver for TV output
>> > >> > Now its done by DSS so removed that.
>> > >> > 14. Minor cleanup
>> > >> > 15. Added support to pass the page offset to application.
>> > >> > 14. Minor cleanup
>> > >> > 15. Added support to pass the page offset to application.
>> > >> > 16. Renamed V4L2_CID_ROTATION to V4L2_CID_ROTATE
>> > >> > 17. Major comment from Hans fixed.
>> > >> > 18. Copy right year changed.
>> > >> > 19. Added module name for each error/warning print message.
>> > >> >
>> > >> > Changes from Previous Version.
>> > >> > 1. Supported YUV rotation.
>> > >> > 2. Supported Flipping.
>> > >> > 3. Rebased line with Tomi's latest DSS2 master branch with commit  id
>> > >> > f575a02edf2218a18d6f2ced308b4f3e26b44ce2.
>> > >> > 4. Kconfig option removed to select between the TV and LCD.
>> > >> > Now supported dynamically by DSS2 library.
>> > >> > 5. Kconfig option for the NTSC_M and PAL_BDGHI mode but not
>> > >> > supported by DSS2.  so it will not work now.
>> > >>
>> > >> There is basic support for this. See the DSS doc:
>> > >>
>> > >> /sys/devices/platform/omapdss/display? directory:
>> > >> ...
>> > >> timings         Display timings
>> > (pixclock,xres/hfp/hbp/hsw,yres/vfp/vbp/vsw)
>> > >>                 When writing, two special timings are accepted for tv-
>> out:
>> > >>                 "pal" and "ntsc"
>> > > [Shah, Hardik] I was not aware of it will remove the compile time option
>> and
>> > for now let the sysfs entry change the standard.  In future I will try to do
>> > it with the S_STD and G_STD ioctls of the V4L2 framework.
>> > >>
>> > >>  Tomi
>> > >>
>> > >>
>> > >
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> > > the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > >
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
