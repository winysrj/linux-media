Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47861 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1HDNZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 09:25:03 -0400
Date: Thu, 4 Aug 2011 15:25:00 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Jan Pohanka <xhpohanka@gmail.com>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: mx2_camera driver on mx27ipcam: dma_alloc_coherent size  failed
Message-ID: <20110804132500.GF31521@pengutronix.de>
References: <op.vzdduqnuyxxkfz@localhost.localdomain>
 <20110729075143.GX16561@pengutronix.de>
 <op.vzdhx5ucyxxkfz@localhost.localdomain>
 <20110729092311.GY16561@pengutronix.de>
 <op.vzdldvr1yxxkfz@localhost.localdomain>
 <20110729115732.GA16561@pengutronix.de>
 <op.vzoxkxheyxxkfz@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vzoxkxheyxxkfz@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jan,

On Thu, Aug 04, 2011 at 03:11:11PM +0200, Jan Pohanka wrote:
> Dear Uwe,
> could you please give me some advice once more? It seems I'm not
> able to make mx2_camera working by myself.
> I have tried dma memory allocation in my board file in several ways,
> but nothing seems to work. I use Video capture example for v4l2 for
> testing.
> 
> regards
> Jan
> 
> mx27ipcam_camera_power: 1
> mx27ipcam_camera_reset
> mx2-camera mx2-camera.0: Camera driver attached to camera 0
> mx2-camera mx2-camera.0: dma_alloc_coherent size 614400 failed
> mmap error 12, Cannot allocate memory
> mx2-camera mx2-camera.0: Camera driver detached from camera 0
> mx27ipcam_camera_power: 0
Cannot say offhand. I'd instrument dma_alloc_from_coherent to check
where it fails.
 
The patch looks OK from a first glance.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
