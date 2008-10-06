Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m968qJ1D029255
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 04:52:19 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m968q8Tt001484
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 04:52:09 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 6 Oct 2008 14:20:45 +0530
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D61074A6@dbde02.ent.ti.com>
In-Reply-To: <200810060829.25055.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-fbdev-devel@lists.sourceforge.net"
	<linux-fbdev-devel@lists.sourceforge.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: RE: [PATCH] OMAP 2/3 V4L2 display driver on video planes
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

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Monday, October 06, 2008 11:59 AM
> To: Shah, Hardik
> Cc: Mauro Carvalho Chehab; video4linux-list@redhat.com; linux-omap@vger.kernel.org; linux-fbdev-
> devel@lists.sourceforge.net; Hadli, Manjunath
> Subject: Re: [PATCH] OMAP 2/3 V4L2 display driver on video planes
> 
> On Monday 06 October 2008 08:06:30 Shah, Hardik wrote:
> > Hi,
> >
> > > -----Original Message-----
> > > From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
> > > Sent: Sunday, October 05, 2008 4:50 PM
> > > To: Shah, Hardik
> > > Cc: Hans Verkuil; video4linux-list@redhat.com;
> > > linux-omap@vger.kernel.org; linux-fbdev-
> > > devel@lists.sourceforge.net
> > > Subject: Re: [PATCH] OMAP 2/3 V4L2 display driver on video planes
> > >
> > > On Fri, 3 Oct 2008 20:10:36 +0530
> > > "Shah, Hardik" <hardik.shah@ti.com> wrote:
> > >
> > >
> > >
> > > I don't like the idea of having private ioctls. This generally
> > > means that only a very restricted subset of userspace apps that are
> > > aware of the that API will work. This is really bad.
> > >
> > > So, I prefer to discuss the need for newer ioctls and add it into
> > > the standard whenever make some sense (ok, maybe you might have
> > > some ioctls that are really very specific for your app and that
> > > won't break userspace apps - I've acked with 2 private ioctls on
> > > uvc driver in the past due to that).
> >
> > [Shah, Hardik] Following are the custom IOCTLs used in the V4L2
> > display driver of DSS.
> >
> > 1.  VIDIOC_S/G_OMAP2_MIRROR: This ioctl is used to enable the
> > mirroring of the image. Hardware supports mirroring. As pointed out
> > by Hans it will be better to move it to VIDIOC_S_CTRL ioctl. we can
> > add the new control id for the mirroring.
> 
> HFLIP and VFLIP user controls already exist.
> 
> > 2.  VIDIOC_S/G_OMAP2_ROTATION: Rotation is used to enable the
> > rotation of the image. This also can be moved to the VIDIOC_S_CTRL
> > ioctl.  Need to add new control id for the rotation also.
> 
> A new standard user control can be added for this.
> 
> > 3.  VIDIOC_S/G_OMAP2_LINK: This feature is software provided. OMAP
> > DSS is having two video pipelines.  Using this feature user can link
> > the two video pipelines. This means the streaming of the video on one
> > pipeline will be linked to the other pipeline with the same
> > parameters as the original pipeline.  Same image can be streamed on
> > both the pipelines, one of the pipeline's output going to TV and
> > other one to LCD.  I believe this feature is very specific to OMAP,
> > and should remain as the custom ioctl.
> 
> I agree.
> 
> > 4.  VIDIOC_S/G_OMAP2_COLORKEY:  Color keying allows the pixels with
> > the defined color on the video pipelines to be replaced with the
> > pixels on the graphics pipelines.  I believe similar feature must be
> > available on almost all next generation of video hardware. We can add
> > new ioctl for this feature in V4L2 framework. I think VIDIOC_S_FBUF
> > ioctl is used for setting up the buffer parameters on per buffer
> > basis.  So IMHO this ioctl is not a natural fit for the above
> > functionality. Please provide your comments on same.
> 
> Do I understand correctly that if the color in the *video* streams
> matches the colorkey, then it is replaced by the color in the
> *framebuffer* (aka menu/overlay)? Usually it is the other way around:
> if the framebuffer (menu) has chromakey pixels, then those pixels are
> replaced by pixels from the video stream. That's what the current API
> does
[Shah, Hardik] This is a hardware provided feature. It can be both ways as hardware supports both the features. It means replacing the graphics pipelines pixels with video pipeline pixels and other way is also true. When both graphics and video pipelines are going to the same output device and when the colorkeying is enabled then the pixels of the video pipelines of specific color are replaced by the pixels of the graphics pipeline. This is done automatically done by the overlay manager aka compositor. Graphics pipeline can be controlled by frame buffer interface or V4L2 interface. 
In driver we only need to enable the color keying and state that whether it is a source color keying or destination color keying along with the color code.
> 
> > 5. VIDIOC_S/G_OMAP2_BGCOLOR: This ioctl is used to set the Background
> > color on either TV or LCD. It takes two inputs, first is the output
> > device second is the color to be set. I think this can be added to
> > the standard ioctl list but is it ok to have the output device as one
> > of the parameters in the input structure? Instead we can set the
> > background color for the current output.
> 
> Setting the background color for the current output is the more logical
> choice. It would also be a nice addition for e.g. the ivtv driver where
> a similar functionality exists (currently unused).
> 
> I assume that background color refers to the part of the display not
> covered by a menu or video?
[Shah, Hardik] Yes background color refers to the whole display screen. Its not covered by menu or video.
> 
> > 6. VIDIOC_OMAP2_COLORKEY_ENABLE/DISABLE.  This ioctl is used to
> > enable or the disable the color keying feature described above. This
> > can be added as the one of the control using VIDIOC_S_CTRL ioctl.
> 
> Depends on the answer to 4).
> 
> > 7.  VIDIOC_S/G_OMAP2_COLORCONV:  This is a hardware feature.  Video
> > pipelines of the DSS are capable of getting the buffer in the
> > YUV/UYVY format. But internally DSS operates on RGB format.  So
> > hardware has a capability to convert the YUV format to RGB format.
> > This is done using the color conversion matrix in the hardware.  It
> > accepts the structure as input which has 9 unsigned short variables
> > representing the coefficients for color conversion.  I think this
> > feature will also be present in many new devices. So we can have the
> > standard ioctl for this.
> 
> I think so too, it's pretty much a standard operation.
> 
> > 8.  VIDIOC_S_OMAP2_DEFCOLORCONV:  This ioctl just programs the
> > default color conversion matrix defined by the driver.  This we can
> > have as one of the controls using VIDIOC_S_CTRL ioctl.
> 
> I don't understand the need for this one. In what way does it differ
> from OMAP2_COLORCONV?
[Shah, Hardik] This gives the extra control to user application, where the color conversion matrix programmed was not showing up the correct colors onto display, and now user wants to restore back the default color conv matrix. 
This we can also support by passing NULL argument to the VIDIOC_S_OMAP2_COLORCONV ioctl to program the default color conv. matrix.

> 
> > Please let me know your view/thoughts on above custom ioctls added in
> > the driver.
> 
> My pleasure,
> 
> 	Hans
> 
> >
> > > So, if you are having several points where you're violating the
> > > rule, probably your code is very complex or you are using long
> > > names instead of short ones. On the fisrt case, try to break the
> > > complex stuff  into smaller and simpler static functions. The
> > > compiler will deal with those functions like inline, so this won't
> > > cost cpu cycles, but it will make easier for people to understand
> > > what you're doing.
> >
> > [Shah, Hardik] I will revisit the code and structure it properly.
> >
> > > Perhaps the better would be for you to have one public machine
> > > where you all can work and merge your work. I'm OK on pulling and
> > > seeing patches outside LinuxTV.
> > >
> > > > [Shah, Hardik] we are in process of coordinating this.
> > >
> > > One option in the future is to base your work on a git tree. I've
> > > changed a lot the proccess of submitting patches upstream, to avoid
> > > having to rebase my tree (Yet, I had to do two rebases during
> > > 2.6.27 cycle). If I can keep my tree without rebase, the developers
> > > may rely on it and start sending me git pull requests also. Let's
> > > see if I can do this for 2.6.28.
> > >
> > > I think we should start discussing using git trees as the reference
> > > for v4l/dvb development, and start moving developers tree to git.
> > > This would solve the issues with complex projects like OMAP, where
> > > you need to touch not only on V4L/DVB subsystem.
> > >
> > > This topic deserves some more discussion,
> >
> > [Shah, Hardik] Right now Manju is on travel.  I will confirm with him
> > once he comes back.
> >
> > > Cheers,
> > > Mauro.
> 
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
