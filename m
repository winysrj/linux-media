Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab0DCBLk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 21:11:40 -0400
Message-ID: <4BB695C1.3080208@redhat.com>
Date: Fri, 02 Apr 2010 22:11:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR protocols
 at the IR core
References: <cover.1270142346.git.mchehab@redhat.com>	 <20100401145632.7b1b98d5@pedra>	 <1270251567.3027.55.camel@palomino.walls.org> <1270256387.3027.84.camel@palomino.walls.org>
In-Reply-To: <1270256387.3027.84.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Fri, 2010-04-02 at 19:39 -0400, Andy Walls wrote:
>> On Thu, 2010-04-01 at 14:56 -0300, Mauro Carvalho Chehab wrote:
> 
>>> +enum raw_event_type {
>>> +	IR_SPACE	= (1 << 0),
>>> +	IR_PULSE	= (1 << 1),
>>> +	IR_START_EVENT	= (1 << 2),
>>> +	IR_STOP_EVENT	= (1 << 3),
>>> +};
>>> +
>> Why are these events encoded as bit flags?  Shouldn't they all be
>> orthogonal?
>   ^^^^^^^^^^
> Argh, wrong word.

Why is it wrong? It seems appropriate to me.
> 
> Shouldn't they all be mutually exclusive?

space x pulse are mutually exclusive, and start x stop are also
mutually exclusive, but you may have several possible combinations
for an event. The hole set of possibilities are:

IR_SPACE
IR_PULSE
IR_SPACE | IR_START_EVENT
IR_SPACE | IR_STOP_EVENT
IR_PULSE | IR_START_EVENT
IR_PULSE | IR_STOP_EVENT

With bit flags, it is possible to cover all the above combinations.

In a matter of fact, the driver is currently not using the stop events.

-- 

Cheers,
Mauro
