Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:35106 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab1EPQqA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 12:46:00 -0400
Message-ID: <4DD15579.2080005@maxwell.research.nokia.com>
Date: Mon, 16 May 2011 19:48:57 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Subject: Re: [RFC 0/3] V4L2 API for flash devices and the adp1653 flash controller
 driver
References: <4DD11FEC.8050308@maxwell.research.nokia.com>
In-Reply-To: <4DD11FEC.8050308@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sakari Ailus wrote:
> Hi,
> 
> This is a patchset which implements RFC v4 of V4L2 API for flash devices
> [1], with minor modifications, and adds the adp1653 flash controller driver.

Replying to myself, the associated board code for the N900 isn't part of
this patchset. It's are available here with the rest of the drivers:

<URL:https://www.gitorious.org/omap3camera/pages/Home>

My current intention is to fix the board code in the future with the
rest of the drivers as I don't see very much use for the flash driver
before the et8ek8 image sensor driver.

The patches in the patchset itself are in the rx51-002-upstream branch.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
