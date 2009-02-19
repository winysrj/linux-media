Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34392 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752183AbZBSIds (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 03:33:48 -0500
Date: Thu, 19 Feb 2009 09:33:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Magnus Damm <magnus.damm@gmail.com>,
	Matthieu CASTET <matthieu.castet@parrot.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera : sh_mobile_ceu_camera race on free_buffer ?
In-Reply-To: <uskmakfy2.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902190924050.5156@axis700.grange>
References: <497487F2.7070400@parrot.com> <aec7e5c30901192046j1a595day51da698181d034e5@mail.gmail.com>
 <497598ED.3050502@parrot.com> <aec7e5c30902130214k6a0fc8ck74b412f41fa63385@mail.gmail.com>
 <u7i3rgpeo.wl%morimoto.kuninori@renesas.com> <Pine.LNX.4.64.0902181938311.6371@axis700.grange>
 <uy6w3jl44.wl%morimoto.kuninori@renesas.com> <Pine.LNX.4.64.0902190825040.4252@axis700.grange>
 <uskmakfy2.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Feb 2009, morimoto.kuninori@renesas.com wrote:

> 
> Dear Guennadi
> 
> > No, sorry, this is not the test I meant. "-c" doesn't really stress the 
> > path we need. You really have to execute capture_example multiple times 
> > completely. The race we're trying to catch happens on STREAMOFF, and for 
> > that you have to run the example completely through. So, I would suggest 
> > something like
> > 
> > for (( i=0; i<100; i++ )); do capture_example -d /dev/videoX -f -c 4; done
> 
> wow !!
> sorry miss understanding.
> 
> OK. I re-tried test with your script (300 times).
> 
> sh_mobile_ceu_camera didn't crashe with
> and without Magnus patch.
> 
> MigoR + ov772x + capture_example
> MigoR + tw9910 + capture_example (VUYU fix)
> AP325 + ov772x + capture_example

Hm, ok, maybe I can ask you about one more test, if you don't mind. The 
thing is, you only see the problem, if after the ->active buffer has been 
freed in free_buffer(), your DMA engine continues writing to the freed 
memory, but you only notice this, if some other driver manages to grab and 
use it in this time, then its data is going to be overwritten.

To actually see, if the race occurs, please do

diff -u a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -326,6 +326,7 @@
 	spin_lock_irqsave(&pcdev->lock, flags);
 
 	vb = pcdev->active;
+	WARN_ON(vb->state == VIDEOBUF_NEEDS_INIT);
 	list_del_init(&vb->queue);
 
 	if (!list_empty(&pcdev->capture))

Also, I think, even better than restarting capture-example completely 
would be to edit capture-example.c and put a loop around

	init_device();
	start_capturing();
	mainloop();
	stop_capturing();
	uninit_device();

or maybe even only

	start_capturing();
	mainloop();
	stop_capturing();

Best would be to first try all three loops without the patch from Magnus 
and see if any of them triggers. And use a larger frame (maximum that your 
sensor can deliver) to give the DMA engine more time per frame.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
