Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40311 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752030AbZBRS4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 13:56:44 -0500
Date: Wed, 18 Feb 2009 19:56:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Matthieu CASTET <matthieu.castet@parrot.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: Re: soc-camera : sh_mobile_ceu_camera race on free_buffer ?
In-Reply-To: <aec7e5c30902130214k6a0fc8ck74b412f41fa63385@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0902181955460.6371@axis700.grange>
References: <497487F2.7070400@parrot.com>  <aec7e5c30901192046j1a595day51da698181d034e5@mail.gmail.com>
  <497598ED.3050502@parrot.com> <aec7e5c30902130214k6a0fc8ck74b412f41fa63385@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Feb 2009, Magnus Damm wrote:

> Hi Matthieu,
> 
> [CC Morimoto-san]
> [Changed list to linux-media]
> 
> On Tue, Jan 20, 2009 at 6:27 PM, Matthieu CASTET
> <matthieu.castet@parrot.com> wrote:
> > Magnus Damm a écrit :
> >> On Mon, Jan 19, 2009 at 11:02 PM, Matthieu CASTET
> >>> But we didn't do stop_capture, so as far I understand the controller is
> >>> still writing data in memory. What prevent us to free the buffer we are
> >>> writing.
> >>
> >> I have not looked into this in great detail, but isn't this handled by
> >> the videobuf state? The videobuf has state VIDEOBUF_ACTIVE while it is
> >> in use. I don't think such a buffer is freed.
> > Well from my understanding form videobuf_queue_cancel [1], we call
> > buf_release on all buffer.
> 
> Yeah, you are correct. I guess waiting for the buffer before freeing
> is the correct way to do this. I guess vivi doesn't have to do this
> since it's not using DMA.
> 
> Morimoto-san, can you check the attached patch? I've tested it on my
> Migo-R board together with mplayer and it seems to work well here. I
> don't think using mplayer triggers this error case though, so maybe we
> should try some other application.

Magnus, can you, please, submit it with an Sob, after Morimoto-san has 
tested it with capture.c?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
