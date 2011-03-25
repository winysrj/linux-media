Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:50971 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab1CYKQG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 06:16:06 -0400
Message-ID: <4D8C6B62.90600@matrix-vision.de>
Date: Fri, 25 Mar 2011 11:16:02 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: Re: [PATCH] omap3isp: implement ENUM_FMT
References: <4D889C61.905@matrix-vision.de> <201103240842.43024.hverkuil@xs4all.nl> <4D8AFD20.4000705@maxwell.research.nokia.com> <201103241136.54032.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103241136.54032.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 03/24/2011 11:36 AM, Laurent Pinchart wrote:
> Hi,
> 
[snip]
> 
> Padding at end of line can be configured through S_FMT. Other than that, all 
> other options (width, height, pixelcode) are fixed for a given mbus format 
> *for the ISP driver*. Other drivers might support different pixel codes for a 
> given mbus code (with different padding and/or endianness).
> 
> Application either need to be aware of the media controller framework, in 
> which case they will know how to deal with mbus formats and pixel formats, or 
> need to be run after an external application takes care of pipeline 
> configuration. In the second case I suppose it's reasonable to assume that no 
> application will touch the pipeline while the pure V4L2 runs. In that case I 
> think your implementation of ENUM_FMT makes sense.
> 

It is this second case which I am currently using, and why I submitted
this patch.  I think supporting ENUM_FMT in some form at /dev/videoX
makes sense unless this second case is deemed obsolete and unsupported.
 But then that seems like a bigger break from V4L.

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
