Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58952 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933379Ab0ECQkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 12:40:33 -0400
Date: Mon, 3 May 2010 18:40:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sedji Gaouaou <sedji.gaouaou@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: ATMEL camera interface
In-Reply-To: <4BDEEE38.9070801@atmel.com>
Message-ID: <Pine.LNX.4.64.1005031836140.4231@axis700.grange>
References: <4BD9AA8A.7030306@atmel.com> <Pine.LNX.4.64.1004291824200.4666@axis700.grange>
 <4BDED3A8.4090606@atmel.com> <Pine.LNX.4.64.1005031556570.4231@axis700.grange>
 <4BDEDB06.9090909@atmel.com> <Pine.LNX.4.64.1005031622040.4231@axis700.grange>
 <4BDEEE38.9070801@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 3 May 2010, Sedji Gaouaou wrote:

> Well sorry to bother you again but I am looking at the mx1_camera.c file, and
> I wonder where are implemented the queue and dqueue functions?
> 
> The atmel IP is using linked list for the buffers, and previously I was
> managing it in the queue and dqueue functions.
> I am not sure where I should take care of it now?

qbuf and dqbuf are implemented by soc-camera in soc_camera_qbuf() and 
soc_camera_dqbuf() respectively, drivers only implement methods from 
struct videobuf_queue_ops, e.g., a .buf_queue method, which for mx1_camera 
is implemented by mx1_videobuf_queue().

Thanks
Guennadi

> 
> 
> Regards,
> Sedji
> 
> Le 5/3/2010 4:26 PM, Guennadi Liakhovetski a écrit :
> > On Mon, 3 May 2010, Sedji Gaouaou wrote:
> > 
> > > Well I need contiguous memory, so I guess I will have a look at
> > > mx1_camera.c?
> > > Is there another example?
> > > 
> > > What do you mean by videobuf implementation? As I said I just need a
> > > contiguous memory.
> > 
> > I mean, whether you're gping to use videobuf-dma-contig.c or
> > videobuf-dma-sg.c, respectively, whether you'll be calling
> > videobuf_queue_dma_contig_init() or videobuf_queue_sg_init() in your
> > driver.
> > 
> > Regards
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
