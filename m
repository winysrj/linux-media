Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4089 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1C3Kof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 06:44:35 -0400
Received: from tschai.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id p2UAiPMD027371
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 30 Mar 2011 12:44:34 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: RFC: polling for events triggers read() in videobuf2-core: how to resolve?
Date: Wed, 30 Mar 2011 12:44:25 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301244.25272.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I've been working on control events and while doing that I encountered a
V4L2 API problem.

Currently calling select() without REQBUFS having been called first will
assume that you want to read (or write for output devices) and it will
start the DMA accordingly if supported by the driver.

This is very nice for applications that want to use read (usually for MPEG
encoders), since they don't need to do an intial read() to kickstart the
DMA. It is also pretty much what you expect to happen.

Unfortunately, this clashes with applications that just select on exceptions
(like a control panel type application that just wants to get events when
controls change value). Now a select() on an exception will cause the driver
to start the DMA. Obviously not what you want.

Ideally the driver's poll() implementation should check whether the user
wanted to wait for input, output or exceptions. Unfortunately, that information
is not in general passed to the driver (see the code in fs/select.c).

I am not certain what to do. One option is that poll no longer can kick off
a DMA action. Instead apps need to call read() or write() at least once. In
that case a read/write count of 0 should be allowed: that way you can start
the DMA without actually needing to read or write data.

So apps can do a read(fd, buf, 0), then use poll afterwards to wait for data
to arrive.

I'm not sure whether this is OK or not.

Another alternative would be to try and change the poll() op so that this
information is actually passed to the driver. That's a rather painful
alternative, though.

Regards,

	Hans
