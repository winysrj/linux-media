Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36206 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966117AbeFOUGA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 16:06:00 -0400
Message-ID: <d2d1d0938384a54bf1c268c83a2684c618bc4af9.camel@collabora.com>
Subject: Re: [RFC 0/2] Memory-to-memory media controller topology
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com
Date: Fri, 15 Jun 2018 17:05:52 -0300
In-Reply-To: <46417cb4adca9289841287c8590b0ce92059298f.camel@collabora.com>
References: <20180612104827.11565-1-ezequiel@collabora.com>
         <46417cb4adca9289841287c8590b0ce92059298f.camel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-06-12 at 10:42 -0400, Nicolas Dufresne wrote:
> Le mardi 12 juin 2018 à 07:48 -0300, Ezequiel Garcia a écrit :
> > As discussed on IRC, memory-to-memory need to be modeled
> > properly in order to be supported by the media controller
> > framework, and thus to support the Request API.
> > 
> > This RFC is a first draft on the memory-to-memory
> > media controller topology.
> > 
> > The topology looks like this:
> > 
> > Device topology
> > - entity 1: input (1 pad, 1 link)
> >             type Node subtype Unknown flags 0
> > 	pad0: Source
> > 		-> "proc":1 [ENABLED,IMMUTABLE]
> > 
> > - entity 3: proc (2 pads, 2 links)
> >             type Node subtype Unknown flags 0
> > 	pad0: Source
> > 		-> "output":0 [ENABLED,IMMUTABLE]
> > 	pad1: Sink
> > 		<- "input":0 [ENABLED,IMMUTABLE]
> > 
> > - entity 6: output (1 pad, 1 link)
> >             type Node subtype Unknown flags 0
> > 	pad0: Sink
> > 		<- "proc":0 [ENABLED,IMMUTABLE]
> 
> Will the end result have "device node name /dev/..." on both entity 1
> and 6 ? 

No. There is just one devnode /dev/videoX, which is accepts
both CAPTURE and OUTPUT directions.

> I got told that in the long run, one should be able to map a
> device (/dev/mediaN) to it's nodes (/dev/video*). In a way that if we
> keep going this way, all the media devices can be enumerated from
> media
> node rather then a mixed between media nodes and orphaned video
> nodes.
> 

Yes, that is the idea I think. For instance, for devices with
multiple audio and video channels, there is currently no
clean way to discover them and correlate e.g. video devices
to audio devices.

Not that this series help on that either :) 
