Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47427 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab1ESMOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 08:14:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 0/3] V4L2 API for flash devices and the adp1653 flash controller driver
Date: Thu, 19 May 2011 14:14:44 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
References: <4DD4F3CA.3040300@maxwell.research.nokia.com>
In-Reply-To: <4DD4F3CA.3040300@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191414.44721.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Thursday 19 May 2011 12:41:14 Sakari Ailus wrote:
> Hi,
> 
> This patchset implements RFC v4 of V4L2 API for flash devices [1], with
> minor modifications, and adds the adp1653 flash controller driver.

As already answered in private:

Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
 
> This patchset depends on the bitmask controls patch [4].
>
> Changes since v2 [3] of the RFC patchset:
> 
> - Improved flash control documentation in general.
> 
> - Faults may change the LED mode to none. This is now documented.
> 
> - adp1653 is returned to sane after faults are detected.
> 
> - Proper error handling for adp1653_get_fault() in adp1653_strobe().
> 
> - Remove useless function: adp1653_registered() and the corresponding
>   callback. Controls are now initialised in adp1653_probe().
> 
> - Improved fault handling in adp1653_init_device().
> 
> Changes since v1 [2] of the RFC patchset:
> 
> - Faults on the flash LED are allowed to make the LED unusable before
> the faults are read. This is implemented in the adp1653 driver.
> 
> - Intensities are using standard units; mA for flash / torch and uA for
> the indicator.
> 
> 
> Thanks to those who have given their feedback so far in the process!
> 
> 
> [1] http://www.spinics.net/lists/linux-media/msg32030.html
> 
> [2] http://www.spinics.net/lists/linux-media/msg32396.html
> 
> [3] http://www.spinics.net/lists/linux-media/msg32436.html
> 
> [4] http://www.spinics.net/lists/linux-media/msg31001.html

-- 
Regards,

Laurent Pinchart
