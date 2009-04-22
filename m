Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:52016 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZDVFjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 01:39:20 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Wed, 22 Apr 2009 11:09:10 +0530
Subject: RE: [Review PATCH 3/3] OMAP2/3 V4L2 Display Driver
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB03051F7EBF@dbde02.ent.ti.com>
In-Reply-To: <30757.62.70.2.252.1240315186.squirrel@webmail.xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
My comments inlined.

Hardik,
 


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, April 21, 2009 5:30 PM
> To: Shah, Hardik
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav, Brijesh R;
> Hiremath, Vaibhav
> Subject: RE: [Review PATCH 3/3] OMAP2/3 V4L2 Display Driver
> 
> Hi Hardik,
> 
> Just a few comments on your comments :-)
> 
> > Hi Hans,
> > My Comments inlined,
> > Most of the comments are taken care off.
> > Thanks for review.
> >
> > Hardik,
> >
> >> -----Original Message-----
> >> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> >> Sent: Saturday, April 18, 2009 7:29 PM
> >> To: Shah, Hardik
> >> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav,
> >> Brijesh R;
> >> Hiremath, Vaibhav
> >> Subject: Re: [Review PATCH 3/3] OMAP2/3 V4L2 Display Driver
> 
> >> > +config VID2_LCD_MANAGER
> >> > +   bool "Use LCD Managaer"
> >> > +   help
> >> > +     Select this option if you want VID2 pipeline on LCD Overlay
> >> manager
> >> > +endchoice
> >> > +
> >> > +choice
> >> > +        prompt "TV Mode"
> >> > +        depends on VID2_TV_MANAGER || VID1_TV_MANAGER
> >> > +        default NTSC_M
> >> > +
> >> > +config NTSC_M
> >> > +        bool "Use NTSC_M mode"
> >> > +        help
> >> > +          Select this option if you want NTSC_M mode on TV
> >> > +
> >> > +config PAL_BDGHI
> >> > +        bool "Use PAL_BDGHI mode"
> >> > +        help
> >> > +          Select this option if you want PAL_BDGHI mode on TV
> >>
> >> Terminology: PAL and NTSC etc. refer to broadcast standards. That is no
> >> generally applicable to omap. When it comes to streaming digital video
> >> there is only the 50 and 60 Hz SDTV standards. For output over a
> >> Composite
> >> or S-Video connector you can also choose between PAL and SECAM. There
> >> are some differences between the two, although I'm not sure about the
> >> details. The common saa7128 i2c device definitely has support for both.
> >>
> >> In this particular case you probably mean 50 or 60 Hz SDTV rather than
> >> NTSC/PAL.
> >>
> > [Shah, Hardik] OMAP DSS is having the internal video encoder for
> > converting the digital to analog standards like NTSC and PAL with a
> > s-video and composite output.  Currently DSS does not support changing of
> > the TV standards dynamically so I have made it as a compile time option.
> > Once DSS will support that I will add the S_STD and G_STD for standards.
> > Internally it will call the DSS2 library APIs to change the standard.
> 
> I don't have a problem with these config options, it's more the names
> NTSC_M and PAL_BDGHI that are misleading IMHO, since it's really a matter
> of 50Hz vs 60Hz and not of NTSC vs PAL.
[Shah, Hardik] Video Encoder of the DSS2 supports number of PAL and NTSC standards out of them only two are supported to I just tried to be specific as 50Hz may mean any PAL standards other than PAL_BDGHI and 60 may mean any NTSC standard other than NTSC_M.  Any way this is not going to be permanent.
> 
> >> > +   if (1 == vout->mirror && vout->rotation >= 0) {
> >> > +           rotation_deg = (vout->rotation == 1) ?
> >> > +                   3 : (vout->rotation == 3) ?
> >> > +                   1 : (vout->rotation ==  2) ?
> >> > +                   0 : 2;
> >>
> >> Or: rotation = (4 - vout->rotation) % 4;
> > [Shah, Hardik] It will not work when rotation will be 0 and I want 2
> > because of mirroring. (4-0) % 2 is 0 I want 2 here.  So not changing it.
> 
> You are right. Sorry about that.
> 
> >> > +static int vidioc_s_ctrl(struct file *file, void *fh, struct
> >> v4l2_control
> >> *a)
> >> > +{
> >> > +   struct omap_vout_device *vout = ((struct omap_vout_fh *)
> >> fh)->vout;
> >> > +
> >> > +   switch (a->id) {
> >> > +   case V4L2_CID_ROTATE:
> >> > +   {
> >> > +           int rotation = a->value;
> >> > +
> >> > +           if (vout->pix.pixelformat == V4L2_PIX_FMT_RGB24 &&
> >> > +                           rotation != -1)
> >>
> >> Huh? Shouldn't this be rotation != 0?
> > [Shah, Hardik] Rotation 0 means the rotation using Virtual Frame Buffer
> > Rotation (VRFB) engine.  It does not support rotation with packed RGB24
> > format.  -1 means VRFB is not used.  So it should be -1;
> 
> This really isn't right. a->value is the rotate control value. And that's
> defined as 0, 90, 180 or 270 according to queryctrl. Not -1. The value -1
> is a purely internal value which is also why I am opposed to its use. It
> is very confusing.
[Shah, Hardik] Agreed,
I will change that.
> 
> Regards,
> 
>         Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
> 

