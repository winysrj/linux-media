Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751934AbZBRSvg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 13:51:36 -0500
Date: Wed, 18 Feb 2009 19:51:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Magnus Damm <magnus.damm@gmail.com>,
	Matthieu CASTET <matthieu.castet@parrot.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc-camera : sh_mobile_ceu_camera race on free_buffer ?
In-Reply-To: <u7i3rgpeo.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902181938311.6371@axis700.grange>
References: <497487F2.7070400@parrot.com> <aec7e5c30901192046j1a595day51da698181d034e5@mail.gmail.com>
 <497598ED.3050502@parrot.com> <aec7e5c30902130214k6a0fc8ck74b412f41fa63385@mail.gmail.com>
 <u7i3rgpeo.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san

On Mon, 16 Feb 2009, morimoto.kuninori@renesas.com wrote:

> 
> Hi Magnus
> 
> > Morimoto-san, can you check the attached patch? I've tested it on my
> > Migo-R board together with mplayer and it seems to work well here. I
> > don't think using mplayer triggers this error case though, so maybe we
> > should try some other application.
> 
> I checked this patch with following case.
> 
> Migo-R + ov772x + mplayer
> Migo-R + tw9910 + mplayer
> AP325  + ov772x + mplayer
> 
> It works well on all cases.

So I can add your "Tested-by:"?

> And I can agree with your opinion
> "so maybe we should try some other application."

You can try to trigger the race with the capture.c example. Reduce the 
"count" variable in mainloop() and run capture.c in a loop for a while... 
Try without this patch and then with this patch. But I think this is a 
correct fix, so, unless you say, it crashes without it and with it, I'll 
apply it.

Thanks
Guennadi

> 
> Best regards
> --
> Kuninori Morimoto
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
