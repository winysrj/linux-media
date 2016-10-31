Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34228 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S947843AbcJaXB4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 19:01:56 -0400
Date: Tue, 1 Nov 2016 01:01:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: p.zabel@pengutronix.de, niklas.soderlund@ragnatech.se,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: Notes on V4L2 async discussion
Message-ID: <20161031230151.GD3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here are my notes on the V4L2 async development discussion we had a couple
of days ago.

Philipp Zabel, Niklas Söderlund, Laurent Pinchart and myself were present.


Background
----------

The V4L2 async framework provides all-important support for delaying the
registration of the external sub-devices until all the necessary information
is available in order to finish the device registration.

New use cases have surfaced since the original V4L2 async framework. While
the original framework dealt with attaching single sub-devices to the ISP
(or bridge) device which also was the owner of the media device, we now have
an entire graph of devices described in DT. This is demonstrated by e.g. the
ADV7482 analogue / HDMI -> CSI-2 converter [1] and the iMX6 IPU [2].


New use cases
-------------

In order to support graphs, there are two approaches that can be taken in
extending the V4L2 async framework:

1. Take the next logical step in extending the V4L2 async framework and add
   support for a different kind of a notifier and a callback for sub-devices
   to register other sub-devices or
2. Implement a generic OF graph parser which parses the entire graph,
   possibly initiated by the Media device owner driver.

In the first option, the use of callbacks to driver functions to call other
callbacks suggests that the framework is getting perhaps a little bit more
complicated than it would need to be. Graph parsing is generic, independent
of hardware. There is also a significant risk of getting things wrong in
drivers, and on the other hand the framework could do more of the driver's job.

The V4L2 async framework would require changes beyond (1) also because there
will be other than 1:1 relations between sub-devices and async slaves (now
called async sub-devices).

Thus, from debugging, maintenance and niceness point of view the second
option is preferred.


Changes required
----------------

- A generic graph parsing function is needed. The function is called on a
  device node of the Media device driver's device.

	- Endpoints may refer to non-V4L2 devices as well. The drivers must
	  thus be consulted before parsing the OF links from a device_node,
	  in order to tell whether or not one or more ports should be
	  ignored. A callback is added for this purpose.
	
		- Driver's probe must be run first.

		- Probably default to parsing all.

- There may be other than 1:1 relations between device nodes and
  sub-devices (for device node which is related to a sub-device). In ADV7482
  case the driver could well instantiate several sub-devices for a single
  device node.

	- Instead of registering sub-devices with the async framework, async
	  slave concept should be used to replace async sub-devices.
	
		- An async slave is registered for each device's device
		  node by the driver in its probe() function.

	- Matching can be done using either the device or port node.

		- Using the port node does have the benefit of making it
		  possible to have a single list of nodes to match against.

- Sub-device registration to the media device can be postponed until the full
  graph is parsed. There may be other benefits from this. Once all
  sub-devices have been registered, the media device is finally registered.

	- The sub-devices can be registered to the media device only when
	  the media device itself is registered.
		
As there will be V4L2 async API changes to the existing API, this should be
tried first with one driver before converting more drivers.


References
----------

[1] http://www.retiisi.org.uk/v4l2/tmp/adv7482.txt

[2] http://www.retiisi.org.uk/v4l2/tmp/imx6.txt

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
