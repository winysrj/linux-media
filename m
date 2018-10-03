Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:39447 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbeJCSRa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Oct 2018 14:17:30 -0400
Date: Wed, 3 Oct 2018 14:29:26 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        jacopo@jmondi.org
Subject: Re: [PATCH v4 2/2] [media] imx214: Add imx214 camera sensor driver
Message-ID: <20181003112926.oxfqykqrazisjwab@paasikivi.fi.intel.com>
References: <20181003072905.21786-1-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003072905.21786-1-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Wed, Oct 03, 2018 at 09:29:05AM +0200, Ricardo Ribalda Delgado wrote:
> Add a V4L2 sub-device driver for the Sony IMX214 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
> 
> Tested on a DB820c alike board with Intrinsyc Open-Q 13MP camera.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

How about adding that exposure control? And perhaps analogue and digital
gain as well.

I'd like to see the exposure control there because

	1. it's needed for the driver to be actually usable and

	2. it requires other non-trivial changes to the driver (runtime PM
	   or other arrangements to avoid accessing registers when the
	   power is off).

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
