Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49291 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbcLEWOF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 17:14:05 -0500
Date: Mon, 5 Dec 2016 23:13:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 3/3] uvcvideo: add a metadata device node
In-Reply-To: <1591074.dEgMGVxATZ@avalon>
Message-ID: <Pine.LNX.4.64.1612052312480.7221@axis700.grange>
References: <Pine.LNX.4.64.1606241312130.23461@axis700.grange>
 <2361420.98YnhAaLcS@avalon> <Pine.LNX.4.64.1612051617340.7221@axis700.grange>
 <1591074.dEgMGVxATZ@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just one question:

On Tue, 6 Dec 2016, Laurent Pinchart wrote:

> > >> +	/*
> > >> +	 * Register a metadata node. TODO: shall this only be enabled for some
> > >> +	 * cameras?
> > >> +	 */
> > >> +	if (!(dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT))
> > >> +		uvc_meta_register(stream);
> > >> +
> > > 
> > > I think so, only for the cameras that can produce metadata.
> > 
> > Every UVC camera produces metadata, but most cameras only have standard
> > fields there. Whether we should stream standard header fields from the
> > metadata node will be discussed later. If we do decide to stream standard
> > header fields, then every USB camera gets metadata nodes. If we decide not
> > to include standard fields, how do we know whether the camera has any
> > private fields in headers without streaming from it? Do you want a quirk
> > for such cameras?
> 
> Unless they can be detected in a standard way that's probably the best 
> solution. Please remember that the UVC specification doesn't allow vendors to 
> extend headers in a vendor-specific way.

Does it not? Where is that specified? I didn't find that anywhere.

Thanks
Guennadi
