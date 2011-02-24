Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46572 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab1BXKtp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 05:49:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: riverful.kim@samsung.com
Subject: Re: [RFC PATCH 0/2] v4l2-ctrls: add new focus mode
Date: Thu, 24 Feb 2011 11:49:48 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <4D6636B9.4020105@samsung.com>
In-Reply-To: <4D6636B9.4020105@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241149.48831.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Thursday 24 February 2011 11:45:13 Kim, HeungJun wrote:
> Hello,
> 
> I faced to the absence of the mode of v4l2 focus for a couple of years.
> While dealing with some few morebile camera sensors, the focus modes
> are needed more than the current v4l2 focus mode, like a Macro &
> Continuous mode. The M-5MOLS camera sensor I dealt with, also support
> these 2 modes. So, I'm going to suggest supports of more detailed
> v4l2 focus mode.
> 
> This RFC series of patch adds new auto focus modes, and documents it.
> 
> The first changes the boolean type of V4L2_CID_FOCUS_AUTO to menu type,
> and insert menus 4 enumerations:
> 
> V4L2_FOCUS_AUTO,
> V4L2_FOCUS_MACRO,
> V4L2_FOCUS_MANUAL,
> V4L2_FOCUS_CONTINUOUS
> 
> The recent mobile camera sensors with ISP supports Macro & Continuous Auto
> Focus aka CAF mode, of course normal AUTO mode, even Continuous mode.

I'm curious, what sensor are you referring to ?

> Changing the type of V4L2_CID_FOCUS_MODE, is able to define more exact
> focusing mode of camera sensor.
> 
> The second changes let the previous drivers using V4L2_CID_FOCUS_AUTO by
> boolean type be able to use the type of menu.
> 
> Thanks for reading this, and I hope any ideas and any comments.

-- 
Regards,

Laurent Pinchart
