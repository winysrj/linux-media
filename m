Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40778 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932862AbeFUMHa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 08:07:30 -0400
Subject: Re: [PATCH 0/2] Memory-to-memory media controller topology
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com
References: <20180620194406.21753-1-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0a39c4b5-792f-4fa3-182b-bf3abeb24ac6@xs4all.nl>
Date: Thu, 21 Jun 2018 14:07:25 +0200
MIME-Version: 1.0
In-Reply-To: <20180620194406.21753-1-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/18 21:44, Ezequiel Garcia wrote:
> As discussed on IRC, memory-to-memory need to be modeled
> properly in order to be supported by the media controller
> framework, and thus to support the Request API.
> 
> The topology looks like this:
> 
> Device topology
> - entity 1: source (1 pad, 1 link)
>             type Node subtype V4L flags 0
> 	pad0: Source
> 		<- "proc":0 [ENABLED,IMMUTABLE]
> 
> - entity 3: proc (2 pads, 2 links)
>             type Node subtype Unknown flags 0
> 	pad0: Source
> 		-> "source":0 [ENABLED,IMMUTABLE]
> 	pad1: Sink
> 		<- "sink":0 [ENABLED,IMMUTABLE]
> 
> - entity 6: sink (1 pad, 1 link)
>             type Node subtype V4L flags 0
> 	pad0: Sink
> 		-> "proc":1 [ENABLED,IMMUTABLE]
> 
> The first commit introduces a register/unregister API,
> that creates/destroys all the entities and pads needed,
> and links them.

Can you add the output of v4l2-compliance -m /dev/mediaX here as well?

Thanks!

	Hans

> 
> The second commit uses this API to support the vim2m driver.
> 
> Ezequiel Garcia (1):
>   media: add helpers for memory-to-memory media controller
> 
> Hans Verkuil (1):
>   vim2m: add media device
> 
>  drivers/media/platform/vim2m.c         |  41 +++++-
>  drivers/media/v4l2-core/v4l2-dev.c     |  13 +-
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 176 +++++++++++++++++++++++++
>  include/media/v4l2-mem2mem.h           |   5 +
>  include/uapi/linux/media.h             |   3 +
>  5 files changed, 229 insertions(+), 9 deletions(-)
> 
