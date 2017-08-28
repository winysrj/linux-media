Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58361
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751152AbdH1N2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 09:28:01 -0400
Date: Mon, 28 Aug 2017 10:27:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: V4L2 device node centric - Was: [PATCH v4 6/7] media: videodev2:
 add a flag for MC-centric  devices
Message-ID: <20170828102751.76f8b93f@vento.lan>
In-Reply-To: <7c8a51f6-92b7-0262-9a41-7eb28234638f@xs4all.nl>
References: <cover.1503747774.git.mchehab@s-opensource.com>
        <638ed268ca84c5e8ea810a2c27e397ab7e90585b.1503747774.git.mchehab@s-opensource.com>
        <7c8a51f6-92b7-0262-9a41-7eb28234638f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Aug 2017 11:41:58 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > +        control, and thus can't be used by **v4l2-centric** applications.  
> 
> vdev-centric
> 
> TBD: I still think I prefer V4L2-centric over vdev-centric.

I'm splitting it on a separate thread, to make easier for us to discuss.

For those that aren't tracking the patchset that are documenting those
terms, when MC was added, we got a hole new series of V4L2 devices that
are incompatible with standard V4L2 applications, as they require 
knowledge about the hardware sub-devices. We are referring to such
devices as MC-centric. We need another term to refer to the V4L2 devices
that can be used by a generic application, and are fully controlled via a 
V4L2 device (/dev/video*, /dev/radio*, /dev/swradio*, /dev/vbi*,
/dev/v4l-touch*).

The proposed documentation patch series solves this issue by
adding a glossary (patch 1) that defines what a "V4L2 device node"
as:

    V4L2 device node
	 A device node that it is associated to a V4L2 main driver,
	 as specified at :ref:`v4l2_device_naming`.

And, at the device naming chapter, at the spec (patch 2), it
explicitly lists all V4L2 device node names:

	.. _v4l2_device_naming:

	V4L2 Device Node Naming
	=======================

	... 
 
	The existing V4L2 device node types are:

	======================== ======================================================
	Default device node name Usage
	======================== ======================================================
	``/dev/videoX``		 Video input/output devices
	``/dev/vbiX``		 Vertical blank data (i.e. closed captions, teletext)
	``/dev/radioX``		 Radio tuners and modulators
	``/dev/swradioX``	 Software Defined Radio tuners and modulators
	``/dev/v4l-touchX``	 Touch sensors
	======================== ======================================================

So, the concept of "V4L2 Device Node" is now clear, and doesn't
include V4L2 sub-device device nodes (/dev/v4l-subdev*).

For devices controlled via media controller, everybody seems to be
comfortable of calling them as MC-centric.

There are currently two proposals to refer to the media hardware that
is controlled via a V4L2 Device Node:

	- vdev-centric
	- V4L2-centric

The last one sounds confusing to me, as subdev API is part of the V4L2
specification. "V4L2-centric" name sounds to include subdevs. 

That's why IMHO, vdev-centric is better.

We could go to some other naming for them, that would also be
an alias for "V4L2 Device Node":

	- VD-centric
	- VDN-centric

Comments?

Thanks,
Mauro
