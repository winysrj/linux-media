Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58484 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbcLFKqk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:46:40 -0500
Date: Tue, 6 Dec 2016 11:39:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 3/3] uvcvideo: add a metadata device node
In-Reply-To: <1934036.5jNzJsjeMl@avalon>
Message-ID: <Pine.LNX.4.64.1612061127550.17179@axis700.grange>
References: <Pine.LNX.4.64.1606241312130.23461@axis700.grange>
 <1591074.dEgMGVxATZ@avalon> <Pine.LNX.4.64.1612052312480.7221@axis700.grange>
 <1934036.5jNzJsjeMl@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, 6 Dec 2016, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Monday 05 Dec 2016 23:13:53 Guennadi Liakhovetski wrote:
> > Just one question:
> > 
> > On Tue, 6 Dec 2016, Laurent Pinchart wrote:
> > >>>> +	/*
> > >>>> +	 * Register a metadata node. TODO: shall this only be enabled
> > >>>> for some
> > >>>> +	 * cameras?
> > >>>> +	 */
> > >>>> +	if (!(dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT))
> > >>>> +		uvc_meta_register(stream);
> > >>>> +
> > >>> 
> > >>> I think so, only for the cameras that can produce metadata.
> > >> 
> > >> Every UVC camera produces metadata, but most cameras only have standard
> > >> fields there. Whether we should stream standard header fields from the
> > >> metadata node will be discussed later. If we do decide to stream
> > >> standard header fields, then every USB camera gets metadata nodes. If we
> > >> decide not to include standard fields, how do we know whether the camera
> > >> has any private fields in headers without streaming from it? Do you want
> > >> a quirk for such cameras?
> > > 
> > > Unless they can be detected in a standard way that's probably the best
> > > solution. Please remember that the UVC specification doesn't allow vendors
> > > to extend headers in a vendor-specific way.
> > 
> > Does it not? Where is that specified? I didn't find that anywhere.
> 
> It's the other way around, it document a standard way to extend the payload 
> header. Any option you pick risks being incompatible with future revisions of 
> the specification. For instance the payload header's bmHeaderInfo field can be 
> extended through the use of the EOF bit, but a future version of the 
> specification could also extend it, in a way that would make a vendor-specific 
> extension be mistaken for the standard extension.
> 
> Now, you could add data after the standard payload without touching the 
> bmHeaderInfo field, but I'm still worried it could be broken by future 
> versions of the specification.

Exactly - using "free" space in payload headers is not a part of the spec, 
but is also not prohibited by it. As for future versions - cameras specify 
which version of the spec they implement, and existing versions cannot 
change. If a camera decides to upgrade and in future UVC versions there 
won't be enough space left for the private data, only then the camera 
manufacturer will have a problem, that they will have to solve. The 
user-space software will have to know, that UVC 5.1 metadata has a 
different format, than UVC 1.5, that's true.

Thanks
Guennadi
