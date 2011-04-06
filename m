Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:44459 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1DFIgr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2011 04:36:47 -0400
Message-ID: <4D9C2670.2000603@mm-sol.com>
Date: Wed, 06 Apr 2011 11:38:08 +0300
From: Nayden Kanchev <nkanchev@mm-sol.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Kim HeungJun <riverful@gmail.com>
Subject: Re: [RFC v2] V4L2 API for flash devices
References: <4D9C2000.9090500@maxwell.research.nokia.com>
In-Reply-To: <4D9C2000.9090500@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

Thanks for the update. I have just one comment about strobe types.

<snip>


On 04/06/2011 11:10 AM, Sakari Ailus wrote:
> - Added an open question on a new control:
> V4L2_CID_FLASH_EXTERNAL_STROBE_WHENCE.
>
>
>
<snip>
> 2. External strobe edge / level
> -------------------------------
>
> No use is seen currently for this, but it may well appear, and the
> hardware supports this. Level based trigger should be used since it is
> more precise.
>
> 	V4L2_CID_FLASH_EXTERNAL_STROBE_WHENCE
>
> Whether the flash controller considers external strobe as edge, when the
> only limit of the strobe is the timeout on flash controller, or level,
> when the flash strobe will last as long as the strobe signal, or as long
> until the timeout expires.
>
> enum v4l2_flash_external_strobe_whence {
> 	V4L2_CID_FLASH_EXTERNAL_STROBE_LEVEL,
> 	V4L2_CID_FLASH_EXTERNAL_STROBE_EDGE,
> };
>

I agree that control over the strobe usage (level/edge) is required. 
Although we have some bad experience will lack of detailed information 
how exactly the flash chip will use those signals.

For example with AS3645A flash driver strobing by edge produced really 
strange flash output - light intensity was changing during the process 
and flash was stopped before the HW timeout.

On the other hand strobing by level didn't cause problems.

So even if HW supports some functionally we should prevent such 
malfunctioning by adding some restrictions in the board code also.

I would also rename xxx_STROBE_WHENCE to xxx_STROBE_TYPE but it is just 
a suggestion :)

BR,
Nayden
