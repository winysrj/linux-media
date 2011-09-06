Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:39405 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1IFLg7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 07:36:59 -0400
Date: Tue, 6 Sep 2011 14:36:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	hechtb@googlemail.com, g.liakhovetski@gmx.de
Subject: [RFC] New class for low level sensors controls?
Message-ID: <20110906113653.GF1393@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We are beginning to have raw bayer image sensor drivers in the mainline.
Typically such sensors are not controlled by general purpose applications
but e.g. require a camera control algorithm framework in user space. This
needs to be implemented in libv4l for general purpose applications to work
properly on this kind of hardware.

These sensors expose controls such as

- Per-component gain controls. Red, blue, green (blue) and green (red)
  gains.

- Link frequency. The frequency of the data link from the sensor to the
  bridge.

- Horizontal and vertical blanking.

None of these controls are suitable for use of general purpose applications
(let alone the end user!) but for the camera control algorithms.

We have a control class called V4L2_CTRL_CLASS_CAMERA for camera controls.
However, the controls in this class are relatively high level controls which
are suitable for end user. The algorithms in the libv4l or a webcam could
implement many of these controls whereas I see that only
V4L2_CID_EXPOSURE_ABSOLUTE might be implemented by raw bayer sensors.

My question is: would it make sense to create a new class of controls for
the low level sensor controls in a similar fashion we have a control class
for the flash controls?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
