Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14378 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1LSSJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 13:09:19 -0500
From: "Zhu, Mingcheng" <mingchen@quicinc.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: query video dev node name using the V4L2 device driver name
Date: Mon, 19 Dec 2011 18:09:18 +0000
Message-ID: <3D233F78EE854A4BA3D34C11AD4FAC1FDEF79C@nasanexd01b.na.qualcomm.com>
References: <20111215095015.GC3677@valkosipuli.localdomain>
 <20111219071723.GL3677@valkosipuli.localdomain>
 <3D233F78EE854A4BA3D34C11AD4FAC1FDEF5E3@nasanexd01b.na.qualcomm.com>
 <201112191131.23195.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112191131.23195.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I have a problem here. Take following example that we have two video dev nodes as:
/dev/video0: this node is for WIFI capture
/dev/video1: this is the camera driver.

Is it possible for the user space to find out video1 is the camera without open and query each video node's capabilities? 

--Mingcheng


-----Original Message-----
From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] 
Sent: Monday, December 19, 2011 2:31 AM
To: Zhu, Mingcheng
Cc: Sakari Ailus; linux-media@vger.kernel.org
Subject: Re: query video dev node name using the V4L2 device driver name

Hi Mingcheng,

On Monday 19 December 2011 11:21:03 Zhu, Mingcheng wrote:
> Hi Laurent and Sakari,
> 
> Current media entity contains a few fields to identify a dev node (name,
> type, group_id). The entity name is the v4l2 dev node name such as
> "/dev/video0" "/dev/video1". There is no information who is "/dev/video0"
> and who is /dev/video1". This makes that, after query the media_entity the
> application still could not figure out who is /dev/video1".

The media controller framework sets the video devnode entities names to the 
video device name, as provided in the video_device name field. That's 
automatic, so you should just ensure that your video_device name is properly 
set.

> However in V4L2 devices, there is a driver name that the vendor can assign
> a specific name such "WIFI CAPTURE" or BACK_CAMERA" to the driver name. Is
> it possible to add the driver name into the media_entity? This makes that,
> if the userspace application knows the driver name it can use the driver
> name to find the dev node.

Using the driver name isn't optimal, as a driver could create several video 
device nodes for the same hardware device. Those nodes should have different 
names, so you should use the video_device name field as explained above.

-- 
Regards,

Laurent Pinchart
