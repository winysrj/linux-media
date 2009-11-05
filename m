Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55635 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbZKERHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 12:07:16 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Date: Thu, 5 Nov 2009 11:07:09 -0600
Subject: RE: [PATCH/RFC 9/9 v2] mt9t031: make the use of the soc-camera
 client API optional
Message-ID: <A69FA2915331DC488A831521EAE36FE4015583406A@dlee06.ent.ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40155798D56@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0911041703000.4837@axis700.grange>
 <200911051657.59303.hverkuil@xs4all.nl>
 <Pine.LNX.4.64.0911051753540.5620@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911051753540.5620@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Guennadi,

>> in the v4l2_queryctrl struct.
>
>I think, this is unrelated. Muralidharan just complained about the
>soc_camera_find_qctrl() function being used in client subdev drivers, that
>were to be converted to v4l2-subdev, specifically, in mt9t031.c. And I
>just explained, that that's just a pretty trivial library function, that
>does not introduce any restrictions on how that subdev driver can be used
>in non-soc-camera configurations, apart from the need to build and load
>the soc-camera module. In other words, any v4l2-device bridge driver
>should be able to communicate with such a subdev driver, calling that
>function.
>
If soc_camera_find_qctrl() is such a generic function, why don't you
move it to v4l2-common.c so that other platforms doesn't have to build
SOC camera sub system to use this function? Your statement reinforce
this.

>> This will also make it easy to convert them to the control framework that
>I
>> am working on.
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

