Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:44942 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323Ab1IHLog (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 07:44:36 -0400
Date: Thu, 8 Sep 2011 14:44:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Subash Patel <subashrp@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	hechtb@googlemail.com, g.liakhovetski@gmx.de
Subject: Re: [RFC] New class for low level sensors controls?
Message-ID: <20110908114428.GC1724@valkosipuli.localdomain>
References: <20110906113653.GF1393@valkosipuli.localdomain>
 <201109061341.11991.laurent.pinchart@ideasonboard.com>
 <20110906122226.GH1393@valkosipuli.localdomain>
 <4E68A5E7.8070800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E68A5E7.8070800@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Subash,

Thanks for the comments.

On Thu, Sep 08, 2011 at 04:54:23PM +0530, Subash Patel wrote:
> Hi Sakari,
> 
> On 09/06/2011 05:52 PM, Sakari Ailus wrote:
> >On Tue, Sep 06, 2011 at 01:41:11PM +0200, Laurent Pinchart wrote:
> >>Hi Sakari,
> >>
> >>On Tuesday 06 September 2011 13:36:53 Sakari Ailus wrote:
> >>>Hi all,
> >>>
> >>>We are beginning to have raw bayer image sensor drivers in the mainline.
> >>>Typically such sensors are not controlled by general purpose applications
> >>>but e.g. require a camera control algorithm framework in user space. This
> >>>needs to be implemented in libv4l for general purpose applications to work
> >>>properly on this kind of hardware.
> >>>
> >>>These sensors expose controls such as
> >>>
> >>>- Per-component gain controls. Red, blue, green (blue) and green (red)
> >>>   gains.
> >>>
> >>>- Link frequency. The frequency of the data link from the sensor to the
> >>>   bridge.
> >>>
> >>>- Horizontal and vertical blanking.
> >>
> >>Other controls often found in bayer sensors are black level compensation and
> >>test pattern.
> 
> Does all BAYER sensor allow the dark level compensation programming?

I'm not sure. I have always seen ISPs being used for that, not sensors.

> I thought it must be auto dark level compensation, which is done by
> the sensor. The sensor detects the optical black value at start of
> each frame, and analog-to-digital conversion is shifted to
> compensate the dark level for that frame. Hence I am thinking if
> this should be a controllable feature.

This is probably what smart sensors could do. If we have a raw bayer sensor
the computation of the optimal black level compensation could be done by
some of the controls algorithms run in the user space. Automatic exposure
probably?

It's also possible to have the value set statically as it is often
considered sensor model specific.

> >>
> >>>None of these controls are suitable for use of general purpose applications
> >>>(let alone the end user!) but for the camera control algorithms.
> >>>
> >>>We have a control class called V4L2_CTRL_CLASS_CAMERA for camera controls.
> >>>However, the controls in this class are relatively high level controls
> >>>which are suitable for end user. The algorithms in the libv4l or a webcam
> >>>could implement many of these controls whereas I see that only
> >>>V4L2_CID_EXPOSURE_ABSOLUTE might be implemented by raw bayer sensors.
> >>>
> >>>My question is: would it make sense to create a new class of controls for
> >>>the low level sensor controls in a similar fashion we have a control class
> >>>for the flash controls?
> >>
> >>I think it would, but I'm not sure how we should name that class.
> >>V4L2_CTRL_CLASS_SENSOR is tempting, but many of the controls that will be
> >>found there (digital gains, black leverl compensation, test pattern, ...) can
> >>also be found in ISPs or other hardware blocks.
> >
> >I don't think ISPs typically implement test patterns. Do you know of any?
> >
> I know atleast two sensors (ov5642 and s5k4bafx) which have inbuilt
> ISP, programmed through i2c. They both have test patten generator. I
> think RAW(BAYER) sensors themselves cannot generate a test pattern
> without some h/w entity to convert RGGB into color bars in RGB or
> YUV.

The sensors can produce test patterns using their native pixel format. The
conversion (if one is needed, likely not, since typically the raw data is of
primary interest in this case) can also be done using the ISP integrated to
the SoC.

> >Should we separate controls which clearly apply to sensors only from the
> >rest?
> >
> >For sensors only:
> >
> >- Analog gain(s)
> >- Horizontal and vertical blanking
> >- Link frequency
> >- Test pattern
> 
> Where should the shutter operation be listed into? Also type
> (rolling, global) and method (manual, electronic) of shutter
> operation?

I'm in favour of Laurent's suggestion to classify these controls based on
what do they control, not where they are implemented in, and naming the
class accordingly.

In my reply to him, these controls would be part of the image capture
control class.

> >
> >The following can be implemented also on ISPs:
> >
> >- Per-component gains
> >- Black level compensation
> >
> >Do we have more to add to the list?
> >
> >If we keep the two the same class, I could propose the following names:
> >
> >V4L2_CTRL_CLASS_LL_CAMERA (for low level camera)
> 
> Instead of LL_CAMERA, wouldnt something like CAM_SENSOR_ARRAY would
> be more meaningful? We control the sensor array properties in this
> level.
> 
> >V4L2_CTRL_CLASS_SOURCE
> >V4L2_CTRL_CLASS_IMAGE_SOURCE
> >
> >The last one would be a good name for the sensor control class, as far as I
> >understand some are using tuners with the OMAP 3 ISP these days. For the
> >another one, I propose V4L2_CTRL_CLASS_ISP.
> >
> >Better names are always welcome. :-)
> >
> 
> Regards,
> Subash

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
