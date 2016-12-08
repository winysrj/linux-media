Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45245 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbcLHNjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 08:39:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 3/3] uvcvideo: add a metadata device node
Date: Thu, 08 Dec 2016 15:39:57 +0200
Message-ID: <15282460.lOulU7IMKd@avalon>
In-Reply-To: <Pine.LNX.4.64.1612081432320.4140@axis700.grange>
References: <Pine.LNX.4.64.1606241312130.23461@axis700.grange> <6827808.RfcVLAN17o@avalon> <Pine.LNX.4.64.1612081432320.4140@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 08 Dec 2016 14:34:46 Guennadi Liakhovetski wrote:
> On Tue, 6 Dec 2016, Laurent Pinchart wrote:
> > On Tuesday 06 Dec 2016 11:39:22 Guennadi Liakhovetski wrote:
> >> On Tue, 6 Dec 2016, Laurent Pinchart wrote:
> >>> On Monday 05 Dec 2016 23:13:53 Guennadi Liakhovetski wrote:
> >>>> On Tue, 6 Dec 2016, Laurent Pinchart wrote:
> >>>>>>>> +	/*
> >>>>>>>> +	 * Register a metadata node. TODO: shall this only be enabled
> >>>>>>>> for some
> >>>>>>>> +	 * cameras?
> >>>>>>>> +	 */
> >>>>>>>> +	if (!(dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT))
> >>>>>>>> +		uvc_meta_register(stream);
> >>>>>>>> +
> >>>>>>> 
> >>>>>>> I think so, only for the cameras that can produce metadata.
> >>>>>> 
> >>>>>> Every UVC camera produces metadata, but most cameras only have
> >>>>>> standard fields there. Whether we should stream standard header
> >>>>>> fields from the metadata node will be discussed later. If we do
> >>>>>> decide to stream standard header fields, then every USB camera gets
> >>>>>> metadata nodes. If we decide not to include standard fields, how do
> >>>>>> we know whether the camera has any private fields in headers
> >>>>>> without streaming from it? Do you want a quirk for such cameras?
> >>>>> 
> >>>>> Unless they can be detected in a standard way that's probably the
> >>>>> best solution.
> 
> How about a module parameter with a list of VID:PID pairs?

I'd like something that works out of the box for end-users, at least in most 
cases. There's already a way to set quirks through a module parameter, and I 
think I'd accept a patch extending that it make it VID:PID dependent. That's 
an acceptable solution for testing, but should not be considered as the way to 
go for production.

> The problem with the quirk is, that as vendors produce multiple cameras with
> different PIDs they will have to push patches for each such camera.

How many such devices do you expect ?

-- 
Regards,

Laurent Pinchart

