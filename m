Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44869 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab1C3Jd4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 05:33:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
Date: Wed, 30 Mar 2011 11:34:14 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
References: <4D90854C.2000802@maxwell.research.nokia.com>
In-Reply-To: <4D90854C.2000802@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301134.14798.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Monday 28 March 2011 14:55:40 Sakari Ailus wrote:

[snip]

> 	V4L2_CID_FLASH_STROBE_MODE (menu; LED)
> 
> Use hardware or software strobe. If hardware strobe is selected, the
> flash controller is a slave in the system where the sensor produces the
> strobe signal to the flash.
> 
> In this case the flash controller setup is limited to programming strobe
> timeout and power (LED flash) and the sensor controls the timing and
> length of the strobe.
> 
> enum v4l2_flash_strobe_mode {
> 	V4L2_FLASH_STROBE_MODE_SOFTWARE,
> 	V4L2_FLASH_STROBE_MODE_EXT_STROBE,
> };

[snip]

> 	V4L2_CID_FLASH_LED_MODE (menu; LED)
> 
> enum v4l2_flash_led_mode {
> 	V4L2_FLASH_LED_MODE_FLASH = 1,
> 	V4L2_FLASH_LED_MODE_TORCH,
> };

Thinking about this some more, shouldn't we combine the two controls ? They 
are basically used to configure how the flash LED is controlled: manually 
(torch mode), automatically by the flash controller (software strobe mode) or 
automatically by an external component (external strobe mode).

-- 
Regards,

Laurent Pinchart
