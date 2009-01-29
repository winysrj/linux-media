Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45200 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZA2Ne6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 08:34:58 -0500
Date: Thu, 29 Jan 2009 11:34:29 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: matthieu castet <castet.matthieu@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Support faulty USB IDs on DIBUSB_MC
Message-ID: <20090129113429.3137ac44@caramujo.chehab.org>
In-Reply-To: <alpine.LRH.1.10.0901291329590.15700@pub6.ifh.de>
References: <484A72D3.7070500@free.fr>
	<4974E4BE.2060107@free.fr>
	<20090129074735.76e07d47@caramujo.chehab.org>
	<alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de>
	<20090129100520.3331f41f@caramujo.chehab.org>
	<alpine.LRH.1.10.0901291329590.15700@pub6.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009 14:08:01 +0100 (CET)
Patrick Boettcher <patrick.boettcher@desy.de> wrote:

> On Thu, 29 Jan 2009, Mauro Carvalho Chehab wrote:
> >> We could do that, still I'm not sure if ARRAY_SIZE will work in that
> >> situation?! Are you
> >> sure, Mauro?
> >
> > Well, at least here, it is compiling fine. I can't really test it, since I
> > don't have any dib0700 devices here.
> 
> Hmm, your patch is shifting the counting problem to another place. Instead 
> of counting manually the devices-array-elements, one now needs to count 
> the number of device_properties ;) .

> With such a patch we would risk to break some device support and as I 
> never saw a patch which broke the current num_device_descs-manual-count I 
> don't see the need to change.

Nothing is perfect ;)

I suspect that you have more additions at the number of the devices than on the
number of device properties. So, the risk of doing bad things seems lower.
Also, a simple board addition won't need to touch at the number of devices.

IMO, it is really bad to have to explicitly say the number of devices at those
arrays. Maybe we may use some macro logic here to avoid such risks, or use a
NULL terminated list instead.

> 
> --
>    Mail: patrick.boettcher@desy.de
>    WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/




Cheers,
Mauro
