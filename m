Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54084 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933949AbeF2MrJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:47:09 -0400
Subject: Re: [PATCH v3 0/2] Memory-to-memory media controller topology
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com
References: <20180627203545.21728-1-ezequiel@collabora.com>
 <db546539-99c4-1e9a-8846-d367bb44635c@xs4all.nl>
 <92f17b984e2b140c8dbc060a3d171d7c55dbaf9d.camel@collabora.com>
 <eae4a73a-0410-623c-bbfc-5e03f20bd54b@xs4all.nl>
Message-ID: <60ecd30f-1286-8460-38da-1b291397a0d1@xs4all.nl>
Date: Fri, 29 Jun 2018 14:47:04 +0200
MIME-Version: 1.0
In-Reply-To: <eae4a73a-0410-623c-bbfc-5e03f20bd54b@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/29/18 09:06, Hans Verkuil wrote:
> On 06/28/2018 09:29 PM, Ezequiel Garcia wrote:

<snip>

>> Compliance test for device /dev/video2:
>>
>> Driver Info:
>> 	Driver name      : vim2m
>> 	Card type        : vim2m
>> 	Bus info         : platform:vim2m
>> 	Driver version   : 4.18.0
>> 	Capabilities     : 0x84208000
>> 		Video Memory-to-Memory
>> 		Streaming
>> 		Extended Pix Format
>> 		Device Capabilities
>> 	Device Caps      : 0x04208000
>> 		Video Memory-to-Memory
>> 		Streaming
>> 		Extended Pix Format
>> Media Driver Info:
>> 	Driver name      : vim2m
>> 	Model            : vim2m
>> 	Serial           : 
>> 	Bus info         : 
>> 	Media version    : 4.18.0
>> 	Hardware revision: 0x00000000 (0)
>> 	Driver version   : 4.18.0
>> Interface Info:
>> 	ID               : 0x0300000c
>> 	Type             : V4L Video
>> Entity Info:
>> 	ID               : 0x00000001 (1)
>> 	Name             : source
>> 	Function         : V4L2 I/O
>> 	Pad 0x01000002   : Source
>> 	  Link 0x02000008: to remote pad 0x1000005 of entity 'proc':
>> Data, Enabled, Immutable
> 
> Hmm, this doesn't show the sink entity associated with this interface.
> 
> It's a v4l2-compliance bug, but I need to think a bit more on how to
> fix this.

Some background: until now an interface was linked to one entity only.
But m2m devices now have two entities linked to the same interface.

So the v4l2-compliance code that outputs this text only sees one entity.
The code needs to be rewritten to be smarter about this.

Something for the (near) future.

Regards,

	Hans
