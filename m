Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34134 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbcK2SIl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 13:08:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: 3A / auto-exposure Region of Interest setting
Date: Tue, 29 Nov 2016 20:08:54 +0200
Message-ID: <3544629.8KCDMPoHBf@avalon>
In-Reply-To: <Pine.LNX.4.64.1611281449520.6665@axis700.grange>
References: <Pine.LNX.4.64.1611281449520.6665@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

(CC'ing Sakari)

On Monday 28 Nov 2016 15:18:03 Guennadi Liakhovetski wrote:
> Hi,
> 
> Has anyone already considered supporting 3A (e.g. auto-exposure) Region of
> Interest selection? In UVC this is the "Digital Region of Interest (ROI)
> Control." Android defines ANDROID_CONTROL_AE_REGIONS,
> ANDROID_CONTROL_AWB_REGIONS, ANDROID_CONTROL_AF_REGIONS. The UVC control
> defines just a single rectangle for all (supported) 3A functions. That
> could be implemented, defining a new selection target. However, Android
> allows arbitrary numbers of ROI rectangles with associated weights. Any
> ideas?

Selections could be used, possibly with an update to the API to allow indexing 
selections for a given target. We'd be missing weights though. Another option 
would be to use compound controls.

-- 
Regards,

Laurent Pinchart

