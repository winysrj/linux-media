Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37198 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1HEH2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 03:28:36 -0400
Date: Fri, 5 Aug 2011 09:28:31 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Jan Pohanka <xhpohanka@gmail.com>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: mx2_camera driver on mx27ipcam: dma_alloc_coherent size failed
Message-ID: <20110805072831.GN31521@pengutronix.de>
References: <op.vzdduqnuyxxkfz@localhost.localdomain>
 <20110729075143.GX16561@pengutronix.de>
 <op.vzdhx5ucyxxkfz@localhost.localdomain>
 <20110729092311.GY16561@pengutronix.de>
 <op.vzdldvr1yxxkfz@localhost.localdomain>
 <20110729115732.GA16561@pengutronix.de>
 <op.vzoxkxheyxxkfz@localhost.localdomain>
 <20110804132500.GF31521@pengutronix.de>
 <CABMiYf9MDzDbVjQMsBZSxsumSU1ZDJEm7AapF86dN4m3qWe6_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABMiYf9MDzDbVjQMsBZSxsumSU1ZDJEm7AapF86dN4m3qWe6_A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jan,

On Fri, Aug 05, 2011 at 09:21:36AM +0200, Jan Pohanka wrote:
> Hello Uwe,
> thank you for the hint. There was problem with insufficient memory.
> dma_alloc_from_coherent is called several times and when I allocated
> only 4MB, last call failed. When I passed 8MB to
> dma_declare_coherent_memory, it works. Unfortunately I do not
> understand why 4MB is not enough for 640x480 YUV image...
A YUV420 image of size 640x480 needs 1.5 * 640 * 480 bytes (I think).
That's ~ 0.5MB. Now it depends how much buffers are allocated. For
taking a photo a single buffer is enough, for a video it uses probably
more than one.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
