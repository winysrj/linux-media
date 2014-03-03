Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55768 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbaCCMmU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Mar 2014 07:42:20 -0500
Message-ID: <53147887.8020302@ti.com>
Date: Mon, 3 Mar 2014 18:11:43 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 5/7] v4l: ti-vpe: Allow usage of smaller images
References: <1393832008-22174-1-git-send-email-archit@ti.com> <1393832008-22174-6-git-send-email-archit@ti.com> <16d701cf36da$17704d80$4650e880$%debski@samsung.com>
In-Reply-To: <16d701cf36da$17704d80$4650e880$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 03 March 2014 05:44 PM, Kamil Debski wrote:
> Hi Archit,
>
>> From: Archit Taneja [mailto:archit@ti.com]
>> Sent: Monday, March 03, 2014 8:33 AM
>>
>> The minimum width and height for VPE input/output was kept as 128
>> pixels. VPE doesn't have a constraint on the image height, it requires
>> the image width to be atleast 16 bytes.
>
> "16 bytes" - shouldn't it be pixels? (also "at least" :) )
> I can correct it when applying the patch if the above is the case.

VPDMA IP requires the line stride of the input/output images to be at 
least 16 bytes in total.

This can safely result in a minimum width of 16 pixels(NV12 has the 
least bpp with 1 byte per pixel). But we don't really have any need to 
support such small image resolutions. So I picked up 32x32 as the 
minimum size, and tested VPE with that.

Thanks,
Archit

