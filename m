Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:59119 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbZJ3Oeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2009 10:34:37 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Date: Fri, 30 Oct 2009 09:34:35 -0500
Subject: RE: [PATCH/RFC 0/9 v2] Image-bus API and accompanying soc-camera
 patches
Message-ID: <A69FA2915331DC488A831521EAE36FE40155798775@dlee06.ent.ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910301338140.4378@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

Thanks for updating the driver. I will integrate it when I get a chance and let you know if I see any issues.

BTW, Is there someone developing a driver for MT9P031 sensor which is very similar to MT9T031? Do you suggest a separate driver for this sensor or
add the support in MT9T031? I need a driver for this and plan to add it soon.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Friday, October 30, 2009 10:01 AM
>To: Linux Media Mailing List
>Cc: Hans Verkuil; Laurent Pinchart; Sakari Ailus; Karicheri, Muralidharan
>Subject: [PATCH/RFC 0/9 v2] Image-bus API and accompanying soc-camera
>patches
>
>Hi all
>
>As discussed yesterday, we sant to finalise the conversion of soc-camera
>to v4l2-subdev. The presented 9 patches consist of a couple of clean-ups,
>minor additions to existing APIs, and, most importantly, the second
>version of the image-bus API. It hardly changed since v1, only got
>extended with a couple more formats and driver conversions. The last patch
>modifies mt9t031 sensor driver to enable its use outside of soc-camera.
>Muralidharan, hopefully you'd be able to test it. I'll provide more
>comments in the respective mail. A complete current patch-stack is
>available at
>
>http://download.open-technology.de/soc-camera/20091030/
>
>based on 2.6.32-rc5. Patches, not included with these mails have either
>been already pushed via hg, or posted to the list earlier.
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

