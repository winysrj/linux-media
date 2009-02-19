Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58391 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753959AbZBSJu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 04:50:58 -0500
Date: Thu, 19 Feb 2009 10:51:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Magnus Damm <magnus.damm@gmail.com>,
	Matthieu CASTET <matthieu.castet@parrot.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera : sh_mobile_ceu_camera race on free_buffer ?
In-Reply-To: <ur61ukc3x.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902191049120.5156@axis700.grange>
References: <497487F2.7070400@parrot.com> <aec7e5c30901192046j1a595day51da698181d034e5@mail.gmail.com>
 <497598ED.3050502@parrot.com> <aec7e5c30902130214k6a0fc8ck74b412f41fa63385@mail.gmail.com>
 <u7i3rgpeo.wl%morimoto.kuninori@renesas.com> <Pine.LNX.4.64.0902181938311.6371@axis700.grange>
 <uy6w3jl44.wl%morimoto.kuninori@renesas.com> <Pine.LNX.4.64.0902190825040.4252@axis700.grange>
 <uskmakfy2.wl%morimoto.kuninori@renesas.com> <Pine.LNX.4.64.0902190924050.5156@axis700.grange>
 <ur61ukc3x.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Feb 2009, morimoto.kuninori@renesas.com wrote:

> 
> Dear Guennadi
> 
> > Hm, ok, maybe I can ask you about one more test, if you don't mind. The 
> > thing is, you only see the problem, if after the ->active buffer has been 
> > freed in free_buffer(), your DMA engine continues writing to the freed 
> > memory, but you only notice this, if some other driver manages to grab and 
> > use it in this time, then its data is going to be overwritten.
> (snip)
> > Best would be to first try all three loops without the patch from Magnus 
> > and see if any of them triggers. And use a larger frame (maximum that your 
> > sensor can deliver) to give the DMA engine more time per frame.
> 
> Hmm. maybe I could understand...
> 
> OK. 
> I tested with MigoR + ov772x + following way.
> 
> 1) apply patch to kernel
> 
> > diff -u a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> > --- a/drivers/media/video/sh_mobile_ceu_camera.c
> > +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> > @@ -326,6 +326,7 @@
> >  	spin_lock_irqsave(&pcdev->lock, flags);
> >  
> >  	vb = pcdev->active;
> > +	WARN_ON(vb->state == VIDEOBUF_NEEDS_INIT);
> >  	list_del_init(&vb->queue);
> >  
> >  	if (!list_empty(&pcdev->capture))
> 
> 2) apply patch to capture-example
> 
> I think your wanting to say is this...
> 
> diff -u capture_example.c capture_example.c.test
> --- capture_example.c	2009-01-24 09:35:12.000000000 +0900
> +++ capture_example.c.test	2009-02-19 18:09:32.000000000 +0900
> @@ -590,6 +590,8 @@
>  
>  int main(int argc, char **argv)
>  {
> +	int i;
> +
>  	dev_name = "/dev/video0";
>  
>  	for (;;) {
> @@ -648,11 +650,14 @@
>  	}
>  
>  	open_device();
> -	init_device();
> -	start_capturing();
> -	mainloop();
> -	stop_capturing();
> -	uninit_device();
> +        for (i=0 ; i<100 ; i++) {
> +            printf("%d ", i);
> +            init_device();
> +            start_capturing();
> +            mainloop();
> +            stop_capturing();
> +            uninit_device();
> +        }
>  	close_device();
>  	fprintf(stderr, "\n");
>  	return 0;
> 
> 3) test this capture_example.
> 
> Then, It say
> 
> ======================================================================
> camera 0-0: SuperH Mobile CEU driver attached to camera 0
>  camera_host0: Format 0 not found
> .0 ... camera_host0: Format 0 not found
> ------------[ cut here ]------------
> Badness at 8c141b9e [verbose debug info unavailable]
> 
> Pid : 869, Comm:                c2
> CPU : 0                 Not tainted  (2.6.29-rc4-00197-g41480ae-dirty #801)
> 
> PC is at sh_mobile_ceu_irq+0x2a/0xc8
> PR is at handle_IRQ_event+0x2e/0x68
> PC  : 8c141b9e SP  : 8fe15e40 SR  : 400001f1 TEA : 2961ba40
> R0  : 8ff05afc R1  : 00000000 R2  : 8fe14000 R3  : 00000000
> R4  : 8ff05a00 R5  : 8ff05a00 R6  : 00000010 R7  : 00000000
> R8  : 8ff416e0 R9  : 000000f0 R10 : 00000000 R11 : 00000034
> R12 : 8ff414d0 R13 : 8ff3a1e0 R14 : 8ff89e74
> MACH: 00000000 MACL: 00000c30 GBR : 29686450 PR  : 8c030e0a
> 
> Call trace:
> [<8c030e0a>] handle_IRQ_event+0x2e/0x68
> [<8c0326a8>] handle_level_irq+0x6c/0x100
> [<8c00356c>] do_IRQ+0x34/0x5c
> [<8c007118>] ret_from_irq+0x0/0x10
> [<8c003538>] do_IRQ+0x0/0x5c
> [<8c0f2c44>] memset+0x30/0x4c
> [<8c00b25a>] dma_alloc_coherent+0x5e/0x148
> [<8c141742>] __videobuf_mmap_mapper+0xbe/0x1a4
> [<8c13fb88>] videobuf_mmap_mapper+0x3c/0x70
> [<8c050ad8>] mmap_region+0x184/0x34c
> [<8c005234>] old_mmap+0x60/0xa8
> [<8c007266>] syscall_call+0xc/0x10
> [<8c0051d4>] old_mmap+0x0/0xa8

Yesss! There you go - this is the race we are hunting.

> camera 0-0: SuperH Mobile CEU driver detached from camera 0
> Trace/breakpoint trap
> ======================================================================
> 
> 4) apply Magnus patch
> 5) and test it again
> 
> then It say...
> 
> ========================================================
> -bash-3.00# ./c2 -d /dev/video0 -f -c 4
> camera 0-0: SuperH Mobile CEU driver attached to camera 0
>  camera_host0: Format 0 not found
> .0 ... camera_host0: Format 0 not found
> .1 ... camera_host0: Format 0 not found
> .2 ... camera_host0: Format 0 not found
> .3 ... camera_host0: Format 0 not found
> (snip)
> .96 ... camera_host0: Format 0 not found
> .97 ... camera_host0: Format 0 not found
> .98 ... camera_host0: Format 0 not found
> .99 ...camera 0-0: SuperH Mobile CEU driver detached from camera 0
> ========================================================

Nice and clean. Good, now I just need a formal patch submission with a 
"Tested-by" string, please.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
