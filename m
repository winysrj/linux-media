Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33707 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab1CCPF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 10:05:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kim HeungJun <riverful@gmail.com>
Subject: Re: using V4L2_CID_BRIGHTNESS or V4L2_CID_EXPOSURE in the camera
Date: Thu, 3 Mar 2011 16:05:33 +0100
Cc: "linux-media@vger.kernel.org Mailing List Media"
	<linux-media@vger.kernel.org>,
	VerkuilHans VerkuilHans <hverkuil@xs4all.nl>,
	=?utf-8?q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>
References: <52566539-3662-4153-B111-EC82389102BE@gmail.com>
In-Reply-To: <52566539-3662-4153-B111-EC82389102BE@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031605.34470.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kim,

On Thursday 03 March 2011 16:01:24 Kim HeungJun wrote:
> Hello everyone,
> 
> I have a question about realization the camera brightness control (or
> exposure, because it's similar effect). I'm confused this similar two
> control - V4L2_CID_BRIGHTNESS and V4L2_CID_EXPOSURE.
> 
> These control both express the brightness consequently.
> 
> The CID can express the brightness - V4L2_CID_EXPOSURE, is prepared in the
> camera class. And V4L2_CID_BRIGHTNESS seems be possible to use in the
> camera driver, although it is defined in the global(?) class.
> 
> So, which CID I can use to express the image's brightness??

V4L2_CID_EXPOSURE is used to control the exposure time (which obviously 
influences the brightness), and V4L2_CID_BRIGHTNESS to control the brightness 
offset (constant value added to all pixels in the image by a processing block 
in the digital domain).

-- 
Regards,

Laurent Pinchart
