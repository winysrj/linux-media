Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33690 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbcLEWdP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2016 17:33:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 3/3] uvcvideo: add a metadata device node
Date: Tue, 06 Dec 2016 00:25:35 +0200
Message-ID: <1934036.5jNzJsjeMl@avalon>
In-Reply-To: <Pine.LNX.4.64.1612052312480.7221@axis700.grange>
References: <Pine.LNX.4.64.1606241312130.23461@axis700.grange> <1591074.dEgMGVxATZ@avalon> <Pine.LNX.4.64.1612052312480.7221@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 05 Dec 2016 23:13:53 Guennadi Liakhovetski wrote:
> Just one question:
> 
> On Tue, 6 Dec 2016, Laurent Pinchart wrote:
> >>>> +	/*
> >>>> +	 * Register a metadata node. TODO: shall this only be enabled
> >>>> for some
> >>>> +	 * cameras?
> >>>> +	 */
> >>>> +	if (!(dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT))
> >>>> +		uvc_meta_register(stream);
> >>>> +
> >>> 
> >>> I think so, only for the cameras that can produce metadata.
> >> 
> >> Every UVC camera produces metadata, but most cameras only have standard
> >> fields there. Whether we should stream standard header fields from the
> >> metadata node will be discussed later. If we do decide to stream
> >> standard header fields, then every USB camera gets metadata nodes. If we
> >> decide not to include standard fields, how do we know whether the camera
> >> has any private fields in headers without streaming from it? Do you want
> >> a quirk for such cameras?
> > 
> > Unless they can be detected in a standard way that's probably the best
> > solution. Please remember that the UVC specification doesn't allow vendors
> > to extend headers in a vendor-specific way.
> 
> Does it not? Where is that specified? I didn't find that anywhere.

It's the other way around, it document a standard way to extend the payload 
header. Any option you pick risks being incompatible with future revisions of 
the specification. For instance the payload header's bmHeaderInfo field can be 
extended through the use of the EOF bit, but a future version of the 
specification could also extend it, in a way that would make a vendor-specific 
extension be mistaken for the standard extension.

Now, you could add data after the standard payload without touching the 
bmHeaderInfo field, but I'm still worried it could be broken by future 
versions of the specification.

-- 
Regards,

Laurent Pinchart

