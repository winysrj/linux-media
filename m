Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52966 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0HGOyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Aug 2010 10:54:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC] V4L2: add a generic function to find the nearest discrete format
Date: Sat, 7 Aug 2010 16:55:12 +0200
Cc: lawrence rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1008051959330.26127@axis700.grange> <1281174446.1363.104.camel@gagarin> <Pine.LNX.4.64.1008071512470.3798@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1008071512470.3798@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008071655.13146.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Saturday 07 August 2010 15:20:58 Guennadi Liakhovetski wrote:
> On Sat, 7 Aug 2010, lawrence rust wrote:

[snip]

> > A mean squared error metric such as hypot() could be better but requires
> > FP.  An integer only version wouldn't be too difficult.
> 
> No FP in the kernel. And I don't think this simple task justifies any
> numerical acrobatic. But we can just compare x^2 + y^2 - without an sqrt.
> Is it worth it?

What about comparing areas ? The uvcvideo driver does (rw and rh are the 
request width and request height, format is a structure containing an array of 
supported sizes)

        /* Find the closest image size. The distance between image sizes is
         * the size in pixels of the non-overlapping regions between the
         * requested size and the frame-specified size.
         */
        rw = fmt->fmt.pix.width;
        rh = fmt->fmt.pix.height;
        maxd = (unsigned int)-1;

        for (i = 0; i < format->nframes; ++i) {
                __u16 w = format->frame[i].wWidth;
                __u16 h = format->frame[i].wHeight;

                d = min(w, rw) * min(h, rh);
                d = w*h + rw*rh - 2*d;
                if (d < maxd) {
                        maxd = d;
                        frame = &format->frame[i];
                }

                if (maxd == 0)
                        break;
        }

-- 
Regards,

Laurent Pinchart
