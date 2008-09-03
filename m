Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m83KtTHt023397
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 16:55:30 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m83KHigG032762
	for <video4linux-list@redhat.com>; Wed, 3 Sep 2008 16:17:45 -0400
From: "Jalori, Mohit" <mjalori@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, "Aguirre Rodriguez, Sergio Alberto"
	<saaguirre@ti.com>
Date: Wed, 3 Sep 2008 15:17:36 -0500
Message-ID: <8AA5EFF14ED6C44DB31DA963D1E78F0DB98111BB@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894411A07DFA@dlee02.ent.ti.com>
	<200809032158.10633.hverkuil@xs4all.nl>
In-Reply-To: <200809032158.10633.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: RE: [PATCH 15/15] OMAP3 camera driver: OMAP34XXCAM: Add Sensors
	Support.
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



> -----Original Message-----
> From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-
> bounces@redhat.com] On Behalf Of Hans Verkuil
> Sent: Wednesday, September 03, 2008 2:58 PM
> To: Aguirre Rodriguez, Sergio Alberto
> Cc: video4linux-list@redhat.com
> Subject: Re: [PATCH 15/15] OMAP3 camera driver: OMAP34XXCAM: Add
> Sensors Support.
> 
> On Wednesday 03 September 2008 18:49:32 Aguirre Rodriguez, Sergio
> Alberto wrote:
> > Hans,
> >
> > This file hasn't yet been merged into Linus tree, these patches are
> > made for applying on top of linux-omap tree, that's why you don't
> > find it there.
> >
> > We came up to the conclusion that  we will only send you all the
> > needed (and reworked with all the comments, of course) v4l2 changes
> > for omap3 camera operation, and send the remaining ones, which are
> > omap-specific, to the linux-omap list.
> 
> OK, clear.
> 
> > We'll keep you updated on this between this week and next one.
> >
> > I appreciate your time. Thanks.
> 
> FYI: I'm on vacation from September 10-29, so I will not be able to do
> any reviewing during that time. During my vacation I'll also be at the
> Linux conference in Portland and I hope to discuss some extensions to
> the v4l API there that could well have an impact on the
> previewer/resizer devices that you created.
> 
> It would really help me to have a description of what and how those
> devices are currently used for so that I can decide whether that will
> fit well with my ideas.
> 


OMAP Previewer:
It is used for color conversion. It takes in RAW images and generated YUV data. The intent for this is to be able to take RAW image, tune the image pipe parameters and generate the YUV images. If you use the OMAP3 camera driver the default values are good for certain light conditions and can be changed by the private IOCTLs implemented in the camera driver. However for good quality images there is an option of just using the previewer with the tuned coefficients for all HW blocks in the OMAP3 ISP.
It takes in RAW image, you can set the size, you can configure which HW blocks you want to enable for processing and you can select what the parameters will be for these HW blocks. For eg you can select whether you want to use the noise filter or not, If used you can specify the threshold and strength for this filter. It will generate the YUV image. It is possible to link it to the resizer wrapper (which is currently being implemented).


OMAP Resizer:
We use this for stand alone image scaling. It takes in YUV data and rescales (upscale/downscale) to the user requested size. User has the option to specify the resizer coefficients to be used since the default coefficients work well for certain rescaling ratios. Can use used for image view application or even for snapshot/thumbnail generation.


About the interface we implemented them to be custom for the following reasons
1. These blocks are anyway very OMAP HW specific so the ioctls and parameters accepted were kept close to what the HW accepted.
2. Lots of existing customers using older chipsets are using this interface and we wanted to maintain the same interface
3. If we moved to V4L2 based I/f we could have reused format, buffer management related ioctls but still most of the controls are very specific to HW and would not be generic.

We will go through the RFC and let you know our comments.

Regards,
Mohit

> See this link for the RFC I wrote:
> 
> http://lists-archives.org/video4linux/23652-rfc-add-support-to-query-
> and-change-connections-inside-a-media-device.html
> 
> I think that most of the driver internals are no doubt OK, it's the
> public API that I will pay close attention to when I review.
> 
> Regards,
> 
> 	Hans
> 
> >
> > Regards,
> > Sergio
> >
> > -----Original Message-----
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > Sent: Tuesday, September 02, 2008 1:24 AM
> > To: video4linux-list@redhat.com
> > Cc: Aguirre Rodriguez, Sergio Alberto
> > Subject: Re: [PATCH 15/15] OMAP3 camera driver: OMAP34XXCAM: Add
> > Sensors Support.
> >
> > On Saturday 30 August 2008 01:44:27 Aguirre Rodriguez, Sergio
> Alberto
> >
> > wrote:
> > > From: Sergio Aguirre <saaguirre@ti.com>
> > >
> > > OMAP34XX: CAM: Add Sensors Support
> > >
> > > This adds support in OMAP34xx SDP board file for Sensor and Lens
> > > driver.
> > >
> > > Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> > > ---
> > >  arch/arm/mach-omap2/board-3430sdp.c |  228
> >
> > ++++++++++++++++++++++++++++++++++++
> >
> > >  1 file changed, 228 insertions(+)
> >
> > Can you mail the original board-3430sdp.c file? I cannot find this
> > file in the linux kernel (looked in the latest git tree from Linus).
> >
> > Regards,
> >
> > 	Hans
> 
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-
> request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
