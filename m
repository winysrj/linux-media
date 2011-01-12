Return-path: <mchehab@pedra>
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:39905 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1ALOpX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 09:45:23 -0500
Received: from [172.21.25.171] (esdhcp-heru025171.research.nokia.com [172.21.25.171])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id p0CEjLPo032201
	for <linux-media@vger.kernel.org>; Wed, 12 Jan 2011 16:45:21 +0200
Message-ID: <4D2DBE81.3060906@nokia.com>
Date: Wed, 12 Jan 2011 16:45:21 +0200
From: =?ISO-8859-1?Q?Antti_Koskip=E4=E4?= <antti.koskipaa@nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RFC: Extending the format setting ioctls for raw image sensors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Introduction
============

The image sensors used in camera phones are quite smart these days and thanks
to the new Media Controller API they are now controlled as subdevs from
userspace. SMIA++ compatible sensors support things like:

- Cropping (both analog and digital)
- Binning (analog summing of adjacent pixels = downscaling)
- Subsampling or skipping (= moire-prone downscaling)
- Another type of downscaling which is more flexible.

There are a lot of other controls as well but handling these three are
complicated enough for one discussion thread. It would be nice to just set some
size via S_FMT and let the sensor driver figure it all out, but it is not that
simple.

Let's take a hypothetical 3 MP sensor as an example. The sensor area is
2048x1536. To produce different kinds of output sizes, the above parameters
have to be set.

For instance 2-by-2 binning would produce 1024x768 and 4-by-4
binning would produce 512x384.

You could also use 4-by-2 binning and 1-by-2 subsampling to produce 512x384.

Or you could use the more flexible scaler.

Depending on what you choose, the image quality may be different, image timings
will change and possibly even power consumption will change. Because of this,
we want to give userspace full freedom to control every parameter of the sensor
and keep the driver as simple and as generic as possible. I heard the FCam guys
were doing something like this already but I don't know how much of a hack
their system is.

Problem with current API
========================

There are only two subdev pad ioctls to set these things: S_FMT for size and
S_CROP for one type of crop only. More is needed or this interface has to
be extended somehow to allow these controls to be set. The additions could be
either new ioctls or new V4L2 controls.

Constraints for new controls
============================

- Not all binning types are supported by all SMIA++ sensors. For instance only
  1-by-1, 2-by-1 and 4-by-2 may be supported instead of continuously variable
  X-by-Y binning.

- Subsampling takes 4 parameters: x,y even increment and x,y odd increment.
  This allows more flexibility in picking the bayer elements (the components of
  your output GRBG quad don't need to be next to each other on the sensor chip)

- The downscaler in SMIA++ is weird. It only allows N/M downscaling where M
  is fixed at 16 and N >= 16. Example: setting N=17 on the abobe 3MP sensor
  would produce 1927x1445 (rounded) and N=32 would produce 1024x768 at the
  output. Perhaps using 16:16 or 8:24 fixed point for this control would be
  flexible enough?

- The downscaler also has two modes: horizontal only and horizontal+vertical.
  There is no vertical only mode in SMIA++.
  In the H+V case the scale factor for both directions is the same. They cannot
  be set separately for SMIA++ sensors.

Conclusion
==========

So, how should the ioctls/controls for these parameters be created? Do we
extend S_FMT with flag to set different "kinds" of formats or create new V4L2
controls? If new controls, how should they be arranged/named?

We don't want to create yet another set of incompatible private ioctls. This
stuff should be standardised and be as generic as possible so that other
sensor types/drivers can use it as well.

Comments?

Regards,

Antti Koskip‰‰
Nokia Corporation, MeeGo R&D
