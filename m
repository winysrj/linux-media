Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:43385 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1KHMUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 07:20:13 -0500
Message-ID: <4EB91E7C.4050302@mlbassoc.com>
Date: Tue, 08 Nov 2011 05:20:12 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Using MT9P031 digital sensor
References: <4EB04001.9050803@mlbassoc.com> <201111041137.08254.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111041137.08254.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-11-04 04:37, Laurent Pinchart wrote:
> Hi Gary,
>
> On Tuesday 01 November 2011 19:52:49 Gary Thomas wrote:
>> I'm trying to use the MT9P031 digital sensor with the Media Controller
>> Framework.  media-ctl tells me that the sensor is set to capture using
>> SGRBG12  2592x1944
>>
>> Questions:
>> * What pixel format in ffmpeg does this correspond to?
>
> I don't know if ffmpeg supports Bayer formats. The corresponding fourcc in
> V4L2 is BA12.

ffmpeg doesn't seem to support these formats

>
> If your sensor is hooked up to the OMAP3 ISP, you can then configure the
> pipeline to include the preview engine and the resizer, and capture YUV data
> at the resizer output.

I am using the OMAP3 ISP, but it's a bit unclear to me how to set up the pipeline
using media-ctl (I looked for documentation on this tool, but came up dry - is there any?)

Do you have an example of how to configure this using the OMAP3 ISP?

>
>> * Can I zoom/crop with this driver using the MCF?  If so, how?
>
> That depends on what host/bridge you use. The OMAP3 ISP has scaling
> capabilities (controller by the crop rectangle at the resizer input and the
> format at the resizer output), others might not.

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
