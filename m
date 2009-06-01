Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:53309 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZFAH6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2009 03:58:36 -0400
Date: Mon, 1 Jun 2009 00:58:38 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Stefan Kost <ensonic@hora-obscura.de>
cc: linux-media@vger.kernel.org
Subject: Re: webcam drivers and V4L2_MEMORY_USERPTR support
In-Reply-To: <4A238292.6000205@hora-obscura.de>
Message-ID: <Pine.LNX.4.58.0906010056140.32713@shell2.speakeasy.net>
References: <4A238292.6000205@hora-obscura.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 1 Jun 2009, Stefan Kost wrote:
> I have implemented support for V4L2_MEMORY_USERPTR buffers in gstreamers
> v4l2src [1]. This allows to request shared memory buffers from xvideo,
> capture into those and therefore save a memcpy. This works great with
> the v4l2 driver on our embedded device.
>
> When I was testing this on my desktop, I noticed that almost no driver
> seems to support it.
> I tested zc0301 and uvcvideo, but also grepped the kernel driver
> sources. It seems that gspca might support it, but I ave not confirmed
> it. Is there a technical reason for it, or is it simply not implemented?

userptr support is relatively new and so it has less support, especially
with driver that pre-date it.  Maybe USB cams use a compressed format and
so userptr with xvideo would not work anyway since xv won't support the
camera's native format.  It certainly could be done for bt8xx, cx88,
saa7134, etc.
