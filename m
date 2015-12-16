Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62401 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784AbbLPJiW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 04:38:22 -0500
Date: Wed, 16 Dec 2015 10:37:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Aviv Greenberg <avivgr@gmail.com>
Subject: per-frame camera metadata (again)
Message-ID: <Pine.LNX.4.64.1512160901460.24913@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

A project, I am currently working on, requires acquiringing per-frame 
metadata from the camera and passing it to user-space. This is not the 
first time this comes up and I know such discussions have been held 
before. A typical user is Android (also my case), where you have to 
provide parameter values, that have been used to capture a specific frame, 
to the user. I know Hans is working to handle one side of this process - 
sending per-request controls, but I'm not aware whether he or anyone else 
is actively working on this already or is planning to do so in the near 
future? I also know, that several proprietary solutions have been 
developed and are in use in various projects.

I think a general agreement has been, that such data has to be passed via 
a buffer queue. But there are a few possibilities there too. Below are 
some:

1. Multiplanar. A separate plane is dedicated to metadata. Pros: (a) 
metadata is already associated to specific frames, which they correspond 
to. Cons: (a) a correct implementation would specify image plane fourcc 
separately from any metadata plane format description, but we currently 
don't support per-plane format specification.

2. Separate buffer queues. Pros: (a) no need to extend multiplanar buffer 
implementation. Cons: (a) more difficult synchronisation with image 
frames, (b) still need to work out a way to specify the metadata version.

Any further options? Of the above my choice would go with (1) but with a 
dedicated metadata plane in struct vb2_buffer.

In either of the above options we also need a way to tell the user what is 
in the metadata buffer, its format. We could create new FOURCC codes for 
them, perhaps as V4L2_META_FMT_... or the user space could identify the 
metadata format based on the camera model and an opaque type (metadata 
version code) value. Since metadata formats seem to be extremely camera- 
specific, I'd go with the latter option.

Comments extremely welcome.

Thanks
Guennadi
