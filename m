Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33708 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752440AbZBSH3w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 02:29:52 -0500
Date: Thu, 19 Feb 2009 08:29:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Magnus Damm <magnus.damm@gmail.com>,
	Matthieu CASTET <matthieu.castet@parrot.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera : sh_mobile_ceu_camera race on free_buffer ?
In-Reply-To: <uy6w3jl44.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902190825040.4252@axis700.grange>
References: <497487F2.7070400@parrot.com> <aec7e5c30901192046j1a595day51da698181d034e5@mail.gmail.com>
 <497598ED.3050502@parrot.com> <aec7e5c30902130214k6a0fc8ck74b412f41fa63385@mail.gmail.com>
 <u7i3rgpeo.wl%morimoto.kuninori@renesas.com> <Pine.LNX.4.64.0902181938311.6371@axis700.grange>
 <uy6w3jl44.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Feb 2009, morimoto.kuninori@renesas.com wrote:

> Dear Guennadi
> 
> > > It works well on all cases.
> > So I can add your "Tested-by:"?
> 
> Yes please.
> 
> > You can try to trigger the race with the capture.c example. Reduce the 
> > "count" variable in mainloop() and run capture.c in a loop for a while... 
> > Try without this patch and then with this patch. But I think this is a 
> > correct fix, so, unless you say, it crashes without it and with it, I'll 
> > apply it.
> 
> I tried with following command option
> 
> # capture_example -d /dev/videoX -f -c 1000
> 
> I used -f option, I think you already know the reason =).

Yes, and I'm working on that.

> I think -c 1000 is enough.

No, sorry, this is not the test I meant. "-c" doesn't really stress the 
path we need. You really have to execute capture_example multiple times 
completely. The race we're trying to catch happens on STREAMOFF, and for 
that you have to run the example completely through. So, I would suggest 
something like

for (( i=0; i<100; i++ )); do capture_example -d /dev/videoX -f -c 4; done

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
