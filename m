Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G5bV4A012480
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 01:37:31 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G5adKc002166
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 01:36:39 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 16 Oct 2008 11:05:55 +0530
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D61A1B59@dbde02.ent.ti.com>
In-Reply-To: <200810060829.25055.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
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



> > 1.  VIDIOC_S/G_OMAP2_MIRROR: This ioctl is used to enable the
> > 
> HFLIP and VFLIP user controls already exist.
> 
> > 2.  VIDIOC_S/G_OMAP2_ROTATION: Rotation is used to enable the
> > 
> 
> A new standard user control can be added for this.
> 
> > 3.  VIDIOC_S/G_OMAP2_LINK: This feature is software provided. OMAP
> 
> 
> I agree.
> 
> > 4.  VIDIOC_S/G_OMAP2_COLORKEY:  Color keying allows the pixels with
> 
> > 5. VIDIOC_S/G_OMAP2_BGCOLOR: This ioctl is used to set the Background
> 
> Setting the background color for the current output is the more logical
> choice. It would also be a nice addition for e.g. the ivtv driver where
> a similar functionality exists (currently unused).
> 
> > 6. VIDIOC_OMAP2_COLORKEY_ENABLE/DISABLE.  This ioctl is used to
> > enable or the disable the color keying feature described above. This
> > can be added as the one of the control using VIDIOC_S_CTRL ioctl.
> 
> Depends on the answer to 4).
> 
> > 7.  VIDIOC_S/G_OMAP2_COLORCONV:  This is a hardware feature.  Video
> 
> I think so too, it's pretty much a standard operation.
> 
> > 8.  VIDIOC_S_OMAP2_DEFCOLORCONV:  This ioctl just programs the
> 
> I don't understand the need for this one. In what way does it differ
> from OMAP2_COLORCONV?
> 
> 
[Shah, Hardik] 
Hi All,
I am posting series of two patches.  First patch adds the two new control IDs to the VIDIOC_S_CTRL ioctl related to setting the rotation and back ground color.  Second patch adds two new ioctls for supporting the color conversion typically from RGB to YUV and vice versa. I also want to know your thoughts on adding the new ioctl for supporting color keying. 

Thanks and Regards,
Hardik Shah



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
