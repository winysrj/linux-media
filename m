Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49744 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753987AbeFUUEe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 16:04:34 -0400
Message-ID: <53421c67f8a760d19e801a85b00d1cb71cab1bc9.camel@collabora.com>
Subject: Re: [PATCH 0/2] Memory-to-memory media controller topology
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com
Date: Thu, 21 Jun 2018 17:04:23 -0300
In-Reply-To: <0a39c4b5-792f-4fa3-182b-bf3abeb24ac6@xs4all.nl>
References: <20180620194406.21753-1-ezequiel@collabora.com>
         <0a39c4b5-792f-4fa3-182b-bf3abeb24ac6@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-06-21 at 14:07 +0200, Hans Verkuil wrote:
> On 06/20/18 21:44, Ezequiel Garcia wrote:
> > As discussed on IRC, memory-to-memory need to be modeled
> > properly in order to be supported by the media controller
> > framework, and thus to support the Request API.
> > 
> > The topology looks like this:
> > 
> > Device topology
> > - entity 1: source (1 pad, 1 link)
> >             type Node subtype V4L flags 0
> > 	pad0: Source
> > 		<- "proc":0 [ENABLED,IMMUTABLE]
> > 
> > - entity 3: proc (2 pads, 2 links)
> >             type Node subtype Unknown flags 0
> > 	pad0: Source
> > 		-> "source":0 [ENABLED,IMMUTABLE]
> > 	pad1: Sink
> > 		<- "sink":0 [ENABLED,IMMUTABLE]
> > 
> > - entity 6: sink (1 pad, 1 link)
> >             type Node subtype V4L flags 0
> > 	pad0: Sink
> > 		-> "proc":1 [ENABLED,IMMUTABLE]
> > 
> > The first commit introduces a register/unregister API,
> > that creates/destroys all the entities and pads needed,
> > and links them.
> 
> Can you add the output of v4l2-compliance -m /dev/mediaX here as
> well?
> 

Let me post a new version of the patch, with some minor changes,
including the output of the v4l2-compliance tool.

Thanks,
Eze
