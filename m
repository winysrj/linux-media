Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55845 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZA2G73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 01:59:29 -0500
From: "Shah, Hardik" <hardik.shah@ti.com>
To: "Shah, Hardik" <hardik.shah@ti.com>,
	Trent Piepho <xyzzy@speakeasy.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Thu, 29 Jan 2009 12:29:01 +0530
Subject: RE: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02F535F674@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Shah, Hardik
> Sent: Thursday, January 29, 2009 12:27 PM
> To: 'Trent Piepho'
> Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com; Jadav, Brijesh
> R; Nagalla, Hari; Hiremath, Vaibhav
> Subject: RE: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
> 
> 
> 
> > -----Original Message-----
> > From: Trent Piepho [mailto:xyzzy@speakeasy.org]
> > Sent: Thursday, January 29, 2009 11:50 AM
> > To: Shah, Hardik
> > Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com; Jadav, Brijesh
> > R; Nagalla, Hari; Hiremath, Vaibhav
> > Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
> >
> > On Thu, 29 Jan 2009, Hardik Shah wrote:
> > > 1.  Control ID added for rotation.  Same as HFLIP.
> > > 2.  Control ID added for setting background color on
> > >     output device.
> > > 3.  New ioctl added for setting the color space conversion from
> > >     YUV to RGB.
> > > 4.  Updated the v4l2-common.c file according to comments.
> >
> > Wasn't there supposed to be some documentation?
[Shah, Hardik] I will update the documentation and will send the separate patch for it.
> >
> > > +	case V4L2_CID_BG_COLOR:
> > > +		/* Max value is 2^24 as RGB888 is used for background color */
> > > +		return v4l2_ctrl_query_fill(qctrl, 0, 16777216, 1, 0);
> >
> > Wouldn't it make more sense to set background in the same colorspace as the
> > selected format?
> [Shah, Hardik] Background color setting can be done only in the RGB space as
> hardware doesn't understand YUV or RGB565 for the background color setting.
> And background color and pixel format are not related.  If we want to have the
> background setting format same as the color format then driver will have to do
> the color conversion and that is not optimal.
> 
> Regards,
> Hardik Shah

