Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:51134 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755402AbbCROzJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 10:55:09 -0400
Message-ID: <550991C2.80503@logicpd.com>
Date: Wed, 18 Mar 2015 09:54:58 -0500
From: Tim Nordell <tim.nordell@logicpd.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-media@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 25/26] omap3isp: Move to videobuf2
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com> <1398083352-8451-26-git-send-email-laurent.pinchart@ideasonboard.com> <5508B15A.2050900@logicpd.com> <2161613.bbRGp2ApSQ@avalon>
In-Reply-To: <2161613.bbRGp2ApSQ@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent -

On 03/18/15 07:39, Laurent Pinchart wrote:
> Hi Tim,
>
> On Tuesday 17 March 2015 17:57:30 Tim Nordell wrote:
>> On 04/21/14 07:29, Laurent Pinchart wrote:
>>> Replace the custom buffers queue implementation with a videobuf2 queue.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> I realize this is late (it's in the kernel now), but I'm noticing that
>> this does not appear to properly support the scatter-gather buffers that
>> were previously supported as far as I recall (and can tell with what was
>> removed with this patch), especially when using USERPTR.  You can
>> observe this using "yavta" with the -u parameter.  Can you confirm if
>> this works for you?  I get the following output from the kernel when
>> attempting to stream a 640x480 UYVY framebuffer:
>>
>> [  111.381256] contiguous mapping is too small 589824/614400
> The OMAP3 ISP uses an IOMMU, physically non-contiguous buffers should thus be
> mapped contiguously into the device memory space. I haven't tried USERPTR
> support recently, but this surprises me. It requires investigation. Could you
> give it a try ?
>
That's why I wrote the e-mail since I did give it a try.  It doesn't 
work in kernel v3.19 as expected.  I'm using a BT.656 device (and with 
the patches I submitted last week since it didn't work for my device 
without those that I wrote), so it's a little harder to go back to the 
exact patch that causes it to fail (since I believe it's this patch 
which is pre-BT.656 support) but I would guess that it's the one I 
replied to here.

The videobuf2-dma-contig framework is what is emitting this error, and 
part of it's framework checks that the buffer is fully contiguous in 
memory rather than doing scatter-gather. The function 
"vb2_dc_get_contiguous_size(...)" is what finds the full contiguous area 
of the buffer and reports back internally how much is available in a 
row.  Would videobuf2-dma-sg have been a better choice here?  I tried a 
naive conversion to that (that is, I'm sure I messed something up), but 
it yielded the kernel spewing messages about "Address Hole seen by CAM" 
from the omap_l3_smx driver.

- Tim

