Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36900 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaITKDF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 06:03:05 -0400
Date: Sat, 20 Sep 2014 07:03:00 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: James Harper <james@ejbdigital.com.au>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, James Harper <james@maxsum.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: buffer delivery stops with cx23885
Message-ID: <20140920070300.0558859e@recife.lan>
In-Reply-To: <609d00f585384d999c8e3522fe1352ee@SIXPR04MB304.apcprd04.prod.outlook.com>
References: <778B08D5C7F58E4D9D9BE1DE278048B5C0B208@maxex1.maxsum.com>
	<541D469B.4000306@xs4all.nl>
	<609d00f585384d999c8e3522fe1352ee@SIXPR04MB304.apcprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 20 Sep 2014 09:26:23 +0000
James Harper <james@ejbdigital.com.au> escreveu:

> > 
> > On 09/20/2014 05:32 AM, James Harper wrote:
> > >
> > > My cx23885 based DViCO FusionHDTV DVB-T Dual Express2 (I submitted a
> > > patch for this a little while ago) has been working great but over
> > > the last few months it has started playing up. Nothing has really
> > > changed that I can put my finger on. Basically mythtv stops recording
> > > after a few minutes sometimes. Rarely when this happens I see some
> > > i2c errors but mostly not.
> > >
> > > With cx23885 debug options turned on (debug=9 vbi_debug=9
> > v4l_debug=9
> > > video_debug=9 irq_debug=9 ci_dbg=9) it seems like the card just stops
> > > delivering buffers (see dmesg output following).

Well, running the driver with all debugs enabled is a bad idea. The printk
mechanism on the Kernel is synchronous (currently - there are some proposals
to change it), so it will cause delays. That's specially bad if you're using
a serial console (not sure if this is your case).

> > > If I stop mythtv,
> > > all the buffers are cancelled (cx23885_stop_dma()) etc, and then
> > > restarting mythtv will get the recording going again, for a short
> > > time (minutes).
> > >
> > > Any suggestions to where I could start looking? Is it possible that
> > > my card itself is broken? (apart from this it's flawless).
> > 
> > I see nothing wrong in the log, but you can try to use the current media_tree
> > code. The cx23885's DMA engine has effectively been rewritten there,
> > simplifying
> > the control flow.
> > 
> 
> Oops I should have mentioned that. I'm using Debian "Jessie" with 3.16 kernel and already using the latest v4l as per link you sent (my  DViCO FusionHDTV DVB-T Dual Express2 patch is in 3.17 I think, but that's not in Debian yet).
> 
> I think it only broke since the rewrite. Before that it seemed to be bulletproof. That was why I asked about the patch just before - I can't tell yet if the driver stops supplying data or if mythtv stops asking for data. If there was something funny about the poll loop then that could cause it. I suppose I can try and go back to an older version of the code and see what happens?
> 
> Would the bug fixed by your "fix VBI/poll regression" patch cause intermittent stalls, or would the application that relied on the missing behaviour simply not work at all?

Yes, it may affect.

> In any case I've just applied the patch and about to reboot.
> 
> Thanks
> 
> James
> 
