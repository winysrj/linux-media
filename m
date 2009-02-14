Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:8903
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbZBNUsz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 15:48:55 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: linux-media@vger.kernel.org
Subject: Adding a control for Sensor Orientation
Date: Sat, 14 Feb 2009 20:48:51 +0000
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu,
	"Hans Verkuil" <hverkuil@xs4all.nl>,
	Olivier Lorin <o.lorin@laposte.net>,
	Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142048.51863.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Hans Verkuil put forward a convincing argument that sensor orientation 
shouldn't be part of the buffer flags as then it would be unavailable to 
clients that use read() so it looks like implementing a read only control is 
the only appropriate option.

It seems that Sensor Orientation is an attribute that many cameras may want to 
expose so it shouldn't be a private control. Olivier Lorin's example patch 
created a new CAMERA_PROPERTIES class. I'm not sure that a new class is 
really justified so would like to hear other views on where the control 
should live (and also if everyone is happy with Hans Verkuil's suggested name 
of SENSOR_ORIENTATION which I prefer to Olivier Lorin's SENSOR_UPSIDE_DOWN as 
we want to represent HFLIP and VFLIP as well as upside down (which as 
currently implemented means 180 degree rotation.))

Assuming that it is considered inappropriate to add a new control as 
an "Old-style 'user' control" then it is also, I presume, necessary to extend 
gspca to support VIDIOC_G_EXT_CTRLS as at the moment it requires all control 
access to use VIDIOC_G_CTRL. Would doing this conflict with anything anyone 
else may be working on such as conversion to use v4l2_device.

Thoughts please.

Adam Baker
