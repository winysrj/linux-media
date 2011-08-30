Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:39379 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1H3Nqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 09:46:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] media: Add support for arbitrary resolution for the ov5642 camera driver
Date: Tue, 30 Aug 2011 15:46:41 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <alpine.DEB.2.02.1108171551040.17540@ipanema> <201108301446.22411.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1108301455120.19151@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108301455120.19151@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301546.42050.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, August 30, 2011 15:13:25 Guennadi Liakhovetski wrote:
> (also replying to a similar comment by Sakari)
> 
> On Tue, 30 Aug 2011, Laurent Pinchart wrote:
> 
> > Hi Guennadi,
> > 
> > On Tuesday 30 August 2011 10:55:08 Guennadi Liakhovetski wrote:
> > > On Mon, 29 Aug 2011, Laurent Pinchart wrote:
> > > > On Monday 29 August 2011 14:34:53 Guennadi Liakhovetski wrote:
> > > > > On Mon, 29 Aug 2011, Laurent Pinchart wrote:
> > > > > > On Monday 29 August 2011 14:18:50 Guennadi Liakhovetski wrote:
> > > > > > > On Sun, 28 Aug 2011, Laurent Pinchart wrote:
> > > > > > > 
> > > > > > > [snip]
> > > > > > > 
> > > > > > > > > @@ -774,17 +839,27 @@ static int ov5642_s_fmt(struct
> > > > > > > > > v4l2_subdev *sd,
> > > > > > > > > 
> > > > > > > > >  	ov5642_try_fmt(sd, mf);
> > > > > > > > > 
> > > > > > > > > +	priv->out_size.width		= mf->width;
> > > > > > > > > +	priv->out_size.height		= mf->height;
> > > > > > > > 
> > > > > > > > It looks like to me (but I may be wrong) that you achieve
> > > > > > > > different resolutions using cropping, not scaling. If that's
> > > > > > > > correct you should implement s_crop support and refuse 
changing
> > > > > > > > the resolution through s_fmt.
> > > > > > > 
> > > > > > > As the patch explains (I think) on several occasions, currently
> > > > > > > only the 1:1 scale is supported, and it was our deliberate 
choice
> > > > > > > to implement this using the scaling API
> > > > > > 
> > > > > > If you implement cropping, you should use the crop API, not the
> > > > > > scaling API
> > > > > > 
> > > > > > :-)
> > > > > 
> > > > > It's changing both - input and output sizes.
> > > > 
> > > > Sure, but it's still cropping.
> > > 
> > > Why? Isn't it a matter of the PoV?
> > 
> > No it isn't. Cropping is cropping, regardless of how you look at it.
> > 
> > > It changes the output window, i.e., implements S_FMT. And S_FMT is by 
far
> > > more important / widely used than S_CROP. Refusing to change the output
> > > window and always just returning the == crop size wouldn't be polite, 
IMHO.
> > 
> > If your sensor has no scaler the output size is equal to the crop 
rectangle. 
> > There's no way around that, and there's no reason to have the driver 
behave 
> > otherwise.
> > 
> > > Don't think many users would guess to use S_CROP.
> > 
> > Users who want to crop use S_CROP.
> > 
> > > Standard applications a la mplayer don't use S_CROP at all.
> > 
> > That's because they don't want to crop. mplayer expects the driver to 
perform 
> > scaling when it calls S_FMT, and users won't be happy if you crop instead.
> 
> So, here's my opinion, based on the V4L2 spec. I'm going to base on this 
> and pull this patch into my tree and let Mauro decide, unless he expresses 
> his negative opinion before that.
> 
> The spec defines S_FMT as an operation to set the output (in case of a 
> capture device) frame format. Which this driver clearly does. The output 
> format should be set, using scaling, however, if the driver or the 
> hardware are unable to preserve the exact same input rectangle to satisfy 
> the request, the driver is also allowed to change the cropping rectangle 
> _as much as necessary_ - S_FMT takes precedence. This has been discussed 
> before, and the conclusion was - of the two geometry calls (S_FMT and 
> S_CROP) the last call overrides previous setting of the opposite geometry.
> 
> It also defines S_CROP as an operation to set the cropping rectangle. The 
> driver is also allowed to change the output window, if it cannot be 
> preserved. Similarly, the last call wins.
> 
> Ideally in this situation I would implement both S_CROP and S_FMT and let 
> both change the opposite window as needed, which in this case means set it 
> equal to the one, being configured. Since most applications are primarily 
> interested in the S_FMT call to configure their user interface, I find it 
> a wrong approach to refuse S_FMT and always return the current cropping 
> rectangle. In such a case the application will possibly be stuck with some 
> default output rectangle, because it certainly will _not_ guess to use 
> S_CROP to configure it. Whereas if we implement S_FMT with a constant 1:1 
> scale the application will get the required UI size. I agree, that 
> changing the view area, while changing the output window, is not exactly 
> what the user expects, but it's better than presenting all applications 
> with a fixed, possibly completely unsuitable, UI window.

The problem with S_FMT changing the crop rectangle (and I assume we are not
talking about small pixel tweaks to make the hardware happy) is that the
crop operation actually removes part of the frame. That's not something you
would expect S_FMT to do, ever. Such an operation has to be explicitly
requested by the user.

It's also why properly written applications (e.g. capture-example.c) has
code like this to reset the crop rectangle before starting streaming:

        if (0 == xioctl(fd, VIDIOC_CROPCAP, &cropcap)) {
                crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                crop.c = cropcap.defrect; /* reset to default */

                if (-1 == xioctl(fd, VIDIOC_S_CROP, &crop)) {
                        switch (errno) {
                        case EINVAL:
                                /* Cropping not supported. */
                                break;
                        default:
                                /* Errors ignored. */
                                break;
                        }
                }
        }

(Hmm, capture-example.c should also test for ENOTTY since we changed the
error code).

Regards,

	Hans
