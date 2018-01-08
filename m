Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48522 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755200AbeAHNrY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 08:47:24 -0500
Date: Mon, 8 Jan 2018 15:47:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@s-opensource.com,
        hverkuil@xs4all.nl
Subject: =?iso-8859-1?B?W0FOTl2gTWVldGlu?= =?iso-8859-1?Q?g?= notes on naming
 meeting 2017-10-11/13
Message-ID: <20180108134720.urmfzleeeyvmxlff@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

Here are the meeting notes on the IRC meeting that took place 11th and 13th
last October. The brief summary is below, the full log can be found here:

<URL:http://www.retiisi.org.uk/v4l2/notes/v4l2-naming-2017-10-11.txt>

Attendees:

	Laurent Pinchart
	Mauro Chehab
	Hans Verkuil
	Lars-Peter Clausen
	Sylwester Nawrocki
	Sakari Ailus

Notes:

- It was decided to call a group of multiple interconnected hardware
  devices that that are designed to operate together as a "media hardware
  complex". We haven't had a proper term for this in the past. Effectively
  this means device that can be accessed through a given media device.

- "Device", when it refers to a device node on a file system, shall be
  replaced by "device node" in uAPI documentation if there's any ambiguity.
  The same applies to "device" when it refers to hardware, i.e. "hardware
  device". Further use of the "device" to refer either is fine as long as
  there is no ambiguity of what it means.

- During the discussion on V4L2 sub-devices as V4L2 devices, the following
  points were brought up:

  - V4L2 sub-device nodes are V4L2 device nodes in the following respects:

    - They share the same major number as V4L2 and they are implemented by
      the V4L2 framework (as instantiated by drivers).
    
    - V4L2 sub-devices share some IOCTLs such as V4L2 controls with other
      V4L2 device nodes.
      
    - They do share the "V4L2" in their name.

  - But there are some differences as well:
  
    - V4L2 sub-devices implement only a handful of IOCTLs, most of which
      are uniformly implemented by all other V4L2 device node types (video,
      radio, touch). E.g. QUERYCAP is not implemented for sub-devices
      albeit there have been proposals to add this for unrelated reasons.
    
    - Historically V4L2 sub-device documentation has been always outside
      the main V4L2 documentation (section 1 in particular). This is
      primarily a documentation issue though.

    - Some V4L2 sub-device IOCTLs have different arguments from the V4L2
      IOCTLs due to e.g. the fact that sub-devices are a control only
      interface dealing with media bus formats whereas V4L2 video device
      nodes deal with in-memory V4L2 formats.

- Documentation-wise, there's a common need to refer to V4L2 device nodes
  which are not sub-device nodes as the rest have quite a bit in common. In
  this case, they should be called "V4L2 video device node" or "V4L2 radio
  device node", or "V4L2 video/radio device nodes". This technically does
  not include touch device nodes.
  
- This distinction enables calling also V4L2 sub-device nodes as V4L2
  device nodes, which was also agreed. The corresponding changes should be
  made to the uAPI documentation.

Let me know if there are inaccuracies or if you feel something is missing.
It's been a while we had the meeting but this is why IRC meetings are
great: you can write the meeting notes afterwards with pretty good
accuracy. :-)

Also thanks to Mauro for reminding me we had no proper notes on the
meeting.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
