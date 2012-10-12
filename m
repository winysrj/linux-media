Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62308 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab2JLMLL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 08:11:11 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1515607bkc.19
        for <linux-media@vger.kernel.org>; Fri, 12 Oct 2012 05:11:10 -0700 (PDT)
Subject: Re: hacking MT9P031 for i.mx
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Chris MacGregor <chris@cybermato.com>, linux-media@vger.kernel.org,
	Liu Ying <Ying.liu@freescale.com>,
	"Hans J. Koch" <hjk@linutronix.de>, Daniel Mack <daniel@zonque.org>
In-Reply-To: <4301383.IPfSC38GGz@avalon>
References: <ade8080d-dbbf-4b60-804c-333d7340c01e@googlegroups.com>
	 <3242652.yHvnWhQcZZ@avalon> <4FED31EC.7010705@cybermato.com>
	 <4301383.IPfSC38GGz@avalon>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Oct 2012 14:10:43 +0200
Message-ID: <1350043843.3730.32.camel@mars>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Mon, 2012-07-02 at 14:48 +0200, Laurent Pinchart wrote:
> On Thursday 28 June 2012 21:41:16 Chris MacGregor wrote:

> > > Where did you get the Aptina board code patch from ?
> > 
> >  From here: https://github.com/Aptina/BeagleBoard-xM
> 
> That's definitely outdated, the code is based on a very old OMAP3 ISP driver 
> that was more or less broken by design. Nowadays anything other than the 
> mainline version isn't supported by the community.

Is there a current (kernel ~3.6) git tree which shows how to add mt9p031
to platform code?

I'm also curious if it's possible to glue mt9p031 to a freescale i.mx35
platform. As far as I can see,
drivers/media/platform/soc_camera/mx3_camera.c would need v4l2_subdev
support?

Thanks
 -- Christoph

