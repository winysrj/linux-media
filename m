Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4542 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZIYHN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2009 03:13:59 -0400
Received: from webmail.xs4all.nl (dovemail1.xs4all.nl [194.109.26.3])
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id n8P7Dwkq029362
	for <linux-media@vger.kernel.org>; Fri, 25 Sep 2009 09:14:02 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-ID: <40e7bbfbf781ac7bdda6757a1292fe45.squirrel@webmail.xs4all.nl>
Date: Fri, 25 Sep 2009 09:14:02 +0200
Subject: V4L-DVB Summit Day 2
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "v4l-dvb" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

A quick update on day 2 of the summit.

We started off with a discussion on the memory pool API. It was soon
obvious that we really should attempt to make this a global memory pool as
opposed to one pool per device. If it is global then we can do some really
fancy stuff that would be hard to do otherwise.

What also became clear quite soon is that a lot more research is needed in
how to allocate and keep track of the memory and how to handle caches etc.

We got some info from Samsung as well on how they solved this issue. We
will need to look at this in more detail. I will make two presentations
from Samsung available on my website later.

After discussing the memory pool API we continued with the Media Controller.

Some conclusions:

- Everyone likes that concept of the media controller.

- Nobody likes using sysfs for link enumeration and setting (sorry Mauro
:-) )

- We do need to introduce something like a group ID in the entity
information to group related entities together. The idea is that
application can use that ID to discover which video node is associated
with which audio node.

- In order to allow data to flow between two endpoints the dataformat
needs to be setup correctly. This needs to be set for both endpoints as
that is the most general solution. But in 99% if not all cases the
dataformat will be the same for both endpoints. So initially the API will
set the dataformat for both endpoints at the same time for ease of use.

- Currently the entity has a 'descr' field that contains what is
effectively tooltip-type information about the entity. This is better
handled as a string control of that entity.

- Rather than using the mc to select a 'target' subdev and pass ioctls on
to that, we decided that creating a node for each sub-device is better.
But only if there is anything to control for that sub-device.

- We agreed that the basic premise should be to keep the driver for a SoC
as simple as possible, and to move a lot of the intelligence in setting up
the SoC to SoC-specific userspace libraries. So the driver in the kernel
is responsible for programming the various sub-devices and buffer I/O,
while configuring the various sub-devices into a working pipeline is the
job of the userspace library. This prevents the kernel driver from
becoming a mess.

Obviously, nothing is final, but all of these points should appear in
future RFCs for further discussion on the mailinglists.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

