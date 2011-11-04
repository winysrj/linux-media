Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60921 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab1KDKhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 06:37:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gary Thomas <gary@mlbassoc.com>
Subject: Re: Using MT9P031 digital sensor
Date: Fri, 4 Nov 2011 11:37:07 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4EB04001.9050803@mlbassoc.com>
In-Reply-To: <4EB04001.9050803@mlbassoc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111041137.08254.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gary,

On Tuesday 01 November 2011 19:52:49 Gary Thomas wrote:
> I'm trying to use the MT9P031 digital sensor with the Media Controller
> Framework.  media-ctl tells me that the sensor is set to capture using
> SGRBG12  2592x1944
> 
> Questions:
> * What pixel format in ffmpeg does this correspond to?

I don't know if ffmpeg supports Bayer formats. The corresponding fourcc in 
V4L2 is BA12.

If your sensor is hooked up to the OMAP3 ISP, you can then configure the 
pipeline to include the preview engine and the resizer, and capture YUV data 
at the resizer output.

> * Can I zoom/crop with this driver using the MCF?  If so, how?

That depends on what host/bridge you use. The OMAP3 ISP has scaling 
capabilities (controller by the crop rectangle at the resizer input and the 
format at the resizer output), others might not.

-- 
Regards,

Laurent Pinchart
