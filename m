Return-path: <linux-media-owner@vger.kernel.org>
Received: from joan.kewl.org ([212.161.35.248]:53810 "EHLO joan.kewl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab0HGQjV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Aug 2010 12:39:21 -0400
From: Darron Broad <darron@kewl.org>
To: Andy Walls <awalls@md.metrocast.net>
cc: lawrence rust <lawrence@softsystem.co.uk>,
	linux-media@vger.kernel.org, Darron Broad <darron@kewl.org>
Subject: Re: [PATCH] Nova-S-Plus audio line input
In-reply-to: <1281191356.2400.91.camel@localhost>
References: <1280587062.1395.37.camel@gagarin> <1281191356.2400.91.camel@localhost>
Date: Sat, 07 Aug 2010 17:16:37 +0100
Message-ID: <12627.1281197797@joan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In message <1281191356.2400.91.camel@localhost>, Andy Walls wrote:

LO

>On Sat, 2010-07-31 at 16:37 +0200, lawrence rust wrote:
<SNIP>

Sorry for the major snip but I am just filling you in
with some history on this thread nothing more. I have no
intention of contributing anything new.

The patch by Lawrence contains some ideas from here:
http://hg.kewl.org/pub/v4l-dvb-20081120/rev/c1d603af3bef

As you may read, this is a copy/paste of the wm8739.c
codec for the wm8775.c. There is no major effort or
work involved there and makes the wm8775 behave
similarly to the 8739 if I recall correctly. This was
20 months ago so I cannot recall much.

Another component is from here:
http://hg.kewl.org/pub/v4l-dvb-20081120/rev/302d51bf2baf

It should be understood that this is also very old and
i2c has had major reworking since so it should be
updated if possible Lawrence and I am sure Andy has
put on the right path.

One other part is probably this:
http://hg.kewl.org/pub/v4l-dvb-20081120/rev/8b24b8211fc9

But I can't tell really, as like Andy says there is
far too much in that patchset to really consume at
once.

All the best, good luck
darron



--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 

