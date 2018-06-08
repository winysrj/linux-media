Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58372 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbeFHMdz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 08:33:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Torleiv Sundre <torleiv@huddly.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Bug: media device controller node not removed when uvc device is unplugged
Date: Fri, 08 Jun 2018 15:34:10 +0300
Message-ID: <1907945.zi1qWH88q7@avalon>
In-Reply-To: <fc69c83d-fbd6-d955-2e07-3960c052cb49@huddly.com>
References: <fc69c83d-fbd6-d955-2e07-3960c052cb49@huddly.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Torleiv,

On Thursday, 7 June 2018 15:07:24 EEST Torleiv Sundre wrote:
> Hi,
> 
> Every time I plug in a UVC camera, a media controller node is created at
> /dev/media<N>.
> 
> In Ubuntu 17.10, running kernel 4.13.0-43, the media controller device
> node is removed when the UVC camera is unplugged.
> 
> In Ubuntu 18.10, running kernel 4.15.0-22, the media controller device
> node is not removed. For every time I plug the device, a new device node
> with incremented minor number is created, leaving me with a growing list
> of media controller device nodes. If I repeat for long enough, I get the
> following error:
> "media: could not get a free minor"
> I also tried building a kernel from mainline, with the same result.

Thank you for the report. I'm sorry about that :-S It's a known issue, and a 
fix is already present in Linus' tree, on its way to v4.18-rc1.

commit f9ffcb0a21e1fa8e64d09ed613d884e054ae8191
Author: Philipp Zabel <philipp.zabel@gmail.com>
Date:   Mon May 21 06:24:58 2018 -0400

    media: uvcvideo: Fix driver reference counting

It should then get backported to stable releases.

If you have time, could you try to apply that commit on top of mainline and 
see if it fixes the problem for you ?

> I'm running on x86_64.

-- 
Regards,

Laurent Pinchart
