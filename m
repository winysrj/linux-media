Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33708 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755936AbeFOMzV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 08:55:21 -0400
Message-ID: <49fab433eb864640f512da31729a68fb304c6105.camel@collabora.com>
Subject: Re: [RFC 0/2] Memory-to-memory media controller topology
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com
Date: Fri, 15 Jun 2018 09:53:43 -0300
In-Reply-To: <bc662417-470a-0539-afc1-a108ee90646d@xs4all.nl>
References: <20180612104827.11565-1-ezequiel@collabora.com>
         <bc662417-470a-0539-afc1-a108ee90646d@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-06-15 at 10:59 +0200, Hans Verkuil wrote:
> On 12/06/18 12:48, Ezequiel Garcia wrote:
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
> > 
> > The first commit introduces a register/unregister API,
> > that creates/destroys all the entities and pads needed,
> > and links them.
> > 
> > The second commit uses this API to support the vim2m driver.
> > 
> > Notes
> > -----
> > 
> > * A new device node type is introduced VFL_TYPE_MEM2MEM,
> >   this is mostly done so the video4linux core doesn't
> >   try to register other media controller entities.
> 
> There is no need for this. You can check if vfl_dir == VFL_DIR_M2M
> instead. I'd rather not add a new VFL_TYPE.
> 

OK, sounds good.

Thanks,
Eze
