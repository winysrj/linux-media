Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m966B4Je008627
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 02:11:04 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9669wYJ013478
	for <video4linux-list@redhat.com>; Mon, 6 Oct 2008 02:09:58 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 6 Oct 2008 11:36:30 +0530
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D610739F@dbde02.ent.ti.com>
In-Reply-To: <20081005081931.1dfdd7b4@pedra.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-fbdev-devel@lists.sourceforge.net"
	<linux-fbdev-devel@lists.sourceforge.net>
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
> From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
> Sent: Sunday, October 05, 2008 4:50 PM
> To: Shah, Hardik
> Cc: Hans Verkuil; video4linux-list@redhat.com; linux-omap@vger.kernel.org; linux-fbdev-
> devel@lists.sourceforge.net
> Subject: Re: [PATCH] OMAP 2/3 V4L2 display driver on video planes
> 
> On Fri, 3 Oct 2008 20:10:36 +0530
> "Shah, Hardik" <hardik.shah@ti.com> wrote:
> 
> 
 
> I don't like the idea of having private ioctls. This generally means that only
> a very restricted subset of userspace apps that are aware of the that API will
> work. This is really bad.
> 
> So, I prefer to discuss the need for newer ioctls and add it into the standard
> whenever make some sense (ok, maybe you might have some ioctls that are really
> very specific for your app and that won't break userspace apps - I've acked
> with 2 private ioctls on uvc driver in the past due to that).
> 
[Shah, Hardik] Following are the custom IOCTLs used in the V4L2 display driver of DSS.

1.  VIDIOC_S/G_OMAP2_MIRROR: This ioctl is used to enable the mirroring of the image. Hardware supports mirroring. As pointed out by Hans it will be better to move it to VIDIOC_S_CTRL ioctl. we can add the new control id for the mirroring.

2.  VIDIOC_S/G_OMAP2_ROTATION: Rotation is used to enable the rotation of the image. This also can be moved to the VIDIOC_S_CTRL ioctl.  Need to add new control id for the rotation also. 

3.  VIDIOC_S/G_OMAP2_LINK: This feature is software provided. OMAP DSS is having two video pipelines.  Using this feature user can link the two video pipelines. This means the streaming of the video on one pipeline will be linked to the other pipeline with the same parameters as the original pipeline.  Same image can be streamed on both the pipelines, one of the pipeline's output going to TV and other one to LCD.  I believe this feature is very specific to OMAP, and should remain as the custom ioctl.

4.  VIDIOC_S/G_OMAP2_COLORKEY:  Color keying allows the pixels with the defined color on the video pipelines to be replaced with the pixels on the graphics pipelines.  I believe similar feature must be available on almost all next generation of video hardware. We can add new ioctl for this feature in V4L2 framework. I think VIDIOC_S_FBUF ioctl is used for setting up the buffer parameters on per buffer basis.  So IMHO this ioctl is not a natural fit for the above functionality. Please provide your comments on same.

5. VIDIOC_S/G_OMAP2_BGCOLOR: This ioctl is used to set the Background color on either TV or LCD. It takes two inputs, first is the output device second is the color to be set. I think this can be added to the standard ioctl list but is it ok to have the output device as one of the parameters in the input structure? Instead we can set the background color for the current output.

6. VIDIOC_OMAP2_COLORKEY_ENABLE/DISABLE.  This ioctl is used to enable or the disable the color keying feature described above. This can be added as the one of the control using VIDIOC_S_CTRL ioctl.

7.  VIDIOC_S/G_OMAP2_COLORCONV:  This is a hardware feature.  Video pipelines of the DSS are capable of getting the buffer in the YUV/UYVY format. But internally DSS operates on RGB format.  So hardware has a capability to convert the YUV format to RGB format.  This is done using the color conversion matrix in the hardware.  It accepts the structure as input which has 9 unsigned short variables representing the coefficients for color conversion.  I think this feature will also be present in many new devices. So we can have the standard ioctl for this.

8.  VIDIOC_S_OMAP2_DEFCOLORCONV:  This ioctl just programs the default color conversion matrix defined by the driver.  This we can have as one of the controls using VIDIOC_S_CTRL ioctl.

Please let me know your view/thoughts on above custom ioctls added in the driver.

> 
> So, if you are having several points where you're violating the rule, probably
> your code is very complex or you are using long names instead of short ones. On
> the fisrt case, try to break the complex stuff  into smaller and simpler static
> functions. The compiler will deal with those functions like inline, so this
> won't cost cpu cycles, but it will make easier for people to understand what
> you're doing.
> 
[Shah, Hardik] I will revisit the code and structure it properly.

> 
> Perhaps the better would be for you to have one public machine where you all
> can work and merge your work. I'm OK on pulling and seeing patches outside LinuxTV.
> 
> > [Shah, Hardik] we are in process of coordinating this.
>

> One option in the future is to base your work on a git tree. I've changed a lot
> the proccess of submitting patches upstream, to avoid having to rebase my tree
> (Yet, I had to do two rebases during 2.6.27 cycle). If I can keep my tree
> without rebase, the developers may rely on it and start sending me git pull
> requests also. Let's see if I can do this for 2.6.28.
> 
> I think we should start discussing using git trees as the reference for
> v4l/dvb development, and start moving developers tree to git. This would solve
> the issues with complex projects like OMAP, where you need to touch not only on
> V4L/DVB subsystem.
> 
> This topic deserves some more discussion,
[Shah, Hardik] Right now Manju is on travel.  I will confirm with him once he comes back.
 
> Cheers,
> Mauro.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
