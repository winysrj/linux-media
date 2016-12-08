Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63736 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753198AbcLHNeo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 08:34:44 -0500
Date: Thu, 8 Dec 2016 14:34:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 3/3] uvcvideo: add a metadata device node
In-Reply-To: <6827808.RfcVLAN17o@avalon>
Message-ID: <Pine.LNX.4.64.1612081432320.4140@axis700.grange>
References: <Pine.LNX.4.64.1606241312130.23461@axis700.grange>
 <1934036.5jNzJsjeMl@avalon> <Pine.LNX.4.64.1612061127550.17179@axis700.grange>
 <6827808.RfcVLAN17o@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

One more question:

On Tue, 6 Dec 2016, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Tuesday 06 Dec 2016 11:39:22 Guennadi Liakhovetski wrote:
> > On Tue, 6 Dec 2016, Laurent Pinchart wrote:
> > > On Monday 05 Dec 2016 23:13:53 Guennadi Liakhovetski wrote:
> > >> On Tue, 6 Dec 2016, Laurent Pinchart wrote:
> > >>>>>> +	/*
> > >>>>>> +	 * Register a metadata node. TODO: shall this only be enabled
> > >>>>>> for some
> > >>>>>> +	 * cameras?
> > >>>>>> +	 */
> > >>>>>> +	if (!(dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT))
> > >>>>>> +		uvc_meta_register(stream);
> > >>>>>> +
> > >>>>> 
> > >>>>> I think so, only for the cameras that can produce metadata.
> > >>>> 
> > >>>> Every UVC camera produces metadata, but most cameras only have standard
> > >>>> fields there. Whether we should stream standard header fields from the
> > >>>> metadata node will be discussed later. If we do decide to stream
> > >>>> standard header fields, then every USB camera gets metadata nodes. If
> > >>>> we decide not to include standard fields, how do we know whether the
> > >>>> camera has any private fields in headers without streaming from it? Do
> > >>>> you want a quirk for such cameras?
> > >>> 
> > >>> Unless they can be detected in a standard way that's probably the best
> > >>> solution.

How about a module parameter with a list of VID:PID pairs? The problem 
with the quirk is, that as vendors produce multiple cameras with different 
PIDs they will have to push patches for each such camera.

Thanks
Guennadi
