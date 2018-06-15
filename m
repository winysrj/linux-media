Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:60146 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936076AbeFOI7K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 04:59:10 -0400
Subject: Re: [RFC 0/2] Memory-to-memory media controller topology
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com
References: <20180612104827.11565-1-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bc662417-470a-0539-afc1-a108ee90646d@xs4all.nl>
Date: Fri, 15 Jun 2018 10:59:08 +0200
MIME-Version: 1.0
In-Reply-To: <20180612104827.11565-1-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/18 12:48, Ezequiel Garcia wrote:
> As discussed on IRC, memory-to-memory need to be modeled
> properly in order to be supported by the media controller
> framework, and thus to support the Request API.
> 
> This RFC is a first draft on the memory-to-memory
> media controller topology.
> 
> The topology looks like this:
> 
> Device topology
> - entity 1: input (1 pad, 1 link)
>             type Node subtype Unknown flags 0
> 	pad0: Source
> 		-> "proc":1 [ENABLED,IMMUTABLE]
> 
> - entity 3: proc (2 pads, 2 links)
>             type Node subtype Unknown flags 0
> 	pad0: Source
> 		-> "output":0 [ENABLED,IMMUTABLE]
> 	pad1: Sink
> 		<- "input":0 [ENABLED,IMMUTABLE]
> 
> - entity 6: output (1 pad, 1 link)
>             type Node subtype Unknown flags 0
> 	pad0: Sink
> 		<- "proc":0 [ENABLED,IMMUTABLE]
> 
> The first commit introduces a register/unregister API,
> that creates/destroys all the entities and pads needed,
> and links them.
> 
> The second commit uses this API to support the vim2m driver.
> 
> Notes
> -----
> 
> * A new device node type is introduced VFL_TYPE_MEM2MEM,
>   this is mostly done so the video4linux core doesn't
>   try to register other media controller entities.

There is no need for this. You can check if vfl_dir == VFL_DIR_M2M
instead. I'd rather not add a new VFL_TYPE.

Regards,

	Hans

> 
> * Also, a new media entity type is introduced. Memory-to-memory
>   devices have a multi-entity description and so can't
>   be simply embedded in other structs, or cast from other structs.
> 
> Ezequiel Garcia (1):
>   media: add helpers for memory-to-memory media controller
> 
> Hans Verkuil (1):
>   vim2m: add media device
> 
>  drivers/media/platform/vim2m.c         |  41 ++++++-
>  drivers/media/v4l2-core/v4l2-dev.c     |  23 ++--
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 157 +++++++++++++++++++++++++
>  include/media/media-entity.h           |   4 +
>  include/media/v4l2-dev.h               |   2 +
>  include/media/v4l2-mem2mem.h           |   5 +
>  include/uapi/linux/media.h             |   2 +
>  7 files changed, 222 insertions(+), 12 deletions(-)
> 
