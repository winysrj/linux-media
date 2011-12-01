Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:37626 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1LAOau (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Dec 2011 09:30:50 -0500
Date: Thu, 1 Dec 2011 16:30:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	snjw23@gmail.com, g.liakhovetski@gmx.de, dacohen@gmail.com,
	hdegoede@redhat.com, pawel@osciak.com
Subject: [RFC] On controlling sensors
Message-ID: <20111201143044.GI29805@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,


I've been working a few years with digital cameras and Linux and come to the
conclusion that the way the sensors are typically configured through V4L2
subdevs is far from optimal for the use of the low level software that
typically accesses it, nor we make efficient use of the standard V4L2 subdev
API currently.

The regular S_FMT and S_PARM IOCTLs are fine as a high level interface. This
RFC does _not_ take a negative stance against them nor suggest they should
ever be deprecated. No new interfaces are proposed for regular V4L2
applications either.

Comments to this RFC are the most welcome.


What's wrong
============

Pixel array, binning and scaling
--------------------------------

ENUM_FRAMESIZES interface makes no sense on V4L2 subdevice user space
interface. Why so? Since the size of the sensor's pixel array is constant.
Other sizes are derived from that by scaling and cropping.

These days most sensors can perform a lot of image processing by themselves
--- for example binning and cropping are available on most sensors the
pixel array of which is larger than 640x480 or so. More advanced sensors can
also perform scaling.

We have existing interface in V4L2 subdev to configure scaling. The sensors
should impelement this interface. This may involve exporting more than one
subdevs from the sensor driver.


Frame rates
-----------

Sensors are utterly unaware of the whole concept of frame rate. Instead,
they deal with pixel clocks, horizontal and vertical blanking, binning and
scaling factors and link frequencies. The same goes for the low level
software controlling automatic white balance and exposure on the sensor:
this information is required to set and get detailed timing information from
the sensor.

However, the current control mechanisms provided by the V4L2 subdev
interface provides neither.

It is also impossible to provide detailed frame rate information using the
current interfaces.


Pixel rate
---------

The pixel rate is important as well. The maximum pixel rate for some of the
hardware blocks may be lower than those earlier in the pipeline. This
becomes an issue in the OMAP 3 ISP where only the CSI-2 receiver can handle
pixel rates up to 200 Mp/s whereas the rest of the ISP blocks only can do
100 Mp/s.

The current APIs do not reveal this, but it is also impossible to know the
output data rate of the sensor in order to come up with a valid
configuration.


How to fix this
===============

Sensors should be controlled by exposing their natural parameters to the
user. This means the following:


Link frequency as control
-------------------------

Typically the hardware allows few different link frequencies to be used. The
actual data rate may depend on the bits-per-pixel value and how many lanes
are being used on serial links.

Togethet with the binning and scaling factors, the link pixel rate defines
how fast the sensor pixel array can be read. The pixel rate at the pixel
array is important for calculating the sensor timing for the user of the
control algorithms.

Link frequency is chosen over pixel rate since pixel rate is dependent on
the format of the data --- bits per pixel.


Horizontal and vertical blanking as controls
--------------------------------------------

Horizontal and vertical blanking typically is relatively freely configurable
in a range between a lower and an upper limit. The limits are hardware
specific. The unit of the horizontal blanking is line and for vertical
blanking it's pixel.

Together with the link rate, vertical and horizontal blanking, image width
and height define the frame rate.

There are also other reasons why the user is interested in the blanking
information, such as to minimise the rolling shutter effect or amortise the
data rate on the memory bus.


Binning, scaling and cropping configuration
-------------------------------------------

Binning, scaling and cropping must be configured using the same Media
controller and V4L2 subdevice APIs as the image pipe inside the ISPs. It
makes really no difference whether the scaler is located in the ISP or in
the sensor: the API for configuring it must be the same. This may mean
exposing the sensor as multiple subdevices to make it configurable using the
V4L2 subdevice interface.

A sensor could look like this, for example:

pixel array:0 [crop] ---> 0:binner:1 ---> 0:ISP's CSI2 receiver

The pixel array's pixel rate would only be defined after configuring the
binner and the link rate between the sensor and the ISP. The reason for this
is that the pixel clock in the pixel array may well be higher than after the
scaler. But the pixel clock, and the limits for vertical and horizontal
blanking are only available after the binning factor and the link rate have
been specified.

The blanking must be thus specified after configuring the formats on the
pipeline.


Proposal
========

In the spec and the interfaces not much would change: only the purposes we
are currently using the interfaces would change a little bit. The sensor
drivers would need to make more use of the V4L2 subdev interface.


Control class for low-level controls
------------------------------------

A new control class will be created for low level controls. It is to be
called

	V4L2_CTRL_CLASS_LL,

where "LL" is for "low level". Better proposals on the name of the class are
welcome. My feeling is that we might get lots of controls to this class over
time.

Controls in this class will include

	V4L2_CID_LL_VBLANK,
	V4L2_CID_LL_HBLANK and
	V4L2_CID_LL_LINK_FREQ.

Link frequency is chosen instead of pixel rate since the pixel rate is
dependent on the format. That would make the available values depend on
selected format which I consider potentially confusing.

The same class should likely hold the controls for separate analogue and
digital gains and per-component gains. Per-component gains are typically
digital-only, but some sensors support per-component analog gains. So we
should have common gains and per-component gains, both digital and analog.


Pixel rate as part of struct v4l2_mbus_pixelfmt
-----------------------------------------------

Pixel rate would be added to the struct v4l2_mbus_pixelfmt in kP/s
(kilopixels per second).

struct v4l2_mbus_framefmt {
        __u32                   width;
        __u32                   height;
        __u32                   code;
        __u32                   field;
        __u32                   colorspace;
	__u32			pixel_rate;
        __u32                   reserved[6];
};


Sensors with only a few pre-defined configurations
--------------------------------------------------

Some sensors, such as the infamous Omnivision ones, only provide register
lists to configure the sensor from a few pre-defined configurations. These
sensor drivers cannot meaningfully expose the low-level API for controlling
them and are bound to continue to provide high level information on supported
resolutions and frame rates.

The generic user space should have no issues in recognising such sensors
from the ones which do provide the low-level controls. We still need to
define the exact method to distinguish them.

I don't like very much that we would have different ways to configure
devices, but as we simply do not have enough information to configure these
properly I do not really see a way around it.


Regular V4L2 applications
-------------------------

Controlling sensors this way is obviously the most suitable for embedded
systems. Desktops might not care. But still on embedded systems one may well
want to run regular V4L2 applications.

The solution for this is the same as previously agreed on: a pipeline setup
library, a configuration configuration program and a libv4l2 plugin using
the library. Vendors are encouraged to provide their own libraries which
know the features of their hardware the best and can best configure them as
well.

It also would require using these libraries on devices which have not needed
them before: if you combine a sensor driver exposing this kind of an
interface with a regular camera bridge which just exposes regular V4L2 API,
it won't work as such.

To avoid creating double effort in pipeline configuration, the bridge driver
also must expose V4L2 subdev API so the full pipeline configuration can be
done from the user space.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
