Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:50606 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932581AbeF1JTK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 05:19:10 -0400
Subject: Re: [PATCH v3 0/2] Memory-to-memory media controller topology
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com
References: <20180627203545.21728-1-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <db546539-99c4-1e9a-8846-d367bb44635c@xs4all.nl>
Date: Thu, 28 Jun 2018 11:19:05 +0200
MIME-Version: 1.0
In-Reply-To: <20180627203545.21728-1-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/27/18 22:35, Ezequiel Garcia wrote:
> As discussed on IRC, memory-to-memory need to be modeled
> properly in order to be supported by the media controller
> framework, and thus to support the Request API.
> 
> First commit introduces a register/unregister API,
> that creates/destroys all the entities and pads needed,
> and links them.
> 
> The second commit uses this API to support the vim2m driver.
> 
> The series applies cleanly on v4.18-rc1.
> 
> Topology (media-ctl -p output)
> ==============================
> 
> media-ctl -p
> Media controller API version 4.17.0
> 
> Media device information
> ------------------------
> driver          vim2m
> model           vim2m
> serial          
> bus info        
> hw revision     0x0
> driver version  4.17.0
> 
> Device topology
> - entity 1: source (1 pad, 1 link)
>             type Node subtype V4L flags 0
> 	pad0: Source
> 		-> "proc":1 [ENABLED,IMMUTABLE]
> 
> - entity 3: proc (2 pads, 2 links)
>             type Node subtype Unknown flags 0
> 	pad0: Sink
> 		-> "sink":0 [ENABLED,IMMUTABLE]
> 	pad1: Source
> 		<- "source":0 [ENABLED,IMMUTABLE]
> 
> - entity 6: sink (1 pad, 1 link)
>             type Node subtype V4L flags 0
> 	pad0: Sink
> 		<- "proc":0 [ENABLED,IMMUTABLE]
> 
> Compliance output
> =================
> 
> v4l2-compliance -m /dev/media0 -v 
> v4l2-compliance SHA: e2038ec6451293787b929338c2a671c732b8693d, 64 bits

This is an old version of v4l2-compliance. Can you update it to the latest
version and run this again?

Thank you!

	Hans
