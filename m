Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41369 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab1LSKbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 05:31:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Zhu, Mingcheng" <mingchen@quicinc.com>
Subject: Re: query video dev node name using the V4L2 device driver name
Date: Mon, 19 Dec 2011 11:31:22 +0100
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20111215095015.GC3677@valkosipuli.localdomain> <20111219071723.GL3677@valkosipuli.localdomain> <3D233F78EE854A4BA3D34C11AD4FAC1FDEF5E3@nasanexd01b.na.qualcomm.com>
In-Reply-To: <3D233F78EE854A4BA3D34C11AD4FAC1FDEF5E3@nasanexd01b.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112191131.23195.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
