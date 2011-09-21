Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33487 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1IUO2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 10:28:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4] noon010pc30: Conversion to the media controller API
Date: Wed, 21 Sep 2011 16:28:08 +0200
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com
References: <201109210018.14185.laurent.pinchart@ideasonboard.com> <1316615160-15580-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1316615160-15580-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109211628.08482.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

On Wednesday 21 September 2011 16:26:00 Sylwester Nawrocki wrote:
> Replace g/s_mbus_fmt ops with the pad level get/set_fmt operations.
> Add media entity initialization and set subdev flags so the host driver
> creates a subdev device node for the driver.
> A mutex was added for serializing the subdev operations. When setting
> format is attempted during streaming an (EBUSY) error will be returned.
> 
> After the device is powered up it will now remain in "power sleep"
> mode until s_stream(1) is called. The "power sleep" mode is used
> to suspend/resume frame generation at the sensor's output through
> s_stream op.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
