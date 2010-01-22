Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50230 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0AVDBW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 22:01:22 -0500
Subject: Re: About MPEG decoder interface
From: Andy Walls <awalls@radix.net>
To: Michael Qiu <fallwind@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>, hverkuil@xs4all.nl
In-Reply-To: <f74f98341001211842y6dabbe97s1d7c362bac2d87b8@mail.gmail.com>
References: <f74f98341001211842y6dabbe97s1d7c362bac2d87b8@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 21 Jan 2010 22:00:53 -0500
Message-Id: <1264129253.3094.5.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-01-22 at 10:42 +0800, Michael Qiu wrote:
> Hi all,
> 
>   How can I export my MPEG decoder control interface to user space?
>   Or in other words, which device file(/dev/xxx) should a proper
> driver for mpeg decoder provide?

The MPEG decoder on a PVR-350 PCI card provides a /dev/video interface
(normally /dev/video16).

The interface specification to userspace is the V4L2 API:

http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html

>   And, in linux dvb documents, all the frontend interface looks like
> /dev/dvb/adapter/xxx, it looks just for PCI based tv card.
>   If it's not a TV card, but a frontend for a embedded system without
> PCI, which interface should I use?

The V4L2 specification should be OK for basic functionality.  Hans
might be able to talk about more advanced interfaces that are in work
for embedded platforms, if the V4L2 API is not good enough for you as
is.

Regards,
Andy

> Best regards
> Michael Qiu


