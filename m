Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48135 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751810AbZDMUQt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 16:16:49 -0400
Date: Mon, 13 Apr 2009 22:16:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: Documentation of the FSM
In-Reply-To: <1239641940-27918-1-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.0904132208050.1587@axis700.grange>
References: <1239641940-27918-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 13 Apr 2009, Robert Jarzmik wrote:

> After DMA redesign, the pxa_camera dynamic behaviour should
> be documented so that future contributors understand how it
> works, and improve it.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  Documentation/video4linux/pxa_camera.txt |   49 ++++++++++++++++++++++++++++++
>  1 files changed, 49 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/video4linux/pxa_camera.txt b/Documentation/video4linux/pxa_camera.txt
> index b1137f9..b595e94 100644
> --- a/Documentation/video4linux/pxa_camera.txt
> +++ b/Documentation/video4linux/pxa_camera.txt
> @@ -26,6 +26,55 @@ Global video workflow
>  
>       Once the last buffer is filled in, the QCI interface stops.
>  
> +  c) Capture global finite state machine schema
> +
> +      +----+                             +---+  +----+
> +      | DQ |                             | Q |  | DQ |
> +      |    v                             |   v  |    v
> +    +-----------+                     +------------------------+
> +    |   STOP    |                     | Wait for capture start |
> +    +-----------+         Q           +------------------------+
> ++-> | QCI: stop | ------------------> | QCI: run               | <------------+
> +|   | DMA: stop |                     | DMA: stop              |              |
> +|   +-----------+             +-----> +------------------------+              |
> +|                            /                            |                   |
> +|                           /             +---+  +----+   |                   |
> +|capture list empty        /              | Q |  | DQ |   | QCI Irq EOF       |
> +|                         /               |   v  |    v   v                   |
> +|   +--------------------+             +----------------------+               |
> +|   | DMA hotlink missed |             |    Capture running   |               |
> +|   +--------------------+             +----------------------+               |
> +|   | QCI: run           |     +-----> | QCI: run             | <-+           |
> +|   | DMA: stop          |    /        | DMA: run             |   |           |
> +|   +--------------------+   /         +----------------------+   | Other     |
> +|     ^                     /DMA still            |               | channels  |
> +|     | capture list       /  running             | DMA Irq End   | not       |
> +|     | not empty         /                       |               | finished  |
> +|     |                  /                        v               | yet       |
> +|   +----------------------+           +----------------------+   |           |
> +|   |  Videobuf released   |           |  Channel completed   |   |           |
> +|   +----------------------+           +----------------------+   |           |
> +|   | QCI: run             |           | QCI: run             | --+           |
> +|   | DMA: run             |           | DMA: run             |               |
> +|   +----------------------+           +----------------------+               |
> +|              ^                      /           |                           |
> +|              |          no overrun /            | overrun                   |
> +|              |                    /             v                           |
> +|   +--------------------+         /   +----------------------+               |
> +|   |  Frame completed   |        /    |     Frame overran    |               |
> +|   +--------------------+ <-----+     +----------------------+ restart frame |
> ++-- | QCI: run           |             | QCI: stop            | --------------+
> +    | DMA: run           |             | DMA: stop            |
> +    +--------------------+             +----------------------+
> +
> +    Legend: - each box is a FSM state
> +            - each arrow is the condition to transition to another state
> +            - an arrow with a comment is a mandatory transition (no condition)
> +            - arrow "Q" means : a buffer was enqueued
> +            - arrow "DQ" means : a buffer was dequeued
> +            - "QCI: stop" means the QCI interface is not enabled
> +            - "DMA: stop" means all 3 DMA channels are stopped
> +            - "DMA: run" means at least 1 DMA channel is still running
>  
>  DMA usage
>  ---------

Cool, nice:-) One question though: shouldn't the "capture list empty" 
transition start from "Videobuf released" state? Or maybe you want to 
reorginise the "Videobuf released" and "Frame completed" states a bit to 
separate cases

- capture list empty
- capture list not empty
  - DMA still running - hot-linking success
  - DMA stopped - restart

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
