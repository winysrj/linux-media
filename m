Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:45588 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2GZOTW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 10:19:22 -0400
Message-ID: <50115299.6000201@matrix-vision.de>
Date: Thu, 26 Jul 2012 16:22:17 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] omap3-isp G_FMT & ENUM_FMT
References: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de> <4048543.KhXI4ynbrF@avalon>
In-Reply-To: <4048543.KhXI4ynbrF@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the reply.

On 07/26/2012 04:05 PM, Laurent Pinchart wrote:
> Hi Michael,
>
> On Thursday 26 July 2012 13:59:54 Michael Jones wrote:
>> Hello,
>>
>> I would like to (re)submit a couple of patches to support V4L2 behavior at
>> the V4L2 device nodes of the omap3-isp driver, but I'm guessing they require
>> some discussion first.
>
> Indeed.
>
> The main reason why the OMAP3 ISP driver implements G_FMT/S_FMT as it does
> today is to hack around a restriction in the V4L2 API. We needed a way to
> preallocate and possibly prequeue buffers for snapshot, which wasn't possible
> in a standard-compliant way back then.
>
> The situation has since changed, and we now have the VIDIOC_CREATE_BUFS and
> VIDIOC_PREPARE_BUF ioctls. My plan is to
>
> - port the OMAP3 ISP driver to videobuf2
> - implement support for CREATE_BUFS and PREPARE_BUF
> - fix the G_FMT/S_FMT/ENUM_FMT behaviour

What will the G_FMT/S_FMT/ENUM_FMT behavior be then?  Can you contrast 
it with the behavior of my patches?  If the behavior will be the same 
for user space, and your proposed changes won't be in very soon, can we 
use my patches until you make your changes?

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
