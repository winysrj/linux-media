Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50658 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884Ab0BZOlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2010 09:41:23 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <p.osciak@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 26 Feb 2010 08:41:11 -0600
Subject: RE: More videobuf and streaming I/O questions
Message-ID: <A69FA2915331DC488A831521EAE36FE4016A3895CE@dlee06.ent.ti.com>
References: <201002201500.21118.hverkuil@xs4all.nl>
 <4B87B8E6.6040608@infradead.org>
 <55a3e0ce1002260505s798e3945ueb1e929dd87e6ea6@mail.gmail.com>
 <201002261529.08099.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201002261529.08099.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>This being said, VIDIOC_S_INPUT was designed to switch analog sources. I'm
>not
>sure it would be the best would to multiplex streams from two digital
>sensors
>for instance. Even for analog signals, using the ioctl from userspace
>usually
>results in at least one corrupt frame if you don't synchronize the
>switching
>to the analog signals, which requires hardware support.

>
>Can you give us more details about the use case you're thinking about ?


This is for supporting interfacing of TVP5148 to DM365 that can mux from two sources. There is an implementation of this in our internal release. Just exploring how this can be ported to upstream. Not done any work yet on this
from my side.

>
>> Does it require 2 buffers per input because every frame period, you have
>> multiple frames to queue from the different inputs?
>
>In this case there's a single video stream, so I don't think it would
>require
>2 buffers per input.
>
>> Usually a minimum of 3 buffers are typically required in a SoC case to do
>> streaming. Could you share the details if possible?
>
>--
>Regards,
>
>Laurent Pinchart
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
