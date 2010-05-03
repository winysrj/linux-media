Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46081 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932446Ab0ECO0K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 May 2010 10:26:10 -0400
Date: Mon, 3 May 2010 16:26:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: ATMEL camera interface
In-Reply-To: <4BDEDB06.9090909@atmel.com>
Message-ID: <Pine.LNX.4.64.1005031622040.4231@axis700.grange>
References: <4BD9AA8A.7030306@atmel.com> <Pine.LNX.4.64.1004291824200.4666@axis700.grange>
 <4BDED3A8.4090606@atmel.com> <Pine.LNX.4.64.1005031556570.4231@axis700.grange>
 <4BDEDB06.9090909@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 3 May 2010, Sedji Gaouaou wrote:

> Well I need contiguous memory, so I guess I will have a look at mx1_camera.c?
> Is there another example?
> 
> What do you mean by videobuf implementation? As I said I just need a
> contiguous memory.

I mean, whether you're gping to use videobuf-dma-contig.c or 
videobuf-dma-sg.c, respectively, whether you'll be calling 
videobuf_queue_dma_contig_init() or videobuf_queue_sg_init() in your 
driver.

Regards
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
