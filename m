Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:47743 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751875AbeF2HGv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 03:06:51 -0400
Subject: Re: [PATCH v3 0/2] Memory-to-memory media controller topology
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
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <eae4a73a-0410-623c-bbfc-5e03f20bd54b@xs4all.nl>
Date: Fri, 29 Jun 2018 09:06:46 +0200
MIME-Version: 1.0
In-Reply-To: <92f17b984e2b140c8dbc060a3d171d7c55dbaf9d.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2018 09:29 PM, Ezequiel Garcia wrote:
> Hi Hans,
> 
> On Thu, 2018-06-28 at 11:19 +0200, Hans Verkuil wrote:
>> On 06/27/18 22:35, Ezequiel Garcia wrote:
>>> As discussed on IRC, memory-to-memory need to be modeled
>>> properly in order to be supported by the media controller
>>> framework, and thus to support the Request API.
>>>
>>> First commit introduces a register/unregister API,
>>> that creates/destroys all the entities and pads needed,
>>> and links them.
>>>
>>> The second commit uses this API to support the vim2m driver.
>>>
>>> The series applies cleanly on v4.18-rc1.
>>>
>>> Topology (media-ctl -p output)
>>> ==============================
>>>
>>> media-ctl -p
>>> Media controller API version 4.17.0
>>>
>>> Media device information
>>> ------------------------
>>> driver          vim2m
>>> model           vim2m
>>> serial          
>>> bus info        
>>> hw revision     0x0
>>> driver version  4.17.0
>>>
>>> Device topology
>>> - entity 1: source (1 pad, 1 link)
>>>             type Node subtype V4L flags 0
>>> 	pad0: Source
>>> 		-> "proc":1 [ENABLED,IMMUTABLE]
>>>
>>> - entity 3: proc (2 pads, 2 links)
>>>             type Node subtype Unknown flags 0
>>> 	pad0: Sink
>>> 		-> "sink":0 [ENABLED,IMMUTABLE]
>>> 	pad1: Source
>>> 		<- "source":0 [ENABLED,IMMUTABLE]
>>>
>>> - entity 6: sink (1 pad, 1 link)
>>>             type Node subtype V4L flags 0
>>> 	pad0: Sink
>>> 		<- "proc":0 [ENABLED,IMMUTABLE]
>>>
>>> Compliance output
>>> =================
>>>
>>> v4l2-compliance -m /dev/media0 -v 
>>> v4l2-compliance SHA: e2038ec6451293787b929338c2a671c732b8693d, 64
>>> bits
>>
>> This is an old version of v4l2-compliance. Can you update it to the
>> latest
>> version and run this again?
>>
> 
> With the two v4l-utils patches that I just sent:
> 
> https://patchwork.linuxtv.org/patch/50654/
> https://patchwork.linuxtv.org/patch/50655/
> 
> The compliance output looks OK, I think:
> 
> root@(none):/# v4l2-compliance -m 0 -v
> v4l2-compliance SHA: 248491682a2919a1bd421f87b33c14125b9fc1f5, 64 bits
> 
> Compliance test for device /dev/media0:
> 
> Media Driver Info:
> 	Driver name      : vim2m
> 	Model            : vim2m
> 	Serial           : 
> 	Bus info         : 
> 	Media version    : 4.18.0
> 	Hardware revision: 0x00000000 (0)
> 	Driver version   : 4.18.0
> 
> Required ioctls:
> 	test MEDIA_IOC_DEVICE_INFO: OK
> 
> Allow for multiple opens:
> 	test second /dev/media0 open: OK
> 	test MEDIA_IOC_DEVICE_INFO: OK
> 	test for unlimited opens: OK
> 
> Media Controller ioctls:
> 		Entity: 0x00000001 (Name: 'source', Function: V4L2 I/O)
> 		Entity: 0x00000003 (Name: 'proc', Function: Video
> Scaler)
> 		Entity: 0x00000006 (Name: 'sink', Function: V4L2 I/O)
> 		Interface: 0x0300000c (Type: V4L Video, DevPath:
> /dev/video2)
> 		Pad: 0x01000002 (source, Source)
> 		Pad: 0x01000004 (proc, Sink)
> 		Pad: 0x01000005 (proc, Source)
> 		Pad: 0x01000007 (sink, Sink)
> 		Link: 0x02000008 (source -> proc)
> 		Link: 0x0200000a (proc -> sink)
> 		Link: 0x0200000d (source to interface /dev/video2)
> 		Link: 0x0200000e (sink to interface /dev/video2)
> 	test MEDIA_IOC_G_TOPOLOGY: OK
> 	Entities: 3 Interfaces: 1 Pads: 4 Links: 4
> 		Entity: 0x00000001 (Name: 'source', Type: V4L2 I/O)
> 		Entity: 0x00000003 (Name: 'proc', Type: Unknown legacy
> device node type (0001ffff))
> 		Entity: 0x00000006 (Name: 'sink', Type: V4L2 I/O)
> 		Entity Links: 0x00000001 (Name: 'source')
> 		Entity Links: 0x00000003 (Name: 'proc')
> 		Entity Links: 0x00000006 (Name: 'sink')
> 	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
> 	test MEDIA_IOC_SETUP_LINK: OK
> 
> ---------------------------------------------------------------------
> -----------
> Compliance test for device /dev/video2:
> 
> Driver Info:
> 	Driver name      : vim2m
> 	Card type        : vim2m
> 	Bus info         : platform:vim2m
> 	Driver version   : 4.18.0
> 	Capabilities     : 0x84208000
> 		Video Memory-to-Memory
> 		Streaming
> 		Extended Pix Format
> 		Device Capabilities
> 	Device Caps      : 0x04208000
> 		Video Memory-to-Memory
> 		Streaming
> 		Extended Pix Format
> Media Driver Info:
> 	Driver name      : vim2m
> 	Model            : vim2m
> 	Serial           : 
> 	Bus info         : 
> 	Media version    : 4.18.0
> 	Hardware revision: 0x00000000 (0)
> 	Driver version   : 4.18.0
> Interface Info:
> 	ID               : 0x0300000c
> 	Type             : V4L Video
> Entity Info:
> 	ID               : 0x00000001 (1)
> 	Name             : source
> 	Function         : V4L2 I/O
> 	Pad 0x01000002   : Source
> 	  Link 0x02000008: to remote pad 0x1000005 of entity 'proc':
> Data, Enabled, Immutable

Hmm, this doesn't show the sink entity associated with this interface.

It's a v4l2-compliance bug, but I need to think a bit more on how to
fix this.

Regards,

	Hans
